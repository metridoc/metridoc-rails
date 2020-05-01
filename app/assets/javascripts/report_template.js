$(document).ready(function() {
  if (userOnTemplatesNewOrEditPage()) {
    loadAggregateSelectSelections();
    updateGroupByFromEnabledSelectSection();

    $("#report_template_from_section").on("change", scanFromSectionChanges);
    $("#report_template_join_section_input textarea").on("input", scanJoinSectionChanges);

    // called on document change due to elements being dyanamically added
    $(document).on("change","#report_template_select_section_input input[type='checkbox']", function(event) {
      clickedValue = event.target.value;
      currentSelection = enabledSelectSectionOptions();
      var asteriskOption = $("#report_template_select_section_input input[type='checkbox']")[0];
      var asteriskOptionValue = $(asteriskOption).val();
      if (currentSelection.indexOf(asteriskOptionValue) >= 0 && clickedValue != asteriskOptionValue) {
        unselectAsteriskOption();
      } else if (clickedValue == asteriskOptionValue) {
        unselectNonAsteriskOptions();
      };
      addOrRemoveAggregateDropdown(clickedValue);
    });


    // called on document change due to elements being dyanamically added
    $(document).on("change","#report_template_select_section_input select", function(event) {
      var changedAggregateDropdown = event.target;
      var liParent = $(changedAggregateDropdown).parent();
      var selectSectionOption = $(liParent).find("input[type='checkbox']");
      addAggregateToSelectValue(selectSectionOption, liParent);
    });

    // all 3 below check for possible change to enabled select section options
    // called on document change due to elements being dyanamically added
    $(document).on("change","#report_template_select_section_input input[type='checkbox']", updateGroupByFromEnabledSelectSection);
    $("#report_template_from_section").on("change", updateGroupByFromEnabledSelectSection);
    $("#report_template_join_section_input textarea").on("input", updateGroupByFromEnabledSelectSection);

    // called on document change due to elements being dyanamically added
    $(document).on("mouseup","#report_template_order_section_input input[type='radio']", function(event) {
      var orderOption = event.target;
      if ($(orderOption).is(":checked")) {
        setTimeout(function(){$(orderOption).prop("checked", false);},0);
      } else {
        $(orderOption).prop("checked", true);
      };
    });
  };

  function userOnTemplatesNewOrEditPage() {
    var pathName = window.location.pathname;
    return (pathName.indexOf('report_templates') >= 0) && ((pathName.indexOf('new') >= 0) || (pathName.indexOf('edit') >= 0))
  };

  // removes disabled attr from "Select" section once "From" section has a valid model name
  function scanFromSectionChanges() {
    var fromTable = $("#report_template_from_section option").filter(":selected").val();
    if (fromTable != "") {
      retrieveTableAttributes(fromTable);
    } else {
      resetToFromInput();
    };
  };

  // dynamical adds/removes table_name.attributes from Select section if table name doesn't appear in FROM or JOIN sections
  function scanJoinSectionChanges() {
    var joinSectionInput = $("#report_template_join_section_input textarea").val();
    if (joinSectionInput.length) {
      var validTableNames = joinSectionValidTableNames(joinSectionInput);
      var fromSectionInput = $("#report_template_from_section option").filter(":selected").val();
      var tableNames = fromSectionInput
      if (validTableNames) {
        tableNames = tableNames + ", " + validTableNames
      };
      tableNames = tableNames.replace(/\s/g, "");
      retrieveTableAttributes(tableNames);
    };
  };

  function joinSectionValidTableNames(joinSectionInput) {
    var fromSectionOptions = $("select#report_template_from_section option").map(function() {return $(this).val();}).get();
    var joinSectionInputArray = joinSectionInput.split(" ");
    var validTableNames = $.map(joinSectionInputArray, function (possibleTableName) {
      if (fromSectionOptions.indexOf(possibleTableName) >= 0) {
        return possibleTableName;
      };
    });
    return validTableNames;
  };

  function enabledSelectSectionOptions() {
    var selectSectionOptions = $("#report_template_select_section_input input[type='checkbox']:checked");
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
        $("#report_template_select_section_input ol.choices-group").append("<li class='choice'><label for='report_template_select_section_" + tableAttribute + "'><input type='checkbox' name='report_template[select_section][]' id='report_template_select_section_" + tableAttribute + "' value=" + tableAttribute + "></input>" + tableAttribute + "</label></li>");
      });
    });

    enablePreviouslyCheckedSelectOptions(selectedOptionValues);
  };

  function listCheckedSelectOptions() {
    var selectedOptions = $("#report_template_select_section_input li.choice input[type='checkbox']:checked");
    if (selectedOptions.length > 0) {
      var selectedOptionValues = $.map(selectedOptions, function(selectedOption) {
        return selectedOption.value;
      });
      return selectedOptionValues;
    };
  };

  function resetSelectOptions() {
    $("#report_template_select_section_input ol.choices-group").empty();
    $("#report_template_select_section_input ol.choices-group").append("<li class='choice'><label for='report_template_select_section_*'><input type='checkbox' name='report_template[select_section][]' id='report_template_select_section_*' value='*'></input>*</label></li>");
  };

  function enablePreviouslyCheckedSelectOptions(selectedOptionValues) {
    if (selectedOptionValues) {
      $.each(selectedOptionValues, function(index, selectedOptionValue) {
        if (isAnAggregate(selectedOptionValue)) {
          var preAggregateSelectSectionOption = identifyPreAggregatedSelectOption(selectedOptionValue);
          var selectSectionOptionValue =$(preAggregateSelectSectionOption).val();
          var aggregateFunction = identifyAggregateFunction(selectedOptionValue);
          checkSelectSectionOption(preAggregateSelectSectionOption);
          addOrRemoveAggregateDropdown(selectSectionOptionValue);
          selectAggregateDropdownOption(preAggregateSelectSectionOption, aggregateFunction);
        } else {
          $("#report_template_select_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
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
    $.each(tables, function(index, table) {
      var attributes = tableAttributes[table]
      $.each(attributes, function(index, attribute) {
        tableAttribute = table + "." + attribute
        $("#report_template_order_section_input ol.choices-group").append("<li class='choice'><label for='report_template_order_section_" + tableAttribute + "'><input type='radio' name='report_template[order_section]' id='report_template_order_section_" + tableAttribute + "' value="+tableAttribute+"></input>"+tableAttribute+"</label></li>");
      });
    });

    enablePreviouslyCheckedOrderOption(selectedOptionValue);
  };

  function listCheckedOrderOption() {
    var selectedOption = $("#report_template_order_section_input li.choice input[type='radio']:checked");
    if (selectedOption.length > 0) {
      var selectedOptionValue = selectedOption[0].value;
      return selectedOptionValue;
    };
  };

  function resetOrderOptions() {
    $("#report_template_order_section_input ol.choices-group").empty();
  };

  function enablePreviouslyCheckedOrderOption(selectedOptionValue) {
    if (selectedOptionValue) {
      $("#report_template_order_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
    };
  };

  function listCheckedGroupByOptions() {
    var selectedOptions = $("#report_template_group_by_section_input li.choice input[type='checkbox']:checked");
    if (selectedOptions.length > 0) {
      var selectedOptionValues = $.map(selectedOptions, function(selectedOption) {
        return selectedOption.value;
      });
      return selectedOptionValues;
    };
  };

  function resetGroupByOptions() {
    $("#report_template_group_by_section_input ol.choices-group").empty();
  };

  function enablePreviouslyCheckedGroupByOptions(selectedOptionValues) {
    if (selectedOptionValues) {
      $.each(selectedOptionValues, function(index, selectedOptionValue) {
        $("#report_template_group_by_section_input li.choice input[value='"+selectedOptionValue+"']").prop("checked", true);
      });
    };
  };

  function resetToFromInput() {
    resetSelectOptions();
    resetGroupByOptions();
    resetOrderOptions();
    $("#report_template_join_section_input textarea").val("");
  };

  function unselectNonAsteriskOptions() {
    var asteriskOption = $("#report_template_select_section_input input[type='checkbox']")[0];
    var allNonAsteriskOptions = $("#report_template_select_section_input input[type='checkbox']").not(asteriskOption);
    $(allNonAsteriskOptions).prop('checked', false);
    $.each(allNonAsteriskOptions, function (index, selectSectionOption) {
      var selectSectionOptionValue = $(selectSectionOption).val();
      addOrRemoveAggregateDropdown(selectSectionOptionValue);
    });
  };

  function unselectAsteriskOption() {
    var asteriskOption = $("#report_template_select_section_input input[type='checkbox']")[0];
    var asteriskOptionValue = $(asteriskOption).val();
    if ($(asteriskOption).is(":checked")) {
      $(asteriskOption).prop('checked', false);
      addOrRemoveAggregateDropdown(asteriskOptionValue);
    };
  };

  function addOrRemoveAggregateDropdown(selectedOptionValue) {
    var selectSectionOption = $("#report_template_select_section_input input[value='" + selectedOptionValue + "']");
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
    var savedSelectSelectionsWithAggregates = $("#report_template_select_section_with_aggregates").val().split(" ");
    var arrayLength = savedSelectSelectionsWithAggregates.length;
    for (var i = 0; i < arrayLength; i++) {
      var selectedOptionValue = savedSelectSelectionsWithAggregates[i];
      if (isAnAggregate(selectedOptionValue)) {
        var preAggregateSelectSectionOption = identifyPreAggregatedSelectOption(selectedOptionValue);
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

  function isAnAggregate(selectedAttribute) {
    return (selectedAttribute.indexOf("(") >= 0 && selectedAttribute.indexOf(")") >= 0)
  };

  function identifyPreAggregatedSelectOption(selectedAttribute) {
    var regExp = /\(([^)]+)\)/;
    var selectedSelectSection = regExp.exec(selectedAttribute)[1];
    return $("#report_template_select_section_input input[value='" + selectedSelectSection + "']");
  };

  function identifyPreAggregatedSelectOptionValue(selectedAttribute) {
    var regExp = /\(([^)]+)\)/;
    return regExp.exec(selectedAttribute)[1];
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

  function updateGroupByFromEnabledSelectSection() {
    var selectedSelectOptionValues = listCheckedSelectOptions();
    var selectedGroupByOptionValues = listCheckedGroupByOptions();
    var selectedSelectOptionBaseValues = $.map(selectedSelectOptionValues, function (selectedSelectOptionValue) {
      if (isAnAggregate(selectedSelectOptionValue)) {
        selectedSelectOptionValue = identifyPreAggregatedSelectOptionValue(selectedSelectOptionValue);
      };
      return selectedSelectOptionValue;
    });
    resetGroupByOptions();
    if (selectedSelectOptionBaseValues[0] == "*") {
      var selectOptionBaseValues = allSelectOptionBaseValues();
      $.each(selectOptionBaseValues, function (index, selectOptionBaseValue) {
        if (selectOptionBaseValue != "*") {
          $("#report_template_group_by_section_input ol.choices-group").append("<li class='choice'><label for='report_template_group_by_section_" + selectOptionBaseValue + "'><input type='checkbox' name='report_template[group_by_section][]' id='report_template_group_by_section_" + selectOptionBaseValue + "' value=" + selectOptionBaseValue + "></input>" + selectOptionBaseValue + "</label></li>");
        };
      });
    } else {
      $.each(selectedSelectOptionBaseValues, function (index, selectedSelectOptionBaseValue) {
            $("#report_template_group_by_section_input ol.choices-group").append("<li class='choice'><label for='report_template_group_by_section_" + selectedSelectOptionBaseValue + "'><input type='checkbox' name='report_template[group_by_section][]' id='report_template_group_by_section_" + selectedSelectOptionBaseValue + "' value=" + selectedSelectOptionBaseValue + "></input>" + selectedSelectOptionBaseValue + "</label></li>");
      });
    };
    enablePreviouslyCheckedGroupByOptions(selectedGroupByOptionValues);
  };

  function allSelectOptionBaseValues() {
    var selectOptionLabels = $("#report_template_select_section_input li.choice label");
    var selectOptionBaseValues = $.map(selectOptionLabels, function (selectOptionLabel) {
      return $(selectOptionLabel).text();
    });
    return selectOptionBaseValues;
  };
});
