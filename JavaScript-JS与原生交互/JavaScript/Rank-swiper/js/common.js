function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
};

//
function formatNumber(str) {
	if(/\./.test(str)) {
		return str.replace(/\d(?=(\d{3})+\.)/g, "$&,").split("").reverse().join("").replace(/\d(?=(\d{3})+\.)/g, "$&,").split("").reverse().join("");
	} else {
		return str.replace(/\d(?=(\d{3})+$)/g, "$&,");
	}
}