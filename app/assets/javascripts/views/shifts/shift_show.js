ShiftScheduler.Views.ShiftShow = Backbone.View.extend({

  template: JST['shifts/show'],

  initialize: function(){
    this.parentView = this.options["parentView"];
  },

  events: {
    "click button.remove-employee-button": "removeEmployee",
    "click button.approve-employee-button": "approveEmployee",
    "click button.deny-employee-button": "denyEmployee",
    "click button.request-shift-button": "requestShift",
    "click button.cancel-shift-button": "cancelShift",
	"click button.shift-delete-button": "deleteShift"
  },

  render: function() {
	 
    var that = this;
		
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
              that.render();
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
              that.render();
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
	var shiftReqCollection = that.model.get("shift_requests")
	var shiftReq = shiftReqCollection.findWhere({shift_id: shiftId, employee_id: currentUserId})
	
	shiftReqCollection.sync("delete", shiftReq, {
	    success: function(){
	      that.parentView.collection.fetch({
	        success: function(){
	          that.parentView.reRender(that);
			  that.render();
	        }
	      });


	    }
	});
	

  },
  
  deleteShift: function(event) {
	var that = this;
	event.preventDefault();
	
	that.collection.sync("delete", that.model);
	
	//closes dialog created in parent view
	this.parentView.$dialogEl.dialog('close');
	this.remove();
	
	that.collection.remove(that.model);

  }

});