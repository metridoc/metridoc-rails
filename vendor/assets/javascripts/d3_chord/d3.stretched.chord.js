////////////////////////////////////////////////////////////
/////////////// Custom Chord Function //////////////////////
//////// Pulls the chords pullOutSize pixels apart /////////
////////////////// along the x axis ////////////////////////
////////////////////////////////////////////////////////////
///////////// Created by Nadieh Bremer /////////////////////
//////////////// VisualCinnamon.com ////////////////////////
////////////////////////////////////////////////////////////
//// Adjusted from the original d3.svg.chord() function ////
///////////////// from the d3.js library ///////////////////
//////////////// Created by Mike Bostock ///////////////////
////////////////////////////////////////////////////////////

stretchedChord = function() {
  var source = d3_source, 
      target = d3_target, 
      radius = d3_svg_chordRadius, 
      startAngle = d3_svg_arcStartAngle, 
      endAngle = d3_svg_arcEndAngle,
      pullOutSize = 0;

  // Define Pi
  var pi = Math.PI, halfpi = pi / 2;

  function subgroup(self, f, d, i) {
    var subgroup = f.call(self, d, i), 
	r = radius.call(self, subgroup, i), 
	a0 = startAngle.call(self, subgroup, i) - halfpi, 
	a1 = endAngle.call(self, subgroup, i) - halfpi;
    return {
      r: r, // radius
      a0: [a0], // Starting angle
      a1: [a1], // Ending angle
      p0: [ r * Math.cos(a0), r * Math.sin(a0)], // Starting point
      p1: [ r * Math.cos(a1), r * Math.sin(a1)] // Ending point
    };
  }

  // Define an elliptical arc
  // A rx, ry x-axis-rotation large-arc-flag, sweep-flag  end-point-x, end-point-y
  // example: A266.5,266.5 0 0,1 -191.78901944612068,185.0384338992728 
  function arc(r, p, a) {
    var sign = (p[0] >= 0 ? 1 : -1);
    return "A" + r + "," + r + " 0 " + +(a > pi) + ",1 " + (p[0] + sign*pullOutSize) + "," + p[1];
  }
  
  // Use a quadratic Bezier curve to define the curve
  // Q control-point-x,control-point-y end-point-x, end-point-y
  // Note that the control-point is set to the origin
  // example: Q 0,0 251.5579641956022,87.98204731514328 
  function curve(p1) {
    var sign = (p1[0] >= 0 ? 1 : -1);
    return "Q 0,0 " + (p1[0] + sign*pullOutSize) + "," + p1[1];
  }
  
  /*
    M = moveto
    M x,y
    Q = quadratic Bézier curve
    Q control-point-x,control-point-y end-point-x, end-point-y
    A = elliptical Arc
    A rx, ry x-axis-rotation large-arc-flag, sweep-flag  end-point-x, end-point-y
    Z = closepath
    
    M251.5579641956022,87.98204731514328
    A266.5,266.5 0 0,1 244.49937503334525,106.02973926358392
    Q 0,0 -177.8355222451483,198.48621369706098
    A266.5,266.5 0 0,1 -191.78901944612068,185.0384338992728
    Q 0,0 251.5579641956022,87.98204731514328
    Z
  */

  // Define the path of the bounds of the chord
  // Move to starting point of source arc - follow source arc -
  // make a bezier curve to the starting point of the target arc -
  // follow the target arc - make a bezier curve to the source arc starting point -
  // close the curve
  function chord(d, i) {
    var s = subgroup(this, source, d, i), 
	t = subgroup(this, target, d, i);
    
    return "M" + (s.p0[0] + pullOutSize) + "," + s.p0[1] + 
      arc(s.r, s.p1, s.a1 - s.a0) + 
      curve(t.p0) + 
      arc(t.r, t.p1, t.a1 - t.a0) + 
      curve(s.p0) + 
      "Z";
  }//chord
  
  // Overwrite the radius of the chord if a target is specified
  chord.radius = function(v) {
    if (!arguments.length) return radius;
    radius = d3_functor(v);
    return chord;
  };

  // Defines the amount the chords are pulled apart
  chord.pullOutSize = function(v) {
    if (!arguments.length) return pullOutSize;
    // Why isn't this:
    // pullOutSize = d3_functor(v)
    pullOutSize = v;
    return chord;
  };

  // Overwrite the source if a target is specified
  chord.source = function(v) {
    if (!arguments.length) return source;
    source = d3_functor(v);
    return chord;
  };

  // Overwrite the target if an argument is specified
  chord.target = function(v) {
    if (!arguments.length) return target;
    target = d3_functor(v);
    return chord;
  };

  // Overwrite the startAngle if an argument is specified
  chord.startAngle = function(v) {
    if (!arguments.length) return startAngle;
    startAngle = d3_functor(v);
    return chord;
  };

  // Overwrite the endAngle if an argument is specified
  chord.endAngle = function(v) {
    if (!arguments.length) return endAngle;
    endAngle = d3_functor(v);
    return chord;
  };

  // Get the radius of chord d
  function d3_svg_chordRadius(d) {
    return d.radius;
  }

  // Get the source of chord d
  function d3_source(d) {
    return d.source;
  }

  // Get the target of chord d
  function d3_target(d) {
    return d.target;
  }

  // Find the start angle of chord d
  function d3_svg_arcStartAngle(d) {
    return d.startAngle;
  }

  // Find the end angle of chord d
  function d3_svg_arcEndAngle(d) {
    return d.endAngle;
  }

  // Ensure that a function is returned
  function d3_functor(v) {
    return typeof v === "function" ? v : function() {
      return v;
    };
  }
  
  return chord;
  
}//stretchedChord
