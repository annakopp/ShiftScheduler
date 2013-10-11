$(document).ready(function() {
  $('#calendar').fullCalendar({
  defaultView: "month",
  header: {
    left: "title",
    center: "month, agendaWeek, agendaDay",
    right:  'today prev,next'
  },
  events: "/shift_requests.json",
  height: 400,
  aspectRation: 1,
  })
});