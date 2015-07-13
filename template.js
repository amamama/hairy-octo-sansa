function adjust_fontsize() {
	if(document.getElementsByTagName('style').length == 0) {
		var newStyle = document.createElement('style');newStyle.type = "text/css";
		document.getElementsByTagName('head').item(0).appendChild(newStyle);
	} else {
		document.styleSheets.item(1).deleteRule(0);
	}
	var css = document.styleSheets.item(1);
	var idx = document.styleSheets[1].cssRules.length;
	var winH = (window.innerHeight||document.documentElement.clientHeight||0);
	css.insertRule("html { font-size : " + winH/20 + "px ; }", idx);
}

window.addEventListener( 'resize', function() {
	adjust_fontsize();
	//resize();
}, false );
 
