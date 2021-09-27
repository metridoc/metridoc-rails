chordDiagram = function(data) {
  ////////////////////////////////////////////////////////////
  //////////////////////// Set-up ////////////////////////////
  ////////////////////////////////////////////////////////////
  // Figure out the screen width
  var screenWidth = $(window).width(),
      mobileScreen = (screenWidth > 400 ? false : true);

  // Calculate the margins around the svg
  var margin = {left: 50, top: 10, right: 50, bottom: 10},
      width = Math.min(screenWidth, 1000) - margin.left - margin.right,
      height = (mobileScreen ? 300 : Math.min(screenWidth, 1000) * 5/6) - margin.top - margin.bottom;

  // Create an svg to display
  var svg = d3.select("#chart").append("svg")
      .attr("width", (width + margin.left + margin.right))
      .attr("height", (height + margin.top + margin.bottom));

  // g is the svg object we will build
  var wrapper = svg.append("g").attr("class", "chordWrapper")
      .attr("transform", "translate(" + (width / 2 + margin.left) + "," + (height / 2 + margin.top) + ")");;

  // Set default variables
  var outerRadius = Math.min(width, height) / 2  - (mobileScreen ? 80 : 100),
      innerRadius = outerRadius * 0.95, // size of the ending arcs
      pullOutSize = (mobileScreen? 20 : 50), // the number of pixels of separation
      padding = 0.02, // padding between chords
      opacityDefault = 0.7, //default opacity of chords
      opacityHigh = 1.0, // default opacity of the chord hovered over
      opacityLow = 0.1; //hover opacity of those chords not hovered over

  ////////////////////////////////////////////////////////////
  ////////////////////////// Data ////////////////////////////
  ////////////////////////////////////////////////////////////

  // Group by the A Categories and add up the values
  var values_a = data.reduce((obj, {A, B, value}) => {
    if (!obj[A]) obj[A] = 0;
    obj[A] += value;
    return obj;
  }, {});

  // Get list of names of A Categories in reverse sort order
  var names_a = Object.entries(values_a).sort((a,b) => a[1] - b[1]).map((a) => a[0]);

  // Group by the B Categories and add up the values
  var values_b = data.reduce((obj, {A, B, value}) => {
    if (!obj[B]) obj[B] = 0;
    obj[B] += value;
    return obj;
  }, {});


  // Get list of names of B Categories in sort order
  var names_b = Object.entries(values_b).sort((a,b) => b[1] - a[1]).map((a) => a[0]);

  // Find the division of the halves
  var split = names_b.length;

  // Make the list of labels with empty strings to fill the stretched chord
  var names = names_b.concat([""], names_a, [""]);

  // Method to create n + 1 colors in a rainbow
  // d3.interpolateRainbow(float) - function takes a float 0-1 and returns a color
  // d3.quantize(interpolator, n) - function that returns an array of n samples from interpolator
  var colors = d3.quantize(d3.interpolateRainbow, names.length-1)

  // Make a mapping of the names to the colors
  const colorMap = new Map()
  i = 0
  names.forEach( function(n) {
    n == "" ? colorMap.set("", "none") : colorMap.set(n, colors[i]);
    i = (n == "" ? i : i + 1);
  });

  // Calculate the total number of events to put in the chord
  var total = data.reduce((obj, {A, B, value}) => {
    obj += value;
    return obj;
  }, 0);
  var double_total = total * 2;

  // Calcuate the fraction of empty events to insert for a 40% gap
  var emptyPerc = 0.4;
  var emptyStroke = Math.round(double_total * emptyPerc);

  // Create an empty 2D array
  var matrix = Array.from(Array(names.length), _ => Array(names.length).fill(0));

  // Fill array with data
  data.forEach( function(obj) {
    a_index = names.indexOf(obj["A"], split);
    b_index = names.indexOf(obj["B"], 0);

    matrix[a_index][b_index] = obj["value"];
    matrix[b_index][a_index] = obj["value"];
  });

  // Add empty stroke to array
  matrix[split][names.length - 1] = emptyStroke;
  matrix[names.length - 1][split] = emptyStroke;

  ////////////////////////////////////////////////////////////
  ////////////////////// Calculations ////////////////////////
  ////////////////////////////////////////////////////////////

  //Calculate how far the Chord Diagram needs to be rotated clockwise to make the dummy
  //invisible chord center vertically
  var offset = Math.PI / 4 - (names_a.length - names_b.length) / 2 * padding;

  //Custom sort function of the chords to keep them in the original order
  var chord = customChordLayout() //d3.layout.chord()//Custom sort function of the chords to keep them in the original order
      .padding(padding)
      .sortChords(d3.descending) //which chord should be shown on top when chords cross. Now the biggest chord is at the bottom
      .matrix(matrix);

  var arc = d3.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius)
      .startAngle(startAngle) //startAngle and endAngle now include the offset in degrees
      .endAngle(endAngle);

  // Creates a mathematical description of the path of the new stretched out chord
  var path = stretchedChord()
      .radius(innerRadius)
      .startAngle(startAngle)
      .endAngle(endAngle)
      .pullOutSize(pullOutSize); // Separation between the two halves

  ////////////////////////////////////////////////////////////
  /////////////// Create the gradient fills //////////////////
  ////////////////////////////////////////////////////////////

  //Function to create the id for each chord gradient
  function getGradID(d){ return "linkGrad-" + d.source.index + "-" + d.target.index; }

  //Create the gradients definitions for each chord
  var grads = svg.append("defs").selectAll("linearGradient")
      .data(chord.chords())
      .enter().append("linearGradient")
      .attr("id", getGradID)
      .attr("gradientUnits", "userSpaceOnUse")
      .attr("x1", function(d,i) { return innerRadius * Math.cos((d.source.endAngle-d.source.startAngle)/2 + d.source.startAngle - Math.PI/2); })
      .attr("y1", function(d,i) { return innerRadius * Math.sin((d.source.endAngle-d.source.startAngle)/2 + d.source.startAngle - Math.PI/2); })
      .attr("x2", function(d,i) { return innerRadius * Math.cos((d.target.endAngle-d.target.startAngle)/2 + d.target.startAngle - Math.PI/2); })
      .attr("y2", function(d,i) { return innerRadius * Math.sin((d.target.endAngle-d.target.startAngle)/2 + d.target.startAngle - Math.PI/2); })

  // Note: to reverse the gradient, flip the source and target

  //Set the starting color (at 0%)
  grads.append("stop")
    .attr("offset", "0%")
    .attr("stop-color", function(d){ return colorMap.get(names[d.source.index]); });

  //Set the ending color (at 100%)
  grads.append("stop")
    .attr("offset", "100%")
    .attr("stop-color", function(d){ return colorMap.get(names[d.target.index]); });

  ////////////////////////////////////////////////////////////
  //////////////////// Draw outer Arcs ///////////////////////
  ////////////////////////////////////////////////////////////

  var g = wrapper.selectAll("g.group")
      .data(chord.groups)
      .enter().append("g")
      .attr("class", "group")
      .on("mouseover", fade(opacityLow)) // setting mouse over arc options
      .on("mouseout", fade(opacityDefault));

  g.append("path")
    .style("stroke", function(d,i) { return (names[i] === "" ? "none" : "black"); }) // outline of the arcs
    .style("fill", function(d,i) { return colorMap.get(names[i]); }) // colors of the arcs
    .style("pointer-events", function(d,i) { return (names[i] === "" ? "none" : "auto"); })
    .attr("d", arc)
    .attr("transform", function(d, i) { //Pull the two slices apart
      d.pullOutSize = pullOutSize * (i > split ? -1 : 1);
      return "translate(" + d.pullOutSize + ',' + 0 + ")";
    });

  ////////////////////////////////////////////////////////////
  ////////////////////// Append Names ////////////////////////
  ////////////////////////////////////////////////////////////

  //The text also needs to be displaced in the horizontal directions
  //And also rotated with the offset in the clockwise direction
  g.append("text")
    .each(function(d) { d.angle = ((d.startAngle + d.endAngle) / 2) + offset;})
    .attr("dy", ".35em")
    .attr("class", "titles")
    .attr("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
    .attr("transform", function(d,i) {
      var c = arc.centroid(d);
      return "translate(" + (c[0] + d.pullOutSize) + "," + c[1] + ")"
        + "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
        + "translate(" + 50 + ",0)"
        + (d.angle > Math.PI ? "rotate(180)" : "")
    })
    .text(function(d,i) { return names[i]; });

  ////////////////////////////////////////////////////////////
  //////////////////// Draw inner chords /////////////////////
  ////////////////////////////////////////////////////////////

  var chords = wrapper.selectAll("path.chord")
      .data(chord.chords)
      .enter().append("path")
      .attr("class", "chord")
      .style("stroke", "black")
      .style("fill", function(d){ return "url(#" + getGradID(d) + ")" }) // Defining fill color here
      .style("opacity", function(d) { return (names[d.source.index] === "" ? 0 : opacityDefault); }) //Make the dummy strokes have a zero opacity (invisible)
      .style("pointer-events", function(d,i) { return (names[d.source.index] === "" ? "none" : "auto"); }) //Remove pointer events from dummy strokes
      .attr("d", path)
      .on("mouseover", fadeChord(opacityLow, true))
      .on("mouseout", fadeChord(opacityDefault, false));

  ////////////////////////////////////////////////////////////
  ///////////////////////// Tooltip //////////////////////////
  ////////////////////////////////////////////////////////////

  //Arcs
  g.append("title")
    .text(function(d, i) {return Math.round(d.value) + " events in " + names[i];});

  //Chords
  chords.append("title")
    .text(function(d) {
      return [Math.round(d.source.value), " events from ", names[d.target.index], " to ", names[d.source.index]].join("");
    });


  ////////////////////////////////////////////////////////////
  ////////////////// Extra Functions /////////////////////////
  ////////////////////////////////////////////////////////////

  //Include the offset in the start and end angle to rotate the Chord diagram clockwise
  function startAngle(d) { return d.startAngle + offset; }
  function endAngle(d) { return d.endAngle + offset; }

  // Returns an event handler for fading a given chord group
  function fade(opacity) {
    return function(d, i) {
      svg.selectAll("path.chord")
        .filter(function(d) {
          return d.source.index !== i.index && d.target.index !== i.index && names[d.source.index] !== "";
        })
        .transition("fadeOnArc")
        .style("opacity", opacity);
    };
  }//fade

  // Returns an event handler for fading a given chord group
  function fadeChord(opacity, mouseover) {
    return function(d, i) {
      // Decrease the opacity for all chords
      svg.selectAll("path.chord")
        .filter(function(d) { return d !== i && names[d.source.index] !== ""; })
        .transition("fadeOnArc")
        .style("opacity", opacity);

      // Show hovered over chord with specialized opacity
      d3.select(this)
        .transition("fadeOnArc")
        .style("opacity", (mouseover ? opacityHigh : opacityDefault));
    };
  }//fade
} // chordDiagram
