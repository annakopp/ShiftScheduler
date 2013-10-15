ShiftScheduler.Views.ShiftShow = Backbone.View.extend({
  el: "#shift-details",

  template: JST['shifts/show'],

  initialize: function(){
    this.render();
  },

  render: function() {
    var that = this;
    if(!this.model){
      this.$el.html("");
      return ;
    }

    console.log(this.model.get("shift_requests").models)
    var renderedContent = this.template({
      shift: that.model
    });

    this.$el.html(renderedContent);
    return this;
  }

});