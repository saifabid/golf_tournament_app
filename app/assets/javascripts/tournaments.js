//namespace for tournaments

var tournaments= tournaments || {};


$(document).ready(function(){
    $('input.timepickable').timepicker();

    $('.file-dropzone').dropzone({

        maxFileSize:5
    });
    $(".card .card-title").dotdotdot( {height: 30});
});
