const minigamesLocations = {
	minigame1: 'car_dealer_gps',
	minigame2: 'car_dealer_number',
	minigame3: 'flecca_door',
	minigame4: 'flecca_panel',
	minigame5: 'mazebank_door',
	minigame6: 'mazebank_pc',
	minigame7: 'mazebank_pc2',
	minigame8: 'mazebank_power',
	minigame9: 'sgoc_camera',
	minigame10: 'sgoc_pc',
	minigame11: 'sgoc_power',
}

window.addEventListener('message', function (event) {
	var type = event.data.type
	var display = event.data.display

	if (type == 'ui') {
		if (display) {
			var minigame = event.data.minigame
			var location = minigamesLocations[minigame]
			window.location.replace('https://cfx-nui-hp_minigames/html/' + location + '/index.html')
		} else {
			window.location.replace('https://cfx-nui-hp_minigames/html/index.html')
		}
	}
})


window.onkeyup = function (e) {
	if (e.keyCode == 27) {
		window.location.replace('https://cfx-nui-hp_minigames/html/index.html')
		let req = new XMLHttpRequest();
		req.open("POST", "https://hp_minigames/minigameResult", true)
		req.setRequestHeader('Content-Type', 'application/json');
		req.send(JSON.stringify({ success: false }));
		//$.post('https://hp_minigames/minigameResult', JSON.stringify({ success: false }))
	}
}
