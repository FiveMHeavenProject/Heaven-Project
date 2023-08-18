window.addEventListener('message', (event) => {
    let data = event.data

    switch(data.action) {
        case 'toggle':
            Toggle(data.state)
            break;

        case 'updateInfo':
            Update(data.players, data.police, data.ems, data.mechanic, data.doj)
            break;

            
        case 'updateJob':
            UpdateJob(data.name)
            break;
    }
});


const Toggle = (state) => {
    if (state) {
        $('body').css('display', 'block')
    } else {
        $('body').css('display', 'none')
    }
}

const UpdateJob = (name) => {
    $('.job').html(name);
}


const Update = (players, police, ems, mechanic, doj) => {

    $('.players > .text').html('<span style="color: lightgray">' + players + '/128</span>');

    $('#police > .text').html(police)
    $('#ambulance > .text').html(ems)
    $('#mechanic > .text').html(mechanic)
    $('#doj > .text').html(doj)
}