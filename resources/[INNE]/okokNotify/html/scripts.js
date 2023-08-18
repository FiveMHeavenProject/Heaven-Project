const showNotification = (data) => {
    var number = Math.floor((Math.random() * 1000) + 1);
    $('.toast').append(`
        <div class="wrapper-${number}">
            <div class="notification_main-${number}">
                <div class="title-${number}"></div>
                <div class="text-${number}">
                    ${data.message}
                </div>
            </div>
        </div>`)
    $(`.wrapper-${number}`).css({
        "margin-bottom": "10px",
        "width": "275px",
        "margin": "0 0 8px 0px",
        "border-radius": "10px"
    })
    $('.notification_main-' + number).addClass('main')
    $('.text-' + number).css({
        "font-size": "14px"
    })

    if (data.type == 'success') {
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('success-icon')
        $(`.wrapper-${number}`).addClass('success success-border')
       // sound.play();
    } else if (data.type == 'info') {
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('info-icon')
        $(`.wrapper-${number}`).addClass('info info-border')
       // sound.play();
    } else if (data.type == 'error') {
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('error-icon')
        $(`.wrapper-${number}`).addClass('error error-border')
       // sound.play();
    } else if (data.type == 'paycheck') {
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('paycheck-icon')
        $(`.wrapper-${number}`).addClass('paycheck paycheck-border')
       // sound.play();
    } else if (data.type == 'warning') {
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('warning-icon')
        $(`.wrapper-${number}`).addClass('warning warning-border')
       // sound.play();
    } else if (data.type == 'phonemessage') {
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('phonemessage-icon')
        $(`.wrapper-${number}`).addClass('phonemessage phonemessage-border')
       // sound.play();
    } else if (data.type == 'neutral') {
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('neutral-icon')
        $(`.wrapper-${number}`).addClass('neutral neutral-border')
       // sound.play()
    } else if (data.type == 'drug'){
        $(`.title-${number}`).html(data.title).css({
            "font-size": "16px",
            "font-weight": "600"
        })
        $(`.notification_main-${number}`).addClass('drug-icon')
        $(`.wrapper-${number}`).addClass('drug drug-border')
    }
    anime({
        targets: `.wrapper-${number}`,
        translateX: 25,
        duration: 750,
        easing: 'spring(1, 70, 100, 10)',
    })
    setTimeout(function () {
        anime({
            targets: `.wrapper-${number}`,
            translateX: -500,
            duration: 750,
            easing: 'spring(1, 80, 100, 0)'
        })
        setTimeout(function () {
            $(`.wrapper-${number}`).remove()
        }, 750)
    }, data.time)
}


var sound = new Audio('sound.mp3');
sound.volume = 0.25;
window.addEventListener('message', function (event) {
    if (event.data.action == 'open') {
        showNotification(event.data)
    }
})