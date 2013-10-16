ShiftScheduler.Models.Shift = Backbone.Model.extend(
{
  paramRoot: 'shift',
  
  parse: function(response) {
    response["shift_requests"] =
    new  ShiftScheduler.Collections.ShiftRequests(response["shift_requests"], {
      urlRoot: "/shifts/" + response["id"] + "/shift_requests"
    })

    response["employees"] =
    new  ShiftScheduler.Collections.Users(response["employees"])

    return response;
  }
},
{
	backboneClass:"ShiftScheduler.Models.Shift"
}
);
