$(function() {
    window.addEventListener('message', function(event) {
        switch(event.data.type) {
            case "open":
                ESXRadio.SlideUp()
                $('#channel').val(event.data.value)
                break;
            case "close":
                ESXRadio.SlideDown()
                break;
            case "DisplayPlayers":
                if (event.data.value == true)
                    ESXRadio.DisplayPlayers(event.data.players, event.data.title, event.data.channel);
                else 
                    ESXRadio.HidePlayers();
                break;
            case "RemovePlayer":
                $('#' + event.data.plyid).remove()
                break;
            case "AddPlayer":
                ESXRadio.AddPlayer(event.data.player, event.data.plyid);
                break;
            default:
                break;
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('https://hp_fraction_radio/escape', JSON.stringify({}));
            ESXRadio.SlideDown()
        } else if (data.which == 13) { // Enter key
            $.post('https://hp_fraction_radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

ESXRadio = {}

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('https://hp_fraction_radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('https://hp_fraction_radio/leaveRadio');
});

$(document).on('click', '#volumeUp', function(e){
    e.preventDefault();

    $.post('https://hp_fraction_radio/volumeUp', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#volumeDown', function(e){
    e.preventDefault();

    $.post('https://hp_fraction_radio/volumeDown', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#decreaseradiochannel', function(e){
    e.preventDefault();

    $.post('https://hp_fraction_radio/decreaseradiochannel', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#increaseradiochannel', function(e){
    e.preventDefault();

    $.post('https://hp_fraction_radio/increaseradiochannel', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#powerStateChange', function(e){
    e.preventDefault();

    $.post('https://hp_fraction_radio/ChangePowerState', JSON.stringify({
        channel: $("#channel").val()
    }));
});

ESXRadio.SlideUp = function() {
    $(".radio-container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

ESXRadio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".radio-container").css("display", "none");
    });
}

ESXRadio.DisplayPlayers = function(Players, Title, Channel) {
    $('.radio-players > .players').empty()
    for(var i = 0; i<=Players.length; i++) 
        if(Players[i] != null) 
            $('.radio-players > .players').append("<div class='player' id='" + Players[i].id + "'>[" + Players[i].badge + "] " + Players[i].name + "</div>")

    $('.radio-players > .title').text(Title);
    $('.radio-players > .freq').text(((Channel/10)+100) + "MHz");

    $(".radio-players").css("display", "block");
    $(".radio-players").animate({left: "0vw",}, 250);
}

ESXRadio.HidePlayers = function() {
    $(".radio-players").animate({left: "-110vw",}, 400, function(){
        $(".radio-players").css("display", "none");
    });
}

ESXRadio.AddPlayer = function(Player, playerId) {
    if(! $('#selector').length ) {
        $('.radio-players > .players').append("<div class='player' id='" + playerId + "'>[" + Player.badge + "] " + Player.name + "</div>")
    }
}