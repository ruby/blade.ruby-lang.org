class MessagesController < ApplicationController
  # GET /messages or /messages.json
  def index
    query = params[:q]
    if query
      # %> and <-> are defined by pg_trgm.
      # https://www.postgresql.org/docs/17/pgtrgm.html
      @messages = Message.find_by_sql([
        'SELECT * FROM messages WHERE body %> ? ORDER BY body <-> ? LIMIT 20',
        query, query,
      ])
    else
      @messages = Message.all
    end
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
end
