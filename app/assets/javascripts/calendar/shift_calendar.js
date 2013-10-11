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
      var year = String(date.getFullYear());
      var day = String(date.getDate());
      var month = String(date.getMonth()+1);
      $(".new-shift-form #start-date").val(year+"/"+month+"/"+day);
      $(".new-shift-form #end-date").val(year+"/"+month+"/"+day)
      console.log(date)

      //if in week or day view, also add the time.
    }

  });


});

