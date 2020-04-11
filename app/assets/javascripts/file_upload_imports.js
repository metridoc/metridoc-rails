$(function() {
  $('#main_content').on('submit', '#new_tools_file_upload_import', function(e) {
    e.preventDefault();
    $.ajax({
      xhr: function() {
        var xhr = new window.XMLHttpRequest();
        xhr.upload.addEventListener('progress', function(evt) {
          if (evt.lengthComputable) {
            var percentComplete = evt.loaded / evt.total;
            percentComplete = parseInt(percentComplete * 100);
            $('#upload-status').html(percentComplete + '% complete');
          }
        }, false);
        return xhr;
      },
      type: 'POST',
      url: this.action,
      data: new FormData(this),
      processData: false,
      contentType: false,
      enctype: 'multipart/form-data'
    });
  });
});
