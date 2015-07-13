function adjust_fontsize() {
	var newStyle = document.createElement('style');newStyle.type = "text/css";
	document.getElementsByTagName('head').item(0).appendChild(newStyle);
	var css = document.styleSheets.item(1)
		//追加
	var idx = document.styleSheets[1].cssRules.length;
	var winH = (window.innerHeight||document.documentElement.clientHeight||0);
	css.insertRule("html { font-size : " + winH/20 + "px ; }", idx);
}

window.addEventListener( 'resize', function() {
	adjust_fontsize();
	//resize();
}, false );
 
