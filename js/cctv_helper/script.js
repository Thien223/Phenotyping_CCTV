var isPlaying = true;

var isFullScreen=false;
var original_width = 960;
var original_height = 720;
openSocket = (channel) => {
	var port = 8500;

    console.log("channel: "+channel);
	switch(channel){
	case 000:
		port = "8500"
			break;
	case 101:
		port = "8501"
			break;
	case 102 :
		port = "8502"
		break;
	case 103 :
		port = "8503"
		break;
	case 104 :
		port = "8504"
		break;
	case 105 :
		port = "8505"
		break;
	case 106 :
		port = "8506"
		break;
	case 107 :
		port = "8507"
		break;
	case 108 :
		port = "8508"
		break;
	case 109 :
		port = "8509"
		break;
	case 110 :
		port = "8510"
		break;
	case 111 :
		port = "8511"
		break;
	case 112 :
		port = "8512"
		break;
	case 113 :
		port = "8513"
		break;
	case 114 :
		port = "8514"
		break;
	case 115 :
		port = "8515"
		break;
	case 116 :
		port = "8516"
		break;
	case 117 :
		port = "8517"
		break;
	case 118 :
		port = "8518"
		break;
	case 119 :
		port = "8519"
		break;
	default :
		break;
	}
    let uri = "ws://localhost:"+port;
    console.log("websocket uri: "+uri);
    socket = new WebSocket(uri);
    let msg = document.getElementById("msg");
    original_width = msg.width;
    original_height = msg.height;
    socket.addEventListener('message', (e) => {
        let ctx = msg.getContext("2d");
        let image = new Image();
//        console.log(e);
//        data = e.data.replace(/'/g, '"');
//        data = JSON.parse(data);
        image.src = URL.createObjectURL(e.data);
        image.addEventListener("load", (e) => {
            if(isPlaying){
                ctx.drawImage(image, 0, 0, msg.width, msg.height);
            }
        });
    });
}


pause = () => {
	isPlaying = !isPlaying;
}


toggleFullscreen = () => {
	var viewFullScreen = document.getElementById("msg");
    if(!isFullScreen) {
        var docElm = document.documentElement;
        if(docElm.requestFullscreen) docElm.requestFullscreen();
        else if(docElm.msRequestFullscreen) docElm.msRequestFullscreen();
        else if(docElm.mozRequestFullScreen) docElm.mozRequestFullScreen();
        else if(docElm.webkitRequestFullScreen) docElm.webkitRequestFullScreen();
        viewFullScreen.width = window.innerWidth;
        viewFullScreen.height = window.innerHeight;
        isFullScreen = true;
    } else {
        viewFullScreen.width = original_width;
        viewFullScreen.height = original_height;
        if(document.exitFullscreen) document.exitFullscreen();
        else if(document.msExitFullscreen) document.msExitFullscreen();
        else if(document.mozCancelFullScreen) document.mozCancelFullScreen();
        else if(document.webkitCancelFullScreen) document.webkitCancelFullScreen();
        isFullScreen = false;
    }
}