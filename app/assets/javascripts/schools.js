
BingMapHelper = {};
BingMapHelper.BingMap = { 
	displayPin: function(n, t, i) {
  var r = new Microsoft.Maps.Map(document.getElementById("myMap"), { credentials: i, center: new Microsoft.Maps.Location(n, t), mapTypeId: Microsoft.Maps.MapTypeId.road, showMapTypeSelector: !1, zoom: 10 }),
      u = new Microsoft.Maps.Pushpin(r.getCenter(), null);
      r.entities.push(u) } };
$(document).ready(function() {
    var n = $("#BingMapKey").val();
    n && ($(".bingMapLink").click(function(t) {
        var i, r, u;
        t.stopPropagation ? t.stopPropagation() : t.cancelBubble = !0;
        i = $(this).attr("lat");
        r = $(this).attr("lon");
        i && r && (BingMapHelper.BingMap.displayPin(i, r, n), u = $(this).offset(), $("#myMap").offset({ top: u.top - 50, left: u.left + 50 }).css({ width: "200px", height: "200px" }).show()) }), $(document).click(function() { $("#myMap").offset({ top: 0, left: 0 }).hide() })) })
