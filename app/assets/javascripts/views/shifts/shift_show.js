ShiftScheduler.Views.ShiftShow = Backbone.View.extend({
  el: "#shift-details",

  template: JST['shifts/show'],

  initialize: function(){
    this.render();
  },

  events: {
    "click button.remove-employee-button": "removeEmployee",
    "click button.approve-employee-button": "approveEmployee",
    "click button.deny-employee-button": "denyEmployee"
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
    event.preventDefault();
    var $target = $(event.target);
    var id = parseInt($target.attr("data-id"));

    var shift_request = this.model.get("shift_requests").findWhere({id: id})
    shift_request.set({status: "pending"});
    shift_request.save();
    this.render();
  },

  approveEmployee: function(event) {
    event.preventDefault();
    var $target = $(event.target);
    var id = parseInt($target.attr("data-id"));

    var shift_request = this.model.get("shift_requests").findWhere({id: id})
    shift_request.set({status: "approved"});
    shift_request.save();
    this.render();

  },

  denyEmployee: function(event) {
    event.preventDefault();
    var $target = $(event.target);
    var id = parseInt($target.attr("data-id"));

    var shift_request = this.model.get("shift_requests").findWhere({id: id})
    shift_request.set({status: "denied"});
    shift_request.save();
    this.render();

  }


});