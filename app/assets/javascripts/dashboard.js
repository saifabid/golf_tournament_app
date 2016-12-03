
$(document).on('turbolinks:load',function() {
    $('#dashboardCalendar').fullCalendar({
        header: {
            left: 'prev,next',
            center: 'title'
        },
        eventSources: [
            {
                url: 'participatingtournaments_feed',
                color: 'blue',
                textColor: 'white'
            },
            {
                url: 'createdtournaments_feed',
                color: 'green',
                textColor: 'white'
            },
            {
                url: 'spectatortournaments_feed',
                color: 'purple',
                textColor: 'white'
            },
            {
                url:'sponsoredtournaments_feed',
                color: 'orange',
                textcolor: 'white'
            }
        ]

    });
});