let loadingProgressBar = document.querySelector('.loading-progress-bar')
let loadingState = document.querySelector('.loading-state')



$(document).ready(function () {
    $("body").addClass("transition");
    setTimeout(function() {
      $("body").removeClass("transition");
    }, 100);
  
    $("#video").hide();
    $(".other").hide();
    setTimeout(function(){
      $("#video").fadeIn(750);
      $(".other").fadeIn(750);
    }, 1000);
  
  });



window.addEventListener('message', function (e) {
    if (e.data.eventName === 'loadProgress') {
        loadingProgressBar.style.width = parseInt(e.data.loadFraction * 100) + "%"
    }
});


(function () {

    const words = [
        "Przykładowy tekst 1",
        "Przykładowy tekst 2",
        "Przykładowy tekst 3",
        "Przykładowy tekst 4",
    ]

    setInterval(function () {
        $('#changemsg').fadeOut(function () {
            $(this).html(words[Math.floor(Math.random() * words.length)]).fadeIn();
        });
    }, 5000)

})();
