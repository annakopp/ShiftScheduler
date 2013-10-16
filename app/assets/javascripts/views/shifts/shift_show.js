ShiftScheduler.Views.ShiftShow = Backbone.View.extend({
  el: "#shift-details",

  template: JST['shifts/show'],

  initialize: function(){
    var that = this;
    this.parentView = this.options["parentView"];
    this.render();
  },

  events: {
    "click button.remove-employee-button": "removeEmployee",
    "click button.approve-employee-button": "approveEmployee",
    "click button.deny-employee-button": "denyEmployee",
    "click button.request-shift-button": "requestShift",
    "click button.cancel-shift-button": "cancelShift"
  },

  render: function() {
	  
    var that = this;
    if(!this.model){
      this.$el.html("");
      return ;
    }

    var renderedContent = this.template({
      shift: that.model
    });

    this.$el.html(renderedContent);
    return this;
  },

  removeEmployee: function(event) {
	var that = this;
    event.preventDefault();
    var $target = $(event.target);
    var id = parseInt($target.attr("data-id"));

    var shift_request = this.model.get("shift_requests").findWhere({id: id})
    shift_request.set({status: "pending"});
    shift_request.save({},{
		success: function(){
          that.parentView.collection.fetch({
            success: function(){
              that.parentView.reRender();
              that.render()
            }
          });
        }
	});
  },

  approveEmployee: function(event) {
    var that = this;
	event.preventDefault();
    var $target = $(event.target);
    var id = parseInt($target.attr("data-id"));
	
    var shift_request = this.model.get("shift_requests").findWhere({id: id})
    shift_request.set({status: "approved"});
    shift_request.save({},{
		success: function(){
          that.parentView.collection.fetch({
            success: function(){
              that.parentView.reRender();
              that.render()
            }
          });
        }
	});
    

  },

  denyEmployee: function(event) {
	var that = this;
    event.preventDefault();
    var $target = $(event.target);
    var id = parseInt($target.attr("data-id"));

    var shift_request = this.model.get("shift_requests").findWhere({id: id})
    shift_request.set({status: "denied"});
    shift_request.save({},{
		success: function(){
          that.parentView.collection.fetch({
            success: function(){
              that.parentView.reRender();
              that.render()
            }
          });
        }
	});

  },

  requestShift: function(event) {
    var that = this;
    event.preventDefault();
    var $target = $(event.target);
    var shiftId = $target.attr("data-id");

    that.model.get("shift_requests").create({},
      {
        url: "/shifts/" + shiftId + "/shift_request",
        success: function(){
          that.parentView.collection.fetch({
            success: function(){
              that.parentView.reRender();
              that.render()
            }
          });


        }
      }
    );
  },

  cancelShift: function(event) {
	event.preventDefault();
    var that = this;
    
 	var shiftId = parseInt(this.model.get("id"))
	var shift_req = this.model.get("shift_requests").findWhere({shift_id: shiftId, employee_id: currentUserId})

	that.model.get("shift_requests").sync("delete", shift_req, {
	    success: function(){
	      that.parentView.collection.fetch({
	        success: function(){
	          that.parentView.reRender();
	          that.render()
	        }
	      });


	    }
	});

  }

});