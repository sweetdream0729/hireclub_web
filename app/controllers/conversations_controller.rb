class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]

  # GET /conversations
  def index
    @conversations = current_user.conversations
  end

  def between
    users = User.find(params[:user_ids])
    conversation = Conversation.between(users)
    redirect_to conversation
  end

  # GET /conversations/1
  def show
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  def create
    @conversation = Conversation.new(conversation_params)

    if @conversation.save
      redirect_to @conversation, notice: 'Conversation was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /conversations/1
  def update
    if @conversation.update(conversation_params)
      redirect_to @conversation, notice: 'Conversation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /conversations/1
  def destroy
    @conversation.destroy
    redirect_to conversations_url, notice: 'Conversation was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def conversation_params
      params.require(:conversation).permit(:slug)
    end
end
