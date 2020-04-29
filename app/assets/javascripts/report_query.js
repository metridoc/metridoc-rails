$(document).ready(function() {
  if (userOnQueriesNewOrEditPage()) {
    loadAggregateSelectSelections();
    reloadOnTemplateSelection();

    $("#report_query_from_section").on("change", scanFromSectionChanges);
    $("#report_query_join_section_input textarea").on("input", scanJoinSectionChanges);

    // called on document change due to elements being dyanamically added
    $(document).on("change","#report_query_select_section_input input[type='checkbox']", function(event) {
      clickedValue = event.target.value;
      currentSelection = enabledSelectSectionOptions();
      var asteriskOption = $("#report_query_select_section_input input[type='checkbox']")[0];
      var asteriskOptionValue = $(asteriskOption).val();
      if (currentSelection.indexOf(asteriskOptionValue) >= 0 && clickedValue != asteriskOptionValue) {
        unselectAsteriskOption();
      } else if (clickedValue == asteriskOptionValue) {
        unselectNonAsteriskOptions();
      };
      addOrRemoveAggregateDropdown(clickedValue);
    });


    // called on document change due to elements being dyanamically added
    $(document).on("change","#report_query_select_section_input select", function(event) {
      var changedAggregateDropdown = event.target;
      var liParent = $(changedAggregateDropdown).parent();
      var selectSectionOption = $(liParent).find("input[type='checkbox']");
      addAggregateToSelectValue(selectSectionOption, liParent);
    });
  };

  function userOnQueriesNewOrEditPage() {
    var pathName = window.location.pathname;
    return (pathName.indexOf('report_queries') >= 0) && ((pathName.indexOf('new') >= 0) || (pathName.indexOf('edit') >= 0))
  };

  // removes disabled attr from "Select" section once "From" section has a valid model name
  function scanFromSectionChanges() {
    var fromTable = $("#report_query_from_section option").filter(":selected").val();
    if (fromTable != "") {
      // enableAllFields();
      retrieveTableAttributes(fromTable);
    } else {
      resetToFromInput();
    };
  };

  // dynamical adds/removes table_name.attributes from Select section if table name doesn't appear in FROM or JOIN sections
  function scanJoinSectionChanges() {
    var joinSectionInput = $("#report_query_join_section_input textarea").val();
    if (joinSectionInput.length) {
      var validTableNames = joinSectionValidTableNames(joinSectionInput);
      var fromSectionInput = $("#report_query_from_section option").filter(":selected").val();
      var tableNames = fromSectionInput
      if (validTableNames) {
        tableNames = tableNames + ", " + validTableNames
      };
      tableNames = tableNames.replace(/\s/g, "");
      retrieveTableAttributes(tableNames);
    };
  };

  function joinSectionValidTableNames(joinSectionInput) {
    var fromSectionOptions = $("select#report_query_from_section option").map(function() {return $(this).val();}).get();
    var joinSectionInputArray = joinSectionInput.split(" ");
    var validTableNames = $.map(joinSectionInputArray, function (possibleTableName) {
      if (fromSectionOptions.indexOf(possibleTableName) >= 0) {
        return possibleTableName;
      };
    });
    return validTableNames;
  };

  function enabledSelectSectionOptions() {
    var selectSectionOptions = $("#report_query_select_section_input input[type='checkbox']:checked");
    var selectedValues = [];
    $.each(selectSectionOptions, function (index, selectSectionOption) {
      selectedValues.push(selectSectionOption.value);
    });
    return selectedValues;
  };

  function retrieveTableAttributes(tableNames) {
    $.ajax({
      type: 'GET',
      dataType: "JSON",
      url: "/admin/report_attributes?table_names="+tableNames,
      success: function(data) {
        populateSelectOptions(data);
        populateGroupByOptions(data);
        populateOrderOptions(data);
      },
      error: function(e) {
        console.log(e.message);
      },
    });
  };

  function populateSelectOptions(selectSectionOptions) {
    var selectedOptionValues = listCheckedSelectOptions();
    resetSelectOptions();

    var tableAttributes = selectSectionOptions["table_attributes"];
    var tables = Object.keys(tableAttributes);
    $.each(tables, function(index, table) {
      var attributes = tableAttributes[table]
      $.each(attributes, function(index, attribute) {
        tableAttribute = table + "." + attribute
        $("#report_query_select_section_input ol.choices-group").append("<li class='choice'><label for='report_query_select_section'><input type='checkbox' name='report_query[select_section][]' id='report_query_select_section' value="+tableAttribute+"></input>"+tableAttribute+"</label></li>");
      });
    });

    enablePreviouslyCheckedSelectOptions(selectedOptionValues);
  };

  function listCheckedSelectOptions() {
    var selectedOptions = $("#report_query_select_section_input li.choice input[type='checkbox']:checked");
    if (selectedOptions.length > 0) {
      var selectedOptionValues = $.map(selectedOptions, function(selectedOption) {
        return selectedOption.value;
      });
      return selectedOptionValues;
    };
  };

  function resetSelectOptions() {
    $("#report_query_select_section_input ol.choices-group").empty();
    $("#report_query_select_section_input ol.choices-group").append("<li class='choice'><label for='report_query_select_section'><input type='checkbox' name='report_query[select_section][]' id='report_query_select_section' value='*'></input>*</label></li>");
  };

  function enablePreviouslyCheckedSelectOptions(selectedOptionValues) {
    if (selectedOptionValues) {
      $.each(selectedOptionValues, function(index, selectedOptionValue) {
        if (IsAnAggregate(selectedOptionValue)) {
          var preAggregateSelectSectionOption = identifyAggregatedSelectOption(selectedOptionValue);
          var selectSectionOptionValue =$(preAggregateSelectSectionOption).val();
          var aggregateFunction = identifyAggregateFunction(selectedOptionValue);
          checkSelectSectionOption(preAggregateSelectSectionOption);
          addOrRemoveAggregateDropdown(selectSectionOptionValue);
          selectAggregateDropdownOption(preAggregateSelectSectionOption, aggregateFunction);
        } else {
          $("#report_query_select_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
          addOrRemoveAggregateDropdown(selectedOptionValue);
        };
      });
    };
  };

  function populateOrderOptions(orderOptions) {
    var selectedOptionValue = listCheckedOrderOption();
    resetOrderOptions();

    var tableAttributes = orderOptions["table_attributes"];
    var tables = Object.keys(tableAttributes);
    $("#report_query_order_section_input ol.choices-group").append("<li class='choice'><label for='report_query_order_section'><input type='radio' name='report_query[order_section][]' id='report_query_order_section' value=nil></input>ignore</label></li>");
    $.each(tables, function(index, table) {
      var attributes = tableAttributes[table]
      $.each(attributes, function(index, attribute) {
        tableAttribute = table + "." + attribute
        $("#report_query_order_section_input ol.choices-group").append("<li class='choice'><label for='report_query_order_section'><input type='radio' name='report_query[order_section][]' id='report_query_order_section' value="+tableAttribute+"></input>"+tableAttribute+"</label></li>");
      });
    });

    enablePreviouslyCheckedOrderOptions(selectedOptionValue);
  };

  function listCheckedOrderOption() {
    var selectedOption = $("#report_query_order_section_input li.choice input[type='radio']:checked");
    if (selectedOption.length > 0) {
      var selectedOptionValue = selectedOption[0].value;
      return selectedOptionValue;
    };
  };

  function resetOrderOptions() {
    $("#report_query_order_section_input ol.choices-group").empty();
  };

  function enablePreviouslyCheckedOrderOptions(selectedOptionValue) {
    if (selectedOptionValue) {
      $("#report_query_order_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
    } else {
      $("#report_query_order_section_input li.choice input[value=nil]").prop("checked", true);
    };
  };

  function populateGroupByOptions(GroupByOptions) {
    var selectedOptionValue = listCheckedGroupByOption();
    resetGroupByOptions();

    var tableAttributes = GroupByOptions["table_attributes"];
    var tables = Object.keys(tableAttributes);
    $("#report_query_group_by_section_input ol.choices-group").append("<li class='choice'><label for='report_query_group_by_section'><input type='radio' name='report_query[group_by_section][]' id='report_query_group_by_section' value=nil>ignore</input></label></li>");
    $.each(tables, function(index, table) {
      var attributes = tableAttributes[table]
      $.each(attributes, function(index, attribute) {
        tableAttribute = table + "." + attribute
        $("#report_query_group_by_section_input ol.choices-group").append("<li class='choice'><label for='report_query_group_by_section'><input type='radio' name='report_query[group_by_section][]' id='report_query_group_by_section' value="+tableAttribute+"></input>"+tableAttribute+"</label></li>");
      });
    });

    enablePreviouslyCheckedGroupByOptions(selectedOptionValue);
  };

  function listCheckedGroupByOption() {
    var selectedOption = $("#report_query_group_by_section_input li.choice input[type='radio']:checked");
    if (selectedOption.length > 0) {
      var selectedOptionValue = selectedOption[0].value;
      return selectedOptionValue;
    };
  };

  function resetGroupByOptions() {
    $("#report_query_group_by_section_input ol.choices-group").empty();
  };

  function enablePreviouslyCheckedGroupByOptions(selectedOptionValue) {
    if (selectedOptionValue) {
      $("#report_query_group_by_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
    } else {
      $("#report_query_group_by_section_input li.choice input[value=nil]").prop("checked", true);
    };
  };

  function resetToFromInput() {
    resetSelectOptions();
    resetGroupByOptions();
    resetOrderOptions();
    // $("#report_query_join_section_input textarea").prop("disabled", true);
    $("#report_query_join_section_input textarea").val("");
    // $("#report_query_where_section_input textarea").prop("disabled", true);
    // $("#report_query_group_by_section_input").prop("disabled", true);
    $('#report_query_group_by_section_input input[type="radio"]').prop('checked', false);
    // $("#report_query_order_section_input").prop("disabled", true);
    $('#report_query_order_section_input input[type="radio"]').prop('checked', false);
    // $("#report_query_order_direction_section").prop("disabled", true);
  };

  function unselectNonAsteriskOptions() {
    var asteriskOption = $("#report_query_select_section_input input[type='checkbox']")[0];
    var allNonAsteriskOptions = $("#report_query_select_section_input input[type='checkbox']").not(asteriskOption);
    $(allNonAsteriskOptions).prop('checked', false);
    $.each(allNonAsteriskOptions, function (index, selectSectionOption) {
      var selectSectionOptionValue = $(selectSectionOption).val();
      addOrRemoveAggregateDropdown(selectSectionOptionValue);
    });
  };

  function unselectAsteriskOption() {
    var asteriskOption = $("#report_query_select_section_input input[type='checkbox']")[0];
    var asteriskOptionValue = $(asteriskOption).val();
    if ($(asteriskOption).is(":checked")) {
      $(asteriskOption).prop('checked', false);
      addOrRemoveAggregateDropdown(asteriskOptionValue);
    };
  };

  function reloadOnTemplateSelection() {
    $("#report_query_report_template_id").on("change", function() {
      if (document.location.href.indexOf('?') >= 0) {
        var url = document.location.href + "&template_id=" + this.value;
      } else {
        var url = document.location.href + "?template_id=" + this.value;
      };
      var queryName = $("#report_query_name").val();
      if (queryName != '') {
        url = url + "&name=" + queryName;
      };
      var queryComments = $("#report_query_comments").val();
      if (queryComments != '') {
        url = url + "&comments=" + queryComments;
      };
      document.location = url;
    });
  };

  function addOrRemoveAggregateDropdown(selectedOptionValue) {
    var selectSectionOption = $("#report_query_select_section_input input[value='" + selectedOptionValue + "']");
    var liParent = $(selectSectionOption).parent().parent();
    if (isSelectOptionSelected(selectSectionOption) && !hasAggregateDropdown(liParent)) {
      $(liParent).append("<select class='select-aggregate'><option value=''></option><option value='AVG'>AVG</option><option value='COUNT'>COUNT</option><option value='MAX'>MAX</option><option value='MIN'>MIN</option><option value='SUM'>SUM</option></select>");
    } else if (!isSelectOptionSelected(selectSectionOption) && hasAggregateDropdown(liParent)) {
      $(liParent).find("select").remove();
    };
    resetSelectValue(selectSectionOption);
  };

  function selectAggregateDropdownOption(selectSectionOption, aggregateFunction) {
    var liItem = $(selectSectionOption).parent().parent();
    selectAggregate(selectSectionOption, aggregateFunction);
    addAggregateToSelectValue(selectSectionOption, liItem);
  };

  function isSelectOptionSelected(selectSectionOption) {
    return $(selectSectionOption).is(":checked")
  };

  function hasAggregateDropdown(liItem) {
    return ($(liItem).find("select").length > 0)
  };

  function resetSelectValue(selectSectionOption) {
    var baseSelectValue = $(selectSectionOption).parent().text();
    $(selectSectionOption).val(baseSelectValue);
  };

  function addAggregateToSelectValue(selectSectionOption, liItem) {
    var aggregateValue = $(liItem).find("option").filter(":selected").val();
    if (aggregateValue != "") {
      var baseSelectValue = $(selectSectionOption).parent().text();
      var newSelectValue = aggregateValue + "(" + baseSelectValue + ")";
      $(selectSectionOption).val(newSelectValue);
    } else {
      resetSelectValue(selectSectionOption);
    };
  };

  function loadAggregateSelectSelections() {
    var savedSelectSelectionsWithAggregates = $("#report_query_select_section_with_aggregates").val().split(" ");
    var arrayLength = savedSelectSelectionsWithAggregates.length;
    for (var i = 0; i < arrayLength; i++) {
      var selectedOptionValue = savedSelectSelectionsWithAggregates[i];
      if (IsAnAggregate(selectedOptionValue)) {
        var preAggregateSelectSectionOption = identifyAggregatedSelectOption(selectedOptionValue);
        var selectSectionOptionValue =$(preAggregateSelectSectionOption).val();
        var aggregateFunction = identifyAggregateFunction(selectedOptionValue);
        checkSelectSectionOption(preAggregateSelectSectionOption);
        addOrRemoveAggregateDropdown(selectSectionOptionValue);
        selectAggregateDropdownOption(preAggregateSelectSectionOption, aggregateFunction);
      } else {
        addOrRemoveAggregateDropdown(selectedOptionValue);
      };
    };
  };

  function IsAnAggregate(selectedAttribute) {
    return (selectedAttribute.indexOf("(") >= 0 && selectedAttribute.indexOf(")") >= 0)
  };

  function identifyAggregatedSelectOption(selectedAttribute) {
    var regExp = /\(([^)]+)\)/;
    var selectedSelectSection = regExp.exec(selectedAttribute)[1];
    return $("#report_query_select_section_input input[value='" + selectedSelectSection + "']");
  };

  function identifyAggregateFunction(selectedAttribute) {
    return selectedAttribute.split("(")[0];
  };

  function checkSelectSectionOption(selectSectionOption) {
    $(selectSectionOption).prop("checked", true);
  };

  function selectAggregate(selectSectionOption, aggregateFunction) {
    aggregateDropdown = $(selectSectionOption).parent().parent().find('select')[0];
    $(aggregateDropdown).val(aggregateFunction);
  };

  if (userOnReportQeuryPage()) {
    if ($("div[_report_query_id]").length) {
      if ($(".row-status > td").text().toLowerCase() != 'success') {
        reportquery_refreshProgressBar();
      }
    }
  };

  function userOnReportQeuryPage() {
    var pathName = window.location.pathname;
    return pathName.indexOf('report_queries') >= 0;
  };

  function reportquery_refreshProgressBar() {
    var progressing = true;
    var div = $("div[_report_query_id]");
    var id = div.attr("_report_query_id");

    $.getJSON( "/admin/report_queries/" + id + ".json", function( data ) {
      var total_rows_to_process = data.total_rows_to_process;
      var n_rows_processed = data.n_rows_processed;
      var status = data.status;

      if (!total_rows_to_process) return;

      var completed_perc = parseInt((n_rows_processed / total_rows_to_process) * 100);
      if (completed_perc >= 100) progressing = false;

      var html = "";
      html += n_rows_processed + ' of ' + total_rows_to_process + ' rows exported';
      html += '<div style="width:500px;border:1px solid black;height: 25px;" id=progress-bar >' +
                '<div style="height:100%;width: ' + completed_perc + '%;background-color:lightblue;text-align:center;vertical-align:middle;font-weight:bold;" ></div>' +
              '</div>'
      ;
      if (status == 'in-progress') {
        html += '<a href="/admin/report_queries/' + id + '/cancel" onclick="return confirm(\'Are you sure you want to cancel this export?\');" >Cancel Export</a>';
      }
      div.html(html);
    }).then(function() {
      if (progressing) {
        setTimeout(function(){ reportquery_refreshProgressBar(); }, 1000);
      } else {
        location.reload();
      }
    });
  };
});
