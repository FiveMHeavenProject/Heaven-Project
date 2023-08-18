const garageMenu = document.querySelector(".garage")
const carList = document.querySelector(".garage-list")
const closeBtn = document.querySelector(".close-garage-btn")
const searchCar = document.querySelector(".garage-search")



window.addEventListener('message', (event) => {
    let data = event.data

    switch (data.action) {
        case "openGarage":
            garageMenu.style.display = "block";

            for (let i = 0; i < data.vehicles.length; i++) {

                const carName = data.vehicles[i].label
                const carPlate = data.vehicles[i].props.plate
                const carEngineStatus = Math.floor(data.vehicles[i].props.engineHealth / 10)
                const carSuspensionStatus = Math.floor(data.vehicles[i].props.tankHealth / 10)
                const carFuelLevel = Math.floor(data.vehicles[i].props.fuelLevel)

                const carCard = `
                <div class="car-header">
                    <p class="car-name">${carName}</p>
                    <p class="car-plate">${carPlate}</p>
                </div>
                <div class="car-status">
                    <div class="suspension">
                        <svg class="suspension-icon" fill="#fd4370" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M14.2178 15.208C14.2178 16.53 15.2933 17.6055 16.6152 17.6055L19.6026 17.6055C20.9245 17.6055 22 16.53 22 15.208C22 13.8861 20.9245 12.8106 19.6026 12.8106L19.0631 12.8106L19.0631 5.18927L19.6026 5.18927C20.9245 5.18932 22 4.11385 22 2.79196C22 1.47003 20.9245 0.39452 19.6026 0.39452L16.6152 0.39452C15.2933 0.39452 14.2178 1.47003 14.2178 2.79196C14.2178 4.11389 15.2933 5.18936 16.6152 5.18936L17.1547 5.18936L17.1547 8.04579L10.8352 8.04579L10.8352 7.09137C10.8352 6.69614 10.5148 6.37573 10.1195 6.37573L6.21405 6.37573C5.81883 6.37573 5.49841 6.69614 5.49841 7.09137L5.49841 8.04579L4.84533 8.04579L4.84533 5.18936L5.3848 5.18936C6.70673 5.18936 7.7822 4.11389 7.7822 2.79196C7.7822 1.47003 6.70673 0.394519 5.3848 0.394519L2.39744 0.394519C1.07551 0.394519 4.3822e-05 1.47003 4.37642e-05 2.79196C4.37064e-05 4.11389 1.07551 5.18936 2.39744 5.18936L2.93691 5.18936L2.93691 12.8107L2.39744 12.8107C1.07551 12.8107 4.32793e-05 13.8862 4.32215e-05 15.2081C4.31637e-05 16.5301 1.07551 17.6056 2.39744 17.6056L5.3848 17.6056C6.70673 17.6056 7.7822 16.5301 7.7822 15.2081C7.7822 13.8862 6.70673 12.8107 5.3848 12.8107L4.84533 12.8107L4.84533 9.95425L5.49841 9.95425L5.49841 10.9969C5.49841 11.3921 5.81883 11.7125 6.21405 11.7125L10.1195 11.7125C10.5148 11.7125 10.8352 11.3921 10.8352 10.9969L10.8352 9.95425L17.1547 9.95425L17.1547 12.8107L16.6152 12.8107C15.2933 12.8107 14.2178 13.8861 14.2178 15.208Z"
                                fill="#fd4370" />
                        </svg>
                        <p class="suspension-value">${carSuspensionStatus}%</p>
                    </div>
                    <div class="engine">
                        <svg class="engine-icon" fill="#fd4370" xmlns="http://www.w3.org/2000/svg">
                            <path fill-rule="evenodd" clip-rule="evenodd"
                                d="M9.1581 19.3753L6.70361 16.9229H5.01405C4.42354 16.9229 3.94021 16.4396 3.94021 15.8491V14.0208H2.91681V16.1601C2.91681 16.6161 2.54275 16.9902 2.08673 16.9902H0.830071C0.374057 16.9902 0 16.6161 0 16.1601V8.91013C0 8.45411 0.374057 8.08005 0.830071 8.08005H2.08673C2.54275 8.08005 2.91681 8.45411 2.91681 8.91013V11.0494H3.94021V9.08244C3.94021 8.49194 4.42354 8.00861 5.01405 8.00861H6.80868L9.34512 5.31245C9.63933 5.05608 10.0302 4.96571 10.4862 4.98463H20.9367C21.2981 5.02455 21.5734 5.16325 21.7415 5.42383C21.9097 5.6802 21.8823 5.8252 21.8823 6.1131V11.0494H22.9057V8.91013C22.9057 8.45411 23.2798 8.08005 23.7358 8.08005H24.9925C25.4485 8.08005 25.8225 8.45411 25.8225 8.91013V16.1601C25.8225 16.6161 25.4485 16.9902 24.9925 16.9902H23.7358C23.2798 16.9902 22.9057 16.6161 22.9057 16.1601V14.0208H21.8823V14.2142C21.8823 14.7879 21.8992 15.1346 21.5335 15.6095C21.4642 15.6999 21.3864 15.7861 21.3002 15.8659L17.5534 19.535C17.3663 19.7431 17.0826 19.8566 16.7086 19.8776H10.3202C9.84317 19.8566 9.4544 19.6926 9.1581 19.3753ZM13.3883 12.9827L10.7321 12.7327L12.9344 7.90774H15.9458L14.2373 10.6753L17.3096 11.0158L11.6693 17.7866L13.3883 12.9827ZM10.9233 0H18.1733C18.6293 0 19.0034 0.374057 19.0034 0.830071V2.08673C19.0034 2.54275 18.6293 2.91681 18.1733 2.91681H16.034V3.97383H13.0626V2.91681H10.9233C10.4673 2.91681 10.0932 2.54275 10.0932 2.08673V0.830071C10.0932 0.374057 10.4673 0 10.9233 0Z"
                                fill="#fd4370" />
                            
                        </svg>
                        <p class="engine-value">${carEngineStatus}%</p>
                    </div>
                    <div class="fuel">
                    <svg  xmlns="http://www.w3.org/2000/svg" >
                    <path fill="#fd4370"
                        d="M19.77 7.23l.01-.01-3.72-3.72L15 4.56l2.11 2.11c-.94.36-1.61 1.26-1.61 2.33 0 1.38 1.12 2.5 2.5 2.5.36 0 .69-.08 1-.21v7.21c0 .55-.45 1-1 1s-1-.45-1-1V14c0-1.1-.9-2-2-2h-1V5c0-1.1-.9-2-2-2H6c-1.1 0-2 .9-2 2v16h10v-7.5h1.5v5c0 1.38 1.12 2.5 2.5 2.5s2.5-1.12 2.5-2.5V9c0-.69-.28-1.32-.73-1.77zM12 10H6V5h6v5zm6 0c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1z" />
                </svg>
                        <p class="fuel-value">${carFuelLevel}%</p>
                    </div>
                </div>
                <div class="car-footer">
                <div id="btn-${i}" class="car-select-btn">Wybierz</div>
                </div>
            `

                const element = document.createElement('div');
                element.classList.add("car");
                element.innerHTML = carCard;
                carList.appendChild(element);



                const btn = carList.querySelector(`#btn-${i}`);
                btn.addEventListener("click", () => {
                    setSelectedCar(JSON.stringify(data.vehicles[i].props))
                })

            }

            if (data.vehicles.length === 1 || data.vehicles.length === 3) {
                const element = document.createElement('div');
                element.classList.add("card-empty-fill")
                carList.appendChild(element)
            }


            break;
        case "closeGarage":
            garageMenu.style.display = "none"
            carList.innerHTML = ""
            searchCar.value = ""
        default:
            break;
    }
})





closeBtn.addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/closeGarage`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        }
    }).then(resp => resp.json()).then(resp => console.log(resp));
})

document.addEventListener("keyup", (e) => {
    if (e.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeGarage`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            }
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
})



searchCar.addEventListener("input", () => {
    const blankCard = document.querySelector(".card-empty-fill")

    if (blankCard) {
        if (searchCar.value === "") {
            blankCard.style.display = "block"
        } else {
            blankCard.style.display = "none"
        }
    }

    const searchText = searchCar.value.toLowerCase();
    const carNames = carList.querySelectorAll(".car-name");

    carNames.forEach((carName) => {
        const car = carName.parentNode.parentNode;
        if (carName.textContent.toLowerCase().includes(searchText)) {
            car.style.display = "block";
        } else {
            car.style.display = "none";
        }
    });
});


const setSelectedCar = (car) => {

    fetch(`https://${GetParentResourceName()}/selectCar`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            selectedCar: JSON.parse(car)
        })
    }).then(resp => resp.json()).then(resp => console.log(resp));

}