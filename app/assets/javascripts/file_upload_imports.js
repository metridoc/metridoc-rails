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

  if (userOnFileUploadImportsPage()) {
    if ($("div[_file_upload_import_id]").length) {
      if ($(".row-status > td").text().toLowerCase() != 'success') {
        refreshProgressBar();
      }
    }
  };
});

function userOnFileUploadImportsPage() {
  var pathName = window.location.pathname;
  return pathName.indexOf('tools_file_upload_imports') >= 0;
};

function refreshProgressBar() {
  var progressing = true;
  var div = $("div[_file_upload_import_id]");
  var id = div.attr("_file_upload_import_id");

  $.getJSON( "/admin/tools_file_upload_imports/" + id + ".json", function( data ) {
    var total_rows_to_process = data.total_rows_to_process;
    var n_rows_processed = data.n_rows_processed;
    var status = data.status;

    if (!total_rows_to_process) return;

    var completed_perc = parseInt((n_rows_processed / total_rows_to_process) * 100);
    if (completed_perc >= 100) progressing = false;

    var html = "";
    html += n_rows_processed + ' of ' + total_rows_to_process + ' rows processed';
    html += '<div style="width:500px;border:1px solid black;height: 25px;" id=progress-bar >' +
              '<div style="height:100%;width: ' + completed_perc + '%;background-color:lightblue;text-align:center;vertical-align:middle;font-weight:bold;" ></div>' +
            '</div>';
    div.html(html);
  }).then(function() {
    if (progressing) {
      setTimeout(function(){ refreshProgressBar(); }, 1000);
    } else {
      location.reload();
    }
  });
}
