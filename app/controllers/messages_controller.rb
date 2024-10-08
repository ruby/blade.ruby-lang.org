class MessagesController < ApplicationController
  before_action :set_message, only: %i[ edit update destroy ]

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

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:subject, :from, :body)
    end
end
