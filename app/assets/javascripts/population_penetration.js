$(admin_gate_path).on("ajax:success", function(event, data, status, xhr) {
    var test_school=data.school;
    var test_library=data.library;
    alert("Response is => " + input_school + input_library)}
  ).on("ajax:error", function(event, xhr, status, error) {
    var test_school="College of Arts and Sciences";
    var test_library="Van Pelt"});

var chart = Chartkick.charts["2"]

chart.updateData(newData)
