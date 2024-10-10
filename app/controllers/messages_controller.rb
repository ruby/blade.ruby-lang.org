class MessagesController < ApplicationController
  PER_PAGE = 50

  # GET /messages or /messages.json
  def index
    query = params[:q]
    unless query
      @messages = []
      return
    end

    page = params[:page].to_i
    list_ids = get_list_ids(params)
    if list_ids.empty?
      raise "Need to select at least one list"
    end

    # %> and <-> are defined by pg_trgm.
    # https://www.postgresql.org/docs/17/pgtrgm.html
    message_where = if Rails.env.production?
      Message.where('body %> ? AND list_id IN (?)', query, list_ids)
        .order(Arel.sql('body <-> ?', query))
    else
      Message.where('body LIKE ? AND list_id IN (?)', "%#{query}%", list_ids)
    end
    @messages = message_where.offset(page * PER_PAGE).limit(PER_PAGE)
  end

  # GET /messages/1 or /messages/1.json
  def show
    if params[:id]
      @message = Message.find(params[:id])
    else
      list = List.find_by_name(params[:list_name])
      @message = Message.find_by(list_id: list.id, list_seq: params[:list_seq])
    end
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
end
