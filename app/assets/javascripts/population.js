$(admin_population_penetration_path).on("ajax:success",admin_population_penetration_path, function(event, data, status, xhr) {
    var input_school=data.school;
    var input_library=data.library;
    alert("Response is => " + input_school + input_library);
    return input_school;
    return input_library};
  ).on("ajax:error", function(event, xhr, status, error) {
    var input_school="College of Arts and Sciences";
    var input_library="Van Pelt"});

//$.ajax({
//        type: "GET",
//        url: "admin_population_path",
//        success: function(data){}
//    }); 

var chart = Chartkick.charts["chart-id"]

chart.updateData(input_school)

chart.redraw()
