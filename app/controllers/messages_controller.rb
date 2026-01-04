class MessagesController < ApplicationController
  PER_PAGE = 50

  # GET /ruby-dev
  def index(list_name: nil, yyyymm: nil, q: nil)
    yyyymm = yyyymm.to_i
    if list_name
      @list = List.find_by_name list_name

      render_threads yyyymm: yyyymm, q: q
    else
      redirect_to List.find_by_name('ruby-core')
    end
  end

  # GET /messages/search_all
  def search_all(q: nil, page: nil)
    if q
      search q, page
    else
      @messages = []
    end
  end

  # GET /ruby-dev/1
  def show(list_name:, list_seq:)
    @list = List.find_by_name(list_name)
    @message = Message.find_by!(list_id: @list, list_seq: list_seq)

    # Calculate navigation links
    calculate_navigation_links

    # If this is a turbo frame request, just render the message
    return if turbo_frame_request?

    render_threads yyyymm: @message.yyyymm
  end

  private

  def calculate_navigation_links
    # Find root of current thread
    root = @message
    while root.parent_id
      root = Message.find(root.parent_id)
    end

    # Find previous/next thread (root messages)
    @prev_thread_seq = Message.where(list_id: @list, parent_id: nil).where('id < ?', root.id).order(id: :desc).pick(:list_seq)
    @next_thread_seq = Message.where(list_id: @list, parent_id: nil).where('id > ?', root.id).order(:id).pick(:list_seq)

    # Get all messages in this thread
    thread_messages = Message.with_recursive(
      thread_msgs: [
        Message.where(id: root.id),
        Message.joins('inner join thread_msgs on messages.parent_id = thread_msgs.id')
      ]
    ).joins('inner join thread_msgs on thread_msgs.id = messages.id').order(:id).pluck(:id, :list_seq)

    # Find previous/next message in thread
    current_index = thread_messages.index {|(id, _)| id == @message.id }
    @prev_message_in_thread_seq = thread_messages[current_index - 1]&.last if current_index && current_index > 0
    @next_message_in_thread_seq = thread_messages[current_index + 1]&.last if current_index
  end

  def render_threads(yyyymm: nil, q: nil)
    root_query = Message.where(list_id: @list, parent_id: nil).order(:id)

    if q
      root_query.where!('body %> ?', q)
    else
      @yyyymms = Message.distinct.where(list_id: @list, parent_id: nil).order('yyyymm').pluck('yyyymm')
      @yyyymm = yyyymm || @yyyymms.last
      root_query.where!(yyyymm: @yyyymm)
    end

    messages = Message.with_recursive(parent_and_children: [root_query, Message.joins('inner join parent_and_children on messages.parent_id = parent_and_children.id')])
      .joins('inner join parent_and_children on parent_and_children.id = messages.id')

    @messages = compose_tree(messages)

    if q
      @yyyymms = @messages.map { it.yyyymm }.uniq
      @yyyymm = @yyyymms.last
    end

    render :index
  end

  def search(query, page)
    lists = List.all.select { params[it.name] != '0' }
    raise "Need to select at least one list" if lists.empty?

    # %> and <-> are defined by pg_trgm.
    # https://www.postgresql.org/docs/17/pgtrgm.html
    message_where = Message.where('body %> ? AND list_id IN (?)', query, lists.map(&:id)).order(Arel.sql('body <-> ?', query))
    @messages = message_where.offset(page.to_i * PER_PAGE).limit(PER_PAGE)
  end

  def compose_tree(messages)
    [].tap do |ret|
      messages.each do |m|
        if m.parent_id && (parent = messages.detect { it.id == m.parent_id })
          (parent.children ||= []) << m
        else
          ret << m
        end
      end
      ret.sort_by!(&:id)
    end
  end
end
