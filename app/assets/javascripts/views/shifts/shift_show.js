ShiftScheduler.Views.ShiftShow = Backbone.View.extend({
  el: "#shift-details",

  template: JST['shifts/show'],

  initialize: function(){
    this.render();
  },

  render: function() {
    console.log(this.model);
    if(!this.model){
      this.$el.html("");
      return ;
    }

    var renderedContent = this.template({
      shift: this.model
    });

    this.$el.html(renderedContent);
    return this;
  }

});