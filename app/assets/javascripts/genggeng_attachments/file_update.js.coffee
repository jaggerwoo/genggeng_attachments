window.App = window.App || {};
fileUploadErrors = {
  maxFileSize: 'File is too big',
  minFileSize: 'File is too small',
  acceptFileTypes: 'Filetype not allowed',
  maxNumberOfFiles: 'Max number of files exceeded',
  uploadedBytes: 'Uploaded bytes exceed file size',
  emptyResult: 'Empty file upload result'
};


$(document).delegate(".file-upload input[type='file']", 'change', ->
  $this = $(this)
  $context = $(this).closest('.file-upload')
  text = $this.val()
  $filepath = $context.find(".filepath")
  if (text)
    text = text.split("\\").pop()
  $filepath.html(text)
  if window.File && window.FileReader && $this[0].files[0]
    fileReader = new FileReader()
    fileReader.onload = (evt) ->
      $img = $("<img>")
      $img[0].src = evt.target.result
      $context.find('.file-thumb').empty().append($img)
    fileReader.readAsDataURL($this[0].files[0])
)

EVENTS = {
  uploadDone: 'upload_done'
  uploadFail: 'upload_fail'
  removeItem: 'remove_item'
}

# Assets upload for photoable and attachable
initAssetsUpload = ($context) ->
  context = context || 'body'
  $context = $(context)
  $context.find('.asset-upload .file-input').each( ->
    paramName = this.name
    $this = $(this)
    formData = {
      attachment_type: $this.data('attachmenttype')
    }
    $context = $this.closest('.asset-upload')
    $uploadBtn = $this.closest('.asset-upload-btn')
    $assetThumbsWrapper = $context.find('.asset-thumbs')
    $templateInput = $context.find('#asset_ids')
    limit = $this.data('limit')
    canPreview = $this.data('canpreview')

    formData.attachment_type || (formData.attachment_type = 'attachments')

    # 检查是否可以上传
    uploadAvailable = ->
      return limit is 0 or limit isnt 0 && $assetThumbsWrapper.find('.asset-thumb').length < limit

    getUploadItemInfo = ($uploadItem)->
      $items = $assetThumbsWrapper.find('.asset-thumb')
      $img = $uploadItem.find('.thumb')
      return {
        index: $items.index($uploadItem)
        thumburl: $img.attr('src')
        url: $img.data('url')
      }

    # 将文件添加到队列时
    onAddFileToQueue = (data)->
      if uploadAvailable()
        data.$placeholder = $("""
          <div class='asset-thumb' title='#{data.files[0].name}'>
            <div class='inner'>
              <div class='message'>上传中...<em></em></message>
            </div>
            <div class='progress'>
              <div class='progress-bar' style='width: 0%;'></div>
            </div>
          </div>
        """)
        $assetThumbsWrapper.append(data.$placeholder)
        unless uploadAvailable()
          $uploadBtn.hide()
        true
      else
        $uploadBtn.hide()
        false

    # 上传成功后
    onUploadSuccess = ($placeholder, assetId, thumbUrl, url)->
      $placeholder.empty()
      .append("<div class='inner'><img class='thumb' src='#{thumbUrl}' " + (if canPreview then "data-preview-url='#{url}'" else "") + " data-url='#{url}'/></div>")
      .append("<a class='remove' title='移除'></a>")
      .append($templateInput.clone(false).removeAttr('id').val(assetId))

    # 上传中
    onProgress = ($placeholder, loaded, total)->
      progress = parseInt(loaded / total * 100, 10) + '%'
      $placeholder.find('.progress-bar').width(progress)
      $placeholder.find('em').text(progress)

      if progress is '100%'
        $placeholder.find('.message').text('处理中...')


    # 上传失败后
    onUploadFail = ($placeholder, message)->
      $placeholder.empty()
      .append("<div class='inner'><span class='text-danger message'>#{message}</span></div>")
      .append("<a class='remove' title='移除'></a>")


    # 对已经存在的图片进行计算和事件重新绑定
    $uploadBtn.hide() unless uploadAvailable()
    $assetThumbsWrapper.on('click.uploader', '.remove', ->
      $uploadItem = $(this).closest('.asset-thumb')
      $context.trigger(EVENTS.removeItem, getUploadItemInfo($uploadItem))
      $uploadItem.remove()
      $uploadBtn.show() if uploadAvailable()
    )


    $this.fileupload({
      dataType: 'json'
      paramName: paramName
      formData: formData
      sequentialUploads: true
      # singleFileUploads: true # do not set to false because the custom logic basic on singleFileUploads
    })
    .on 'fileuploadadd',      (e, data) -> onAddFileToQueue(data)
    .on 'fileuploaddone',     (e, data) ->
      onUploadSuccess(data.$placeholder, data.result.asset_id, data.result.thumb_url, data.result.url)
      $context.trigger(EVENTS.uploadDone, getUploadItemInfo(data.$placeholder))
      data.$placeholder = null
    .on 'fileuploadprogress', (e, data) -> onProgress(data.$placeholder, data.loaded, data.total)
    .on 'fileuploadfail',     (e, data) ->
      onUploadFail(data.$placeholder, (data.result && data.result.error_message || '上传失败<br>格式不符'))
      $context.trigger(EVENTS.uploadFail)
      data.$placeholder = null
  )

destroyAllUploaders = ->
  $('.asset-upload .asset-thumbs').off('.uploader')
  $('.asset-upload .file-input').fileupload('destroy')

App.initAssetsUpload = initAssetsUpload

# 页面加载后初始化
if window.Turbolinks && Turbolinks.supported
  $(document).on 'turbolinks:load', initAssetsUpload
  $(document).on 'turbolinks:request-end', destroyAllUploaders
else
  $ ->
    initAssetsUpload('body')