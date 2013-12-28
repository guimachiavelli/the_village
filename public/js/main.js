window.onload = function(){
	'use strict';

	var socket = io.connect('http://localhost');
	var el = document.getElementById('stage');	
	socket.on('turn passed', function (data) {
		//el.innerHTML = data.log;
		
		el.innerHTML = data.stage;
	});	

	socket.on('disconnect', function() {
		io.sockets.emit('user disconnected');
	});


}
