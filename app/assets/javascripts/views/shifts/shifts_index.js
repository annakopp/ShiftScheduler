ShiftScheduler.Views.ShiftsIndex = Backbone.View.extend({

  el: "#shift-index-view",

  template: JST['shifts/index'],

  initialize: function(){
    var that = this;
	_.bindAll(this, 'select', 'eventClick')
    this.listenTo(that.collection, 'reset', that.addAll);
	this.listenTo(that.collection, 'remove', that.reRender);
	
    that.collection.fetch({
      reset: true,
    });

  },
  updateHeight: function() {
	  $('#calendar').fullCalendar('option', 'height', this.getHeight());
  },
  
  getHeight: function() {
	  return $(window).height() - 115
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
	  height: this.getHeight(),
	  selectable: true,
	  selectHelper: true,
	  select: this.select,
      eventClick: this.eventClick,
	  windowResize: function(view) {
		  that.updateHeight();
	  }

    });

    return this;
  },
  
  eventClick: function(event, element) {
	    this.shiftShowView = new ShiftScheduler.Views.ShiftShow({
	      model: this.collection.get(event),
		  collection: this.collection,
	      parentView: this
	    });
		
		this.$dialogEl = $("#shift-container");
		console.log(this.shiftShowView.render().el)
		this.$dialogEl.html(this.shiftShowView.render().el);
		this.$dialogEl.dialog({
			modal: true,
			width: 470,
			title: this.collection.get(event).get("title")
		});

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
  },

  reRender: function() {
      var that = this;
	  console.log('removed')
      var source = that.collection.toJSON();
      $('#calendar').fullCalendar('removeEvents');
      $("#calendar").fullCalendar( 'addEventSource', source );
  }

});
