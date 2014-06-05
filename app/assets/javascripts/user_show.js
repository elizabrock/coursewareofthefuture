(function(){
  'use strict';

  $(document).ready(initialize);

  function initialize(){
    if($('#self_report_graph').length > 0){
      initializeData();
    }
  }

  function initializeData(){
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

    selfReports = selfReports.filter(function(elem, pos) {
      return selfReports.indexOf(elem) == pos;
    });

    var hoursCoding = [], hoursLearning = [], hoursSlept = [];
    for(var i = 0; i < selfReports.length; i++){
      hoursCoding.push(selfReports[i].hours_coding);
      hoursLearning.push(selfReports[i].hours_learning);
      hoursSlept.push(selfReports[i].hours_slept);
    }

    var width = $('#self_report_graph').parent().width(), height = 300;
    var margin = 20;

    var y = d3.scale.linear()
      .domain([10, 0])
      .range([0 + margin, height - margin]);

    var x = d3.scale.linear()
      .domain([0, selfReports.length])
      .range([0 + margin, width - margin]);

    var xTime = d3.time.scale()
      .domain([new Date(selfReports[0].date), new Date(selfReports[selfReports.length - 1].date)])
      .nice(d3.time.day)
      .range([0 + margin, width - margin]);

    var lineGraph = d3.select("#self_report_graph")
      .attr("width", width)
      .attr("height", height)
      .append("g");

    var line = d3.svg.line()
      .x(function(d, i) { return x(i); })
      .y(function(d) { return y(d); });

    lineGraph.append("svg:path").attr("d", line(hoursCoding)).attr("id", "hoursCoding");
    lineGraph.append("svg:path").attr("d", line(hoursLearning)).attr("id", "hoursLearning");
    lineGraph.append("svg:path").attr("d", line(hoursSlept)).attr("id", "hoursSlept");

    lineGraph.append("svg:line")
      .attr("x1", x(0))
      .attr("y1", y(0))
      .attr("x2", x(width))
      .attr("y2", y(0));

    lineGraph.append("svg:line")
      .attr("x1", x(0))
      .attr("y1", y(0))
      .attr("x2", x(0))
      .attr("y2", y(10));

    lineGraph.append("g")
      .attr("transform", "translate(0, " + (height-20) + ")")
      .attr("class", "x axis")
      .call(d3.svg.axis().scale(xTime).orient("bottom"));

    lineGraph.selectAll(".yLabel")
      .data(y.ticks(4))
      .enter().append("svg:text")
      .attr("class", "yLabel")
      .text(String)
      .attr("x", 0)
      .attr("y", function(d) { return y(d) })
      .attr("dy", 4);

    lineGraph.selectAll(".yTicks")
      .data(y.ticks(4))
      .enter().append("svg:line")
      .attr("class", "yTicks")
      .attr("y1", function(d) { return y(d); })
      .attr("x1", x(-0.3))
      .attr("y2", function(d) { return y(d); })
      .attr("x2", x(0));
  }
})();
