$(admin_gatecount_path).on("ajax:success", function(event, data, status, xhr) {
    var input_school=data.school;
    var input_library=data.library}
  ).on("ajax:error", function(event, xhr, status, error) {
    var input_school="College of Arts and Sciences";
    var input_library="Van Pelt"});
