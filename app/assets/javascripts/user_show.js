(function(){
  'use strict';

  $(document).ready(initialize);

  function initialize(){
    if($('#self_report_graph').length > 0){
      drawGraph();
    }
  }

  function drawGraph(){
    //Retrieve and sort self reports
    var selfReports = $('#self_reports').data('data');
    selfReports.sort(function(a, b){
      if(a.date < b.date){
        return -1;
      }else if(a.date > b.date){
        return 1;
      }else{
        return 0;
      }
    });

    //Pull data from self reports into separate arrays, including parsing and correcting dates
    var hoursCoding = [], hoursLearning = [], hoursSlept = [], dates = [];
    for(var i = 0; i < selfReports.length; i++){
      hoursCoding.push(selfReports[i].hours_coding);
      hoursLearning.push(selfReports[i].hours_learning);
      hoursSlept.push(selfReports[i].hours_slept);

      var d = new Date(selfReports[i].date);
      var difference = d.getTimezoneOffset();
      d.setMinutes(difference);
      dates.push(d);
    }

    //Initialize #self_report_graph svg and main <g> element
    var width = $('#self_report_graph').parent().width(),
        height = 300,
        margin = 20;

    var lineGraph = d3.select("#self_report_graph")
      .attr("width", width)
      .attr("height", height)
      .append("g");

    //Initialize x and y scales (note separate scales for x [used to create lines] and xTime [used to create x-axis labels]
    var y = d3.scale.linear()
      .domain([10, 0])
      .range([0 + margin, height - margin]);

    var x = d3.scale.linear()
      .domain([0, selfReports.length-1])
      .range([0 + margin, width - margin]);

    var xTime = d3.time.scale()
      .domain(d3.extent(dates))
      .range([0 + margin, width - margin]);

    //Define rules for line graph (using x and y scales) and use them to draw three lines
    var line = d3.svg.line()
      .x(function(d, i) { return x(i); })
      .y(function(d) { return y(d); });

    lineGraph.append("svg:path").attr("d", line(hoursCoding)).attr("id", "hoursCoding");
    lineGraph.append("svg:path").attr("d", line(hoursLearning)).attr("id", "hoursLearning");
    lineGraph.append("svg:path").attr("d", line(hoursSlept)).attr("id", "hoursSlept");

    //Draw x-axis and add labels and ticks based on xTime scale
    lineGraph.append("svg:line")
      .attr("x1", x(0))
      .attr("y1", y(0))
      .attr("x2", x(width))
      .attr("y2", y(0));

    lineGraph.append("g")
      .attr("transform", "translate(0, " + (height-20) + ")")
      .attr("class", "x axis")
      .call(d3.svg.axis().scale(xTime).tickValues(dates).tickFormat(d3.time.format('%-m/%-d')).orient("bottom"));

    //Draw y-axis and add labels and ticks based on y scale
    lineGraph.append("svg:line")
      .attr("x1", x(0))
      .attr("y1", y(0))
      .attr("x2", x(0))
      .attr("y2", y(10));

    lineGraph.append("g")
      .attr("transform", "translate(20, 0)")
      .attr("class", "y axis")
      .call(d3.svg.axis().scale(y).orient("left"));
  }
})();
