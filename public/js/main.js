window.onload = function(){
	'use strict';

	var socket = io.connect('http://localhost');
	var el = document.getElementById('test');
	socket.on('turns passed', function (data) {
		el.innerHTML = data.turns;
	});	

}
