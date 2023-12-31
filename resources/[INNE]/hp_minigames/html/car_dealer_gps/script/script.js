const config = {
	defaultTime: 10,
	defaultSpawn: 1000,
	defaultMaxsquare: 20,
}

const container = document.querySelector('.container')
const hackFunction = document.querySelector('.hackFunction')
const hackFunction2 = document.getElementById('hackFunction2')
const hackOptions = document.querySelector('.hackOptions')
const hackText = document.querySelector('.hackText')
const progressBar = document.getElementById('progressBox')
const buttonStart = document.getElementById('buttonStart')
const hackInfo = document.querySelector('.hackInfo')
const textInfo = document.getElementById('textInfo')
const progressBarId = document.getElementById('progress-bar')

var __timePlay = document.getElementById('timeChangeInput')
var __spawnPlay = document.getElementById('spawnChangeInput')
var __maxsquare = document.getElementById('maxsquareChangeInput')
var progressBarInterval
var squaresInterval
var allSquares
var defaultTime = config.defaultTime
var defaultSpawn = config.defaultSpawn
var defaultMaxsquare = config.defaultMaxsquare

const gameInit = () => {
	container.style.display = 'flex'
	hackFunction.style.display = 'none'
	hackText.style.display = 'none'
	progressBar.style.display = 'none'
	hackInfo.style.display = 'none'
	hackFunction2.style.display = 'none'
	document.getElementById('timeChangeId').innerHTML = String(defaultTime)
	document.getElementById('spawnChangeId').innerHTML = String(defaultSpawn)
	document.getElementById('maxsquareChangeId').innerHTML = String(defaultMaxsquare)
	document.addEventListener('contextmenu', event => event.preventDefault())
}

const gameStart = () => {
	allSquares = 0
	buttonStart.style.display = 'none'
	hackOptions.style.display = 'none'
	progressBar.style.display = 'block'
	hackInfo.style.display = 'block'
	textInfo.innerHTML = 'Przygotuj sie...'
	clearInterval(squaresInterval)
	progressBarStart('start', 2)
}

const gameWin = () => {
	hackFunction.style.display = 'none'
	hackInfo.style.display = 'block'
	textInfo.innerHTML = 'Hack Udany!'
	hackText.style.display = 'none'
	hackFunction2.style.display = 'none'
	hackFunction.innerHTML = ''
	container.style.display = 'none'
	$.post('https://hp_minigames/minigameResult', JSON.stringify({ success: true }))
	progressBarStart('end', 2)
}

const gameOver = () => {
	hackInfo.style.display = 'block'
	textInfo.innerHTML = 'Hack nieudany!'
	hackFunction.style.display = 'none'
	hackText.style.display = 'none'
	hackFunction2.style.display = 'none'
	hackFunction.innerHTML = ''
	container.style.display = 'none'
	$.post('https://hp_minigames/minigameResult', JSON.stringify({ success: false }))
	clearInterval(squaresInterval)
	progressBarStart('end', 2)
}

function progressBarStart(type, time) {
	var maxwidth = 1000
	var width = maxwidth
	const process = () => {
		if (width > 0) {
			if (type == 'start' || type == 'end') width = width - 3
			else width--
			progressBarId.style.width = (width * 100.0) / maxwidth + '%'
		} else {
			if (type == 'start') {
				hackFunction.style.display = ''
				hackText.style.display = ''
				hackInfo.style.display = 'none'
				progressBarStart('game', __timePlay.value)
				createNumbers()
				return
			}
			if (type == 'game') {
				gameWin()
				clearInterval(squaresInterval)
				return
			}
			if (type == 'end') {
				hackFunction.style.display = 'none'
				hackText.style.display = 'none'
				buttonStart.style.display = ''
				hackOptions.style.display = 'none'
				progressBar.style.display = 'none'
				hackInfo.style.display = 'none'
			}
		}
	}
	clearInterval(progressBarInterval)
	progressBarInterval = setInterval(process, time)
}

function createNumbers() {
	hackFunction.innerHTML = ''

	var currentIndex = 0
	var random
	while (currentIndex <= 48) {
		const el = document.createElement('div')
		el.classList.add('el')
		el.setAttribute('id', currentIndex)

		hackFunction.appendChild(el)

		el.onclick = function () {
			if (el.classList.contains('select')) {
				el.classList.remove('select')
				allSquares--
			} else gameOver()
		}

		currentIndex++
	}

	generateNewSquare()

	hackFunction2.style.display = ''
}

function hasClass(element, className) {
	return (' ' + element.className + ' ').indexOf(' ' + className + ' ') > -1
}

function generateNewSquare() {
	squaresInterval = setInterval(() => {
		let random = Math.floor(Math.random() * 47)
		let element = document.getElementById(random)
		let good = true

		if (hasClass(element, 'select')) good = false

		if (good) {
			document.getElementById(random).classList.add('select')
			allSquares++
		}

		if (allSquares > __maxsquare.value) gameOver()
	}, __spawnPlay.value)
}

function timeChangeFunction() {
	document.getElementById('timeChangeId').innerHTML = document.getElementById('timeChangeInput').value
}

function spawnChangeFunction() {
	document.getElementById('spawnChangeId').innerHTML = document.getElementById('spawnChangeInput').value
}

function maxsquareChangeFunction() {
	document.getElementById('maxsquareChangeId').innerHTML = document.getElementById('maxsquareChangeInput').value
}
