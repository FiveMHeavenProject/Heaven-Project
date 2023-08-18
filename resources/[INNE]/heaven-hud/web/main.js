const wrapper = document.querySelector(".wrapper")
const normalHud = document.querySelector(".normal-hud")
const carHud = document.querySelector(".car-hud")
const controlPanel = document.querySelector(".control-panel")
const streetBoard = document.querySelector(".street-board")
const viewDirection = document.querySelector(".view-direction")
const district = document.querySelector(".district")
const streetName = document.querySelector(".street-name")
const speedDisplay = [
    document.querySelector(".speed-value-digit-1"),
    document.querySelector(".speed-value-digit-2"),
    document.querySelector(".speed-value-digit-3"),
];
const fuelBar = document.querySelectorAll("#xgrad1 stop")
const engineIcon = document.querySelector(".engine-state")
const lightsIcon = document.querySelector(".lights-state")
const lockIcon = document.querySelector(".lock-state")
const seatbeltIcon = document.querySelector(".seatbelt-state")
const idDisplay = [
    document.querySelector(".id-value-digit-1"),
    document.querySelector(".id-value-digit-2"),
    document.querySelector(".id-value-digit-3"),
    document.querySelector(".id-value-digit-4"),
    document.querySelector(".id-value-digit-5"),
]
const ssnDisplay = [
    document.querySelector(".uid-value-digit-1"),
    document.querySelector(".uid-value-digit-2"),
    document.querySelector(".uid-value-digit-3"),
    document.querySelector(".uid-value-digit-4"),
    document.querySelector(".uid-value-digit-5"),
]
const healthIcon = document.querySelector(".health")
const vestIcon = document.querySelector(".vest")
const hungerIcon = document.querySelector(".hunger")
const waterIcon = document.querySelector(".water")
const micIcon = document.querySelector(".mic")

let radarHeight = null;


const toogleHud = (data) => {
    if (data) {
        wrapper.style.display = "block"
    } else {
        wrapper.style.display = "none"
    }
}


const toggleCarHud = (data) => {
    if (data === true) {
        normalHud.style.transform = `translateY(calc(-${radarHeight + 20}px - 100%))`
        carHud.style.opacity = "1"
        streetBoard.style.opacity = "1"
        controlPanel.style.opacity = "1"

    } else {
        normalHud.style.transform = "translateY(calc(0px - 100%))"
        carHud.style.opacity = "0"
        streetBoard.style.opacity = "0"
        controlPanel.style.opacity = "0"
    }
}

const handleSingleDigits = (value, digitsArray, arrayLength) => {
    const digitsString = value.toString().padStart(arrayLength, '&');
    for (let i = 0; i < arrayLength; i++) digitsArray[i].innerHTML = digitsString[i] == "&" ? '<p class="gray-digit">0</p>' : digitsString[i];
}

const handleIconPulsation = (icon, status) => {
    const parentIcon = icon.parentElement.parentElement;
    if (status <= 30) {
        parentIcon.classList.add("pulsation")
    } else if (status > 30) {
        parentIcon.classList.remove("pulsation")
    }
}

const setStatusPosition = ({ left_x, bottom_y }) => {
    const leftX = window.screen.width * left_x;
    const bottomY = window.screen.height * bottom_y;

    document.querySelector('.normal-hud').style.top = `${bottomY}px`;
    document.querySelector('.normal-hud').style.left = `${leftX}px`;
};

const setStreetLabelPosition = ({ right_x, bottom_y }) => {
    const rightX = window.screen.width * right_x;
    const bottomY = window.screen.height * bottom_y;

    document.querySelector('.street-board').style.top = `${bottomY - 20}px`;
    document.querySelector('.street-board').style.left = `${rightX + 20}px`;
    document.querySelector('.control-panel').style.top = `${bottomY - 80}px`;
    document.querySelector('.control-panel').style.left = `${rightX + 20}px`;
};

const setCarPosition = ({ bottom_y }) => {
    const bottomY = window.screen.height * bottom_y;

    document.querySelector('.car-hud').style.top = `${bottomY - 20}px`;
};

window.addEventListener("message", (event) => {

    const item = event.data;

    if (item.action === "openHud") {
        toogleHud(true)
    } else if (item.action === "closeHud") {
        toogleHud(false)
    }


    if (item.action === "carHud" && item.status === true) {
        toggleCarHud(true)
    } else if (item.action === "carHud" && item.status === false) {
        toggleCarHud(false)
    }

    switch (item.action) {
        case "setID":
            handleSingleDigits(item.id_label, idDisplay, 5)
            break;
        case "setSSN":
            handleSingleDigits(item.ssn_label, ssnDisplay, 5)
            break;
        case "updateHealth":
            handleIconPulsation(healthIcon, item.healthPrecent)
            healthIcon.style.height = `${item.healthPrecent}%`
            break;
        case "updateArmour":
            const icon = vestIcon.parentElement.parentElement;
            if (!item.armourPrecent) {
                icon.style.display = 'none'
            } else {
                icon.style.display = 'flex'
                vestIcon.style.height = `${item.armourPrecent}%`
            }
            break;
        case "updateStatus":
            handleIconPulsation(waterIcon, item.status.drinkBar)
            handleIconPulsation(hungerIcon, item.status.foodBar)
            waterIcon.style.height = `${item.status.drinkBar}%`
            hungerIcon.style.height = `${item.status.foodBar}%`
            break;
        case "voice_range":
            micIcon.style.height = `${item.voicerange}%`
            break;
        case "updateCarSpeed":
            handleSingleDigits(item.speed, speedDisplay, 3)
            break;
        case "updateCarFuelLevel":
            fuelBar.forEach((fuelElement) => {
                fuelElement.setAttribute("offset", `${item.fuel}%`)
            })
            break;
        case "updateStreetAndZone":
            district.textContent = item.street.zone
            streetName.textContent = item.street.street
            viewDirection.textContent = item.street.direction
            break;
        case "updateVehicle":
            // if (item.vehdata.lightstate == 1) {
            //     lightsIcon.setAttribute("fill", "white");
            // } else if (item.vehdata.lightstate == 2) {
            //     lightsIcon.setAttribute("fill", "blue");
            // } else {
            //     lightsIcon.setAttribute("fill", "#696969");
            // }



            item.vehdata.enginestate == 1 ? engineIcon.setAttribute("fill", "white") : engineIcon.setAttribute("fill", "#696969");
            // item.vehdata.lightstate == 1 ? lightsIcon.setAttribute("fill", "white") : lightsIcon.setAttribute("fill", "#696969");
            item.vehdata.lock == 1 ? lockIcon.setAttribute("fill", "#696969") : lockIcon.setAttribute("fill", "#fd4370");
            break;
        case "TalkingOnMic":
            item.talking == true ? micIcon.style.backgroundColor = '#2a93d5' : micIcon.style.backgroundColor = '#fd4370';
            break;
        case "seatbelt":
            if (!item.seatbelt == true) {
                seatbeltIcon.classList.remove("seatbelt-pulse")
                seatbeltIcon.setAttribute("fill", "#fff")
            } else {
                seatbeltIcon.classList.add("seatbelt-pulse")
            }
            break;
        case "updateRadar":
            setStatusPosition(item.minimap);
            setStreetLabelPosition(item.minimap);
            setCarPosition(item.minimap);
            radarHeight = item.minimap.height * window.screen.height;
            break;
        default:
            break;
    }
})