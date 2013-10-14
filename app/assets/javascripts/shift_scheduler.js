window.ShiftScheduler = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    console.log("initialized");
    var shifts = new ShiftScheduler.Collections.Shifts();
    new ShiftScheduler.Views.ShiftsIndex({collection: shifts}).render();
  }
};