class GenggengAttachment < ActiveRecord::Base
  belongs_to :genggeng_attachmentable, polymorphic: true, optional: true

  mount_uploader :attachment_file, GenggengAttachmentUploader

  def to_jq_upload
    {
      "name" => read_attribute(:attachment_file),
      "size" => attachment_file.size,
      "thumb_url" => thumbnail_url,
      "url" => url,
      "asset_id" => id,
      "filename" => filename,
      "type" => attachment_file.file.extension
    }

  end

  def filename
    attachment_file.file.original_filename if attachment_file.file
  end

  def url
    attachment_file.url
  end

  def thumbnail_url
    attachment_file.thumbnail_url
  end

end
