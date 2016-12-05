//namespace for tournaments

var tournaments= tournaments || {};


$(document).ready(function(){
    $('input.timepickable').timepicker();

    $('.file-dropzone').dropzone({

        maxFileSize:5
    });

});
