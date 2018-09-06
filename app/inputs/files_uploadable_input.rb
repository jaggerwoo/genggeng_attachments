# coding: utf-8

class FilesUploadableInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    super(wrapper_options)
    hint = options.delete(:hint)
    upload_limit = options.delete(:upload_limit) || 5
    upload_type = options.delete(:upload_type)
    attachment_type = options.delete(:attachment_type)
    can_preview = options.delete(:preview) == true ? true : false
    # upload_format =  (upload_type == 'image' ? AttachmentUploader::IMAGE_EXTENSION_LIST : AttachmentUploader::FILE_EXTENSION_WHITE_LIST).join('、')
    attribute_ids_name = "#{attribute_name.to_s.singularize}_ids"

    template.content_tag(:div, class: 'asset-upload') do
      result = ''
      result += template.tag(:input, :type => 'hidden', :name => "#{@builder.object_name}[#{attribute_ids_name}][]", id: 'asset_ids')
      result += template.content_tag(:div, class: 'help-block') do
        hint || "#{"最多可上传#{upload_limit}个" if upload_limit > 0}(支持以下格式文件: doc docx xls xlsx pdf ppt pptx jpg jpeg png gif)"
      end
      result += template.content_tag(:div, class: 'asset-uploader') do
        r2 = ''
        r2 += template.content_tag(:div, class: 'asset-thumbs') do
          r3 = ''
          if @builder.object.present?
            @builder.object.send(attribute_name).each do |attachment|
              r3 += template.content_tag(:div, class: 'asset-thumb', title: attachment.filename) do
                r4 = '<div class="inner">'
                r4 += template.image_tag(attachment.thumbnail_url, class: 'thumb', 'data-preview-url': can_preview ? attachment.url : nil, 'data-url': attachment.url)
                r4 += template.content_tag(:a, '', class: 'remove', title: '移除')
                r4 += template.tag(:input, type: 'hidden', name: "#{@builder.object_name}[#{attribute_ids_name}][]", value: attachment.id)
                r4 += '</div>'
                r4.html_safe
              end
            end
          end
          r3.html_safe
        end
        r2 += template.content_tag(:div, class: 'asset-upload-btn') do
          template.tag(:input, :class => 'file-input', :type => 'file', :name => 'genggeng_attachment[attachment_file]', :multiple => true, 'data-url' => template.genggeng_attachments.genggeng_attachments_path, 'data-limit' => upload_limit, 'data-attachmenttype' => attachment_type, 'data-canpreview' => can_preview)
        end
        r2.html_safe
      end
      result.html_safe
    end
  end

end
