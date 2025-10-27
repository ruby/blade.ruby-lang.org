class MessagesController < ApplicationController
  PER_PAGE = 50

  # GET /ruby-dev or /q=searchterm
  def index(list_name: nil, yyyymm: nil, q: nil, page: nil)
    if list_name
      @list = List.find_by_name list_name

      render_threads yyyymm: yyyymm
    elsif q
      search q, page

      render :search
    else
      @messages = []

      render :search
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

    render_threads yyyymm: @message.published_at.strftime('%Y%m')
  end

  private

  def calculate_navigation_links
    # Find root of current thread
    root = @message
    while root.parent_id
      root = Message.find(root.parent_id)
    end

    # Find previous/next thread (root messages)
    @prev_thread = Message.where(list_id: @list, parent_id: nil).where('id < ?', root.id).order(id: :desc).first
    @next_thread = Message.where(list_id: @list, parent_id: nil).where('id > ?', root.id).order(:id).first

    # Get all messages in this thread
    thread_messages = Message.with_recursive(
      thread_msgs: [
        Message.where(id: root.id),
        Message.joins('inner join thread_msgs on messages.parent_id = thread_msgs.id')
      ]
    ).joins('inner join thread_msgs on thread_msgs.id = messages.id').order(:id).to_a

    # Find previous/next message in thread
    current_index = thread_messages.index {|m| m.id == @message.id }
    @prev_message_in_thread = thread_messages[current_index - 1] if current_index && current_index > 0
    @next_message_in_thread = thread_messages[current_index + 1] if current_index
  end

  def render_threads(yyyymm: nil)
    @yyyymms = Message.where(list_id: @list).order('yyyymm').pluck(Arel.sql "distinct to_char(published_at, 'YYYYMM') as yyyymm")
    @yyyymm = yyyymm || @yyyymms.last

    root_query = Message.where(list_id: @list, parent_id: nil).where("to_char(published_at, 'YYYYMM') = ?", @yyyymm).order(:id)
    messages = Message.with_recursive(parent_and_children: [root_query, Message.joins('inner join parent_and_children on messages.parent_id = parent_and_children.id')])
      .joins('inner join parent_and_children on parent_and_children.id = messages.id')

    @messages = compose_tree(messages)

    render :index
  end

  def get_list_ids(params)
    list_ids = []
    ['ruby-talk', 'ruby-core', 'ruby-list', 'ruby-dev'].each do |name|
      if params[name.tr('-', '_').to_sym] != '0'
        list_ids << List.find_by_name(name).id
      end
    end
    list_ids
  end

  def search(query, page)
    list_ids = get_list_ids(params)
    if list_ids.empty?
      raise "Need to select at least one list"
    end

    # %> and <-> are defined by pg_trgm.
    # https://www.postgresql.org/docs/17/pgtrgm.html
    message_where = Message.where('body %> ? AND list_id IN (?)', query, list_ids).order(Arel.sql('body <-> ?', query))
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
