var refreshIntervalId;
$(document).ready(function() {

  if (userOnFileUploadImportsPage()) {

    var div = $("div[_file_upload_import_id]");
    if (div.length > 0 ) {
      refreshProgressBar();
      refreshIntervalId = setInterval(function(){ refreshProgressBar(); }, 1000);
    }

  };

});

function userOnFileUploadImportsPage() {
  pathName = window.location.pathname;
  return pathName.indexOf('tools_file_upload_imports') >= 0;
};

var progressing = false;
function refreshProgressBar() {
  var div = $("div[_file_upload_import_id]");
  var id = div.attr("_file_upload_import_id");

  $.getJSON( "/admin/tools_file_upload_imports/" + id + ".json", function( data ) {
    console.log("data=" + data.total_rows_to_process + " - " + data.n_rows_processed);

    var total_rows_to_process = data.total_rows_to_process;
    var n_rows_processed = data.n_rows_processed;
    var status = data.status;

    var completed_perc = parseInt((n_rows_processed / total_rows_to_process) * 100);
    if (completed_perc < 100) progressing = true;
    var html = "";
    html += n_rows_processed + ' of ' + total_rows_to_process + ' rows processed';
    html += '<div style="width:500px;border:1px solid black;height: 25px;" id=progress-bar >' +
              '<div style="height:100%;width: ' + completed_perc + '%;background-color:lightblue;text-align:center;vertical-align:middle;font-weight:bold;" ></div>' +
            '</div>';
    div.html(html);
    if (progressing && completed_perc >= 100) {
      document.location.href = "/admin/tools_file_upload_imports/" + id;
    }

  });


}