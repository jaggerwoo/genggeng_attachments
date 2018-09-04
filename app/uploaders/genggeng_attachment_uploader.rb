# encoding: utf-8

class GenggengAttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  FILE_EXTENSION_LIST = %w(doc docx xls xlsx pdf ppt pptx rar zip 7z)
  IMAGE_EXTENSION_LIST = %w(jpg jpeg png gif tif tiff)
  FILE_EXTENSION_WHITE_LIST = FILE_EXTENSION_LIST + IMAGE_EXTENSION_LIST

  before :cache, :save_original_filename
  storage :file

  def thumbnail_url
    ActionController::Base.helpers.asset_path(thumbnail_url_without_asset_path)
  end

  def filename
     "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  def thumbnail_url_without_asset_path
    if FILE_EXTENSION_LIST.include?(file.extension.downcase)
      "assets/genggeng_attachments/attachment_thumbnails/#{file.extension.downcase}.png"
    else
      'assets/genggeng_attachments/attachment_thumbnails/image.png'
    end
  end

  protected
    def secure_token(length=16)
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
    end

    def save_original_filename(file)
      model.file_name ||= file.original_filename if file.respond_to?(:original_filename)
    end
end
