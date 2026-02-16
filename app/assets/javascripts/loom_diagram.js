function loomLayout(layoutData) {
  // Constants needed for the Loom Layout
  let padding = 0.02; // The padding between arcs
  let emptyPerc = 0.2; // The extra padding needed at the top and bottom.
  let heightInner = 20; // The height of the words

  // Nest the data on the outer variable
  const outerData = Array.from(d3.group(layoutData, (d) => d.outer));
  // The number of outer group entries
  const n = outerData.length;

  // The total count of events
  const total = d3.sum(layoutData.map((d) => d.value));

  // emptyPerc gives the fraction of the pie that is in empty wedges
  // padding gives the spacing between groups
  const totalPaddingFraction = emptyPerc + (padding * (n - 2)) / (2 * Math.PI);

  // Calculate the effective total which includes all padding
  const effectiveTotal = total / (1 - totalPaddingFraction);

  // Sorted group of inner data
  let innerGroups = Array.from(
    d3.rollup(
      layoutData,
      (v) => d3.sum(v, (d) => d.value),
      (d) => d.inner,
    ),
  ) // Creates a nested object of inner name and values of other variables
    .sort((a, b) => b[1] - a[1]) // Sort in descending order
    .map((d, i, arr) => ({
      innerName: d[0],
      innerTotal: d[1],
      innerTotalFormat: d3.format(",.0f")(d[1]),
      subGroupIndex: i,
      total: total, // The total of all events
      x: 0, // Text located in the center of the image
      y: (-1 * arr.length * heightInner) / 2 + i * heightInner, // Text placement in y
    })); // Map to the output object

  // Define the left and right start angles
  // Imagining 0 is the vertical center and everything is evenly split down the sides
  let startAngleRight = (emptyPerc / 4) * (2 * Math.PI);
  let startAngleLeft = -1 * startAngleRight;

  // Define the total for the left and right sides
  // Use a greedy algorithm to separate the set into left and right sides.
  let leftTotal = 0;
  let rightTotal = 0;

  // Grouping of outer data
  let outerGroups = Array.from(
    d3.rollup(
      layoutData,
      (v) => d3.sum(v, (d) => d.value),
      (d) => d.outer,
    ),
  )
    .sort((a, b) => b[1] - a[1])
    .map((d, i) => {
      // Calculate the starting and ending angle of the group
      let startAngle, endAngle;
      if (leftTotal > rightTotal) {
        startAngle = startAngleRight;
        endAngle = startAngle + (d[1] / effectiveTotal) * (2 * Math.PI);
        // Calculate the next starting angle on the RHS
        startAngleRight = endAngle + padding;

        // Increment the Right Total for greedy algorithm
        rightTotal += d[1];
      } else {
        startAngle = startAngleLeft;
        endAngle = startAngle - (d[1] / effectiveTotal) * (2 * Math.PI);
        // Calculate the next starting angle on the LHS
        startAngleLeft = endAngle - padding;

        // Increment the Left Total for greedy algorithm
        leftTotal += d[1];
      }

      // Return a object with information about the group
      return {
        outerName: d[0],
        groupTotal: d[1],
        groupTotalFormat: d3.format(",.0f")(d[1]),
        groupIndex: i,
        groupFraction: d[1] / total,
        groupPercent: d3.format(".1f")((d[1] / total) * 100),
        groupStartAngle: startAngle,
        groupEndAngle: endAngle,
        total: total, // The total of all events
      };
    });

  // Map the input data to the loom structure
  let stringLayout = layoutData.map(function (d) {
    // Search outer groups and inner groups to find elements matching the data
    let outerData = outerGroups.find((e) => e.outerName == d.outer);
    let innerData = innerGroups.find((e) => e.innerName == d.inner);

    // Get the inner group index
    outerData.subGroupIndex = innerData.subGroupIndex;

    // Get the value of the string and the fraction of the subGroup
    outerData.value = d.value;
    outerData.subGroupFraction = d.value / outerData.groupTotal;

    // Prepare outer group formatting for display
    outerData.subGroupTotal = d3.format(",.0f")(d.value);
    outerData.subGroupPercent = d3.format(".1f")(
      outerData.subGroupFraction * 100,
    );

    // Prepare inner group formatting for display
    innerData.innerPercent = d3.format(".1f")(
      (d.value / innerData.innerTotal) * 100,
    );

    // This calculation is to figure out the angles of the subgroups

    // Get the list of previous subgroups used in the group
    let largerSubGroups = innerGroups
      .filter((e) => e.subGroupIndex < innerData.subGroupIndex)
      .map((e) => e.innerName);

    // Find the fraction of subGroups seen previously
    let previousSubGroups = layoutData
      .filter((e) => (e.outer == d.outer) & largerSubGroups.includes(e.inner))
      .map((e) => e.value / outerData.groupTotal)
      .reduce((acc, e) => acc + e, 0);

    // Calculate the start and end angle of the subgroup
    outerData.subGroupStartAngle =
      outerData.groupStartAngle +
      (outerData.groupEndAngle - outerData.groupStartAngle) * previousSubGroups;

    outerData.subGroupEndAngle =
      outerData.subGroupStartAngle +
      (outerData.groupEndAngle - outerData.groupStartAngle) *
        outerData.subGroupFraction;

    return {
      inner: Object.assign({}, innerData),
      outer: Object.assign({}, outerData),
    };
  });

  return {
    outerGroups: outerGroups,
    innerGroups: innerGroups,
    strings: stringLayout,
  };
} // End Loom Layout Function

loomDiagram = function (data, uid) {
  ////////////////////////////////////////////////////////////
  //////////////////////// Set-up ////////////////////////////
  ////////////////////////////////////////////////////////////
  // Figure out the screen width
  let screenWidth = window.innerWidth,
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
  /////////////////// Set-up Loom parameters /////////////////
  ////////////////////////////////////////////////////////////

  // Set default variables
  let outerRadius = Math.min(width, height) / 2 - (mobileScreen ? 80 : 100),
    innerRadius = outerRadius * 0.95, // size of the ending arcs
    pullOutSize = mobileScreen ? 20 : 80, // the number of pixels of separation
    opacityDefault = 0.7, //default opacity of strings
    opacityHigh = 1.0, // default opacity of the strings hovered over
    opacityLow = 0.1; //hover opacity of those strings not hovered over

  // Format the loom data for further use
  let loom = loomLayout(data);

  ////////////////////////////////////////////////////////////
  ///////////////////////// Colors ///////////////////////////
  ////////////////////////////////////////////////////////////

  // Colors depend on outer list of labels
  let colors = d3.quantize(d3.interpolateRainbow, loom.outerGroups.length + 1);

  ////////////////////////////////////////////////////////////
  ///////////////// Connect data to SVG //////////////////////
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
    .datum(loom);

  ////////////////////////////////////////////////////////////
  ////////////////////// Draw outer arcs /////////////////////
  ////////////////////////////////////////////////////////////

  //Initiate an arc drawing function that is also needed
  let arc = d3
    .arc()
    .innerRadius(innerRadius)
    .outerRadius(outerRadius)
    .startAngle((d) => d.groupStartAngle)
    .endAngle((d) => d.groupEndAngle);

  let arcGroup = g.append("g").attr("class", "arc-outer-wrapper");

  //Create a group per outer arc, which will contain the arc path + the outer name & number of value text
  let arcs = arcGroup
    .selectAll(".arc-wrapper")
    .data((s) => s.outerGroups)
    .enter()
    .append("g")
    .attr("class", "arc-wrapper")
    .each(function (d) {
      // Define the color for the outer group
      d.color = colors[d.groupIndex];
      // Define the average angle of the arc in degrees
      d.angle = (((d.groupStartAngle + d.groupEndAngle) / 2) * 180) / Math.PI;
      // Add a definition for the pull out size to each object
      d.pullOutSize = pullOutSize * (d.angle > 0 ? 1 : -1);
    })
    .on("mouseover", fadeArc(opacityLow))
    .on("mouseout", fadeArc(opacityDefault));

  //Create the actual arc paths
  let outerArcs = arcs
    .append("path")
    .attr("class", "arc")
    .style("fill", (d) => d.color)
    .style("stroke", "black")
    .attr("d", arc)
    .attr("transform", function (d) {
      //Pull the two slices apart
      return "translate(" + d.pullOutSize + "," + 0 + ")";
    });

  ////////////////////////////////////////////////////////////
  //////////////////// Draw outer labels /////////////////////
  ////////////////////////////////////////////////////////////

  let outerLabels = arcs
    .append("g")
    .attr("class", "outer-labels")
    .attr("text-anchor", function (d) {
      // Define which end of the text to anchor at
      // depending on the left or right hand side
      return d.angle < 0 ? "end" : "start";
    })
    .attr("transform", function (d, i) {
      return (
        // Pull out text in X
        "translate(" +
        d.pullOutSize +
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

  // Add the Outer Label Name
  outerLabels
    .append("text")
    .attr("class", "outer-label")
    .attr("dy", "-.5em")
    .text((d) => d.outerName);

  // Add the Outer Value
  outerLabels
    .append("text")
    .attr("class", "outer-label-value")
    .attr("dy", ".5em")
    .text((d) => d.groupTotalFormat + " events");

  ////////////////////////////////////////////////////////////
  //////////////////// Draw inner labels /////////////////////
  ////////////////////////////////////////////////////////////

  let innerLabelGroup = g.append("g").attr("class", "inner-label-wrapper");

  //Place the inner text labels in the middle of the stretched Chord
  let innerLabels = innerLabelGroup
    .selectAll("text")
    .data((s) => s.innerGroups)
    .enter()
    .append("text")
    .attr("class", "inner-label")
    .attr("text-anchor", "middle")
    .attr("x", (d) => d.x)
    .attr("y", (d) => d.y)
    .attr("dy", ".35em")
    .text((d) => d.innerName)
    .on("mouseover", fadeInnerLabel(opacityLow))
    .on("mouseout", fadeInnerLabel(opacityHigh));

  ////////////////////////////////////////////////////////////
  //////////////////// Draw inner strings ////////////////////
  ////////////////////////////////////////////////////////////

  // 8px is the average width of a 16px character
  const innerNameWidth =
    (8 * Math.max(...loom.innerGroups.map((d) => d.innerName.length))) / 2;

  let stringPaths = loom.strings.map(function (d) {
    // Adjustment for the difference in orientation between svg and loom data
    const adjustedStartAngle =
      (d.outer.subGroupStartAngle < 0
        ? d.outer.subGroupEndAngle
        : d.outer.subGroupStartAngle) -
      Math.PI / 2;
    const adjustedEndAngle =
      (d.outer.subGroupStartAngle < 0
        ? d.outer.subGroupStartAngle
        : d.outer.subGroupEndAngle) -
      Math.PI / 2;

    // The central position of the arc
    const arcCenterX = (d.outer.subGroupStartAngle < 0 ? -1 : 1) * pullOutSize;
    const arcCenterY = 0;

    // The x,y starting position of the arc
    const arcStartX = innerRadius * Math.cos(adjustedStartAngle) + arcCenterX;
    const arcStartY = innerRadius * Math.sin(adjustedStartAngle) + arcCenterY;
    // The x,y ending position of the arc
    const arcEndX = innerRadius * Math.cos(adjustedEndAngle) + arcCenterX;
    const arcEndY = innerRadius * Math.sin(adjustedEndAngle) + arcCenterY;

    // Define the location of the inner words
    // with the offset for word length.
    const innerX =
      d.inner.x + (d.outer.subGroupStartAngle < 0 ? -1 : 1) * innerNameWidth;
    const innerY = d.inner.y;
    // Define the control points of the bezier curves
    // For the first Bezier Curve ("A")
    const controlAX1 = d3.interpolateNumber(arcEndX, arcCenterX)(0.5);
    const controlAY1 = d3.interpolateNumber(arcEndY, arcCenterY)(0.5);
    const controlAX2 = arcCenterX;
    const controlAY2 = innerY;

    // For the second Bezier Curve ("B")
    const controlBX1 = arcCenterX;
    const controlBY1 = innerY;
    const controlBX2 = d3.interpolateNumber(arcStartX, arcCenterX)(0.5);
    const controlBY2 = d3.interpolateNumber(arcStartY, arcCenterY)(0.5);

    // Create a path
    path = d3.path();
    // Move to the arc starting point
    path.moveTo(arcStartX, arcStartY);
    // Create the arc for the subgroup
    path.arc(
      arcCenterX,
      arcCenterY,
      innerRadius,
      adjustedStartAngle,
      adjustedEndAngle,
    );
    // Create a bezier curve from the arc to the inner words.
    path.bezierCurveTo(
      controlAX1,
      controlAY1,
      controlAX2,
      controlAY2,
      innerX,
      innerY,
    );
    // Create a bezier curve from the inner words back to the arc.
    path.bezierCurveTo(
      controlBX1,
      controlBY1,
      controlBX2,
      controlBY2,
      arcStartX,
      arcStartY,
    );
    path.closePath();

    // Return a string object
    return {
      path: path,
      color: colors[d.outer.groupIndex],
      innerName: d.inner.innerName,
      outerName: d.outer.outerName,
      innerIndex: d.outer.subGroupIndex,
      subGroupTotal: d.outer.subGroupTotal,
      outerPercent: d.outer.subGroupPercent,
      innerPercent: d.inner.innerPercent,
      totalPercent: d3.format(".1f")((d.outer.value / d.outer.total) * 100),
    };
  });

  // Build the strings connecting the middle to the sides
  let stringGroup = g.append("g").attr("class", "string-wrapper");

  stringGroup
    .selectAll("path")
    .data(stringPaths)
    .enter()
    .append("path")
    .attr("class", "string")
    .style("fill", (d) => d3.rgb(d.color).brighter(0.2))
    .style("stroke", "black")
    .attr("d", (d) => d.path)
    .attr("opacity", opacityDefault)
    .on("mouseover", fadeString(opacityLow))
    .on("mouseout", fadeString(opacityDefault));

  ////////////////////////////////////////////////////////////
  //////////////////////// Title text ////////////////////////
  ////////////////////////////////////////////////////////////

  let total = d3.sum(loom.outerGroups.map((d) => d.groupTotal));

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
    .style("font-size", "12px")
    .attr("x", 0)
    .attr("y", (outerRadius * 2) / 3)
    .style("textAlign", "center")
    .text("")
    .style("visibility", "hidden");

  ////////////////////////////////////////////////////////////
  //////////////// Interactive Behavior //////////////////////
  ////////////////////////////////////////////////////////////

  // Function to apply a heavy opacity weight to text and arcs
  function opacityWeight(opacity) {
    return opacity > 0.5 ? opacityHigh : opacity;
  }

  // Returns an event handler for fading a inner label group
  function fadeInnerLabel(opacity) {
    return function (mouseEvent, data) {
      let innerName = data.innerName;

      // Fade out non selected text
      svg
        .selectAll(".inner-label")
        .filter((d) => d.innerName !== innerName)
        .transition("fadeOnArc")
        .style("opacity", opacityWeight(opacity));

      // Create description of selection
      let description = svg
        .selectAll(".description")
        .attr("text-anchor", "middle");
      if (opacity < 0.5) {
        description
          .append("tspan")
          .attr("x", 0)
          .text(
            d3.format(".1f")((data.innerTotal / total) * 100) + "% of Total",
          )
          .attr("font-weight", 700)
          .style("visibility", "visible");
        description
          .append("tspan")
          .attr("x", 0)
          .attr("dy", "1.45" + "em")
          .text(data.innerTotalFormat + " events")
          .attr("font-weight", 300)
          .style("visibility", "visible");
      } else {
        description.text("").style("visibility", "hidden");
      }

      // Fade out non selected strings
      svg
        .selectAll(".string")
        .filter((d) => d.innerName !== innerName)
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacityDefault : opacityLow);

      // Find all selected strings
      let selectedStrings = svg
        .selectAll(".string")
        .filter((d) => d.innerName == innerName);

      // Fade in the selected strings
      selectedStrings
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacityDefault : opacityHigh);

      // Define the lists of outer and inner names
      let outerNames = selectedStrings.data().map((d) => d.outerName);
      let innerNames = selectedStrings.data().map((d) => d.innerName);

      // Fade out non selected arcs
      svg
        .selectAll(".arc-wrapper")
        .filter((d) => !outerNames.includes(d.outerName))
        .transition("fadeOnArc")
        .style("opacity", opacityWeight(opacity));

      // Change the value of the outer labels
      if (opacity < 0.5) {
        // Mouse In
        // Set all non-selected arc values to 0
        svg
          .selectAll(".outer-labels")
          .filter((d) => !outerNames.includes(d.outerName))
          .selectAll(".outer-label-value")
          .text((_) => "0 events");

        // Set all selected arc values to selected data
        svg
          .selectAll(".outer-labels")
          .filter((d) => outerNames.includes(d.outerName))
          .selectAll(".outer-label-value")
          .text(function (d) {
            return (
              selectedStrings.data().find((e) => e.outerName == d.outerName)
                .subGroupTotal + " events"
            );
          });
      } else {
        // Mouse Out
        // Set all arc values back to default
        svg
          .selectAll(".outer-label-value")
          .text((d) => d.groupTotalFormat + " events");
      }
    };
  } // fadeInnerLabel

  // Returns an event handler for fading a given outer string group
  function fadeArc(opacity) {
    return function (mouseEvent, data) {
      let outerName = data.outerName;

      // Find all selected strings
      let selectedStrings = svg
        .selectAll(".string")
        .filter((d) => d.outerName == outerName)
        .sort((a, b) => a.innerIndex - b.innerIndex);

      // Define the lists of outer and inner names
      let outerNames = selectedStrings.data().map((d) => d.outerName);
      let innerNames = selectedStrings.data().map((d) => d.innerName);

      // Fade selected strings
      selectedStrings
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacityDefault : opacityHigh);

      // Fade non-selected strings
      svg
        .selectAll(".string")
        .filter((d) => d.outerName !== outerName)
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacityDefault : opacityLow);

      // Fade non-selected arcs
      svg
        .selectAll(".arc-wrapper")
        .filter((d) => d.outerName !== outerName)
        .transition("fadeOnArc")
        .style("opacity", opacityWeight(opacity));

      // Fade non-selected inner labels
      svg
        .selectAll(".inner-label")
        .filter((d) => !innerNames.includes(d.innerName))
        .transition("fadeOnArc")
        .style("opacity", opacityWeight(opacity));

      // Create description of selection
      let description = svg
        .selectAll(".description")
        .attr("text-anchor", "middle");

      if (opacity < 0.5) {
        description
          .append("tspan")
          .attr("x", 0)
          .text(data.groupPercent + "% of Total events")
          .attr("font-weight", 700)
          .style("visibility", "visible");
        selectedStrings.data().forEach((d) =>
          description
            .append("tspan")
            .attr("x", 0)
            .attr("dy", "1.45" + "em")
            .text(
              d.innerName +
                ": " +
                d.subGroupTotal +
                " (" +
                d.outerPercent +
                "%)",
            )
            .attr("font-weight", 300)
            .style("visibility", "visible"),
        );
      } else {
        description.text("").style("visibility", "hidden");
      }
      // Change the value of the outer labels
      if (opacity < 0.5) {
        // Mouse In
        // Set all non-selected arc values to 0
        svg
          .selectAll(".outer-labels")
          .filter((d) => d.outerName !== outerName)
          .selectAll(".outer-label-value")
          .text((_) => "0 events");

        // Set all selected arc values to selected data
        svg
          .selectAll(".outer-labels")
          .filter((d) => outerName == d.outerName)
          .selectAll(".outer-label-value")
          .text((d) => d.groupTotalFormat + " events");
      } else {
        // Mouse Out
        // Set all arc values back to default
        svg
          .selectAll(".outer-label-value")
          .text((d) => d.groupTotalFormat + " events");
      }
    };
  } // fadeArc

  // Returns an event handler for fading a given outer string group
  function fadeString(opacity) {
    return function (mouseEvent, data) {
      let outerName = data.outerName;
      let innerName = data.innerName;

      // Fade non-selected inner label
      svg
        .selectAll(".inner-label")
        .filter((d) => d.innerName !== innerName)
        .transition("fadeOnArc")
        .style("opacity", opacityWeight(opacity));

      // Fade non-selected arcs
      svg
        .selectAll(".arc-wrapper")
        .filter((d) => d.outerName !== outerName)
        .transition("fadeOnArc")
        .style("opacity", opacityWeight(opacity));

      // Fade out non selected strings
      svg
        .selectAll(".string")
        .filter((d) => d.outerName !== outerName || d.innerName !== innerName)
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacity : opacityLow);

      let selectedStrings = svg
        .selectAll(".string")
        .filter((d) => d.outerName == outerName && d.innerName == innerName);

      // Fade selected string
      selectedStrings
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacity : opacityHigh);

      // Create description of selection
      let description = svg
        .selectAll(".description")
        .attr("text-anchor", "middle");

      if (opacity < 0.5) {
        description
          .append("tspan")
          .attr("x", 0)
          .text(data.totalPercent + "% of Total events")
          .attr("font-weight", 700)
          .style("visibility", "visible");
        description
          .append("tspan")
          .attr("x", 0)
          .attr("dy", "1.45" + "em")
          .text(data.innerPercent + "% of " + data.innerName + " events")
          .attr("font-weight", 300)
          .style("visibility", "visible");
        description
          .append("tspan")
          .attr("x", 0)
          .attr("dy", "1.45" + "em")
          .text(data.outerPercent + "% of " + data.outerName + " events")
          .attr("font-weight", 300)
          .style("visibility", "visible");
      } else {
        description.text("").style("visibility", "hidden");
      }

      // Change the value of the outer labels
      if (opacity < 0.5) {
        // Mouse In
        // Set all non-selected arc values to 0
        svg
          .selectAll(".outer-labels")
          .filter((d) => d.outerName !== outerName)
          .selectAll(".outer-label-value")
          .text((_) => "0 events");

        // Set all selected arc values to selected data
        svg
          .selectAll(".outer-labels")
          .filter((d) => outerName == d.outerName)
          .selectAll(".outer-label-value")
          .text(function (d) {
            return (
              selectedStrings.data().find((e) => e.outerName == d.outerName)
                .subGroupTotal + " events"
            );
          });
      } else {
        // Mouse Out
        // Set all arc values back to default
        svg
          .selectAll(".outer-label-value")
          .text((d) => d.groupTotalFormat + " events");
      }
    };
  } // fadeString
};
