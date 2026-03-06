// Function should take a list of Hashes of data and a unique identifier
// data = [{A: From Category, B: To Category, value: strength}, ...]
// The uid must be the name of the div that the svg will be inserted into
// It needs to be unique to ensure that the gradient colors aren't screwed up.

function chordLayout(layoutData) {
  // Constants needed for the Layout
  let padding = 0.02; // The padding between arcs
  let emptyPerc = 0.2; // The extra padding needed at the top and bottom.

  // Calculate the total of all events
  const total = d3.sum(layoutData, (d) => d.value);

  function processGroups(inputData, left = False) {
    // Organize the data in name value pairs in descending order
    const groups = Array.from(
      d3.rollup(
        inputData,
        (v) => d3.sum(v, (d) => d.value),
        (d) => (left ? d.left : d.right),
      ),
    ) // Creates a nested object of inner name and values of other variables
      .sort((a, b) => b[1] - a[1])
      .map((d) => ({ name: d[0], value: d[1] }));

    // The number of groupings
    const n = groups.length;

    // Calculate the percent of the half pie that will be padding
    // emptyPerc gives the padding between the left and right sides in percent
    // padding is the angular gap between groups in radians
    // Half of the circle is pi
    const totalPaddingFraction = emptyPerc + (padding * (n - 1)) / Math.PI;

    // Calculate the effective total which includes all padding
    const effectiveTotal = total / (1 - totalPaddingFraction);

    // calculate the start angle
    let startAngle = (emptyPerc / 4) * 2 * Math.PI;

    // Return a object with information about the group
    let processedData = groups.map((d, i) => {
      groupAngle = (d.value / effectiveTotal) * Math.PI;
      endAngle = startAngle + groupAngle;

      output = {
        groupName: d.name,
        groupValue: d.value,
        groupValueFormat: d3.format(",.0f")(d.value),
        groupIndex: i,
        groupAngle: groupAngle,
        groupStartAngle: startAngle * (left ? -1 : 1),
        groupEndAngle: endAngle * (left ? -1 : 1),
        group: left ? "left" : "right",
        groupTotal: total, // The total of all events
      };

      // Increment the starting angle
      startAngle = endAngle + padding;

      return output;
    }); // End processedData

    return processedData;
  } // End processGroups

  const leftGroups = processGroups(layoutData, true);
  const rightGroups = processGroups(layoutData, false);

  // Map the input data to the loom structure
  let chord = layoutData.map(function (d) {
    // Search left groups and right groups to find elements matching the data
    let leftData = leftGroups.find((e) => e.groupName == d.left);
    let rightData = rightGroups.find((e) => e.groupName == d.right);

    let output = {
      left: Object.assign({}, leftData),
      right: Object.assign({}, rightData),
    };

    output.value = d.value;
    output.valueFormat = d3.format(",.0f")(d.value);

    // Calculate the missing left hand subgroup facts
    output.left.subgroupFraction = d.value / leftData.groupValue;

    // Calculate the angle subtended by the subgroup
    output.left.subgroupAngle =
      (leftData.groupEndAngle - leftData.groupStartAngle) *
      output.left.subgroupFraction;

    // Sort in order of the right hand index
    let previousRightGroups = rightGroups
      .filter((e) => e.groupIndex < rightData.groupIndex)
      .map((e) => e.groupName);

    let previousLeftSum = d3.sum(
      layoutData.filter(
        (e) => e.left == d.left && previousRightGroups.includes(e.right),
      ),
      (e) => e.value,
    );

    // Calculate the starting angle of the left side
    output.left.subgroupStartAngle =
      output.left.groupStartAngle -
      (previousLeftSum / output.left.groupValue) * output.left.groupAngle;

    output.left.subgroupEndAngle =
      output.left.subgroupStartAngle + output.left.subgroupAngle;

    // Sort in order of the left hand index
    let previousLeftGroups = leftGroups
      .filter((e) => e.groupIndex < leftData.groupIndex)
      .map((e) => e.groupName);

    let previousRightSum = d3.sum(
      layoutData.filter(
        (e) => e.right == d.right && previousLeftGroups.includes(e.left),
      ),
      (e) => e.value,
    );

    // Calculate the missing right hand subgroup facts
    output.right.subgroupFraction = d.value / rightData.groupValue;

    // Calculate the angle subtended by the subgroup
    output.right.subgroupAngle =
      (rightData.groupEndAngle - rightData.groupStartAngle) *
      output.right.subgroupFraction;

    // Calculate the starting angle of the right side
    output.right.subgroupStartAngle =
      output.right.groupStartAngle +
      (previousRightSum / output.right.groupValue) * output.right.groupAngle;

    output.right.subgroupEndAngle =
      output.right.subgroupStartAngle + output.right.subgroupAngle;

    return output;
  });

  return {
    groups: leftGroups.concat(rightGroups),
    leftGroups: leftGroups,
    rightGroups: rightGroups,
    chords: chord,
  };
} // End Chord Layout Function

chordDiagram = function (data, uid) {
  ////////////////////////////////////////////////////////////
  //////////////////////// Set-up ////////////////////////////
  ////////////////////////////////////////////////////////////
  // Figure out the screen width
  var screenWidth = $(window).width(),
    mobileScreen = screenWidth > 400 ? false : true;

  ///////////////////////////////////////////////////////////
  ////////////////////// Create SVG //////////////////////////
  ////////////////////////////////////////////////////////////

  // Calculate the margins around the svg
  let margin = { left: 50, top: 10, right: 50, bottom: 10 },
    width = Math.min(screenWidth, 1000) - margin.left - margin.right,
    height =
      (mobileScreen ? 300 : (Math.min(screenWidth, 1000) * 5) / 6) -
      margin.top -
      margin.bottom;

  // Create an svg to display
  let svg = d3
    .select("#" + uid)
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom);

  ////////////////////////////////////////////////////////////
  /////////////////// Set-up Chord parameters ////////////////
  ////////////////////////////////////////////////////////////

  // Set default variables
  let outerRadius = Math.min(width, height) / 2 - (mobileScreen ? 80 : 100),
    innerRadius = outerRadius * 0.95,
    pullOutSize = mobileScreen ? 20 : 50, // the number of pixels of separation
    opacityDefault = 0.7, //default opacity of chords
    opacityHigh = 1.0, // default opacity of the chord hovered over
    opacityLow = 0.1; //hover opacity of those chords not hovered over

  // Format the loom data for further use
  let chord = chordLayout(data);

  ////////////////////////////////////////////////////////////
  ///////////////////////// Colors ///////////////////////////
  ////////////////////////////////////////////////////////////

  // Colors depend on left list of labels
  let colors = d3.quantize(d3.interpolateRainbow, chord.groups.length + 1);

  ////////////////////////////////////////////////////////////
  ///////////////////// Read in data /////////////////////////
  ////////////////////////////////////////////////////////////

  // Build the svg and connect to the data
  let g = svg
    .append("g")
    .attr(
      "transform",
      "translate(" +
        (width / 2 + margin.left) +
        "," +
        (height / 2 + margin.top) +
        ")",
    )
    .datum(chord);

  ////////////////////////////////////////////////////////////
  ////////////////////// Draw arcs ///////////////////////
  ////////////////////////////////////////////////////////////

  //Initiate an arc drawing function that is also needed
  let arc = d3
    .arc()
    .innerRadius(innerRadius)
    .outerRadius(outerRadius)
    .startAngle((d) => d.groupStartAngle)
    .endAngle((d) => d.groupEndAngle);

  let arcGroup = g.append("g").attr("class", "arc-outer-wrapper");

  //Create a group per arc, which will contain the arc path + the left name & number of value text
  let arcs = arcGroup
    .selectAll(".arc-wrapper")
    .data((s) => s.groups)
    .enter()
    .append("g")
    .attr("class", "arc-wrapper")
    .each(function (d) {
      // Define the color for the group
      let idx =
        d.groupIndex + (d.group == "left" ? 0 : chord.leftGroups.length);
      d.color = colors[idx];
      // Define the average angle of the arc in degrees
      d.angle = (((d.groupStartAngle + d.groupEndAngle) / 2) * 180) / Math.PI;
      // Add a definition for the pull out size to each object
      d.pullOutSize = pullOutSize * (d.angle > 0 ? 1 : -1);
    })
    .on("mouseover", fadeArc(opacityLow))
    .on("mouseout", fadeArc(opacityDefault));

  //Create the actual arc paths
  let arcPaths = arcs
    .append("path")
    .attr("class", "arc")
    .style("fill", (d) => d.color)
    .style("stroke", "black")
    .attr("d", arc)
    .attr("transform", (d) => "translate(" + d.pullOutSize + "," + 0 + ")");

  ////////////////////////////////////////////////////////////
  //////////////////// Draw left labels /////////////////////
  ////////////////////////////////////////////////////////////

  let arcLabels = arcs
    .append("g")
    .attr("class", "arc-labels")
    .attr("text-anchor", function (d) {
      // Define which end of the text to anchor at
      // depending on the left or right hand side
      return d.angle < 0 ? "end" : "start";
    })
    .attr("transform", function (d) {
      return (
        // Pull out text in X
        "translate(" +
        50 * (d.angle < 0 ? -1 : 1) +
        ", 0)rotate(" +
        // Rotate text to appropriate location
        // 90 offset needed since chord zero is vertical and svg zero is horizontal
        (d.angle - 90) +
        ")" +
        // Move the text outside the circle of arcs
        "translate(" +
        1.05 * outerRadius +
        ", 0)" +
        // Flip the text depending on left or right hand side
        (d.angle < 0 ? "rotate(180)" : "")
      );
    });
  // Add the left Label Name
  arcLabels
    .append("text")
    .attr("class", "arc-label")
    .attr("dy", "-.5em")
    .text((d) => d.groupName);

  // Add the arc Value
  arcLabels
    .append("text")
    .attr("class", "arc-label-value")
    .attr("dy", ".5em")
    .text((d) => d.groupValueFormat + " events");

  ////////////////////////////////////////////////////////////
  /////////////// Create the gradient fills //////////////////
  ////////////////////////////////////////////////////////////

  //Function to create the id for each chord gradient
  function getGradID(d) {
    return (
      uid + "-" + "linkGrad-" + d.left.groupIndex + "-" + d.right.groupIndex
    );
  }

  //Create the gradients definitions for each chord
  var gradients = svg
    .append("defs")
    .selectAll("linearGradient")
    .data(chord.chords)
    .enter()
    .append("linearGradient")
    .attr("id", (d) => getGradID(d))
    .attr("gradientUnits", "userSpaceOnUse")
    .attr("x1", function (d) {
      // Find the midpoint angle of the arc (with offset)
      // A 90 turn is needed as well
      var avg_angle =
        (d.left.subgroupStartAngle + d.left.subgroupEndAngle) / 2 - Math.PI / 2;
      // Return the x value modified by half of the pullout size
      return innerRadius * Math.cos(avg_angle) - pullOutSize;
    })
    .attr("y1", function (d) {
      var avg_angle =
        (d.left.subgroupStartAngle + d.left.subgroupEndAngle) / 2 - Math.PI / 2;
      return innerRadius * Math.sin(avg_angle);
    })
    .attr("x2", function (d) {
      var avg_angle =
        (d.right.subgroupStartAngle + d.right.subgroupEndAngle) / 2 -
        Math.PI / 2;
      return innerRadius * Math.cos(avg_angle) + pullOutSize;
    })
    .attr("y2", function (d) {
      var avg_angle =
        (d.right.subgroupStartAngle + d.right.subgroupEndAngle) / 2 -
        Math.PI / 2;
      return innerRadius * Math.sin(avg_angle);
    });

  //Set the starting color (at 0%)
  gradients
    .append("stop")
    .attr("offset", "0%")
    .attr("stop-color", (d) => colors[d.left.groupIndex]);

  //Set the ending color (at 100%)
  gradients
    .append("stop")
    .attr("offset", "100%")
    .attr("stop-color", function (d) {
      return colors[chord.leftGroups.length + d.right.groupIndex];
    });

  ////////////////////////////////////////////////////////////
  ////////////////////// Draw chords /////////////////////////
  ////////////////////////////////////////////////////////////

  let chordPaths = chord.chords.map(function (d) {
    // Adjustment for the difference in orientation between svg and loom data
    const leftStartAngle = d.left.subgroupEndAngle - Math.PI / 2;
    const leftEndAngle = d.left.subgroupStartAngle - Math.PI / 2;

    // Adjustment for the difference in orientation between svg and loom data
    const rightStartAngle = d.right.subgroupStartAngle - Math.PI / 2;
    const rightEndAngle = d.right.subgroupEndAngle - Math.PI / 2;

    // The central position of the arc
    const leftCenterX = -1 * pullOutSize;
    const leftCenterY = 0;

    const rightCenterX = pullOutSize;
    const rightCenterY = 0;

    // The x,y starting position of the left arc
    const leftArcStartX = innerRadius * Math.cos(leftStartAngle) + leftCenterX;
    const leftArcStartY = innerRadius * Math.sin(leftStartAngle) + leftCenterY;

    // The x,y ending position of the right arc
    const rightArcStartX =
      innerRadius * Math.cos(rightStartAngle) + rightCenterX;
    const rightArcStartY =
      innerRadius * Math.sin(rightStartAngle) + rightCenterY;

    // Create a path
    path = d3.path();
    // Move to the arc starting point
    path.moveTo(leftArcStartX, leftArcStartY);
    // Create the arc for the left subgroups
    path.arc(
      leftCenterX,
      leftCenterY,
      innerRadius,
      leftStartAngle,
      leftEndAngle,
    );

    path.quadraticCurveTo(0, 0, rightArcStartX, rightArcStartY);

    // Create the arc for the right subgroups
    path.arc(
      rightCenterX,
      rightCenterY,
      innerRadius,
      rightStartAngle,
      rightEndAngle,
    );

    path.quadraticCurveTo(0, 0, leftArcStartX, leftArcStartY);

    path.closePath();

    // Return a chord object
    return {
      path: path,
      color: "url(#" + getGradID(d) + ")",
      rightName: d.right.groupName,
      leftName: d.left.groupName,
      leftIndex: d.left.groupIndex,
      rightIndex: d.right.groupIndex,
      value: d.value,
      fraction: d.value / d.left.groupTotal,
      percent: d3.format(".1f")((d.value / d.left.groupTotal) * 100),
    };
  });

  // Build the chords connecting the middle to the sides
  let chordGroup = g.append("g").attr("class", "chord-wrapper");

  chordGroup
    .selectAll("path")
    .data(chordPaths)
    .enter()
    .append("path")
    .attr("class", "chord")
    .style("fill", (d) => d.color)
    .style("stroke", "black")
    .attr("d", (d) => d.path)
    .style("opacity", opacityDefault)
    .attr("left", (d) => d.leftIndex)
    .attr("right", (d) => d.rightIndex)
    .on("mouseover", fadeChord(opacityLow))
    .on("mouseout", fadeChord(opacityDefault));

  ////////////////////////////////////////////////////////////
  //////////////////////// Title text ////////////////////////
  ////////////////////////////////////////////////////////////

  let total = chord.leftGroups[0].groupTotal;

  // Put the total number of events above the chord diagram
  g.append("text")
    .attr("class", "total")
    .attr("x", 0)
    .attr("y", -outerRadius)
    .attr("text-anchor", "middle")
    .style("textAlign", "center")
    .text("Total Events:")
    .style("font-size", "30px")
    .append("tspan")
    .attr("x", 0)
    .attr("y", -outerRadius)
    .attr("dy", "1.1em")
    .attr("text-anchor", "middle")
    .style("textAlign", "center")
    .text(d3.format(",.0f")(total));

  g.append("text")
    .attr("class", "description")
    .attr("text-anchor", "middle")
    .style("font-size", "24px")
    .attr("x", 0)
    .attr("y", (outerRadius * 2) / 3)
    .style("textAlign", "center")
    .text("")
    .style("visibility", "hidden");

  ////////////////////////////////////////////////////////////
  //////////////// Interactive Behavior //////////////////////
  ////////////////////////////////////////////////////////////

  // Function to handle fading
  function fade(selectedChords, opacity) {
    // Fade the selected Chords
    selectedChords
      .transition("fadeOnArc")
      .style("opacity", opacity < 0.5 ? opacityHigh : opacityDefault);

    // Filter on the chord color, which is unique
    let selectedChordColors = selectedChords.data().map((d) => d.color);

    // Fade all non selected chords
    svg
      .selectAll(".chord")
      .filter((d) => !selectedChordColors.includes(d.color))
      .transition("fadeOnArc")
      .style("opacity", opacity < 0.5 ? opacityLow : opacityDefault);

    // Collect the selected arcs
    let selectedArcNames = selectedChords
      .data()
      .reduce((acc, d) => [...acc, d.leftName, d.rightName], []);

    // Selected arcs
    svg
      .selectAll(".arc-wrapper")
      .filter((d) => selectedArcNames.includes(d.groupName))
      .transition("fadeOnArc")
      .style("opacity", opacity < 0.5 ? opacityHigh : opacityHigh);

    // Not Selected arcs
    svg
      .selectAll(".arc-wrapper")
      .filter((d) => !selectedArcNames.includes(d.groupName))
      .transition("fadeOnArc")
      .style("opacity", opacity < 0.5 ? opacityLow : opacityHigh);

    // Update text in labels
    let leftNameValues = Array.from(
      d3.rollup(
        selectedChords.data(),
        (v) => d3.format(",.0f")(d3.sum(v, (d) => d.value)),
        (d) => d.leftName,
      ),
    );

    let rightNameValues = Array.from(
      d3.rollup(
        selectedChords.data(),
        (v) => d3.format(",.0f")(d3.sum(v, (d) => d.value)),
        (d) => d.rightName,
      ),
    );

    let nameValues = Object.fromEntries(leftNameValues.concat(rightNameValues));

    svg
      .selectAll(".arc-labels")
      .selectAll(".arc-label-value")
      .text(
        (d) =>
          (opacity < 0.5 ? nameValues[d.groupName] || 0 : d.groupValueFormat) +
          " events",
      );

    // Create description of selection
    let description = svg
      .selectAll(".description")
      .attr("text-anchor", "middle");
    if (opacity < 0.5) {
      let totalFraction = selectedChords
        .data()
        .reduce((acc, d) => acc + d.fraction, 0);
      description
        .append("tspan")
        .attr("x", 0)
        .text(d3.format(".1f")(totalFraction * 100) + "% of Total")
        .attr("font-weight", 700)
        .style("visibility", "visible");
    } else {
      description.text("").style("visibility", "hidden");
    }
  } // End fade

  // Returns an event handler for fading on an arc
  function fadeArc(opacity) {
    return function (mouseEvent, data) {
      // Find all selected chords
      let selectedChords = svg
        .selectAll(".chord")
        .filter((d) =>
          data.group == "right"
            ? data.groupIndex == d.rightIndex
            : data.groupIndex == d.leftIndex,
        );

      fade(selectedChords, opacity);
    };
  } // fadeArc

  // Returns an event handler for fading on an chord
  function fadeChord(opacity) {
    return function (mouseEvent, data) {
      // Find all selected chords
      let selectedChords = svg
        .selectAll(".chord")
        .filter((d) => data.color == d.color);

      fade(selectedChords, opacity);
    };
  }
};
