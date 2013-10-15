ShiftScheduler.Models.Shift = Backbone.Model.extend({
  parse: function(response) {
    response["shift_requests"] =
    new  ShiftScheduler.Collections.ShiftRequests(response["shift_requests"], {
      url: "/shifts/" + response["id"] + "/shift_requests/"
    })

    response["employees"] =
    new  ShiftScheduler.Collections.Users(response["employees"])

    return response;
  }
});