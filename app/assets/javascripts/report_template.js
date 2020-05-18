$(document).ready(function() {
  if (userOnTemplatesNewOrEditPage()) {
    loadAggregateSelectSelections();
    updateGroupByFromEnabledSelectSection();

    $("#report_template_from_section").on("change", scanFromSectionChanges);

    // called on document change due to elements being dyanamically added
    $(document).on("change","#report_template_select_section_input input[type='checkbox']", function(event) {
      clickedValue = event.target.value;
      currentSelection = enabledSelectSectionOptions();
      var asteriskOption = $("#report_template_select_section_input input[type='checkbox']");
      var asteriskOptionValue = $(asteriskOption).val();
      if (currentSelection.indexOf(asteriskOptionValue) >= 0 && clickedValue != asteriskOptionValue) {
        unselectAsteriskOption();
      } else if (clickedValue == asteriskOptionValue) {
        unselectNonAsteriskOptions();
      };
      addOrRemoveAggregateDropdown(clickedValue);
    });

    $(document).on("change","#report_template_select_section_input", updateGroupByFromEnabledSelectSection);
    $(document).on("change","#report_template_select_section_input select", function(event) {
      var changedAggregateDropdown = event.target;
      var liParent = $(changedAggregateDropdown).parent().parent();
      var selectSectionOption = $(liParent).find("input[type='checkbox']");
      addAggregateToSelectValue(selectSectionOption, liParent);
    });

    $(document).on("change","#join-section select.table-select", scanJoinSectionChanges);
    $(document).on("click","#join-section a.has_many_remove", scanJoinSectionChanges);

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
    var pageTitle = $("#page_title").text();
    return (pathName.indexOf('report_templates') >= 0) && ((pageTitle == "New Template Query" || pageTitle == "Edit Template Query"));
  };

  // removes disabled attr from "Select" section once "From" section has a valid model name
  function scanFromSectionChanges() {
    resetToFromInput();
    var fromTable = $("#report_template_from_section option").filter(":selected").val();
    if (fromTable != "") {
      retrieveTableAttributes(fromTable);
    };
  };

  // dynamical adds/removes table_name.attributes from Select section if table name doesn't appear in FROM or JOIN sections
  function scanJoinSectionChanges() {
    var fromSectionInput = $("#report_template_from_section option").filter(":selected").val();
    var tableNames = fromSectionInput;
    var joinTables = $("#join-section .table-select").map(function() {return $(this).val();}).get().join(",");
    if (joinTables) {
      tableNames = tableNames + "," + joinTables
    };
    retrieveTableAttributes(tableNames);
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
        updateGroupByFromEnabledSelectSection();
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
    if (tables) {
      $("#report_template_select_section_input ol.choices-group").append("<li class='choice'><label for='report_template_select_section_*'><input type='checkbox' name='report_template[select_section][]' id='report_template_select_section_*' value='*'></input>*</label></li>");
    };
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
    resetJoinSectionOptions();
    resetGroupByOptions();
    resetOrderOptions();
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
      $(liParent).append("<div class='aggregate select input'><select class='select-aggregate'><option value=''></option><option value='AVG'>AVG</option><option value='COUNT'>COUNT</option><option value='MAX'>MAX</option><option value='MIN'>MIN</option><option value='SUM'>SUM</option></select></div>");
    } else if (!isSelectOptionSelected(selectSectionOption) && hasAggregateDropdown(liParent)) {
      $(liParent).find(".aggregate").remove();
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
    aggregateDropdown = $(selectSectionOption).parent().parent().find('select');
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

  function resetJoinSectionOptions() {
    $("#join-section .report_template_join_clauses > fieldset").remove()
  };
});
