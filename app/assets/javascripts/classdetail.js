function iniTiles() {
    $(".deskcontainer:not([position='0']").each(function() {
        var n = $(this).attr("position"),
            t = $(".desktile[position='" + n + "']");
        $(this).appendTo(t) 
    }) 
}

function iniControl() {
    function t() { $("#imgsave").hide();
        $("#imgcancel").hide();
        $("#imgedit").show();
        $(".deskclose").hide();
        disableDragAndDrop() }
    $("#imgedit").click(function() { $(this).hide();
        $("#imgsave").show();
        $("#imgcancel").show();
        $(".deskclose").show();
        enableDragAndDrop() });
    $("#imgcancel").click(function() { t();
        cancelEditDesk() });
    $("#imgsave").click(function() { t();
        saveEditDesk() });
    $(".students #studoc tbody tr, .students #conversations tbody tr").click(function() { $(this).addClass("selected").siblings().removeClass("selected") });
    var n = $.urlParam("tab");
    n && $(".nav-tabs li:eq(" + n + ") a").tab("show") }

function formatDateTime() { $(".coursedetail #termdate").each(function(n, t) {
        var i = $(t),
            r = i.text();
        r && i.text(moment.utc(r).local().format("MMMM D YYYY")) });
    $("#studoc tbody .tr-content td:nth-child(4)").each(function(n, t) {
        var i = $(t),
            r = i.text();
        r && i.text(moment.utc(r).local().format("MM/DD/YYYY hh: mm: ss A")) }) }

function loadImages() { $("img[realheader]").each(function(n, t) {
        var i = $(t);
        i.attr("src", i.attr("realheader")) }) }

function iniTableSort() { $("#studentsTable").tablesorter({ sortList: [
            [0, 0]
        ] });
    $("#studoc").tablesorter({ sortList: [
            [2, 0]
        ] }) }

function enableDragAndDrop() {
    function n(n, t) {
        if (n = $(n), typeof t === undefined || t == !0) n.on("dragstart", function(n) { $(this).addClass("greenlist");
            var t = $(this).attr("id");
            n.originalEvent.dataTransfer.setData("text", "userid:" + t) }).on("dragend", function() { $(this).removeClass("greenlist");
            $(".greenTileTooltip").remove() });
        else n.off("dragstart dragend");
        return n }
    var t = $("#lstproducts li");
    $.each(t, function() {
        var t = $(this).attr("id"),
            i = $(".deskcontainer[userid='" + t + "']").attr("position");
        i == "0" ? n(this, !0) : n($(this), !1).find(".seated").removeClass("hideitem") });
    $(".deskcontainer").on("dragstart", function(n) {
        var t = $(this).attr("userid"),
            i;
        n.originalEvent.dataTransfer.setData("text", "userid:" + t);
        $("#" + t).addClass("greenlist");
        i = $(this).attr("prev-position");
        i || $(this).attr("prev-position", $(this).attr("position")) });
    $(".desktile").on("drop", function(t) {
        var f, e;
        t.preventDefault();
        var r = t.originalEvent.dataTransfer.getData("text"),
            u = "userid:",
            i = "";
        (typeof r == "string" && r.indexOf(u) == 0 && (i = r.substr(u.length)), f = $(this).find(".deskcontainer"), f.length > 0 || i.length == 0) || ($(".greenTileTooltip").remove(), n($("#" + i), !1).removeClass("greenlist").find(".seated").removeClass("hideitem"), $(".deskcontainer[userid='" + i + "']").addClass("white").appendTo($(this)), e = $(this).attr("position"), $(this).find(".deskcontainer").attr("position", e)) });
    $(".desktile").on("dragenter", function(n) {
        if (n.preventDefault(), $(this).find(".deskcontainer").length == 0 && $("#lstproducts li.greenlist").length > 0) {
            var t = $(".desktile .greenTileTooltip");
            t.length == 0 && (t = $("<div class='greenTileTooltip'>Place student here<\/div>"));
            t.appendTo($(this)) } }).on("dragend", function(n) { n.preventDefault();
        $(".greenTileTooltip").remove();
        $(".greenlist").removeClass("greenlist") });
    $("#dvright").on("dragover", function(n) { n.preventDefault() });
    $(".deskclose").click(function() {
        var t = $(this).closest(".deskcontainer"),
            u = t.attr("userid"),
            i = $("#" + u),
            r;
        i.find(".seated").addClass("hideitem");
        n(i, !0);
        r = t.attr("position");
        t.attr({ "prev-position": r, position: 0 });
        t.appendTo($("#hidtiles")) }) }

function disableDragAndDrop() { $("#lstproducts li, .deskcontainer").off("dragstart");
    $(".desktile").off("dragenter drop dragend");
    $("#dvright").off("dragover");
    $(".deskclose").off("click") }

function saveEditDesk() {
    var n = [], t = $("#hidSectionid").val();
    $(".deskcontainer").each(function() {
	    var i = $(this).attr("userid"),r;
	    i && (r = $(this).attr("position"), n.push({ O365UserId: i, Position: r, ClassId: t })) 
    });
    $.ajax({ 
    	type: "POST", 
    	url: "/schools/save_settings", 
    	dataType: "json", 
    	data: {postions: n},
    	success: function() { 
    		$(".desktile .deskcontainer.unsaved").removeClass("unsaved");
        $(".desktile .deskcontainer[prev-position]").removeAttr("prev-position");
        $('<div id="saveResult"><div>Seating map changes saved.<\/div><\/div>').insertBefore($("#dvleft")).fadeIn("slow", function() { $(this).delay(3e3).fadeOut("slow") }) 
      }, 
     	error: function() {} 
    }) 
}

function cancelEditDesk() { $(".desktile .deskcontainer.unsaved").appendTo($("#hidtiles")).attr("position", 0).each(function(n, t) { $("#" + $(t).attr("userid")).find(".seated").addClass("hideitem") });
    $("#hidtiles .deskcontainer:not(.unsaved)").each(function(n, t) {
        var i = $(t),
            r = i.attr("prev-position");
        i.attr("position", r).removeAttr("prev-position").appendTo($(".desktile[position=" + r + "]"));
        $("#" + i.attr("userid")).find(".seated").removeClass("hideitem") });
    $(".desktile .deskcontainer[prev-position]").each(function(n, t) {
        var i = $(t),
            r = i.attr("prev-position");
        r != i.attr("position") && i.attr("position", r).removeAttr("prev-position").appendTo($(".desktile[position=" + r + "]")) }) }

function getSeatingArrangements(n, t) {
    return { O365UserId: n, Position: t } }

function addParam(n, t, i) {
    var u = document.createElement("a"),
        e = /(?:\?|&amp;|&)+([^=]+)(?:=([^&]*))*/g,
        r, f = [];
    for (u.href = n, t = encodeURIComponent(t); r = e.exec(u.search);) t != r[1] && f.push(r[1] + (r[2] ? "=" + r[2] : ""));
    return f.push(t + (i ? "=" + encodeURIComponent(i) : "")), u.search = f.join("&"), u.href }(function(n) { n.extend({ tablesorter: new function() {
            function i(n, t) { u(n + "," + ((new Date).getTime() - t.getTime()) + "ms") }

            function u(n) { typeof console != "undefined" && typeof console.debug != "undefined" ? console.log(n) : alert(n) }

            function h(t, i) {
                var o, e, r, f;
                if (t.config.debug && (o = ""), t.tBodies.length != 0) {
                    if (e = t.tBodies[0].rows, e[0]) {
                        var s = [],
                            h = e[0].cells,
                            l = h.length;
                        for (r = 0; r < l; r++) f = !1, n.metadata && n(i[r]).metadata() && n(i[r]).metadata().sorter ? f = c(n(i[r]).metadata().sorter) : t.config.headers[r] && t.config.headers[r].sorter && (f = c(t.config.headers[r].sorter)), f || (f = w(t, e, -1, r)), t.config.debug && (o += "column:" + r + " parser:" + f.id + "\n"), s.push(f) }
                    return t.config.debug && u(o), s } }

            function w(n, i, r, f) {
                for (var c = t.length, o = !1, s = !1, h = !0, e; s == "" && h;) r++, i[r] ? (o = b(i, r, f), s = k(n.config, o), n.config.debug && u("Checking if value was empty on row:" + r)) : h = !1;
                for (e = 1; e < c; e++)
                    if (t[e].is(s, n, o)) return t[e];
                return t[0] }

            function b(n, t, i) {
                return n[t].cells[i] }

            function k(t, i) {
                return n.trim(e(t, i)) }

            function c(n) {
                for (var r = t.length, i = 0; i < r; i++)
                    if (t[i].id.toLowerCase() == n.toLowerCase()) return t[i];
                return !1 }

            function l(t) {
                var h, s, u, o, f;
                t.config.debug && (h = new Date);
                var c = t.tBodies[0] && t.tBodies[0].rows.length || 0,
                    l = t.tBodies[0].rows[0] && t.tBodies[0].rows[0].cells.length || 0,
                    a = t.config.parsers,
                    r = { row: [], normalized: [] };
                for (s = 0; s < c; ++s) {
                    if (u = n(t.tBodies[0].rows[s]), o = [], u.hasClass(t.config.cssChildRow)) { r.row[r.row.length - 1] = r.row[r.row.length - 1].add(u);
                        continue }
                    for (r.row.push(u), f = 0; f < l; ++f) o.push(a[f].format(e(t.config, u[0].cells[f]), t, u[0].cells[f]));
                    o.push(r.normalized.length);
                    r.normalized.push(o);
                    o = null }
                return t.config.debug && i("Building cache for " + c + " rows:", h), r }

            function e(t, i) {
                return i ? (t.supportsTextContent || (t.supportsTextContent = i.textContent || !1), t.textExtraction == "simple" ? t.supportsTextContent ? i.textContent : i.childNodes[0] && i.childNodes[0].hasChildNodes() ? i.childNodes[0].innerHTML : i.innerHTML : typeof t.textExtraction == "function" ? t.textExtraction(i) : n(i).text()) : "" }

            function o(t, r) {
                var l, u, f, v, e;
                t.config.debug && (l = new Date);
                var a = r,
                    o = a.row,
                    h = a.normalized,
                    y = h.length,
                    p = h[0].length - 1,
                    w = n(t.tBodies[0]),
                    c = [];
                for (u = 0; u < y; u++)
                    if (f = h[u][p], c.push(o[f]), !t.config.appender)
                        for (v = o[f].length, e = 0; e < v; e++) w[0].appendChild(o[f][e]);
                t.config.appender && t.config.appender(t, c);
                c = null;
                t.config.debug && i("Rebuilt table:", l);
                s(t);
                setTimeout(function() { n(t).trigger("sortEnd") }, 0) }

            function d(t) {
                var r, e, f;
                return t.config.debug && (r = new Date), e = n.metadata ? !0 : !1, f = g(t), $tableHeaders = n(t.config.selectorHeaders, t).each(function(i) {
                    if (this.column = f[this.parentNode.rowIndex + "-" + this.cellIndex], this.order = rt(t.config.sortInitialOrder), this.count = this.order, (tt(this) || it(t, i)) && (this.sortDisabled = !0), a(t, i) && (this.order = this.lockedOrder = a(t, i)), !this.sortDisabled) {
                        var r = n(this).addClass(t.config.cssHeader);
                        t.config.onRenderHeader && t.config.onRenderHeader.apply(r) }
                    t.config.headerList[i] = this }), t.config.debug && (i("Built headers:", r), u($tableHeaders)), $tableHeaders }

            function g(n) {
                for (var h, u, t, a, o, i = [], c = {}, v = n.getElementsByTagName("THEAD")[0], l = v.getElementsByTagName("TR"), s = 0; s < l.length; s++)
                    for (h = l[s].cells, u = 0; u < h.length; u++) {
                        var f = h[u],
                            r = f.parentNode.rowIndex,
                            y = r + "-" + f.cellIndex,
                            p = f.rowSpan || 1,
                            w = f.colSpan || 1,
                            e;
                        for (typeof i[r] == "undefined" && (i[r] = []), t = 0; t < i[r].length + 1; t++)
                            if (typeof i[r][t] == "undefined") { e = t;
                                break }
                        for (c[y] = e, t = r; t < r + p; t++)
                            for (typeof i[t] == "undefined" && (i[t] = []), a = i[t], o = e; o < e + w; o++) a[o] = "x" }
                return c }

            function tt(t) {
                return n.metadata && n(t).metadata().sorter === !1 ? !0 : !1 }

            function it(n, t) {
                return n.config.headers[t] && n.config.headers[t].sorter === !1 ? !0 : !1 }

            function a(n, t) {
                return n.config.headers[t] && n.config.headers[t].lockedOrder ? n.config.headers[t].lockedOrder : !1 }

            function s(n) {
                for (var i = n.config.widgets, r = i.length, t = 0; t < r; t++) v(i[t]).format(n) }

            function v(n) {
                for (var i = r.length, t = 0; t < i; t++)
                    if (r[t].id.toLowerCase() == n.toLowerCase()) return r[t] }

            function rt(n) {
                return typeof n != "Number" ? n.toLowerCase() == "desc" ? 1 : 0 : n == 1 ? 1 : 0 }

            function ut(n, t) {
                for (var r = t.length, i = 0; i < r; i++)
                    if (t[i][0] == n) return !0;
                return !1 }

            function y(t, i, r, u) {
                var e, o, f;
                for (i.removeClass(u[0]).removeClass(u[1]), e = [], i.each(function() { this.sortDisabled || (e[this.column] = n(this)) }), o = r.length, f = 0; f < o; f++) e[r[f][0]].addClass(u[r[f][1]]) }

            function ft(t) {
                var r = t.config,
                    i;
                r.widthFixed && (i = n("<colgroup>"), n("tr:first td", t.tBodies[0]).each(function() { i.append(n("<col>").css("width", n(this).width())) }), n(t).prepend(i)) }

            function et(n, t) {
                for (var r, u, f = n.config, e = t.length, i = 0; i < e; i++) r = t[i], u = f.headerList[r[0]], u.count = r[1], u.count++ }

            function p(table, sortList, cache) {
                var sortTime, dynamicExp, l, orgOrderCol, i;
                for (table.config.debug && (sortTime = new Date), dynamicExp = "var sortWrapper = function(a,b) {", l = sortList.length, i = 0; i < l; i++) {
                    var c = sortList[i][0],
                        order = sortList[i][1],
                        s = table.config.parsers[c].type == "text" ? order == 0 ? f("text", "asc", c) : f("text", "desc", c) : order == 0 ? f("numeric", "asc", c) : f("numeric", "desc", c),
                        e = "e" + i;
                    dynamicExp += "var " + e + " = " + s;
                    dynamicExp += "if(" + e + ") { return " + e + "; } ";
                    dynamicExp += "else { " }
                for (orgOrderCol = cache.normalized[0].length - 1, dynamicExp += "return a[" + orgOrderCol + "]-b[" + orgOrderCol + "];", i = 0; i < l; i++) dynamicExp += "}; ";
                return dynamicExp += "return 0; ", dynamicExp += "}; ", table.config.debug && i("Evaling expression:" + dynamicExp, new Date), eval(dynamicExp), cache.normalized.sort(sortWrapper), table.config.debug && i("Sorting on " + sortList.toString() + " and dir " + order + " time:", sortTime), cache }

            function f(n, t, i) {
                var r = "a[" + i + "]",
                    u = "b[" + i + "]";
                return n == "text" && t == "asc" ? "(" + r + " == " + u + " ? 0 : (" + r + " === null ? Number.POSITIVE_INFINITY : (" + u + " === null ? Number.NEGATIVE_INFINITY : (" + r + " < " + u + ") ? -1 : 1 )));" : n == "text" && t == "desc" ? "(" + r + " == " + u + " ? 0 : (" + r + " === null ? Number.POSITIVE_INFINITY : (" + u + " === null ? Number.NEGATIVE_INFINITY : (" + u + " < " + r + ") ? -1 : 1 )));" : n == "numeric" && t == "asc" ? "(" + r + " === null && " + u + " === null) ? 0 :(" + r + " === null ? Number.POSITIVE_INFINITY : (" + u + " === null ? Number.NEGATIVE_INFINITY : " + r + " - " + u + "));" : n == "numeric" && t == "desc" ? "(" + r + " === null && " + u + " === null) ? 0 :(" + r + " === null ? Number.POSITIVE_INFINITY : (" + u + " === null ? Number.NEGATIVE_INFINITY : " + u + " - " + r + "));" : void 0 }
            var t = [],
                r = [];
            this.defaults = { cssHeader: "header", cssAsc: "headerSortUp", cssDesc: "headerSortDown", cssChildRow: "expand-child", sortInitialOrder: "asc", sortMultiSortKey: "shiftKey", sortForce: null, sortAppend: null, sortLocaleCompare: !0, textExtraction: "simple", parsers: {}, widgets: [], widgetZebra: { css: ["even", "odd"] }, headers: {}, widthFixed: !1, cancelSelection: !0, sortList: [], headerList: [], dateFormat: "us", decimal: "/.|,/g", onRenderHeader: null, selectorHeaders: "thead th", debug: !1 };
            this.benchmark = i;
            this.construct = function(t) {
                return this.each(function() {
                    var r, u, f, i, a, c;
                    this.tHead && this.tBodies && (a = 0, this.config = {}, i = n.extend(this.config, n.tablesorter.defaults, t), r = n(this), n.data(this, "tablesorter", i), u = d(this), this.config.parsers = h(this, u), f = l(this), c = [i.cssDesc, i.cssAsc], ft(this), u.click(function(t) {
                        var v = r[0].tBodies[0] && r[0].tBodies[0].rows.length || 0,
                            w, s, l, e, h, a;
                        if (!this.sortDisabled && v > 0) {
                            if (r.trigger("sortStart"), w = n(this), s = this.column, this.order = this.count++ % 2, this.lockedOrder && (this.order = this.lockedOrder), t[i.sortMultiSortKey])
                                if (ut(s, i.sortList))
                                    for (e = 0; e < i.sortList.length; e++) h = i.sortList[e], a = i.headerList[h[0]], h[0] == s && (a.count = h[1], a.count++, h[1] = a.count % 2);
                                else i.sortList.push([s, this.order]);
                            else {
                                if (i.sortList = [], i.sortForce != null)
                                    for (l = i.sortForce, e = 0; e < l.length; e++) l[e][0] != s && i.sortList.push(l[e]);
                                i.sortList.push([s, this.order]) }
                            return setTimeout(function() { y(r[0], u, i.sortList, c);
                                o(r[0], p(r[0], i.sortList, f)) }, 1), !1 } }).mousedown(function() {
                        if (i.cancelSelection) return this.onselectstart = function() {
                            return !1 }, !1 }), r.bind("update", function() {
                        var n = this;
                        setTimeout(function() { n.config.parsers = h(n, u);
                            f = l(n) }, 1) }).bind("updateCell", function(n, t) {
                        var r = this.config,
                            i = [t.parentNode.rowIndex - 1, t.cellIndex];
                        f.normalized[i[0]][i[1]] = r.parsers[i[1]].format(e(r, t), t) }).bind("sorton", function(t, r) { n(this).trigger("sortStart");
                        i.sortList = r;
                        var e = i.sortList;
                        et(this, e);
                        y(this, u, e, c);
                        o(this, p(this, e, f)) }).bind("appendCache", function() { o(this, f) }).bind("applyWidgetId", function(n, t) { v(t).format(this) }).bind("applyWidgets", function() { s(this) }), n.metadata && n(this).metadata() && n(this).metadata().sortlist && (i.sortList = n(this).metadata().sortlist), i.sortList.length > 0 && r.trigger("sorton", [i.sortList]), s(this)) }) };
            this.addParser = function(n) {
                for (var u = t.length, r = !0, i = 0; i < u; i++) t[i].id.toLowerCase() == n.id.toLowerCase() && (r = !1);
                r && t.push(n) };
            this.addWidget = function(n) { r.push(n) };
            this.formatFloat = function(n) {
                var t = parseFloat(n);
                return isNaN(t) ? 0 : t };
            this.formatInt = function(n) {
                var t = parseInt(n);
                return isNaN(t) ? 0 : t };
            this.isDigit = function(t) {
                return /^[-+]?\d*$/.test(n.trim(t.replace(/[,.']/g, ""))) };
            this.clearTableBody = function(t) {
                if (n.browser.msie) {
                    function i() {
                        while (this.firstChild) this.removeChild(this.firstChild) }
                    i.apply(t.tBodies[0]) } else t.tBodies[0].innerHTML = "" } } });
    n.fn.extend({ tablesorter: n.tablesorter.construct });
    var t = n.tablesorter;
    t.addParser({ id: "text", is: function() {
            return !0 }, format: function(t) {
            return n.trim(t.toLocaleLowerCase()) }, type: "text" });
    t.addParser({ id: "digit", is: function(t, i) {
            var r = i.config;
            return n.tablesorter.isDigit(t, r) }, format: function(t) {
            return n.tablesorter.formatFloat(t) }, type: "numeric" });
    t.addParser({ id: "currency", is: function(n) {
            return /^[£$€?.]/.test(n) }, format: function(t) {
            return n.tablesorter.formatFloat(t.replace(new RegExp(/[£$€]/g), "")) }, type: "numeric" });
    t.addParser({ id: "ipAddress", is: function(n) {
            return /^\d{2,3}[\.]\d{2,3}[\.]\d{2,3}[\.]\d{2,3}$/.test(n) }, format: function(t) {
            for (var i, u = t.split("."), f = "", e = u.length, r = 0; r < e; r++) i = u[r], f += i.length == 2 ? "0" + i : i;
            return n.tablesorter.formatFloat(f) }, type: "numeric" });
    t.addParser({ id: "url", is: function(n) {
            return /^(https?|ftp|file):\/\/$/.test(n) }, format: function(n) {
            return jQuery.trim(n.replace(new RegExp(/(https?|ftp|file):\/\//), "")) }, type: "text" });
    t.addParser({ id: "isoDate", is: function(n) {
            return /^\d{4}[\/-]\d{1,2}[\/-]\d{1,2}$/.test(n) }, format: function(t) {
            return n.tablesorter.formatFloat(t != "" ? new Date(t.replace(new RegExp(/-/g), "/")).getTime() : "0") }, type: "numeric" });
    t.addParser({ id: "percent", is: function(t) {
            return /\%$/.test(n.trim(t)) }, format: function(t) {
            return n.tablesorter.formatFloat(t.replace(new RegExp(/%/g), "")) }, type: "numeric" });
    t.addParser({ id: "usLongDate", is: function(n) {
            return n.match(new RegExp(/^[A-Za-z]{3,10}\.? [0-9]{1,2}, ([0-9]{4}|'?[0-9]{2}) (([0-2]?[0-9]:[0-5][0-9])|([0-1]?[0-9]:[0-5][0-9]\s(AM|PM)))$/)) }, format: function(t) {
            return n.tablesorter.formatFloat(new Date(t).getTime()) }, type: "numeric" });
    t.addParser({ id: "shortDate", is: function(n) {
            return /\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}/.test(n) }, format: function(t, i) {
            var r = i.config;
            return t = t.replace(/\-/g, "/"), r.dateFormat == "us" ? t = t.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$1/$2") : r.dateFormat == "uk" ? t = t.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$2/$1") : (r.dateFormat == "dd/mm/yy" || r.dateFormat == "dd-mm-yy") && (t = t.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2})/, "$1/$2/$3")), n.tablesorter.formatFloat(new Date(t).getTime()) }, type: "numeric" });
    t.addParser({ id: "time", is: function(n) {
            return /^(([0-2]?[0-9]:[0-5][0-9])|([0-1]?[0-9]:[0-5][0-9]\s(am|pm)))$/.test(n) }, format: function(t) {
            return n.tablesorter.formatFloat(new Date("2000/01/01 " + t).getTime()) }, type: "numeric" });
    t.addParser({ id: "metadata", is: function() {
            return !1 }, format: function(t, i, r) {
            var u = i.config,
                f = u.parserMetadataName ? u.parserMetadataName : "sortValue";
            return n(r).metadata()[f] }, type: "numeric" });
    t.addWidget({ id: "zebra", format: function(t) {
            var f, i, r, u;
            t.config.debug && (f = new Date);
            r = -1;
            n("tr:visible", t.tBodies[0]).each(function() { i = n(this);
                i.hasClass(t.config.cssChildRow) || r++;
                u = r % 2 == 0;
                i.removeClass(t.config.widgetZebra.css[u ? 0 : 1]).addClass(t.config.widgetZebra.css[u ? 1 : 0]) });
            t.config.debug && n.tablesorter.benchmark("Applying Zebra widget", f) } }) })(jQuery);
! function(n, t) { "object" == typeof exports && "undefined" != typeof module ? module.exports = t() : "function" == typeof define && define.amd ? define(t) : n.moment = t() }(this, function() { "use strict";

    function t() {
        return ye.apply(null, arguments) }

    function po(n) { ye = n }

    function ct(n) {
        return n instanceof Array || "[object Array]" === Object.prototype.toString.call(n) }

    function pi(n) {
        return null != n && "[object Object]" === Object.prototype.toString.call(n) }

    function wo(n) {
        for (var t in n) return !1;
        return !0 }

    function dt(n) {
        return "number" == typeof n || "[object Number]" === Object.prototype.toString.call(n) }

    function wi(n) {
        return n instanceof Date || "[object Date]" === Object.prototype.toString.call(n) }

    function tf(n, t) {
        for (var r = [], i = 0; i < n.length; ++i) r.push(t(n[i], i));
        return r }

    function l(n, t) {
        return Object.prototype.hasOwnProperty.call(n, t) }

    function lt(n, t) {
        for (var i in t) l(t, i) && (n[i] = t[i]);
        return l(t, "toString") && (n.toString = t.toString), l(t, "valueOf") && (n.valueOf = t.valueOf), n }

    function rt(n, t, i, r) {
        return gf(n, t, i, r, !0).utc() }

    function bo() {
        return { empty: !1, unusedTokens: [], unusedInput: [], overflow: -2, charsLeftOver: 0, nullInput: !1, invalidMonth: null, invalidFormat: !1, userInvalidated: !1, iso: !1, parsedDateParts: [], meridiem: null } }

    function u(n) {
        return null == n._pf && (n._pf = bo()), n._pf }

    function ar(n) {
        if (null == n._isValid) {
            var t = u(n),
                r = iy.call(t.parsedDateParts, function(n) {
                    return null != n }),
                i = !isNaN(n._d.getTime()) && t.overflow < 0 && !t.empty && !t.invalidMonth && !t.invalidWeekday && !t.nullInput && !t.invalidFormat && !t.userInvalidated && (!t.meridiem || t.meridiem && r);
            if (n._strict && (i = i && 0 === t.charsLeftOver && 0 === t.unusedTokens.length && void 0 === t.bigHour), null != Object.isFrozen && Object.isFrozen(n)) return i;
            n._isValid = i }
        return n._isValid }

    function bi(n) {
        var t = rt(NaN);
        return null != n ? lt(u(t), n) : u(t).userInvalidated = !0, t }

    function b(n) {
        return void 0 === n }

    function vr(n, t) {
        var f, i, r;
        if (b(t._isAMomentObject) || (n._isAMomentObject = t._isAMomentObject), b(t._i) || (n._i = t._i), b(t._f) || (n._f = t._f), b(t._l) || (n._l = t._l), b(t._strict) || (n._strict = t._strict), b(t._tzm) || (n._tzm = t._tzm), b(t._isUTC) || (n._isUTC = t._isUTC), b(t._offset) || (n._offset = t._offset), b(t._pf) || (n._pf = u(t)), b(t._locale) || (n._locale = t._locale), cu.length > 0)
            for (f in cu) i = cu[f], r = t[i], b(r) || (n[i] = r);
        return n }

    function si(n) { vr(this, n);
        this._d = new Date(null != n._d ? n._d.getTime() : NaN);
        this.isValid() || (this._d = new Date(NaN));
        lu === !1 && (lu = !0, t.updateOffset(this), lu = !1) }

    function at(n) {
        return n instanceof si || null != n && null != n._isAMomentObject }

    function k(n) {
        return n < 0 ? Math.ceil(n) || 0 : Math.floor(n) }

    function f(n) {
        var t = +n,
            i = 0;
        return 0 !== t && isFinite(t) && (i = k(t)), i }

    function rf(n, t, i) {
        for (var e = Math.min(n.length, t.length), o = Math.abs(n.length - t.length), u = 0, r = 0; r < e; r++)(i && n[r] !== t[r] || !i && f(n[r]) !== f(t[r])) && u++;
        return u + o }

    function uf(n) { t.suppressDeprecationWarnings === !1 && "undefined" != typeof console && console.warn && console.warn("Deprecation warning: " + n) }

    function d(n, i) {
        var r = !0;
        return lt(function() {
            var u, e, f, o;
            if (null != t.deprecationHandler && t.deprecationHandler(null, n), r) {
                for (e = [], f = 0; f < arguments.length; f++) {
                    if (u = "", "object" == typeof arguments[f]) { u += "\n[" + f + "] ";
                        for (o in arguments[0]) u += o + ": " + arguments[0][o] + ", ";
                        u = u.slice(0, -2) } else u = arguments[f];
                    e.push(u) }
                uf(n + "\nArguments: " + Array.prototype.slice.call(e).join("") + "\n" + (new Error).stack);
                r = !1 }
            return i.apply(this, arguments) }, i) }

    function ff(n, i) { null != t.deprecationHandler && t.deprecationHandler(n, i);
        we[n] || (uf(i), we[n] = !0) }

    function ft(n) {
        return n instanceof Function || "[object Function]" === Object.prototype.toString.call(n) }

    function ko(n) {
        var t;
        for (var i in n) t = n[i], ft(t) ? this[i] = t : this["_" + i] = t;
        this._config = n;
        this._ordinalParseLenient = new RegExp(this._ordinalParse.source + "|" + /\d{1,2}/.source) }

    function ef(n, t) {
        var i, r = lt({}, n);
        for (i in t) l(t, i) && (pi(n[i]) && pi(t[i]) ? (r[i] = {}, lt(r[i], n[i]), lt(r[i], t[i])) : null != t[i] ? r[i] = t[i] : delete r[i]);
        for (i in n) l(n, i) && !l(t, i) && pi(n[i]) && (r[i] = lt({}, r[i]));
        return r }

    function yr(n) { null != n && this.set(n) }

    function go(n, t, i) {
        var r = this._calendar[n] || this._calendar.sameElse;
        return ft(r) ? r.call(t, i) : r }

    function ns(n) {
        var t = this._longDateFormat[n],
            i = this._longDateFormat[n.toUpperCase()];
        return t || !i ? t : (this._longDateFormat[n] = i.replace(/MMMM|MM|DD|dddd/g, function(n) {
            return n.slice(1) }), this._longDateFormat[n]) }

    function ts() {
        return this._invalidDate }

    function is(n) {
        return this._ordinal.replace("%d", n) }

    function rs(n, t, i, r) {
        var u = this._relativeTime[i];
        return ft(u) ? u(n, t, i, r) : u.replace(/%d/i, n) }

    function us(n, t) {
        var i = this._relativeTime[n > 0 ? "future" : "past"];
        return ft(i) ? i(t) : i.replace(/%s/i, t) }

    function p(n, t) {
        var i = n.toLowerCase();
        ai[i] = ai[i + "s"] = ai[t] = n }

    function g(n) {
        if ("string" == typeof n) return ai[n] || ai[n.toLowerCase()] }

    function pr(n) {
        var i, t, r = {};
        for (t in n) l(n, t) && (i = g(t), i && (r[i] = n[t]));
        return r }

    function w(n, t) { de[n] = t }

    function fs(n) {
        var t = [];
        for (var i in n) t.push({ unit: i, priority: de[i] });
        return t.sort(function(n, t) {
            return n.priority - t.priority }), t }

    function ui(n, i) {
        return function(r) {
            return null != r ? (of(this, n, r), t.updateOffset(this, i), this) : ki(this, n) } }

    function ki(n, t) {
        return n.isValid() ? n._d["get" + (n._isUTC ? "UTC" : "") + t]() : NaN }

    function of(n, t, i) { n.isValid() && n._d["set" + (n._isUTC ? "UTC" : "") + t](i) }

    function es(n) {
        return n = g(n), ft(this[n]) ? this[n]() : this }

    function os(n, t) {
        if ("object" == typeof n) { n = pr(n);
            for (var r = fs(n), i = 0; i < r.length; i++) this[r[i].unit](n[r[i].unit]) } else if (n = g(n), ft(this[n])) return this[n](t);
        return this }

    function et(n, t, i) {
        var r = "" + Math.abs(n),
            u = t - r.length,
            f = n >= 0;
        return (f ? i ? "+" : "" : "-") + Math.pow(10, Math.max(0, u)).toString().substr(1) + r }

    function r(n, t, i, r) {
        var u = r; "string" == typeof r && (u = function() {
            return this[r]() });
        n && (oi[n] = u);
        t && (oi[t[0]] = function() {
            return et(u.apply(this, arguments), t[1], t[2]) });
        i && (oi[i] = function() {
            return this.localeData().ordinal(u.apply(this, arguments), n) }) }

    function ss(n) {
        return n.match(/\[[\s\S]/) ? n.replace(/^\[|\]$/g, "") : n.replace(/\\/g, "") }

    function hs(n) {
        for (var t = n.match(ge), i = 0, r = t.length; i < r; i++) t[i] = oi[t[i]] ? oi[t[i]] : ss(t[i]);
        return function(i) {
            for (var f = "", u = 0; u < r; u++) f += t[u] instanceof Function ? t[u].call(i, n) : t[u];
            return f } }

    function wr(n, t) {
        return n.isValid() ? (t = sf(t, n.localeData()), au[t] = au[t] || hs(t), au[t](n)) : n.localeData().invalidDate() }

    function sf(n, t) {
        function r(n) {
            return t.longDateFormat(n) || n }
        var i = 5;
        for (ur.lastIndex = 0; i >= 0 && ur.test(n);) n = n.replace(ur, r), ur.lastIndex = 0, i -= 1;
        return n }

    function i(n, t, i) { pu[n] = ft(t) ? t : function(n) {
            return n && i ? i : t } }

    function cs(n, t) {
        return l(pu, n) ? pu[n](t._strict, t._locale) : new RegExp(ls(n)) }

    function ls(n) {
        return gt(n.replace("\\", "").replace(/\\(\[)|\\(\])|\[([^\]\[]*)\]|\\(.)/g, function(n, t, i, r, u) {
            return t || i || r || u })) }

    function gt(n) {
        return n.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&") }

    function s(n, t) {
        var i, r = t;
        for ("string" == typeof n && (n = [n]), dt(t) && (r = function(n, i) { i[t] = f(n) }), i = 0; i < n.length; i++) wu[n[i]] = r }

    function hi(n, t) { s(n, function(n, i, r, u) { r._w = r._w || {};
            t(n, r._w, r, u) }) }

    function as(n, t, i) { null != t && l(wu, n) && wu[n](t, i._a, i, n) }

    function br(n, t) {
        return new Date(Date.UTC(n, t + 1, 0)).getUTCDate() }

    function vs(n, t) {
        return n ? ct(this._months) ? this._months[n.month()] : this._months[(this._months.isFormat || uo).test(t) ? "format" : "standalone"][n.month()] : this._months }

    function ys(n, t) {
        return n ? ct(this._monthsShort) ? this._monthsShort[n.month()] : this._monthsShort[uo.test(t) ? "format" : "standalone"][n.month()] : this._monthsShort }

    function ps(n, t, i) {
        var u, r, e, f = n.toLocaleLowerCase();
        if (!this._monthsParse)
            for (this._monthsParse = [], this._longMonthsParse = [], this._shortMonthsParse = [], u = 0; u < 12; ++u) e = rt([2e3, u]), this._shortMonthsParse[u] = this.monthsShort(e, "").toLocaleLowerCase(), this._longMonthsParse[u] = this.months(e, "").toLocaleLowerCase();
        return i ? "MMM" === t ? (r = v.call(this._shortMonthsParse, f), r !== -1 ? r : null) : (r = v.call(this._longMonthsParse, f), r !== -1 ? r : null) : "MMM" === t ? (r = v.call(this._shortMonthsParse, f), r !== -1 ? r : (r = v.call(this._longMonthsParse, f), r !== -1 ? r : null)) : (r = v.call(this._longMonthsParse, f), r !== -1 ? r : (r = v.call(this._shortMonthsParse, f), r !== -1 ? r : null)) }

    function ws(n, t, i) {
        var r, u, f;
        if (this._monthsParseExact) return ps.call(this, n, t, i);
        for (this._monthsParse || (this._monthsParse = [], this._longMonthsParse = [], this._shortMonthsParse = []), r = 0; r < 12; r++)
            if ((u = rt([2e3, r]), i && !this._longMonthsParse[r] && (this._longMonthsParse[r] = new RegExp("^" + this.months(u, "").replace(".", "") + "$", "i"), this._shortMonthsParse[r] = new RegExp("^" + this.monthsShort(u, "").replace(".", "") + "$", "i")), i || this._monthsParse[r] || (f = "^" + this.months(u, "") + "|^" + this.monthsShort(u, ""), this._monthsParse[r] = new RegExp(f.replace(".", ""), "i")), i && "MMMM" === t && this._longMonthsParse[r].test(n)) || i && "MMM" === t && this._shortMonthsParse[r].test(n) || !i && this._monthsParse[r].test(n)) return r }

    function hf(n, t) {
        var i;
        if (!n.isValid()) return n;
        if ("string" == typeof t)
            if (/^\d+$/.test(t)) t = f(t);
            else if (t = n.localeData().monthsParse(t), !dt(t)) return n;
        return i = Math.min(n.date(), br(n.year(), t)), n._d["set" + (n._isUTC ? "UTC" : "") + "Month"](t, i), n }

    function cf(n) {
        return null != n ? (hf(this, n), t.updateOffset(this, !0), this) : ki(this, "Month") }

    function bs() {
        return br(this.year(), this.month()) }

    function ks(n) {
        return this._monthsParseExact ? (l(this, "_monthsRegex") || lf.call(this), n ? this._monthsShortStrictRegex : this._monthsShortRegex) : (l(this, "_monthsShortRegex") || (this._monthsShortRegex = hy), this._monthsShortStrictRegex && n ? this._monthsShortStrictRegex : this._monthsShortRegex) }

    function ds(n) {
        return this._monthsParseExact ? (l(this, "_monthsRegex") || lf.call(this), n ? this._monthsStrictRegex : this._monthsRegex) : (l(this, "_monthsRegex") || (this._monthsRegex = cy), this._monthsStrictRegex && n ? this._monthsStrictRegex : this._monthsRegex) }

    function lf() {
        function f(n, t) {
            return t.length - n.length }
        for (var i, r = [], u = [], t = [], n = 0; n < 12; n++) i = rt([2e3, n]), r.push(this.monthsShort(i, "")), u.push(this.months(i, "")), t.push(this.months(i, "")), t.push(this.monthsShort(i, ""));
        for (r.sort(f), u.sort(f), t.sort(f), n = 0; n < 12; n++) r[n] = gt(r[n]), u[n] = gt(u[n]);
        for (n = 0; n < 24; n++) t[n] = gt(t[n]);
        this._monthsRegex = new RegExp("^(" + t.join("|") + ")", "i");
        this._monthsShortRegex = this._monthsRegex;
        this._monthsStrictRegex = new RegExp("^(" + u.join("|") + ")", "i");
        this._monthsShortStrictRegex = new RegExp("^(" + r.join("|") + ")", "i") }

    function ci(n) {
        return af(n) ? 366 : 365 }

    function af(n) {
        return n % 4 == 0 && n % 100 != 0 || n % 400 == 0 }

    function gs() {
        return af(this.year()) }

    function nh(n, t, i, r, u, f, e) {
        var o = new Date(n, t, i, r, u, f, e);
        return n < 100 && n >= 0 && isFinite(o.getFullYear()) && o.setFullYear(n), o }

    function di(n) {
        var t = new Date(Date.UTC.apply(null, arguments));
        return n < 100 && n >= 0 && isFinite(t.getUTCFullYear()) && t.setUTCFullYear(n), t }

    function gi(n, t, i) {
        var r = 7 + t - i,
            u = (7 + di(n, 0, r).getUTCDay() - t) % 7;
        return -u + r - 1 }

    function vf(n, t, i, r, u) {
        var f, o, s = (7 + i - r) % 7,
            h = gi(n, r, u),
            e = 1 + 7 * (t - 1) + s + h;
        return e <= 0 ? (f = n - 1, o = ci(f) + e) : e > ci(n) ? (f = n + 1, o = e - ci(n)) : (f = n, o = e), { year: f, dayOfYear: o } }

    function li(n, t, i) {
        var f, r, e = gi(n.year(), t, i),
            u = Math.floor((n.dayOfYear() - e - 1) / 7) + 1;
        return u < 1 ? (r = n.year() - 1, f = u + ni(r, t, i)) : u > ni(n.year(), t, i) ? (f = u - ni(n.year(), t, i), r = n.year() + 1) : (r = n.year(), f = u), { week: f, year: r } }

    function ni(n, t, i) {
        var r = gi(n, t, i),
            u = gi(n + 1, t, i);
        return (ci(n) - r + u) / 7 }

    function th(n) {
        return li(n, this._week.dow, this._week.doy).week }

    function ih() {
        return this._week.dow }

    function rh() {
        return this._week.doy }

    function uh(n) {
        var t = this.localeData().week(this);
        return null == n ? t : this.add(7 * (n - t), "d") }

    function fh(n) {
        var t = li(this, 1, 4).week;
        return null == n ? t : this.add(7 * (n - t), "d") }

    function eh(n, t) {
        return "string" != typeof n ? n : isNaN(n) ? (n = t.weekdaysParse(n), "number" == typeof n ? n : null) : parseInt(n, 10) }

    function oh(n, t) {
        return "string" == typeof n ? t.weekdaysParse(n) % 7 || 7 : isNaN(n) ? null : n }

    function sh(n, t) {
        return n ? ct(this._weekdays) ? this._weekdays[n.day()] : this._weekdays[this._weekdays.isFormat.test(t) ? "format" : "standalone"][n.day()] : this._weekdays }

    function hh(n) {
        return n ? this._weekdaysShort[n.day()] : this._weekdaysShort }

    function ch(n) {
        return n ? this._weekdaysMin[n.day()] : this._weekdaysMin }

    function lh(n, t, i) {
        var f, r, e, u = n.toLocaleLowerCase();
        if (!this._weekdaysParse)
            for (this._weekdaysParse = [], this._shortWeekdaysParse = [], this._minWeekdaysParse = [], f = 0; f < 7; ++f) e = rt([2e3, 1]).day(f), this._minWeekdaysParse[f] = this.weekdaysMin(e, "").toLocaleLowerCase(), this._shortWeekdaysParse[f] = this.weekdaysShort(e, "").toLocaleLowerCase(), this._weekdaysParse[f] = this.weekdays(e, "").toLocaleLowerCase();
        return i ? "dddd" === t ? (r = v.call(this._weekdaysParse, u), r !== -1 ? r : null) : "ddd" === t ? (r = v.call(this._shortWeekdaysParse, u), r !== -1 ? r : null) : (r = v.call(this._minWeekdaysParse, u), r !== -1 ? r : null) : "dddd" === t ? (r = v.call(this._weekdaysParse, u), r !== -1 ? r : (r = v.call(this._shortWeekdaysParse, u), r !== -1 ? r : (r = v.call(this._minWeekdaysParse, u), r !== -1 ? r : null))) : "ddd" === t ? (r = v.call(this._shortWeekdaysParse, u), r !== -1 ? r : (r = v.call(this._weekdaysParse, u), r !== -1 ? r : (r = v.call(this._minWeekdaysParse, u), r !== -1 ? r : null))) : (r = v.call(this._minWeekdaysParse, u), r !== -1 ? r : (r = v.call(this._weekdaysParse, u), r !== -1 ? r : (r = v.call(this._shortWeekdaysParse, u), r !== -1 ? r : null))) }

    function ah(n, t, i) {
        var r, u, f;
        if (this._weekdaysParseExact) return lh.call(this, n, t, i);
        for (this._weekdaysParse || (this._weekdaysParse = [], this._minWeekdaysParse = [], this._shortWeekdaysParse = [], this._fullWeekdaysParse = []), r = 0; r < 7; r++)
            if ((u = rt([2e3, 1]).day(r), i && !this._fullWeekdaysParse[r] && (this._fullWeekdaysParse[r] = new RegExp("^" + this.weekdays(u, "").replace(".", ".?") + "$", "i"), this._shortWeekdaysParse[r] = new RegExp("^" + this.weekdaysShort(u, "").replace(".", ".?") + "$", "i"), this._minWeekdaysParse[r] = new RegExp("^" + this.weekdaysMin(u, "").replace(".", ".?") + "$", "i")), this._weekdaysParse[r] || (f = "^" + this.weekdays(u, "") + "|^" + this.weekdaysShort(u, "") + "|^" + this.weekdaysMin(u, ""), this._weekdaysParse[r] = new RegExp(f.replace(".", ""), "i")), i && "dddd" === t && this._fullWeekdaysParse[r].test(n)) || i && "ddd" === t && this._shortWeekdaysParse[r].test(n) || i && "dd" === t && this._minWeekdaysParse[r].test(n) || !i && this._weekdaysParse[r].test(n)) return r }

    function vh(n) {
        if (!this.isValid()) return null != n ? this : NaN;
        var t = this._isUTC ? this._d.getUTCDay() : this._d.getDay();
        return null != n ? (n = eh(n, this.localeData()), this.add(n - t, "d")) : t }

    function yh(n) {
        if (!this.isValid()) return null != n ? this : NaN;
        var t = (this.day() + 7 - this.localeData()._week.dow) % 7;
        return null == n ? t : this.add(n - t, "d") }

    function ph(n) {
        if (!this.isValid()) return null != n ? this : NaN;
        if (null != n) {
            var t = oh(n, this.localeData());
            return this.day(this.day() % 7 ? t : t - 7) }
        return this.day() || 7 }

    function wh(n) {
        return this._weekdaysParseExact ? (l(this, "_weekdaysRegex") || kr.call(this), n ? this._weekdaysStrictRegex : this._weekdaysRegex) : (l(this, "_weekdaysRegex") || (this._weekdaysRegex = yy), this._weekdaysStrictRegex && n ? this._weekdaysStrictRegex : this._weekdaysRegex) }

    function bh(n) {
        return this._weekdaysParseExact ? (l(this, "_weekdaysRegex") || kr.call(this), n ? this._weekdaysShortStrictRegex : this._weekdaysShortRegex) : (l(this, "_weekdaysShortRegex") || (this._weekdaysShortRegex = py), this._weekdaysShortStrictRegex && n ? this._weekdaysShortStrictRegex : this._weekdaysShortRegex) }

    function kh(n) {
        return this._weekdaysParseExact ? (l(this, "_weekdaysRegex") || kr.call(this), n ? this._weekdaysMinStrictRegex : this._weekdaysMinRegex) : (l(this, "_weekdaysMinRegex") || (this._weekdaysMinRegex = wy), this._weekdaysMinStrictRegex && n ? this._weekdaysMinStrictRegex : this._weekdaysMinRegex) }

    function kr() {
        function u(n, t) {
            return t.length - n.length }
        for (var f, e, o, s, h = [], i = [], r = [], t = [], n = 0; n < 7; n++) f = rt([2e3, 1]).day(n), e = this.weekdaysMin(f, ""), o = this.weekdaysShort(f, ""), s = this.weekdays(f, ""), h.push(e), i.push(o), r.push(s), t.push(e), t.push(o), t.push(s);
        for (h.sort(u), i.sort(u), r.sort(u), t.sort(u), n = 0; n < 7; n++) i[n] = gt(i[n]), r[n] = gt(r[n]), t[n] = gt(t[n]);
        this._weekdaysRegex = new RegExp("^(" + t.join("|") + ")", "i");
        this._weekdaysShortRegex = this._weekdaysRegex;
        this._weekdaysMinRegex = this._weekdaysRegex;
        this._weekdaysStrictRegex = new RegExp("^(" + r.join("|") + ")", "i");
        this._weekdaysShortStrictRegex = new RegExp("^(" + i.join("|") + ")", "i");
        this._weekdaysMinStrictRegex = new RegExp("^(" + h.join("|") + ")", "i") }

    function dr() {
        return this.hours() % 12 || 12 }

    function dh() {
        return this.hours() || 24 }

    function yf(n, t) { r(n, 0, 0, function() {
            return this.localeData().meridiem(this.hours(), this.minutes(), t) }) }

    function pf(n, t) {
        return t._meridiemParse }

    function gh(n) {
        return "p" === (n + "").toLowerCase().charAt(0) }

    function nc(n, t, i) {
        return n > 11 ? i ? "pm" : "PM" : i ? "am" : "AM" }

    function wf(n) {
        return n ? n.toLowerCase().replace("_", "-") : n }

    function tc(n) {
        for (var i, t, f, r, u = 0; u < n.length;) {
            for (r = wf(n[u]).split("-"), i = r.length, t = wf(n[u + 1]), t = t ? t.split("-") : null; i > 0;) {
                if (f = bf(r.slice(0, i).join("-"))) return f;
                if (t && t.length >= i && rf(r, t, !0) >= i - 1) break;
                i-- }
            u++ }
        return null }

    function bf(n) {
        var t = null;
        if (!a[n] && "undefined" != typeof module && module && module.exports) try { t = cr._abbr;
            require("./locale/" + n);
            fi(t) } catch (n) {}
        return a[n] }

    function fi(n, t) {
        var i;
        return n && (i = b(t) ? vt(n) : gr(n, t), i && (cr = i)), cr._abbr }

    function gr(n, t) {
        if (null !== t) {
            var i = eo;
            if (t.abbr = n, null != a[n]) ff("defineLocaleOverride", "use moment.updateLocale(localeName, config) to change an existing locale. moment.defineLocale(localeName, config) should only be used for creating a new locale See http://momentjs.com/guides/#/warnings/define-locale/ for more info."), i = a[n]._config;
            else if (null != t.parentLocale) {
                if (null == a[t.parentLocale]) return yi[t.parentLocale] || (yi[t.parentLocale] = []), yi[t.parentLocale].push({ name: n, config: t }), null;
                i = a[t.parentLocale]._config }
            return a[n] = new yr(ef(i, t)), yi[n] && yi[n].forEach(function(n) { gr(n.name, n.config) }), fi(n), a[n] }
        return delete a[n], null }

    function ic(n, t) {
        if (null != t) {
            var i, r = eo;
            null != a[n] && (r = a[n]._config);
            t = ef(r, t);
            i = new yr(t);
            i.parentLocale = a[n];
            a[n] = i;
            fi(n) } else null != a[n] && (null != a[n].parentLocale ? a[n] = a[n].parentLocale : null != a[n] && delete a[n]);
        return a[n] }

    function vt(n) {
        var t;
        if (n && n._locale && n._locale._abbr && (n = n._locale._abbr), !n) return cr;
        if (!ct(n)) {
            if (t = bf(n)) return t;
            n = [n] }
        return tc(n) }

    function rc() {
        return ry(a) }

    function nu(n) {
        var i, t = n._a;
        return t && u(n).overflow === -2 && (i = t[ot] < 0 || t[ot] > 11 ? ot : t[ut] < 1 || t[ut] > br(t[tt], t[ot]) ? ut : t[y] < 0 || t[y] > 24 || 24 === t[y] && (0 !== t[it] || 0 !== t[st] || 0 !== t[ri]) ? y : t[it] < 0 || t[it] > 59 ? it : t[st] < 0 || t[st] > 59 ? st : t[ri] < 0 || t[ri] > 999 ? ri : -1, u(n)._overflowDayOfYear && (i < tt || i > ut) && (i = ut), u(n)._overflowWeeks && i === -1 && (i = fy), u(n)._overflowWeekday && i === -1 && (i = ey), u(n).overflow = i), n }

    function kf(n) {
        var t, r, o, e, f, s, h = n._i,
            i = ky.exec(h) || dy.exec(h);
        if (i) {
            for (u(n).iso = !0, t = 0, r = lr.length; t < r; t++)
                if (lr[t][1].exec(i[1])) { e = lr[t][0];
                    o = lr[t][2] !== !1;
                    break }
            if (null == e) return void(n._isValid = !1);
            if (i[3]) {
                for (t = 0, r = ku.length; t < r; t++)
                    if (ku[t][1].exec(i[3])) { f = (i[2] || " ") + ku[t][0];
                        break }
                if (null == f) return void(n._isValid = !1) }
            if (!o && null != f) return void(n._isValid = !1);
            if (i[4]) {
                if (!gy.exec(i[4])) return void(n._isValid = !1);
                s = "Z" }
            n._f = e + (f || "") + (s || "");
            iu(n) } else n._isValid = !1 }

    function uc(n) {
        var i = np.exec(n._i);
        return null !== i ? void(n._d = new Date(+i[1])) : (kf(n), void(n._isValid === !1 && (delete n._isValid, t.createFromInputFallback(n)))) }

    function ei(n, t, i) {
        return null != n ? n : null != t ? t : i }

    function fc(n) {
        var i = new Date(t.now());
        return n._useUTC ? [i.getUTCFullYear(), i.getUTCMonth(), i.getUTCDate()] : [i.getFullYear(), i.getMonth(), i.getDate()] }

    function tu(n) {
        var t, i, r, f, e = [];
        if (!n._d) {
            for (r = fc(n), n._w && null == n._a[ut] && null == n._a[ot] && ec(n), n._dayOfYear && (f = ei(n._a[tt], r[tt]), n._dayOfYear > ci(f) && (u(n)._overflowDayOfYear = !0), i = di(f, 0, n._dayOfYear), n._a[ot] = i.getUTCMonth(), n._a[ut] = i.getUTCDate()), t = 0; t < 3 && null == n._a[t]; ++t) n._a[t] = e[t] = r[t];
            for (; t < 7; t++) n._a[t] = e[t] = null == n._a[t] ? 2 === t ? 1 : 0 : n._a[t];
            24 === n._a[y] && 0 === n._a[it] && 0 === n._a[st] && 0 === n._a[ri] && (n._nextDay = !0, n._a[y] = 0);
            n._d = (n._useUTC ? di : nh).apply(null, e);
            null != n._tzm && n._d.setUTCMinutes(n._d.getUTCMinutes() - n._tzm);
            n._nextDay && (n._a[y] = 24) } }

    function ec(n) {
        var t, o, f, i, r, e, c, s, l;
        (t = n._w, null != t.GG || null != t.W || null != t.E) ? (r = 1, e = 4, o = ei(t.GG, n._a[tt], li(h(), 1, 4).year), f = ei(t.W, 1), i = ei(t.E, 1), (i < 1 || i > 7) && (s = !0)) : (r = n._locale._week.dow, e = n._locale._week.doy, l = li(h(), r, e), o = ei(t.gg, n._a[tt], l.year), f = ei(t.w, l.week), null != t.d ? (i = t.d, (i < 0 || i > 6) && (s = !0)) : null != t.e ? (i = t.e + r, (t.e < 0 || t.e > 6) && (s = !0)) : i = r);
        f < 1 || f > ni(o, r, e) ? u(n)._overflowWeeks = !0 : null != s ? u(n)._overflowWeekday = !0 : (c = vf(o, f, i, r, e), n._a[tt] = c.year, n._dayOfYear = c.dayOfYear) }

    function iu(n) {
        if (n._f === t.ISO_8601) return void kf(n);
        n._a = [];
        u(n).empty = !0;
        for (var i, f, s, r = "" + n._i, c = r.length, h = 0, o = sf(n._f, n._locale).match(ge) || [], e = 0; e < o.length; e++) f = o[e], i = (r.match(cs(f, n)) || [])[0], i && (s = r.substr(0, r.indexOf(i)), s.length > 0 && u(n).unusedInput.push(s), r = r.slice(r.indexOf(i) + i.length), h += i.length), oi[f] ? (i ? u(n).empty = !1 : u(n).unusedTokens.push(f), as(f, i, n)) : n._strict && !i && u(n).unusedTokens.push(f);
        u(n).charsLeftOver = c - h;
        r.length > 0 && u(n).unusedInput.push(r);
        n._a[y] <= 12 && u(n).bigHour === !0 && n._a[y] > 0 && (u(n).bigHour = void 0);
        u(n).parsedDateParts = n._a.slice(0);
        u(n).meridiem = n._meridiem;
        n._a[y] = oc(n._locale, n._a[y], n._meridiem);
        tu(n);
        nu(n) }

    function oc(n, t, i) {
        var r;
        return null == i ? t : null != n.meridiemHour ? n.meridiemHour(t, i) : null != n.isPM ? (r = n.isPM(i), r && t < 12 && (t += 12), r || 12 !== t || (t = 0), t) : t }

    function sc(n) {
        var t, e, f, r, i;
        if (0 === n._f.length) return u(n).invalidFormat = !0, void(n._d = new Date(NaN));
        for (r = 0; r < n._f.length; r++) i = 0, t = vr({}, n), null != n._useUTC && (t._useUTC = n._useUTC), t._f = n._f[r], iu(t), ar(t) && (i += u(t).charsLeftOver, i += 10 * u(t).unusedTokens.length, u(t).score = i, (null == f || i < f) && (f = i, e = t));
        lt(n, e || t) }

    function hc(n) {
        if (!n._d) {
            var t = pr(n._i);
            n._a = tf([t.year, t.month, t.day || t.date, t.hour, t.minute, t.second, t.millisecond], function(n) {
                return n && parseInt(n, 10) });
            tu(n) } }

    function cc(n) {
        var t = new si(nu(df(n)));
        return t._nextDay && (t.add(1, "d"), t._nextDay = void 0), t }

    function df(n) {
        var t = n._i,
            i = n._f;
        return n._locale = n._locale || vt(n._l), null === t || void 0 === i && "" === t ? bi({ nullInput: !0 }) : ("string" == typeof t && (n._i = t = n._locale.preparse(t)), at(t) ? new si(nu(t)) : (wi(t) ? n._d = t : ct(i) ? sc(n) : i ? iu(n) : lc(n), ar(n) || (n._d = null), n)) }

    function lc(n) {
        var i = n._i;
        void 0 === i ? n._d = new Date(t.now()) : wi(i) ? n._d = new Date(i.valueOf()) : "string" == typeof i ? uc(n) : ct(i) ? (n._a = tf(i.slice(0), function(n) {
            return parseInt(n, 10) }), tu(n)) : "object" == typeof i ? hc(n) : dt(i) ? n._d = new Date(i) : t.createFromInputFallback(n) }

    function gf(n, t, i, r, u) {
        var f = {};
        return i !== !0 && i !== !1 || (r = i, i = void 0), (pi(n) && wo(n) || ct(n) && 0 === n.length) && (n = void 0), f._isAMomentObject = !0, f._useUTC = f._isUTC = u, f._l = i, f._i = n, f._f = t, f._strict = r, cc(f) }

    function h(n, t, i, r) {
        return gf(n, t, i, r, !1) }

    function ne(n, t) {
        var r, i;
        if (1 === t.length && ct(t[0]) && (t = t[0]), !t.length) return h();
        for (r = t[0], i = 1; i < t.length; ++i) t[i].isValid() && !t[i][n](r) || (r = t[i]);
        return r }

    function ac() {
        var n = [].slice.call(arguments, 0);
        return ne("isBefore", n) }

    function vc() {
        var n = [].slice.call(arguments, 0);
        return ne("isAfter", n) }

    function nr(n) {
        var t = pr(n),
            i = t.year || 0,
            r = t.quarter || 0,
            u = t.month || 0,
            f = t.week || 0,
            e = t.day || 0,
            o = t.hour || 0,
            s = t.minute || 0,
            h = t.second || 0,
            c = t.millisecond || 0;
        this._milliseconds = +c + 1e3 * h + 6e4 * s + 36e5 * o;
        this._days = +e + 7 * f;
        this._months = +u + 3 * r + 12 * i;
        this._data = {};
        this._locale = vt();
        this._bubble() }

    function ru(n) {
        return n instanceof nr }

    function uu(n) {
        return n < 0 ? Math.round(-1 * n) * -1 : Math.round(n) }

    function te(n, t) { r(n, 0, 0, function() {
            var n = this.utcOffset(),
                i = "+";
            return n < 0 && (n = -n, i = "-"), i + et(~~(n / 60), 2) + t + et(~~n % 60, 2) }) }

    function fu(n, t) {
        var i = (t || "").match(n);
        if (null === i) return null;
        var e = i[i.length - 1] || [],
            r = (e + "").match(oo) || ["-", 0, 0],
            u = +(60 * r[1]) + f(r[2]);
        return 0 === u ? 0 : "+" === r[0] ? u : -u }

    function eu(n, i) {
        var r, u;
        return i._isUTC ? (r = i.clone(), u = (at(n) || wi(n) ? n.valueOf() : h(n).valueOf()) - r.valueOf(), r._d.setTime(r._d.valueOf() + u), t.updateOffset(r, !1), r) : h(n).local() }

    function ou(n) {
        return 15 * -Math.round(n._d.getTimezoneOffset() / 15) }

    function yc(n, i) {
        var r, u = this._offset || 0;
        if (!this.isValid()) return null != n ? this : NaN;
        if (null != n) {
            if ("string" == typeof n) {
                if (n = fu(hr, n), null === n) return this } else Math.abs(n) < 16 && (n = 60 * n);
            return !this._isUTC && i && (r = ou(this)), this._offset = n, this._isUTC = !0, null != r && this.add(r, "m"), u !== n && (!i || this._changeInProgress ? fe(this, yt(n - u, "m"), 1, !1) : this._changeInProgress || (this._changeInProgress = !0, t.updateOffset(this, !0), this._changeInProgress = null)), this }
        return this._isUTC ? u : ou(this) }

    function pc(n, t) {
        return null != n ? ("string" != typeof n && (n = -n), this.utcOffset(n, t), this) : -this.utcOffset() }

    function wc(n) {
        return this.utcOffset(0, n) }

    function bc(n) {
        return this._isUTC && (this.utcOffset(0, n), this._isUTC = !1, n && this.subtract(ou(this), "m")), this }

    function kc() {
        if (null != this._tzm) this.utcOffset(this._tzm);
        else if ("string" == typeof this._i) {
            var n = fu(uy, this._i);
            null != n ? this.utcOffset(n) : this.utcOffset(0, !0) }
        return this }

    function dc(n) {
        return !!this.isValid() && (n = n ? h(n).utcOffset() : 0, (this.utcOffset() - n) % 60 == 0) }

    function gc() {
        return this.utcOffset() > this.clone().month(0).utcOffset() || this.utcOffset() > this.clone().month(5).utcOffset() }

    function nl() {
        var n, t;
        return b(this._isDSTShifted) ? (n = {}, (vr(n, this), n = df(n), n._a) ? (t = n._isUTC ? rt(n._a) : h(n._a), this._isDSTShifted = this.isValid() && rf(n._a, t.toArray()) > 0) : this._isDSTShifted = !1, this._isDSTShifted) : this._isDSTShifted }

    function tl() {
        return !!this.isValid() && !this._isUTC }

    function il() {
        return !!this.isValid() && this._isUTC }

    function ie() {
        return !!this.isValid() && this._isUTC && 0 === this._offset }

    function yt(n, t) {
        var u, e, o, i = n,
            r = null;
        return ru(n) ? i = { ms: n._milliseconds, d: n._days, M: n._months } : dt(n) ? (i = {}, t ? i[t] = n : i.milliseconds = n) : (r = so.exec(n)) ? (u = "-" === r[1] ? -1 : 1, i = { y: 0, d: f(r[ut]) * u, h: f(r[y]) * u, m: f(r[it]) * u, s: f(r[st]) * u, ms: f(uu(1e3 * r[ri])) * u }) : (r = ho.exec(n)) ? (u = "-" === r[1] ? -1 : 1, i = { y: ti(r[2], u), M: ti(r[3], u), w: ti(r[4], u), d: ti(r[5], u), h: ti(r[6], u), m: ti(r[7], u), s: ti(r[8], u) }) : null == i ? i = {} : "object" == typeof i && ("from" in i || "to" in i) && (o = rl(h(i.from), h(i.to)), i = {}, i.ms = o.milliseconds, i.M = o.months), e = new nr(i), ru(n) && l(n, "_locale") && (e._locale = n._locale), e }

    function ti(n, t) {
        var i = n && parseFloat(n.replace(",", "."));
        return (isNaN(i) ? 0 : i) * t }

    function re(n, t) {
        var i = { milliseconds: 0, months: 0 };
        return i.months = t.month() - n.month() + 12 * (t.year() - n.year()), n.clone().add(i.months, "M").isAfter(t) && --i.months, i.milliseconds = +t - +n.clone().add(i.months, "M"), i }

    function rl(n, t) {
        var i;
        return n.isValid() && t.isValid() ? (t = eu(t, n), n.isBefore(t) ? i = re(n, t) : (i = re(t, n), i.milliseconds = -i.milliseconds, i.months = -i.months), i) : { milliseconds: 0, months: 0 } }

    function ue(n, t) {
        return function(i, r) {
            var u, f;
            return null === r || isNaN(+r) || (ff(t, "moment()." + t + "(period, number) is deprecated. Please use moment()." + t + "(number, period). See http://momentjs.com/guides/#/warnings/add-inverted-param/ for more info."), f = i, i = r, r = f), i = "string" == typeof i ? +i : i, u = yt(i, r), fe(this, u, n), this } }

    function fe(n, i, r, u) {
        var o = i._milliseconds,
            f = uu(i._days),
            e = uu(i._months);
        n.isValid() && (u = null == u || u, o && n._d.setTime(n._d.valueOf() + o * r), f && of(n, "Date", ki(n, "Date") + f * r), e && hf(n, ki(n, "Month") + e * r), u && t.updateOffset(n, f || e)) }

    function ul(n, t) {
        var i = n.diff(t, "days", !0);
        return i < -6 ? "sameElse" : i < -1 ? "lastWeek" : i < 0 ? "lastDay" : i < 1 ? "sameDay" : i < 2 ? "nextDay" : i < 7 ? "nextWeek" : "sameElse" }

    function fl(n, i) {
        var u = n || h(),
            f = eu(u, this).startOf("day"),
            r = t.calendarFormat(this, f) || "sameElse",
            e = i && (ft(i[r]) ? i[r].call(this, u) : i[r]);
        return this.format(e || this.localeData().calendar(r, this, h(u))) }

    function el() {
        return new si(this) }

    function ol(n, t) {
        var i = at(n) ? n : h(n);
        return !(!this.isValid() || !i.isValid()) && (t = g(b(t) ? "millisecond" : t), "millisecond" === t ? this.valueOf() > i.valueOf() : i.valueOf() < this.clone().startOf(t).valueOf()) }

    function sl(n, t) {
        var i = at(n) ? n : h(n);
        return !(!this.isValid() || !i.isValid()) && (t = g(b(t) ? "millisecond" : t), "millisecond" === t ? this.valueOf() < i.valueOf() : this.clone().endOf(t).valueOf() < i.valueOf()) }

    function hl(n, t, i, r) {
        return r = r || "()", ("(" === r[0] ? this.isAfter(n, i) : !this.isBefore(n, i)) && (")" === r[1] ? this.isBefore(t, i) : !this.isAfter(t, i)) }

    function cl(n, t) {
        var i, r = at(n) ? n : h(n);
        return !(!this.isValid() || !r.isValid()) && (t = g(t || "millisecond"), "millisecond" === t ? this.valueOf() === r.valueOf() : (i = r.valueOf(), this.clone().startOf(t).valueOf() <= i && i <= this.clone().endOf(t).valueOf())) }

    function ll(n, t) {
        return this.isSame(n, t) || this.isAfter(n, t) }

    function al(n, t) {
        return this.isSame(n, t) || this.isBefore(n, t) }

    function vl(n, t, i) {
        var f, e, r, u;
        return this.isValid() ? (f = eu(n, this), f.isValid() ? (e = 6e4 * (f.utcOffset() - this.utcOffset()), t = g(t), "year" === t || "month" === t || "quarter" === t ? (u = yl(this, f), "quarter" === t ? u /= 3 : "year" === t && (u /= 12)) : (r = this - f, u = "second" === t ? r / 1e3 : "minute" === t ? r / 6e4 : "hour" === t ? r / 36e5 : "day" === t ? (r - e) / 864e5 : "week" === t ? (r - e) / 6048e5 : r), i ? u : k(u)) : NaN) : NaN }

    function yl(n, t) {
        var r, f, u = 12 * (t.year() - n.year()) + (t.month() - n.month()),
            i = n.clone().add(u, "months");
        return t - i < 0 ? (r = n.clone().add(u - 1, "months"), f = (t - i) / (i - r)) : (r = n.clone().add(u + 1, "months"), f = (t - i) / (r - i)), -(u + f) || 0 }

    function pl() {
        return this.clone().locale("en").format("ddd MMM DD YYYY HH:mm:ss [GMT]ZZ") }

    function wl() {
        var n = this.clone().utc();
        return 0 < n.year() && n.year() <= 9999 ? ft(Date.prototype.toISOString) ? this.toDate().toISOString() : wr(n, "YYYY-MM-DD[T]HH:mm:ss.SSS[Z]") : wr(n, "YYYYYY-MM-DD[T]HH:mm:ss.SSS[Z]") }

    function bl() {
        var n, t;
        if (!this.isValid()) return "moment.invalid(/* " + this._i + " */)";
        n = "moment";
        t = "";
        this.isLocal() || (n = 0 === this.utcOffset() ? "moment.utc" : "moment.parseZone", t = "Z");
        var i = "[" + n + '("]',
            r = 0 < this.year() && this.year() <= 9999 ? "YYYY" : "YYYYYY",
            u = t + '[")]';
        return this.format(i + r + "-MM-DD[T]HH:mm:ss.SSS" + u) }

    function kl(n) { n || (n = this.isUtc() ? t.defaultFormatUtc : t.defaultFormat);
        var i = wr(this, n);
        return this.localeData().postformat(i) }

    function dl(n, t) {
        return this.isValid() && (at(n) && n.isValid() || h(n).isValid()) ? yt({ to: this, from: n }).locale(this.locale()).humanize(!t) : this.localeData().invalidDate() }

    function gl(n) {
        return this.from(h(), n) }

    function na(n, t) {
        return this.isValid() && (at(n) && n.isValid() || h(n).isValid()) ? yt({ from: this, to: n }).locale(this.locale()).humanize(!t) : this.localeData().invalidDate() }

    function ta(n) {
        return this.to(h(), n) }

    function ee(n) {
        var t;
        return void 0 === n ? this._locale._abbr : (t = vt(n), null != t && (this._locale = t), this) }

    function oe() {
        return this._locale }

    function ia(n) {
        switch (n = g(n)) {
            case "year":
                this.month(0);
            case "quarter":
            case "month":
                this.date(1);
            case "week":
            case "isoWeek":
            case "day":
            case "date":
                this.hours(0);
            case "hour":
                this.minutes(0);
            case "minute":
                this.seconds(0);
            case "second":
                this.milliseconds(0) }
        return "week" === n && this.weekday(0), "isoWeek" === n && this.isoWeekday(1), "quarter" === n && this.month(3 * Math.floor(this.month() / 3)), this }

    function ra(n) {
        return n = g(n), void 0 === n || "millisecond" === n ? this : ("date" === n && (n = "day"), this.startOf(n).add(1, "isoWeek" === n ? "week" : n).subtract(1, "ms")) }

    function ua() {
        return this._d.valueOf() - 6e4 * (this._offset || 0) }

    function fa() {
        return Math.floor(this.valueOf() / 1e3) }

    function ea() {
        return new Date(this.valueOf()) }

    function oa() {
        var n = this;
        return [n.year(), n.month(), n.date(), n.hour(), n.minute(), n.second(), n.millisecond()] }

    function sa() {
        var n = this;
        return { years: n.year(), months: n.month(), date: n.date(), hours: n.hours(), minutes: n.minutes(), seconds: n.seconds(), milliseconds: n.milliseconds() } }

    function ha() {
        return this.isValid() ? this.toISOString() : null }

    function ca() {
        return ar(this) }

    function la() {
        return lt({}, u(this)) }

    function aa() {
        return u(this).overflow }

    function va() {
        return { input: this._i, format: this._f, locale: this._locale, isUTC: this._isUTC, strict: this._strict } }

    function tr(n, t) { r(0, [n, n.length], 0, t) }

    function ya(n) {
        return se.call(this, n, this.week(), this.weekday(), this.localeData()._week.dow, this.localeData()._week.doy) }

    function pa(n) {
        return se.call(this, n, this.isoWeek(), this.isoWeekday(), 1, 4) }

    function wa() {
        return ni(this.year(), 1, 4) }

    function ba() {
        var n = this.localeData()._week;
        return ni(this.year(), n.dow, n.doy) }

    function se(n, t, i, r, u) {
        var f;
        return null == n ? li(this, r, u).year : (f = ni(n, r, u), t > f && (t = f), ka.call(this, n, t, i, r, u)) }

    function ka(n, t, i, r, u) {
        var e = vf(n, t, i, r, u),
            f = di(e.year, 0, e.dayOfYear);
        return this.year(f.getUTCFullYear()), this.month(f.getUTCMonth()), this.date(f.getUTCDate()), this }

    function da(n) {
        return null == n ? Math.ceil((this.month() + 1) / 3) : this.month(3 * (n - 1) + this.month() % 3) }

    function ga(n) {
        var t = Math.round((this.clone().startOf("day") - this.clone().startOf("year")) / 864e5) + 1;
        return null == n ? t : this.add(n - t, "d") }

    function nv(n, t) { t[ri] = f(1e3 * ("0." + n)) }

    function tv() {
        return this._isUTC ? "UTC" : "" }

    function iv() {
        return this._isUTC ? "Coordinated Universal Time" : "" }

    function rv(n) {
        return h(1e3 * n) }

    function uv() {
        return h.apply(null, arguments).parseZone() }

    function he(n) {
        return n }

    function ir(n, t, i, r) {
        var u = vt(),
            f = rt().set(r, t);
        return u[i](f, n) }

    function ce(n, t, i) {
        if (dt(n) && (t = n, n = void 0), n = n || "", null != t) return ir(n, t, i, "month");
        for (var u = [], r = 0; r < 12; r++) u[r] = ir(n, r, i, "month");
        return u }

    function su(n, t, i, r) {
        var o, f, u, e;
        if ("boolean" == typeof n ? (dt(t) && (i = t, t = void 0), t = t || "") : (t = n, i = t, n = !1, dt(t) && (i = t, t = void 0), t = t || ""), o = vt(), f = n ? o._week.dow : 0, null != i) return ir(t, (i + f) % 7, r, "day");
        for (e = [], u = 0; u < 7; u++) e[u] = ir(t, (u + f) % 7, r, "day");
        return e }

    function fv(n, t) {
        return ce(n, t, "months") }

    function ev(n, t) {
        return ce(n, t, "monthsShort") }

    function ov(n, t, i) {
        return su(n, t, i, "weekdays") }

    function sv(n, t, i) {
        return su(n, t, i, "weekdaysShort") }

    function hv(n, t, i) {
        return su(n, t, i, "weekdaysMin") }

    function cv() {
        var n = this._data;
        return this._milliseconds = ht(this._milliseconds), this._days = ht(this._days), this._months = ht(this._months), n.milliseconds = ht(n.milliseconds), n.seconds = ht(n.seconds), n.minutes = ht(n.minutes), n.hours = ht(n.hours), n.months = ht(n.months), n.years = ht(n.years), this }

    function le(n, t, i, r) {
        var u = yt(t, i);
        return n._milliseconds += r * u._milliseconds, n._days += r * u._days, n._months += r * u._months, n._bubble() }

    function lv(n, t) {
        return le(this, n, t, 1) }

    function av(n, t) {
        return le(this, n, t, -1) }

    function ae(n) {
        return n < 0 ? Math.floor(n) : Math.ceil(n) }

    function vv() {
        var u, f, e, s, o, r = this._milliseconds,
            n = this._days,
            t = this._months,
            i = this._data;
        return r >= 0 && n >= 0 && t >= 0 || r <= 0 && n <= 0 && t <= 0 || (r += 864e5 * ae(hu(t) + n), n = 0, t = 0), i.milliseconds = r % 1e3, u = k(r / 1e3), i.seconds = u % 60, f = k(u / 60), i.minutes = f % 60, e = k(f / 60), i.hours = e % 24, n += k(e / 24), o = k(ve(n)), t += o, n -= ae(hu(o)), s = k(t / 12), t %= 12, i.days = n, i.months = t, i.years = s, this }

    function ve(n) {
        return 4800 * n / 146097 }

    function hu(n) {
        return 146097 * n / 4800 }

    function yv(n) {
        var t, r, i = this._milliseconds;
        if (n = g(n), "month" === n || "year" === n) return t = this._days + i / 864e5, r = this._months + ve(t), "month" === n ? r : r / 12;
        switch (t = this._days + Math.round(hu(this._months)), n) {
            case "week":
                return t / 7 + i / 6048e5;
            case "day":
                return t + i / 864e5;
            case "hour":
                return 24 * t + i / 36e5;
            case "minute":
                return 1440 * t + i / 6e4;
            case "second":
                return 86400 * t + i / 1e3;
            case "millisecond":
                return Math.floor(864e5 * t) + i;
            default:
                throw new Error("Unknown unit " + n); } }

    function pv() {
        return this._milliseconds + 864e5 * this._days + this._months % 12 * 2592e6 + 31536e6 * f(this._months / 12) }

    function pt(n) {
        return function() {
            return this.as(n) } }

    function wv(n) {
        return n = g(n), this[n + "s"]() }

    function ii(n) {
        return function() {
            return this._data[n] } }

    function bv() {
        return k(this.days() / 7) }

    function kv(n, t, i, r, u) {
        return u.relativeTime(t || 1, !!i, n, r) }

    function dv(n, t, i) {
        var r = yt(n).abs(),
            h = bt(r.as("s")),
            f = bt(r.as("m")),
            e = bt(r.as("h")),
            o = bt(r.as("d")),
            s = bt(r.as("M")),
            c = bt(r.as("y")),
            u = h < kt.s && ["s", h] || f <= 1 && ["m"] || f < kt.m && ["mm", f] || e <= 1 && ["h"] || e < kt.h && ["hh", e] || o <= 1 && ["d"] || o < kt.d && ["dd", o] || s <= 1 && ["M"] || s < kt.M && ["MM", s] || c <= 1 && ["y"] || ["yy", c];
        return u[2] = t, u[3] = +n > 0, u[4] = i, kv.apply(null, u) }

    function gv(n) {
        return void 0 === n ? bt : "function" == typeof n && (bt = n, !0) }

    function ny(n, t) {
        return void 0 !== kt[n] && (void 0 === t ? kt[n] : (kt[n] = t, !0)) }

    function ty(n) {
        var t = this.localeData(),
            i = dv(this, !n, t);
        return n && (i = t.pastFuture(+this, i)), t.postformat(i) }

    function rr() {
        var n, e, o, t = nf(this._milliseconds) / 1e3,
            a = nf(this._days),
            i = nf(this._months);
        n = k(t / 60);
        e = k(n / 60);
        t %= 60;
        n %= 60;
        o = k(i / 12);
        i %= 12;
        var s = o,
            h = i,
            c = a,
            r = e,
            u = n,
            f = t,
            l = this.asSeconds();
        return l ? (l < 0 ? "-" : "") + "P" + (s ? s + "Y" : "") + (h ? h + "M" : "") + (c ? c + "D" : "") + (r || u || f ? "T" : "") + (r ? r + "H" : "") + (u ? u + "M" : "") + (f ? f + "S" : "") : "P0D" }
    var ye, pe, be, v, bu, fo, oo, so, ho, co, lo, du, gu, ao, vo, wt, yo, n, o;
    pe = Array.prototype.some ? Array.prototype.some : function(n) {
        for (var i = Object(this), r = i.length >>> 0, t = 0; t < r; t++)
            if (t in i && n.call(this, i[t], t, i)) return !0;
        return !1 };
    var iy = pe,
        cu = t.momentProperties = [],
        lu = !1,
        we = {};
    t.suppressDeprecationWarnings = !1;
    t.deprecationHandler = null;
    be = Object.keys ? Object.keys : function(n) {
        var t, i = [];
        for (t in n) l(n, t) && i.push(t);
        return i };
    var ke, ry = be,
        ai = {},
        de = {},
        ge = /(\[[^\[]*\])|(\\)?([Hh]mm(ss)?|Mo|MM?M?M?|Do|DDDo|DD?D?D?|ddd?d?|do?|w[o|w]?|W[o|W]?|Qo?|YYYYYY|YYYYY|YYYY|YY|gg(ggg?)?|GG(GGG?)?|e|E|a|A|hh?|HH?|kk?|mm?|ss?|S{1,9}|x|X|zz?|ZZ?|.)/g,
        ur = /(\[[^\[]*\])|(\\)?(LTS|LT|LL?L?L?|l{1,4})/g,
        au = {},
        oi = {},
        no = /\d/,
        nt = /\d\d/,
        to = /\d{3}/,
        vu = /\d{4}/,
        fr = /[+-]?\d{6}/,
        c = /\d\d?/,
        io = /\d\d\d\d?/,
        ro = /\d\d\d\d\d\d?/,
        er = /\d{1,3}/,
        yu = /\d{1,4}/,
        or = /[+-]?\d{1,6}/,
        sr = /[+-]?\d+/,
        uy = /Z|[+-]\d\d:?\d\d/gi,
        hr = /Z|[+-]\d\d(?::?\d\d)?/gi,
        vi = /[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+|[\u0600-\u06FF\/]+(\s*?[\u0600-\u06FF]+){1,2}/i,
        pu = {},
        wu = {},
        tt = 0,
        ot = 1,
        ut = 2,
        y = 3,
        it = 4,
        st = 5,
        ri = 6,
        fy = 7,
        ey = 8;
    ke = Array.prototype.indexOf ? Array.prototype.indexOf : function(n) {
        for (var t = 0; t < this.length; ++t)
            if (this[t] === n) return t;
        return -1 };
    v = ke;
    r("M", ["MM", 2], "Mo", function() {
        return this.month() + 1 });
    r("MMM", 0, 0, function(n) {
        return this.localeData().monthsShort(this, n) });
    r("MMMM", 0, 0, function(n) {
        return this.localeData().months(this, n) });
    p("month", "M");
    w("month", 8);
    i("M", c);
    i("MM", c, nt);
    i("MMM", function(n, t) {
        return t.monthsShortRegex(n) });
    i("MMMM", function(n, t) {
        return t.monthsRegex(n) });
    s(["M", "MM"], function(n, t) { t[ot] = f(n) - 1 });
    s(["MMM", "MMMM"], function(n, t, i, r) {
        var f = i._locale.monthsParse(n, r, i._strict);
        null != f ? t[ot] = f : u(i).invalidMonth = n });
    var uo = /D[oD]?(\[[^\[\]]*\]|\s)+MMMM?/,
        oy = "January_February_March_April_May_June_July_August_September_October_November_December".split("_"),
        sy = "Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec".split("_"),
        hy = vi,
        cy = vi;
    r("Y", 0, 0, function() {
        var n = this.year();
        return n <= 9999 ? "" + n : "+" + n });
    r(0, ["YY", 2], 0, function() {
        return this.year() % 100 });
    r(0, ["YYYY", 4], 0, "year");
    r(0, ["YYYYY", 5], 0, "year");
    r(0, ["YYYYYY", 6, !0], 0, "year");
    p("year", "y");
    w("year", 1);
    i("Y", sr);
    i("YY", c, nt);
    i("YYYY", yu, vu);
    i("YYYYY", or, fr);
    i("YYYYYY", or, fr);
    s(["YYYYY", "YYYYYY"], tt);
    s("YYYY", function(n, i) { i[tt] = 2 === n.length ? t.parseTwoDigitYear(n) : f(n) });
    s("YY", function(n, i) { i[tt] = t.parseTwoDigitYear(n) });
    s("Y", function(n, t) { t[tt] = parseInt(n, 10) });
    t.parseTwoDigitYear = function(n) {
        return f(n) + (f(n) > 68 ? 1900 : 2e3) };
    bu = ui("FullYear", !0);
    r("w", ["ww", 2], "wo", "week");
    r("W", ["WW", 2], "Wo", "isoWeek");
    p("week", "w");
    p("isoWeek", "W");
    w("week", 5);
    w("isoWeek", 5);
    i("w", c);
    i("ww", c, nt);
    i("W", c);
    i("WW", c, nt);
    hi(["w", "ww", "W", "WW"], function(n, t, i, r) { t[r.substr(0, 1)] = f(n) });
    fo = { dow: 0, doy: 6 };
    r("d", 0, "do", "day");
    r("dd", 0, 0, function(n) {
        return this.localeData().weekdaysMin(this, n) });
    r("ddd", 0, 0, function(n) {
        return this.localeData().weekdaysShort(this, n) });
    r("dddd", 0, 0, function(n) {
        return this.localeData().weekdays(this, n) });
    r("e", 0, 0, "weekday");
    r("E", 0, 0, "isoWeekday");
    p("day", "d");
    p("weekday", "e");
    p("isoWeekday", "E");
    w("day", 11);
    w("weekday", 11);
    w("isoWeekday", 11);
    i("d", c);
    i("e", c);
    i("E", c);
    i("dd", function(n, t) {
        return t.weekdaysMinRegex(n) });
    i("ddd", function(n, t) {
        return t.weekdaysShortRegex(n) });
    i("dddd", function(n, t) {
        return t.weekdaysRegex(n) });
    hi(["dd", "ddd", "dddd"], function(n, t, i, r) {
        var f = i._locale.weekdaysParse(n, r, i._strict);
        null != f ? t.d = f : u(i).invalidWeekday = n });
    hi(["d", "e", "E"], function(n, t, i, r) { t[r] = f(n) });
    var ly = "Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),
        ay = "Sun_Mon_Tue_Wed_Thu_Fri_Sat".split("_"),
        vy = "Su_Mo_Tu_We_Th_Fr_Sa".split("_"),
        yy = vi,
        py = vi,
        wy = vi;
    r("H", ["HH", 2], 0, "hour");
    r("h", ["hh", 2], 0, dr);
    r("k", ["kk", 2], 0, dh);
    r("hmm", 0, 0, function() {
        return "" + dr.apply(this) + et(this.minutes(), 2) });
    r("hmmss", 0, 0, function() {
        return "" + dr.apply(this) + et(this.minutes(), 2) + et(this.seconds(), 2) });
    r("Hmm", 0, 0, function() {
        return "" + this.hours() + et(this.minutes(), 2) });
    r("Hmmss", 0, 0, function() {
        return "" + this.hours() + et(this.minutes(), 2) + et(this.seconds(), 2) });
    yf("a", !0);
    yf("A", !1);
    p("hour", "h");
    w("hour", 13);
    i("a", pf);
    i("A", pf);
    i("H", c);
    i("h", c);
    i("HH", c, nt);
    i("hh", c, nt);
    i("hmm", io);
    i("hmmss", ro);
    i("Hmm", io);
    i("Hmmss", ro);
    s(["H", "HH"], y);
    s(["a", "A"], function(n, t, i) { i._isPm = i._locale.isPM(n);
        i._meridiem = n });
    s(["h", "hh"], function(n, t, i) { t[y] = f(n);
        u(i).bigHour = !0 });
    s("hmm", function(n, t, i) {
        var r = n.length - 2;
        t[y] = f(n.substr(0, r));
        t[it] = f(n.substr(r));
        u(i).bigHour = !0 });
    s("hmmss", function(n, t, i) {
        var r = n.length - 4,
            e = n.length - 2;
        t[y] = f(n.substr(0, r));
        t[it] = f(n.substr(r, 2));
        t[st] = f(n.substr(e));
        u(i).bigHour = !0 });
    s("Hmm", function(n, t) {
        var i = n.length - 2;
        t[y] = f(n.substr(0, i));
        t[it] = f(n.substr(i)) });
    s("Hmmss", function(n, t) {
        var i = n.length - 4,
            r = n.length - 2;
        t[y] = f(n.substr(0, i));
        t[it] = f(n.substr(i, 2));
        t[st] = f(n.substr(r)) });
    var cr, by = ui("Hours", !0),
        eo = { calendar: { sameDay: "[Today at] LT", nextDay: "[Tomorrow at] LT", nextWeek: "dddd [at] LT", lastDay: "[Yesterday at] LT", lastWeek: "[Last] dddd [at] LT", sameElse: "L" }, longDateFormat: { LTS: "h:mm:ss A", LT: "h:mm A", L: "MM/DD/YYYY", LL: "MMMM D, YYYY", LLL: "MMMM D, YYYY h:mm A", LLLL: "dddd, MMMM D, YYYY h:mm A" }, invalidDate: "Invalid date", ordinal: "%d", ordinalParse: /\d{1,2}/, relativeTime: { future: "in %s", past: "%s ago", s: "a few seconds", m: "a minute", mm: "%d minutes", h: "an hour", hh: "%d hours", d: "a day", dd: "%d days", M: "a month", MM: "%d months", y: "a year", yy: "%d years" }, months: oy, monthsShort: sy, week: fo, weekdays: ly, weekdaysMin: vy, weekdaysShort: ay, meridiemParse: /[ap]\.?m?\.?/i },
        a = {},
        yi = {},
        ky = /^\s*((?:[+-]\d{6}|\d{4})-(?:\d\d-\d\d|W\d\d-\d|W\d\d|\d\d\d|\d\d))(?:(T| )(\d\d(?::\d\d(?::\d\d(?:[.,]\d+)?)?)?)([\+\-]\d\d(?::?\d\d)?|\s*Z)?)?$/,
        dy = /^\s*((?:[+-]\d{6}|\d{4})(?:\d\d\d\d|W\d\d\d|W\d\d|\d\d\d|\d\d))(?:(T| )(\d\d(?:\d\d(?:\d\d(?:[.,]\d+)?)?)?)([\+\-]\d\d(?::?\d\d)?|\s*Z)?)?$/,
        gy = /Z|[+-]\d\d(?::?\d\d)?/,
        lr = [
            ["YYYYYY-MM-DD", /[+-]\d{6}-\d\d-\d\d/],
            ["YYYY-MM-DD", /\d{4}-\d\d-\d\d/],
            ["GGGG-[W]WW-E", /\d{4}-W\d\d-\d/],
            ["GGGG-[W]WW", /\d{4}-W\d\d/, !1],
            ["YYYY-DDD", /\d{4}-\d{3}/],
            ["YYYY-MM", /\d{4}-\d\d/, !1],
            ["YYYYYYMMDD", /[+-]\d{10}/],
            ["YYYYMMDD", /\d{8}/],
            ["GGGG[W]WWE", /\d{4}W\d{3}/],
            ["GGGG[W]WW", /\d{4}W\d{2}/, !1],
            ["YYYYDDD", /\d{7}/]
        ],
        ku = [
            ["HH:mm:ss.SSSS", /\d\d:\d\d:\d\d\.\d+/],
            ["HH:mm:ss,SSSS", /\d\d:\d\d:\d\d,\d+/],
            ["HH:mm:ss", /\d\d:\d\d:\d\d/],
            ["HH:mm", /\d\d:\d\d/],
            ["HHmmss.SSSS", /\d\d\d\d\d\d\.\d+/],
            ["HHmmss,SSSS", /\d\d\d\d\d\d,\d+/],
            ["HHmmss", /\d\d\d\d\d\d/],
            ["HHmm", /\d\d\d\d/],
            ["HH", /\d\d/]
        ],
        np = /^\/?Date\((\-?\d+)/i;
    t.createFromInputFallback = d("value provided is not in a recognized ISO format. moment construction falls back to js Date(), which is not reliable across all browsers and versions. Non ISO date formats are discouraged and will be removed in an upcoming major release. Please refer to http://momentjs.com/guides/#/warnings/js-date/ for more info.", function(n) { n._d = new Date(n._i + (n._useUTC ? " UTC" : "")) });
    t.ISO_8601 = function() {};
    var tp = d("moment().min is deprecated, use moment.max instead. http://momentjs.com/guides/#/warnings/min-max/", function() {
            var n = h.apply(null, arguments);
            return this.isValid() && n.isValid() ? n < this ? this : n : bi() }),
        ip = d("moment().max is deprecated, use moment.min instead. http://momentjs.com/guides/#/warnings/min-max/", function() {
            var n = h.apply(null, arguments);
            return this.isValid() && n.isValid() ? n > this ? this : n : bi() }),
        rp = function() {
            return Date.now ? Date.now() : +new Date };
    for (te("Z", ":"), te("ZZ", ""), i("Z", hr), i("ZZ", hr), s(["Z", "ZZ"], function(n, t, i) { i._useUTC = !0;
            i._tzm = fu(hr, n) }), oo = /([\+\-]|\d\d)/gi, t.updateOffset = function() {}, so = /^(\-)?(?:(\d*)[. ])?(\d+)\:(\d+)(?:\:(\d+)(\.\d*)?)?$/, ho = /^(-)?P(?:(-?[0-9,.]*)Y)?(?:(-?[0-9,.]*)M)?(?:(-?[0-9,.]*)W)?(?:(-?[0-9,.]*)D)?(?:T(?:(-?[0-9,.]*)H)?(?:(-?[0-9,.]*)M)?(?:(-?[0-9,.]*)S)?)?$/, yt.fn = nr.prototype, co = ue(1, "add"), lo = ue(-1, "subtract"), t.defaultFormat = "YYYY-MM-DDTHH:mm:ssZ", t.defaultFormatUtc = "YYYY-MM-DDTHH:mm:ss[Z]", du = d("moment().lang() is deprecated. Instead, use moment().localeData() to get the language configuration. Use moment().locale() to change languages.", function(n) {
            return void 0 === n ? this.localeData() : this.locale(n) }), r(0, ["gg", 2], 0, function() {
            return this.weekYear() % 100 }), r(0, ["GG", 2], 0, function() {
            return this.isoWeekYear() % 100 }), tr("gggg", "weekYear"), tr("ggggg", "weekYear"), tr("GGGG", "isoWeekYear"), tr("GGGGG", "isoWeekYear"), p("weekYear", "gg"), p("isoWeekYear", "GG"), w("weekYear", 1), w("isoWeekYear", 1), i("G", sr), i("g", sr), i("GG", c, nt), i("gg", c, nt), i("GGGG", yu, vu), i("gggg", yu, vu), i("GGGGG", or, fr), i("ggggg", or, fr), hi(["gggg", "ggggg", "GGGG", "GGGGG"], function(n, t, i, r) { t[r.substr(0, 2)] = f(n) }), hi(["gg", "GG"], function(n, i, r, u) { i[u] = t.parseTwoDigitYear(n) }), r("Q", 0, "Qo", "quarter"), p("quarter", "Q"), w("quarter", 7), i("Q", no), s("Q", function(n, t) { t[ot] = 3 * (f(n) - 1) }), r("D", ["DD", 2], "Do", "date"), p("date", "D"), w("date", 9), i("D", c), i("DD", c, nt), i("Do", function(n, t) {
            return n ? t._ordinalParse : t._ordinalParseLenient }), s(["D", "DD"], ut), s("Do", function(n, t) { t[ut] = f(n.match(c)[0], 10) }), gu = ui("Date", !0), r("DDD", ["DDDD", 3], "DDDo", "dayOfYear"), p("dayOfYear", "DDD"), w("dayOfYear", 4), i("DDD", er), i("DDDD", to), s(["DDD", "DDDD"], function(n, t, i) { i._dayOfYear = f(n) }), r("m", ["mm", 2], 0, "minute"), p("minute", "m"), w("minute", 14), i("m", c), i("mm", c, nt), s(["m", "mm"], it), ao = ui("Minutes", !1), r("s", ["ss", 2], 0, "second"), p("second", "s"), w("second", 15), i("s", c), i("ss", c, nt), s(["s", "ss"], st), vo = ui("Seconds", !1), r("S", 0, 0, function() {
            return ~~(this.millisecond() / 100) }), r(0, ["SS", 2], 0, function() {
            return ~~(this.millisecond() / 10) }), r(0, ["SSS", 3], 0, "millisecond"), r(0, ["SSSS", 4], 0, function() {
            return 10 * this.millisecond() }), r(0, ["SSSSS", 5], 0, function() {
            return 100 * this.millisecond() }), r(0, ["SSSSSS", 6], 0, function() {
            return 1e3 * this.millisecond() }), r(0, ["SSSSSSS", 7], 0, function() {
            return 1e4 * this.millisecond() }), r(0, ["SSSSSSSS", 8], 0, function() {
            return 1e5 * this.millisecond() }), r(0, ["SSSSSSSSS", 9], 0, function() {
            return 1e6 * this.millisecond() }), p("millisecond", "ms"), w("millisecond", 16), i("S", er, no), i("SS", er, nt), i("SSS", er, to), wt = "SSSS"; wt.length <= 9; wt += "S") i(wt, /\d+/);
    for (wt = "S"; wt.length <= 9; wt += "S") s(wt, nv);
    yo = ui("Milliseconds", !1);
    r("z", 0, 0, "zoneAbbr");
    r("zz", 0, 0, "zoneName");
    n = si.prototype;
    n.add = co;
    n.calendar = fl;
    n.clone = el;
    n.diff = vl;
    n.endOf = ra;
    n.format = kl;
    n.from = dl;
    n.fromNow = gl;
    n.to = na;
    n.toNow = ta;
    n.get = es;
    n.invalidAt = aa;
    n.isAfter = ol;
    n.isBefore = sl;
    n.isBetween = hl;
    n.isSame = cl;
    n.isSameOrAfter = ll;
    n.isSameOrBefore = al;
    n.isValid = ca;
    n.lang = du;
    n.locale = ee;
    n.localeData = oe;
    n.max = ip;
    n.min = tp;
    n.parsingFlags = la;
    n.set = os;
    n.startOf = ia;
    n.subtract = lo;
    n.toArray = oa;
    n.toObject = sa;
    n.toDate = ea;
    n.toISOString = wl;
    n.inspect = bl;
    n.toJSON = ha;
    n.toString = pl;
    n.unix = fa;
    n.valueOf = ua;
    n.creationData = va;
    n.year = bu;
    n.isLeapYear = gs;
    n.weekYear = ya;
    n.isoWeekYear = pa;
    n.quarter = n.quarters = da;
    n.month = cf;
    n.daysInMonth = bs;
    n.week = n.weeks = uh;
    n.isoWeek = n.isoWeeks = fh;
    n.weeksInYear = ba;
    n.isoWeeksInYear = wa;
    n.date = gu;
    n.day = n.days = vh;
    n.weekday = yh;
    n.isoWeekday = ph;
    n.dayOfYear = ga;
    n.hour = n.hours = by;
    n.minute = n.minutes = ao;
    n.second = n.seconds = vo;
    n.millisecond = n.milliseconds = yo;
    n.utcOffset = yc;
    n.utc = wc;
    n.local = bc;
    n.parseZone = kc;
    n.hasAlignedHourOffset = dc;
    n.isDST = gc;
    n.isLocal = tl;
    n.isUtcOffset = il;
    n.isUtc = ie;
    n.isUTC = ie;
    n.zoneAbbr = tv;
    n.zoneName = iv;
    n.dates = d("dates accessor is deprecated. Use date instead.", gu);
    n.months = d("months accessor is deprecated. Use month instead", cf);
    n.years = d("years accessor is deprecated. Use year instead", bu);
    n.zone = d("moment().zone is deprecated, use moment().utcOffset instead. http://momentjs.com/guides/#/warnings/zone/", pc);
    n.isDSTShifted = d("isDSTShifted is deprecated. See http://momentjs.com/guides/#/warnings/dst-shifted/ for more information", nl);
    o = yr.prototype;
    o.calendar = go;
    o.longDateFormat = ns;
    o.invalidDate = ts;
    o.ordinal = is;
    o.preparse = he;
    o.postformat = he;
    o.relativeTime = rs;
    o.pastFuture = us;
    o.set = ko;
    o.months = vs;
    o.monthsShort = ys;
    o.monthsParse = ws;
    o.monthsRegex = ds;
    o.monthsShortRegex = ks;
    o.week = th;
    o.firstDayOfYear = rh;
    o.firstDayOfWeek = ih;
    o.weekdays = sh;
    o.weekdaysMin = ch;
    o.weekdaysShort = hh;
    o.weekdaysParse = ah;
    o.weekdaysRegex = wh;
    o.weekdaysShortRegex = bh;
    o.weekdaysMinRegex = kh;
    o.isPM = gh;
    o.meridiem = nc;
    fi("en", { ordinalParse: /\d{1,2}(th|st|nd|rd)/, ordinal: function(n) {
            var t = n % 10,
                i = 1 === f(n % 100 / 10) ? "th" : 1 === t ? "st" : 2 === t ? "nd" : 3 === t ? "rd" : "th";
            return n + i } });
    t.lang = d("moment.lang is deprecated. Use moment.locale instead.", fi);
    t.langData = d("moment.langData is deprecated. Use moment.localeData instead.", vt);
    var ht = Math.abs,
        up = pt("ms"),
        fp = pt("s"),
        ep = pt("m"),
        op = pt("h"),
        sp = pt("d"),
        hp = pt("w"),
        cp = pt("M"),
        lp = pt("y"),
        ap = ii("milliseconds"),
        vp = ii("seconds"),
        yp = ii("minutes"),
        pp = ii("hours"),
        wp = ii("days"),
        bp = ii("months"),
        kp = ii("years"),
        bt = Math.round,
        kt = { s: 45, m: 45, h: 22, d: 26, M: 11 },
        nf = Math.abs,
        e = nr.prototype;
    return e.abs = cv, e.add = lv, e.subtract = av, e.as = yv, e.asMilliseconds = up, e.asSeconds = fp, e.asMinutes = ep, e.asHours = op, e.asDays = sp, e.asWeeks = hp, e.asMonths = cp, e.asYears = lp, e.valueOf = pv, e._bubble = vv, e.get = wv, e.milliseconds = ap, e.seconds = vp, e.minutes = yp, e.hours = pp, e.days = wp, e.weeks = bv, e.months = bp, e.years = kp, e.humanize = ty, e.toISOString = rr, e.toString = rr, e.toJSON = rr, e.locale = ee, e.localeData = oe, e.toIsoString = d("toIsoString() is deprecated. Please use toISOString() instead (notice the capitals)", rr), e.lang = du, r("X", 0, 0, "unix"), r("x", 0, 0, "valueOf"), i("x", sr), i("X", /[+-]?\d+(\.\d{1,3})?/), s("X", function(n, t, i) { i._d = new Date(1e3 * parseFloat(n, 10)) }), s("x", function(n, t, i) { i._d = new Date(f(n)) }), t.version = "2.17.1", po(h), t.fn = n, t.min = ac, t.max = vc, t.now = rp, t.utc = rt, t.unix = rv, t.months = fv, t.isDate = wi, t.locale = fi, t.invalid = bi, t.duration = yt, t.isMoment = at, t.weekdays = ov, t.parseZone = uv, t.localeData = vt, t.isDuration = ru, t.monthsShort = ev, t.weekdaysMin = hv, t.defineLocale = gr, t.updateLocale = ic, t.locales = rc, t.weekdaysShort = sv, t.normalizeUnits = g, t.relativeTimeRounding = gv, t.relativeTimeThreshold = ny, t.calendarFormat = ul, t.prototype = n, t });
	$(document).ready(function() { 
		// iniTiles();
    iniControl();
    formatDateTime();
    loadImages();
    iniTableSort() 
  });
	$.urlParam = function(n) {
  	var t = new RegExp("[?&]" + n + "=([^&#]*)").exec(window.location.href);
  	return t == null ? null : t[1] || 0 
  }