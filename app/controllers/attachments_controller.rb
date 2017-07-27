class AttachmentsController < ApplicationController
  after_action :verify_authorized, except: [:index]

  def create
    @attachment = @attachable.attachments.new attachment_params
    authorize @attachment
    #@attachment.user = current_user
    
    if @attachment.save 
      redirect_to @attachable, notice: "Attachment created."
    else
      redirect_to @attachable
    end
  end

  def destroy
    set_attachment
    @attachment.destroy
    redirect_to @attachment.attachable, alert: "Attachment deleted."
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
      authorize @attachment
    end

    def attachment_params
      params.require(:attachment).permit(:link, :file, :retained_file, :remove_file, :file_url)
    end
end