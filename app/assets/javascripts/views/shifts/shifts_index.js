ShiftScheduler.Views.ShiftsIndex = Backbone.View.extend({

  el: "#shift-index-view",

  template: JST['shifts/index'],

  initialize: function(){
    var that = this;
	_.bindAll(this, 'select')
    this.listenTo(that.collection, 'reset', that.addAll);

    that.collection.fetch({
      reset: true,
    });

  },

  render: function() {
    var that = this;
    this.$el.append(this.template());
    $("#calendar").fullCalendar({
      defaultView: "month",
      header: {
        left: "title",
        center: "month, agendaWeek, agendaDay",
        right:  'today prev,next'
      },
      height: 500,
	  selectable: true,
	  selectHelper: true,
	  select: this.select,
      aspectRation: 1,
      eventClick: function(event, element) {
        var shiftModel = that.collection.get(event)

        that.shiftShowView.model = shiftModel;
        that.shiftShowView.render();

      }

    });

    return this;
  },
  
  select: function(startDate, endDate) {
	  if (ability.can("crud", ShiftScheduler.Models.Shift))	{ 
		  this.newShiftView = new ShiftScheduler.Views.ShiftNew({
			  parentView: this,
			  startDate: startDate,
			  endDate: endDate, 
		  });
	  };
  },

  addAll: function() {
    var that = this;
    var source = that.collection.toJSON();
    $("#calendar").fullCalendar( 'addEventSource', source );
    this.shiftShowView = new ShiftScheduler.Views.ShiftShow({
      model: that.collection.at(0),
	  collection: that.collection,
      parentView: this
    })
  },

  reRender: function(shift) {
    var that = this;
      var source = that.collection.toJSON();
      $('#calendar').fullCalendar('removeEvents');
      $("#calendar").fullCalendar( 'addEventSource', source );
  }

});
