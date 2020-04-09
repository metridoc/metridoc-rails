$(document).ready(function() {
  pathName = window.location.pathname;
  if (userOnQueriesNewOrEditPage()) {
    scanFromSectionChanges();
    scanJoinSectionChanges();
    reloadOnTemplateSelection();

    $("#report_query_from_section").on("input", scanFromSectionChanges);
    $("#report_query_join_section_input textarea").on("input change", scanJoinSectionChanges);

      // allows user to only select * or attributes
    $(document).on("change","#report_query_select_section_input input[type='checkbox']", function(event){
      clickedValue = event.target.value;
      currentSelection = currentSelectedSelection();
      if (currentSelection.indexOf("*") >= 0 && clickedValue != "*") {
        unselectAsteriskOption();
      } else if (clickedValue == "*") {
        unselectNoneAsteriskOptions();
      };
    });
  };

  function userOnQueriesNewOrEditPage() {
    pathName = window.location.pathname;
    return (pathName.indexOf('report_queries') >= 0) && ((pathName.indexOf('new') >= 0) || (pathName.indexOf('edit') >= 0))
  };

  // removes disabled attr from "Select" section once "From" section has a valid model name
  function scanFromSectionChanges() {
    fromSectionInput = $("#report_query_from_section")[0]
    if (fromSectionInput.value.length) {
      if (valueAppearsOnDatalist(fromSectionInput)) {
        enableAllFields();
        retrieveTableAttributes(fromSectionInput.value);
      } else {
        resetToFromInput();
      };
    };
  };

  // dynamical adds/removes table_name.attributes from Select section if table name doesn't appear in FROM or JOIN sections
  function scanJoinSectionChanges() {
    joinSectionInput = $("#report_query_join_section_input textarea")[0]
    if (joinSectionInput.value.length) {
      matchedTableNames = matchedStringValuesToDatalist(joinSectionInput);
      fromSectionInput = $("#report_query_from_section")[0].value;
      tableNames = fromSectionInput
      if (matchedTableNames) {
        tableNames = tableNames + ", " + matchedTableNames
      };
      tableNames = tableNames.replace(/\s/g, "");
      retrieveTableAttributes(tableNames);
    };
  };

  function valueAppearsOnDatalist(input) {
    value = input.value;
    datalistText = input.list.textContent;
    datalistArray = datalistText.split("\n");
    return datalistArray.indexOf(value) >= 0;
  };

  function matchedStringValuesToDatalist(joinString) {
    datalist = $("#report_query_from_section")[0].list.textContent.split("\n");
    joinArray = joinString.value.split(" ");
    matchedStringValues = $.map(joinArray, function (possibleTableName) {
      if (datalist.indexOf(possibleTableName) >= 0) {
        return possibleTableName
      };
    });
    return matchedStringValues;
  };

  function currentSelectedSelection() {
    selectOptions = $("#report_query_select_section_input input[type='checkbox']:checked");
    selectedValues = [];
    $.each(selectOptions, function (index, selectOption) {
      selectedValues.push(selectOption.value);
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
        populateOrderOptions(data);
      },
      error: function(e) {
        console.log(e.message);
      },
    });
  };

  function populateSelectOptions(selectOptions) {
    selectedOptionValues = listCheckedSelectOptions();
    resetSelectOptions();

    tableAttributes = selectOptions["table_attributes"];
    tables = Object.keys(tableAttributes);
    $.each(tables, function(index, table) {
      attributes = tableAttributes[table]
      $.each(attributes, function(index, attribute) {
        tableAttribute = table + "." + attribute
        $("#report_query_select_section_input ol.choices-group").append("<li class='choice'><label for='report_query_select_section'><input type='checkbox' name='report_query[select_section][]' id='report_query_select_section' value="+tableAttribute+"></input>"+tableAttribute+"</label></li>");
      });
    });

    enablePreviouslyCheckedSelectOptions(selectedOptionValues);
  };

  function listCheckedSelectOptions() {
    selectedOptions = $("#report_query_select_section_input li.choice input[type='checkbox']:checked");
    if (selectedOptions.length > 0) {
      selectedOptionValues = $.map(selectedOptions, function(selectedOption) {
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
        $("#report_query_select_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
      });
    };
  };

  function populateOrderOptions(orderOptions) {
    selectedOptionValue = listCheckedOrderOption();
    resetOrderOptions();

    tableAttributes = orderOptions["table_attributes"];
    tables = Object.keys(tableAttributes);
    $.each(tables, function(index, table) {
      attributes = tableAttributes[table]
      $.each(attributes, function(index, attribute) {
        tableAttribute = table + "." + attribute
        $("#report_query_order_section_input ol.choices-group").append("<li class='choice'><label for='report_query_order_section'><input type='radio' name='report_query[order_section][]' id='report_query_order_section' value="+tableAttribute+"></input>"+tableAttribute+"</label></li>");
      });
    });

    enablePreviouslyCheckedOrderOptions(selectedOptionValue);
  };

  function listCheckedOrderOption() {
    selectedOption = $("#report_query_order_section_input li.choice input[type='radio']:checked");
    if (selectedOption.length > 0) {
      selectedOptionValue = selectedOption[0].value;
      return selectedOptionValue;
    };
  };

  function resetOrderOptions(allTablesToShow) {
    $("#report_query_order_section_input ol.choices-group").empty();
  };

  function enablePreviouslyCheckedOrderOptions(selectedOptionValue) {
    if (selectedOptionValue) {
      $("#report_query_order_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
    };
  };

  function enableAllFields() {
    $("#report_query_select_section_input input[type='checkbox]").prop("disabled", false);
    $("#report_query_join_section_input textarea").prop("disabled", false);
    $("#report_query_where_section_input textarea").prop("disabled", false);
    // $("#report_query_group_by_section_input textarea").prop("disabled", false);
    $("#report_query_order_section_input").prop("disabled", false);
    $("#report_query_order_direction_section").prop("disabled", false);
  };

  function resetToFromInput() {
    resetSelectOptions();
    resetOrderOptions();
    $("#report_query_select_section_input input[type='checkbox]").prop("disabled", true);
    $("#report_query_join_section_input textarea").prop("disabled", true);
    $("#report_query_join_section_input textarea").val("").
    $("#report_query_where_section_input textarea").prop("disabled", true);
    // $("#report_query_group_by_section_input textarea").prop("disabled", true);
    $("#report_query_order_section_input").prop("disabled", true);
    $('#report_query_order_section_input input[type="radio"]').prop('checked', false);
    $("#report_query_order_direction_section").prop("disabled", true);
  };

  function unselectNoneAsteriskOptions() {
    asteriskOption = $("#report_query_select_section_input input[value='*']");
    $("#report_query_select_section_input input[type='checkbox']").not(asteriskOption).prop('checked', false);
  };

  function unselectAsteriskOption() {
    $("#report_query_select_section_input input[value='*']").prop('checked', false);
  };

  function reloadOnTemplateSelection() {
    $("#report_query_report_template_id").on("change", function() {
      urlOrigin = document.location.origin;
      urlPathName = document.location.pathname;
      updatedUrl = urlOrigin + urlPathName + "?template_id=" + this.value;
      document.location = updatedUrl;
    });
  };
});
