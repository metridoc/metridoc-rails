loomDiagram = function(data, uid) {
  ////////////////////////////////////////////////////////////
  //////////////////////// Set-up ////////////////////////////
  ////////////////////////////////////////////////////////////
  // Figure out the screen width
  var screenWidth = $(window).width(),
      mobileScreen = (screenWidth > 400 ? false : true);

  // Calculate the margins around the svg
  var margin = {left: 50, top: 10, right: 50, bottom: 10},
      width = Math.min(screenWidth, 1000) - margin.left - margin.right,
      height = Math.min(screenWidth, 1000) * 5/6 - margin.top - margin.bottom;

  // Create an svg to display
  var svg = d3.select("#" + uid).append("svg")
      .attr("width", (width + margin.left + margin.right))
      .attr("height", (height + margin.top + margin.bottom));

  // Set default variables
  var outerRadius = Math.min(width, height) / 2  - 100,
      innerRadius = outerRadius * 0.95, // size of the ending arcs
      pullOutSize = 75, // the number of pixels of separation
      padding = 0.01, // padding between arcs
      opacityDefault = 0.7, //default opacity of strings
      opacityHigh = 1.0, // default opacity of the strings hovered over
      opacityLow = 0.1; //hover opacity of those strings not hovered over

  // Define the number formatting
  var formatNumber = d3.format(",.0f");
  var formatPercent = d3.format(".2f");

  ////////////////////////////////////////////////////////////
  /////////////////// Set-up Loom parameters /////////////////
  ////////////////////////////////////////////////////////////

  // Group by A and B categories
  const groupA = loomGroupBy(data, "A", "value")
  const groupB = loomGroupBy(data, "B", "value")

  // Sort groupA in descending order
  const sortedA = sortDesc(groupA);
  // Sort groupB into two equal groups with each side descending
  const sortedB = evenSort(sortDesc(groupB), groupB);
  // Get the sorted B counts for the group sorting
  const sortedBValues = sortedB.map(a => groupB[a])

  // Calculate the total number of events
  const totalEvents = Object.values(groupA).reduce(
     (previous, current) => previous + current,
     0
  )

  // Sort by the order of A
  function sortByA(a, b) {return sortedA.indexOf(a) - sortedA.indexOf(b); }

  // Sort by the order of B, but with the counts instead of the names
  function sortByB(a, b) {
    return sortedBValues.indexOf(a) - sortedBValues.indexOf(b);
  }

  // Find the width of the longest word on the inner set
  var maxWordLength = Math.max(...sortedA.map(d => d.length));

  //Scale to convert from string length to pixels
  // Done by trial and error
  var wordScale = d3.scaleLinear()
      .domain([1, 10])
      .range([5, 50]);

  //Initiate the loom function with all the options
  var loom = d3.loom()
    .sortGroups(sortByB)
    .sortSubgroups(sortByA)
    .padAngle(0.05)
    .heightInner(20)
    .emptyPerc(0.2)
    .widthInner(wordScale(maxWordLength))
    .value(d => d.value)
    .inner(d => d.A)
    .outer(d => d.B);

  //Initiate the inner string function that belongs to the loom
  var string = d3.string()
      .radius(innerRadius)
      .pullout(pullOutSize);

  //Initiate an arc drawing function that is also needed
  var arc = d3.arc()
      .innerRadius(innerRadius*1.01)
      .outerRadius(outerRadius);


  ////////////////////////////////////////////////////////////
  ///////////////////// Read in data /////////////////////////
  ////////////////////////////////////////////////////////////

  //Create a group that already holds the data
  var g = svg.append("g")
      .attr("transform", "translate(" + (width/2 + margin.left) + "," + (height/2 + margin.top) + ")")
      .datum(loom(data));

  ////////////////////////////////////////////////////////////
  /////////////// Setup Description Text /////////////////////
  ////////////////////////////////////////////////////////////


  // Put the total number of events above the loom diagram
  svg.append("text")
    .attr("class", "total")
    .attr("x", width / 2 + margin.left)
    .attr("y", height / 8 + margin.top)
    .attr("text-anchor", "middle")
    .style("textAlign", "center")
    .text("Total Interactions:")
    .style("font-size", "30px")
    .append("tspan")
    .attr("x", width / 2 + margin.left)
    .attr("y", height / 8 + margin.top)
    .attr("dy", "1.1em")
    .attr("text-anchor", "middle")
    .style("textAlign", "center")
    .text(formatNumber(totalEvents));

  let lineHeight = 1.1; // ems
  let descriptionX = width / 2 + margin.left
  let descriptionY = height * 3 / 4 + margin.top
  svg.append("text")
    .attr("class", "description")
    .attr("text-anchor", "middle")
    .style("textAlign", "center")
    .style("font-size", "15px")
    .attr("x", descriptionX)
    .attr("y", descriptionY)
    .text("A descriptive tooltip")
    .style("visibility", "hidden");

  ////////////////////////////////////////////////////////////
  ///////////////////////// Colors ///////////////////////////
  ////////////////////////////////////////////////////////////

  // Method to create n + 1 colors in a rainbow
  // d3.interpolateRainbow(float) - function takes a float 0-1 and returns a color
  // d3.quantize(interpolator, n) - function that returns an array of n samples from interpolator
  colors = d3.quantize(d3.interpolateRainbow, Object.keys(groupB).length+1);
  var color = d3.scaleOrdinal()
    .domain(Object.keys(groupB))
    .range(colors)

  ////////////////////////////////////////////////////////////
  ////////////////////// Draw outer arcs /////////////////////
  ////////////////////////////////////////////////////////////

  var arcGroup = g.append("g").attr("class", "arc-outer-wrapper");

  //Create a group per outer arc, which will contain the arc path + the location name & number of words text
  var arcs = arcGroup.selectAll(".arc-wrapper")
    .data(function(s) { return s.groups; })
    .enter().append("g")
    .attr("class", "arc-wrapper")
    .on("mouseover", fadeArc(opacityLow))
    .on("mouseout", fadeArc(opacityDefault))
    .each(function(d) {
      d.pullOutSize = (pullOutSize * ( d.startAngle > Math.PI + 1e-2 ? -1 : 1));
    });

  //Create the actual arc paths
  var outerArcs = arcs.append("path")
    .attr("class", "arc")
    .style("fill", function(d) { return color(d.outername); })
    .style("stroke", "black")
    .attr("d", arc)
    .attr("transform", function(d, i) {
      return "translate(" + d.pullOutSize + ',' + 0 + ")"; //Pull the two slices apart
    });

  ////////////////////////////////////////////////////////////
  //////////////////// Draw outer labels /////////////////////
  ////////////////////////////////////////////////////////////

      //The text needs to be rotated with the offset in the clockwise direction
  var outerLabels = arcs.append("g")
      .each(function(d) { d.angle = ((d.startAngle + d.endAngle) / 2); })
      .attr("class", "outer-labels")
      .attr("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
      .attr("transform", function(d,i) {
        var c = arc.centroid(d);
        return "translate(" + (c[0] + d.pullOutSize) + "," + c[1] + ")"
          + "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
          + "translate(" + 26 + ",0)"
          + (d.angle > Math.PI ? "rotate(180)" : "")
      })

  //The outer name
  outerLabels.append("text")
    .attr("class", "outer-label")
    .attr("dy", ".35em")
    .text(function(d,i){ return d.outername; });

  //The value below it
  outerLabels.append("text")
    .attr("class", "outer-label-value")
    .attr("dy", "1.5em")
    .text(function(d,i){ return formatNumber(d.value) + " events"; });

  ////////////////////////////////////////////////////////////
  //////////////////// Draw inner strings ////////////////////
  ////////////////////////////////////////////////////////////

  var stringGroup = g.append("g").attr("class", "string-wrapper");

  //Draw the paths of the inner strings
  var strings = stringGroup.selectAll("path")
      .data(function(strings) { return strings; })
      .enter()
      .append("path")
      .attr("class", "string")
      .style("fill", function(d) {
        return d3.rgb( color(d.outer.outername) ).brighter(0.2);
      })
      .style("opacity", opacityDefault)
      .style("stroke","black")
      .attr("d", string)
      .on("mouseover", fadeString(opacityLow))
      .on("mouseout", fadeString(opacityDefault));

  ////////////////////////////////////////////////////////////
  //////////////////// Draw inner labels /////////////////////
  ////////////////////////////////////////////////////////////

  var innerLabelGroup = g.append("g").attr("class","inner-label-wrapper");

  //Place the inner text labels in the middle
  var innerLabels = innerLabelGroup.selectAll("text")
      .data(function(s) { return s.innergroups; })
      .enter().append("text")
      .attr("class", "inner-label")
      .style("font-size", "20px")
      .attr("x", function(d,i) { return d.x; })
      .attr("y", function(d,i) { return d.y; })
      .attr("text-anchor", "middle")
      .style("textAlign", "center")
      .attr("dy", ".35em")
      .text(function(d,i) { return d.name; })
      .on("mouseover", fadeInnerLabel(opacityLow))
      .on("mouseout", fadeInnerLabel(opacityDefault));



////////////////////////////////////////////////////////////
///////////////////// Utility Func /////////////////////////
////////////////////////////////////////////////////////////

// Function to apply a heavy opacity weight to text and arcs
function opacityWeight(opacity) {
  return opacity > 0.5 ? opacityHigh : opacity;
}

// Count the number of events in each major grouping.
// Find total if required.
function countEvents(selection, inner, total) {
  // Get the number of events for each major arc
  let eventCounts = selection
      ._groups[0]
      .reduce(function(acc, s) {
        if (inner) {
          name = s.__data__.inner.name;
        }
        else {
          name = s.__data__.outer.outername;
        }
        value = s.__data__.outer.value;
        acc[name] = (acc[name] ? acc[name] : 0) + value;
        return acc;
      }, {});

  // Sum over all arcs if requested
  if (total) {
    return Object.values(eventCounts)
      .reduce(function (acc, s) {
        acc = acc + s;
        return acc;
      }, 0);
  }

  return eventCounts;
} // countEvents

// Filter the counts to display on the plot
function filterCounts(selection) {
  // Get the number of events for each major arc
  let eventCounts = countEvents(selection, false, false);

  // Get a list of the outer labels
  outerLabels = Object.keys(eventCounts);

  // Make all unselected labels 0 events
  svg.selectAll(".outer-labels")
    .filter(d => !outerLabels.includes(d.outername))
    .selectAll(".outer-label-value")
    .text(function(d){ return "0 events"; });

  // Adjust selected label counters
  svg.selectAll(".outer-labels")
    .filter(d => outerLabels.includes(d.outername))
    .selectAll(".outer-label-value")
    .text(function(d){
      return formatNumber(eventCounts[d.outername]) + " events";
    });
} // filterCounts

// Returns an event handler for fading a inner label group
function fadeInnerLabel(opacity) {
  return function(mouseEvent, i) {

    // Get the targeted inner element
    inner = mouseEvent.target.__data__

    let innername = inner.name;

    // Fade out non selected text
    svg.selectAll(".inner-label")
      .filter(d => d.name !== innername)
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Fade out non selected strings
    svg.selectAll(".string")
      .filter(function(d) {
        return d.inner.name !== innername;
      })
      .transition("fadeOnArc")
      .style("opacity", opacity);

    // Find all selected strings
    let selectedStrings = svg.selectAll(".string")
        .filter(function(d) {
          return d.inner.name == innername;
        })
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacity : opacityHigh);

    // Filter the counters on the outer arcs
    if (opacity > 0.5) {
      filterCounts(svg.selectAll(".string").filter(d => d));
    }
    else {
      filterCounts(selectedStrings);
    }
    // List of selected outer labels connected by selected strings
    let selectedOuterLabels = selectedStrings
        ._groups[0]
        .map(s => s.__data__.outer.outername);

    // Fade out non selected text
    svg.selectAll(".outer-labels")
      .filter(d => !selectedOuterLabels.includes(d.outername))
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Fade out non selected arc
    svg.selectAll(".arc")
      .filter(function(d) {
        return !selectedOuterLabels.includes(d.outername);
      })
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Only add description text if a selection is made.
    if (opacity < 0.5) {
      // Calculate the total number of events
      let totalEvents = countEvents(
        svg.selectAll(".string").filter(d => d),
        false, true
      );

      // Calculate the selected events
      let selectedEvents = countEvents(selectedStrings, false, true);

      svg.selectAll(".description")
        .attr("x", descriptionX)
        .attr("y", descriptionY)
        .attr("text-anchor", "middle")
        .style("textAlign", "center")
        .text(formatPercent(selectedEvents / totalEvents * 100 ) + "% of Total")
        .attr("font-weight", 700)
        .style("visibility", "visible")
        .append("tspan")
        .attr("x", descriptionX)
        .attr("y", descriptionY)
        .attr("dy", "1.45" + "em")
        .attr("text-anchor", "middle")
        .style("textAlign", "center")
        .text(formatNumber(selectedEvents) + " events")
        .attr("font-weight", 300);
    }
    else {
      svg.selectAll(".description")
        .text("")
        .style("visibility", "hidden");
    }
  };
} // fadeInnerLabel

// Returns an event handler for fading a given string group
function fadeArc(opacity) {
  return function(mouseEvent, i) {
    // Get the targeted arc
    arc = mouseEvent.target.__data__
    // Get the name of the arc
    let outername = arc.outername;

    // Fade out non selected arc
    svg.selectAll(".arc")
      .filter(function(d) {
        return d.outername !== outername;
      })
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Fade out non selected strings
    svg.selectAll(".string")
      .filter(function(d) {
        return d.outer.outername !== outername;
      })
      .transition("fadeOnArc")
      .style("opacity", opacity);

    // Fade out outer labels
    svg.selectAll(".outer-labels")
      .filter(function(d) {
        return d.outername !== outername;
      })
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Find all selected strings
    let selectedStrings = svg.selectAll(".string")
        .filter(function(d) {
          return d.outer.outername == outername;
        })
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacity : opacityHigh);

    // List of selected inner labels connected by selected strings
    let selectedInnerLabels = selectedStrings
        ._groups[0]
        .map(s => s.__data__.inner.name);

    // Fade out non selected text
    svg.selectAll(".inner-label")
      .filter(d => !selectedInnerLabels.includes(d.name))
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Only add description text if a selection is made.
    if (opacity < 0.5) {
      // Calculate the total number of events
      let totalEvents = countEvents(
        svg.selectAll(".string").filter(d => d),
        false,
        true
      );

      // Calculate the selected events
      let selectedEvents = countEvents(selectedStrings, false, true);
      let groupedEvents = countEvents(selectedStrings, true, false);

      // Set the order of the text rows
      // Either in Inner String order:
      let orderA = sortedA.filter(t => Object.keys(groupedEvents).includes(t));
      // Or in Greatest to Least order
      // let orderA = Object.keys(groupedEvents).sort(function(a,b) {
      //   return groupedEvents[b] - groupedEvents[a];
      // });

      // The first line of the description box
      svg.selectAll(".description")
        .attr("font-weight", 700)
        .attr("x", descriptionX)
        .attr("y", descriptionY)
        .text(formatPercent(selectedEvents / totalEvents * 100 ) + "% of Total")
        .style("visibility", "visible");

      // Add a breakdown of the events for the inner list
      orderA.forEach( function (t,i) {
        svg.selectAll(".description")
          .append("tspan")
          .attr("x", descriptionX)
          .attr("y", descriptionY)
          .attr("dy", (i + 1) * 1.2 + "em")
          .attr("font-weight", 300)
          .text(
            t + ": " + formatNumber(groupedEvents[t]) + " (" + formatPercent(groupedEvents[t] / selectedEvents * 100 ) + "%)");
      });

    }
    else {
      svg.selectAll(".description")
        .attr("font-weight", 300)
        .text("")
        .style("visibility", "hidden");
    }
  };

}//fadeArc

// Returns an event handler for fading a given string group
function fadeString(opacity) {
  return function(mouseEvent, i) {
    // Get the targeted string
    string = mouseEvent.target.__data__

    // Get the inner and outer names of the string
    let outername = string.outer.outername;
    let innername = string.inner.name;

    // Fade out non selected arc
    svg.selectAll(".arc")
      .filter(function(d) {
        return d.outername !== outername;
      })
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Fade out non selected strings
    svg.selectAll(".string")
      .filter(function(d) {
        return d !== string;
      })
      .transition("fadeOnArc")
      .style("opacity", opacity);

    // Fade out outer labels
    svg.selectAll(".outer-labels")
      .filter(function(d) {
        return d.outername !== outername;
      })
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Find the selected string
    var selectedString = svg.selectAll(".string")
        .filter(function(d) {
          return d == string;
        })
        .transition("fadeOnArc")
        .style("opacity", opacity > 0.5 ? opacity : opacityHigh);

    // Fade out non selected text
    svg.selectAll(".inner-label")
      .filter(d => d.name !== innername)
      .transition("fadeOnArc")
      .style("opacity", opacityWeight(opacity));

    // Adjust counts for outer ring
    if (opacity > 0.5) {
      filterCounts(
        svg.selectAll(".string")
          .filter(d => d)
      );
    }
    else {
      filterCounts(selectedString);
    }

    // Add description text
    // Number of events, % of total
    // % of outer group
    // % of inner group

    // Only add description text if a selection is made.
    if (opacity < 0.5) {
      // Calculate the total number of events
      let totalEvents = countEvents(
        svg.selectAll(".string").filter(d => d),
        false,
        true
      );

      // Calculate the selected events
      let selectedEvents = countEvents(selectedString, false, true);
      let outerEvents = countEvents(
        svg.selectAll(".string").filter(d => d.outer.outername == outername),
        false,
        true
      );
      let innerEvents = countEvents(
        svg.selectAll(".string").filter(d => d.inner.name == innername),
        true,
        true
      );

      // The first line of the description box
      svg.selectAll(".description")
        .attr("font-weight", 700)
        .attr("x", descriptionX)
        .attr("y", descriptionY)
        .text(formatPercent(selectedEvents / totalEvents * 100 ) + "% of Total")
        .style("visibility", "visible");


      svg.selectAll(".description")
        .append("tspan")
        .attr("x", descriptionX)
        .attr("y", descriptionY)
        .attr("dy", 1.2 + "em")
        .attr("font-weight", 300)
        .text(formatPercent(selectedEvents / outerEvents * 100 ) + "% of " + outername + " events.");

      svg.selectAll(".description")
        .append("tspan")
        .attr("x", descriptionX)
        .attr("y", descriptionY)
        .attr("dy", 2.3 + "em")
        .attr("font-weight", 300)
        .text(formatPercent(selectedEvents / innerEvents * 100 ) + "% of " + innername + " events.");

    }
    else {
      svg.selectAll(".description")
        .attr("font-weight", 300)
        .text("")
        .style("visibility", "hidden");
    }

  };
}//fadeString

  // Define a group by function
  // Adapted from learnwithparam.com
  // Accepts the array and key and a key to sum over
  function loomGroupBy(array, key, sumKey) {
    // Return the end result
    return array.reduce((result, currentValue) => {
      // If a value is already present for key, add to it. Else insert the current value as a seed.
      result[currentValue[key]] = (result[currentValue[key]] || 0) + currentValue[sumKey]
      // Return the current iteration `result` value, this will be taken as next iteration `result` value and accumulate
      return result;
    }, {}); // empty object is the initial value for result object
  };

  // Should sort descending?
  function sortDesc(map) {
    return Object.keys(map).sort( (a, b) => {
      return map[b] - map[a]
    });
  };

  // greedy algorithm to take an array, split into two equal-ish parts and sort it
  function evenSort(array, map) {
    let arrayA = [], sumA = 0, arrayB = [], sumB = 0;
    // Loop through the array
    array.forEach(function(v) {
      if (sumA <= sumB) {
        arrayA.push(v);
        sumA += map[v];
      }
      else {
        arrayB.push(v);
        sumB += map[v];
      }
    }); // end of loop through array
    return arrayA.concat(arrayB.reverse());
  };// end of evenSort

} // End of loomDiagram
