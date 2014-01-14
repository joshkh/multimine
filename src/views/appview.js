  // Include helper functions:
  var mediator = require("../modules/mediator");
  var $ = require('../modules/dependencies').$;
  var Helper = require("../modules/MyHelper");

  // The Application
  // --------------
  var AppView = Backbone.View.extend({

    el: 'body',

    initialize: function(params) {

      mediator.on('rand', this.rand, this);

      // Do search
      $('#' + params.input).on('keypress', function(e) {
        if (e.keyCode == 13) {
          mediator.trigger('rand', {})
          return false;
        }
      });


      $('#' + params.input).on('keyup change', function() {
        console.log("changed");
      });

      // Listen to our mediator for events
      mediator.on('column:add', this.addColumn, this);
      
    },

    rand: function() {
    var aHelper = new Helper();
    value = $("#textsearch").val();
    someResults = aHelper.quickSearchSingle(value);
    Q(someResults)
    .then(function(o){
      var categories = aHelper.calcCategories(o);
      var organisms = aHelper.calcOrganisms(o);

      aHelper.buildChart(categories);
      aHelper.buildChart(organisms);
      return someData;
       // console.log(JSON.stringify(o, null, 2));
      })
    .then(function() {
      aHelper.buildChart(someData);
    })
    .then(function() {
      someData = aHelper.calc
    });
    },

    render: function() {
      return this;
    }

  });


  module.exports = AppView;