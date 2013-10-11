$(document).ready(function() {
  $("#calendar").fullCalendar({
    defaultView: "month",
    header: {
      left: "title",
      center: "month, agendaWeek, agendaDay",
      right:  'today prev,next'
    },
    eventSources: [ {url: "/shifts.json"}], //{url: "/shift_requests.json"} ],
    height: 400,
    aspectRation: 1,
    eventClick: function(event, element) {
      $("#calendar").fullCalendar('updateEvent', event);
      var shiftName = "<strong>" + event.title + "</strong>"
      $.ajax({
        url: "/shifts/"+event.id,
        type: "GET",
        success: function(response) {
          $(".shift-details").html(response);
        }
      });

    },
    dayClick: function(date) {
      console.log(date)
    }

  });


});

