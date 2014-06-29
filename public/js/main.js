var printLog = function(log, target) {
	var i, arr_length;
	i = 1;
	arr_length = log.length;
	target.innerHTML = '';

	while (i < arr_length && i < 20) {
		target.innerHTML += log[arr_length - i] + '<br>';
		i++;
	}

};

window.onload = function(){
	'use strict';

	var socket, stage, log;

	socket = io.connect('http://localhost');
	stage = document.getElementById('stage');
	log = document.getElementById('log');

	socket.on('turn passed', function (data) {
		stage.innerHTML = data.stage;
		printLog(data.log, log);
	});

	socket.on('disconnect', function() {
		io.sockets.emit('user disconnected');
	});


}


