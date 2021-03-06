class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversations, only: [:index, :show]
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index]

  # GET /conversations
  def index
    if current_user.conversations.any?
      current_user.conversations.by_recent.find_each do |conversation|
        unless conversation.blocked?(current_user)
          redirect_to conversation 
          return
        end
      end
    else
      redirect_back(fallback_location: user_path(User.first), alert: "You have no messages yet. Try messaging someone from their profile page.")
    end
  end

  def between
    users = User.find(params[:user_ids])
    conversation = Conversation.between(users)
    authorize conversation
    redirect_to conversation
  end

  # GET /conversations/1
  def show
    if @conversation.blocked?(current_user)
      flash[:alert] = "User not found"
      redirect_to(conversations_path)
      return
    end

    @other_users = @conversation.other_users(current_user)
    @message = Message.new
    @messages = @conversation.messages.by_recent
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
    authorize @conversation
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  def create
    @conversation = Conversation.new(conversation_params)
    authorize @conversation

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

    def set_conversations
      @conversations = current_user.conversations.by_recent
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.friendly.find(params[:id])
      authorize @conversation
    end

    # Only allow a trusted parameter "white list" through.
    def conversation_params
      params.require(:conversation).permit(:slug)
    end
end
