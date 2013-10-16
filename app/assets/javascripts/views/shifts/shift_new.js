ShiftScheduler.Views.ShiftNew = Backbone.View.extend({
    el: "#new-shift-dialog",

    template: JST['shifts/new'],

    initialize: function(){
		_.bindAll(this, 'close', 'save');
      this.parentView = this.options["parentView"];
      this.render();
    },
	
	render: function() {		
	    var renderedContent = this.template({
	    	shift: this.model
	    });
		this.$el.html(renderedContent);
		
		this.$el.dialog({
			modal: true,
			title: 'New Event',
			buttons: {'Save': this.save, 'Cancel': this.close}
		});
		
		return this;
	},
	
	close: function() {
		this.$el.dialog('close');
	},
	
	save: function() {
		this.model.set({'title': $("#title").val(), 'slots': $("#slots").val()});
		this.collection.create(this.model, {success: this.close});
	}

});