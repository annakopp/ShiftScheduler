ShiftScheduler.Views.ShiftNew = Backbone.View.extend({
    el: "#new-shift-dialog",

    template: JST['shifts/new'],

    initialize: function(){
		_.bindAll(this, 'close', 'save');
      this.parentView = this.options["parentView"];
	  this.startDate = this.options["startDate"];
	  this.endDate = this.options["endDate"];
      this.render();
    },
	
	render: function() {		
	    var renderedContent = this.template({
	    	startDate: this.parseDate(this.endDate),
			endDate: this.parseDate(this.startDate)
	    });
		this.$el.html(renderedContent);
		
		this.$el.dialog({
			modal: true,
			width: 470,
			title: 'Add Shift: ',
			buttons: {'Save': this.save, 'Cancel': this.close}
		});
		
		return this;
	},
	
	close: function() {
		this.$el.dialog('close');
	},
	
	save: function() {
		var that = this;
		var userData = $("form.new-shift-form").serializeJSON();
		userData["shift"]["start_date"] = this.parseDate(this.startDate);
		userData["shift"]["end_date"] = this.parseDate(this.endDate);
		$.ajax({
			url: "/shifts",
			type: "POST",
			data: userData,
			success: function(){
          	  	that.parentView.collection.fetch({
            		success: function(){
						that.close();
              			that.parentView.reRender();
            		}
          	  	})
			},
			
			error: function(data){	
				console.log($.parseJSON(data));
			}
		});
	},
	
	parseDate: function(date){
        var year = String(date.getFullYear());
        var day = String(date.getDate());
        var month = String(date.getMonth()+1);
		return (year+"/"+month+"/"+day);
	}

});