class MessagesController < ApplicationController
  PER_PAGE = 50

  # GET /messages
  def index
    if (list_name = params[:list_name])
      @list = List.find_by_name list_name

      messages = Message.with_recursive(parent_and_children: [Message.where(list_id: @list, parent_id: nil).order(:id).limit(100), Message.joins('inner join parent_and_children on messages.parent_id = parent_and_children.id')])
        .joins('inner join parent_and_children on parent_and_children.id = messages.id')
      @messages = compose_tree(messages)
    elsif (query = params[:q])
      search query

      render :search
    else
      @messages = []

      render :search
    end
  end

  # GET /messages/ruby-dev/1
  def show
    @list = List.find_by_name(params[:list_name])
    @message = Message.find_by(list_id: @list, list_seq: params[:list_seq])
  end

  private

  def get_list_ids(params)
    list_ids = []
    ['ruby-talk', 'ruby-core', 'ruby-list', 'ruby-dev'].each do |name|
      if params[name.tr('-', '_').to_sym] != '0'
        list_ids << List.find_by_name(name).id
      end
    end
    list_ids
  end

  def search(query)
    page = params[:page].to_i
    list_ids = get_list_ids(params)
    if list_ids.empty?
      raise "Need to select at least one list"
    end

    # %> and <-> are defined by pg_trgm.
    # https://www.postgresql.org/docs/17/pgtrgm.html
    message_where = Message.where('body %> ? AND list_id IN (?)', query, list_ids).order(Arel.sql('body <-> ?', query))
    @messages = message_where.offset(page * PER_PAGE).limit(PER_PAGE)
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
