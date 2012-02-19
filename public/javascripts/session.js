//开始session 会话计时
function startSessionTimer() {
	schedulePopup(10);
}
//设置在等待多长时间后弹出警告
function schedulePopup(t) {
	if (timeoutUniqueId != null) {
		clearTimeout(timeoutUniqueId);
	}
	timeoutUniqueId = setTimeout(alertTimeout, t * 1000);
}
//退出登录处理
function doLogout() {
	window.location = "/logout";
}
var alertWindow = null;
var parentWindow = null;
var timeoutUniqueId = null;
//更新session 过期时间
function updateSessionTimeouts(secondsLeft, secondsUntilPopup) {
	if (typeof(secondsLeft) != 'undefined') secondsLeftValue = secondsLeft;
	if (typeof(secondsUntilPopup) != 'undefined') secondsPopupValue = secondsUntilPopup;
	lastPageActivityTime = new Date().getTime();
	schedulePopup(secondsPopupValue);
}
//
function alertTimeout() {
	timeoutUniqueId = null;
	alertWindow = window.open('/session_settings/timeout_warn', "ironmine",'width=360,height=280,left='+(screen.width-360)/2+',top='+(screen.height-280)/2+',location=no,dependent=no,resizable=yes,toolbar=no,status=no,directories=no,menubar=no,scrollbars=yes', false);
	parentWindow = window;
	if (!alertWindow && forceLogout) {
		setTimeout(parentWindow.doLogout(), 25 * 1000)
	}
	document.body.onfocus = alertFocus;
}
function checkSessionTimeout() {
	var currentTime = new Date().getTime();
	var sessionTimeLeft = secondsLeftValue - ((currentTime - lastPageActivityTime) / 1000);
	if (sessionTimeLeft <= 5) {
		var url = window.location.pathname + window.location.hash;
		if (window.location.search && window.location.search.length > 1) {
			url += window.location.search;
		}
		var loc = '/?startURL=' + encodeURIComponent(url);
			top.location = loc;
	} else {
		lastPageActivityTime = currentTime;
		startSessionTimer();
	}
}
function alertFocus() {
	if (alertWindow) {
		if (!alertWindow.closed) {
			alertWindow.focus();
		} else {
			alertWindow = null;
			document.body.onfocus = closePopup;
		}
	}
}