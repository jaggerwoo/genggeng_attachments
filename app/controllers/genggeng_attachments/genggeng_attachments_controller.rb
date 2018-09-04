module GenggengAttachments
  class GenggengAttachmentsController < GenggengAttachments::ApplicationController

    def create
      attachment = GenggengAttachment.new(genggeng_attachment_params)

      respond_to do |format|
        if attachment.save
          format.json { render json: attachment.to_jq_upload.to_json }
        else
          format.json { render json: {result: 'error'} }
        end
      end
    end

    def download_file
      @attachment = GenggengAttachment.find(params[:id])
      send_file(@attachment.attachment_file.file.path)
    end

    private

      def genggeng_attachment_params
        params.require(:genggeng_attachment).permit(:attachment_file)
      end
  end
end
