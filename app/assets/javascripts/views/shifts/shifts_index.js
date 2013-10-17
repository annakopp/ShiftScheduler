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

      },
      dayClick: function(date) {
        var year = String(date.getFullYear());
        var day = String(date.getDate());
        var month = String(date.getMonth()+1);
        $(".new-shift-form #start-date").val(year+"/"+month+"/"+day);
        $(".new-shift-form #end-date").val(year+"/"+month+"/"+day)

      }

    });

    return this;
  },
  
  select: function(startDate, endDate) {	 
	  this.newShiftView = new ShiftScheduler.Views.ShiftNew({
		  parentView: this,
		  startDate: startDate,
		  endDate: endDate, 
	  });
  },

  addAll: function() {
    var that = this;
    var source = that.collection.toJSON();
    $("#calendar").fullCalendar( 'addEventSource', source );
    this.shiftShowView = new ShiftScheduler.Views.ShiftShow({
      model: that.collection.at(0),
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
