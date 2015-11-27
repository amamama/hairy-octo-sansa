function adjust_size() {
	if(document.styleSheets.length == 1) {
		var newStyle = document.createElement('style');
		newStyle.type = "text/css";
		document.getElementsByTagName('head').item(0).appendChild(newStyle);
	} else {
		document.styleSheets.item(1).deleteRule(0);
		document.styleSheets.item(1).deleteRule(0);
	}
	var css = document.styleSheets.item(1);
	var idx = document.styleSheets[1].cssRules.length;
	var winH = (window.innerHeight||document.documentElement.clientHeight||0);
	var winW = (window.innerWidth||document.documentElement.clientWidth||0);
	css.insertRule("html { font-size : " + winH/25 + "px; }", 0);
	css.insertRule("img { width : auto;/*width : " + winW*0.5 + "px;*/ height : " + winH*0.5 + "px; }", 1);
}

window.addEventListener( 'resize', function() {
	adjust_size();
	//resize();
}, false );

window.addEventListener( 'keyup', function(e){
	var kc = e.keyCode;
	var num = parseInt(location.pathname.match(/[0-9]+\.html/)[0].match(/[0-9]+/)[0]);
	var locbase = location.origin + location.pathname.substr(0,location.pathname.indexOf(num + '.html'));
	switch(kc) {
	//case 38 : location.href = locbase + 1 + '.html';
	//	break;
	case 37 : location.href = locbase + (num-1) + '.html';
		break;
	case 39 : location.href = locbase + (num+1) + '.html';
		break;
	}
}, false );
