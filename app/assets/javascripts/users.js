$(document).ready(function() {
    function i() { $("img[realheader]").each(function(n, t) {
            var i = $(t);
            i.attr("src", i.attr("realheader")) }) }

    function t(n, t, i, r, u, f, e) {
        var o = (t - 1) * 12,
            s = t * 12,
            h = e.children();
        h.slice(o, s).fadeIn("slow", function() {
            var n = $(this).find("img[realheader]");
            n.attr("src", n.attr("realheader")) });
        u.toggleClass("current", !n && s >= h.length && !i);
        r.toggleClass("current", o === 0);
        f.val(t) }

    function n(n) {
        var i, r, t;
        n ? (i = "", $(".txtsearch").val("")) : i = $(".txtsearch").val();
        r = $(".filterlink-container .selected").text().trim().toLocaleLowerCase();
        t = "users";
        switch (r) {
            case "teachers":
                t = "teachers";
                break;
            case "students":
                t = "students";
                break;
            default:
                t = "users" }
        i ? $("#" + t + " .username").each(function() { $(this).text().search(new RegExp(i, "i")) < 0 ? $(this).closest(".element").hide() : $(this).closest(".element").show() }) : $("#" + t + " .element").show() }
    i();
    $(".teacher-student .filterlink-container .filterlink").click(function() {
        var t, r, i;
        n(!0);
        t = $(this);
        t.addClass("selected").siblings("a").removeClass("selected");
        r = t.data("type");
        i = $(".teacher-student .tiles-root-container");
        i.removeClass(i.attr("class").replace("tiles-root-container", "")).addClass(r + "-container") });
    $(".teacher-student .tiles-root-container .pagination .prev, .teacher-student .tiles-root-container .pagination .next").on('click', function() {
        var i, a, r, w, v;
        if (n(!0), _this = $(this), !_this.hasClass("current") && !_this.hasClass("disabled")) {
        	// 判断点击的是向前还是向后
        	var current_page = parseInt(_this.siblings('#curpage').val());
        	var type = _this.closest(".tiles-secondary-container").attr('id');
        	if(_this.hasClass('prev')){
        		//向前
        		$("#" + type + "_" + current_page).hide();

        		$("#" + type + "_" + (current_page - 1)).show();

        		_this.siblings('#curpage').val(current_page - 1); //更改current page 的值

        		if(current_page - 1 <= 1){
        			_this.addClass('current');
        		}
        	}else{
        		//向后， 先判断是否存在， 如果存在则show， 不存在 则请求
        		var next_page = $('#' + type + '_' + (current_page + 1));
                var prev_obj = $(".teacher-student .tiles-root-container .pagination .prev");
                prev_obj.addClass("disabled");

        		if(next_page.length){
					$('#' + type + '_' + current_page).hide(); //隐藏之前的
        			next_page.show();

                    if(current_page + 1 > 1){
                        _this.siblings('.prev').removeClass('current');
                    }else{
                        _this.siblings('.prev').addClass('current');
                    }

                    _this.siblings('#curpage').val(current_page + 1); //更改current page 的值
                    prev_obj.removeClass("disabled");
        		}else{
        			var next_link = _this.siblings('#nextlink').val();
	        		var school_number = $('#school-objectid').val();

	        		_this.addClass('disabled');
	        		$.post({
	        			url: '/schools/' + school_number + '/next_users',
	        			data: {
	        				school_number: school_number,
	        				next_link: next_link,
	        				type: type,
	        			},
	        			success: function(res){
	        				if(res['expired']){
	        					alert("Your current session has expired. Please click OK to refresh the page.");
	        					window.location.reload(!1);
	        					return;
	        				}
	        				var html = '<div class="content" id="' +type+ '_'+ (current_page + 1)+'">';
	        				$.each(res['values'], function(index, user){
	        					if(user['object_type'] == 'Teacher'){
	        						html += '<div class="element teacher-bg"><div class="userimg"><img src="'+ user['photo'] +'" realheader="'+ user['photo'] +'" /></div><div class="username">'+ user['displayName'] +'</div></div>';
	        					}else{
	        						html += '<div class="element student-bg"><div class="userimg"><img src="'+ user['photo'] +'" realheader="'+ user['photo'] +'" /></div><div class="username">'+ user['displayName'] +'</div></div>';
	        					}
	        				});
	        				html += '</div>';
	        				_this.closest(".tiles-secondary-container").prepend(html);
	        				_this.siblings('#nextlink').val(res['skip_token']);
	        				_this.removeClass('disabled');
                            $('#'+ type +'_' + current_page).hide(); //隐藏之前的页面

                            if(current_page + 1 > 1){
                                _this.siblings('.prev').removeClass('current');
                            }else{
                                _this.siblings('.prev').addClass('current');
                            }

                            _this.siblings('#curpage').val(current_page + 1); //更改current page 的值
                            prev_obj.removeClass("disabled");
	        			}
	        		})
        		}

        		// if(current_page + 1 > 1){
        		// 	_this.siblings('.prev').removeClass('current');
        		// }else{
        		// 	_this.siblings('.prev').addClass('current');
        		// }

        		// _this.siblings('#curpage').val(current_page + 1); //更改current page 的值
        	}

            // var h = i.siblings("#curpage"),
            //     b = parseInt(h.val()),
            //     u = i.hasClass("prev"),
            //     c = b + (u ? -1 : 1),
            //     e = u ? i.siblings(".next") : i,
            //     o = u ? i : i.siblings(".prev"),
            //     y = i.siblings("#nextlink"),
            //     l = y.val(),
            //     s = typeof l == "string" && l.length > 0;
            // u && (e = i.siblings(".next"), o = i);
            // var p = i.closest(".tiles-secondary-container"),
            //     f = p.find(".content"),
            //     k = (c - 1) * 12;
                
            // k < f.children().length ? t(u, c, s, o, e, h, f) : s && (a = $(".teacher-student input#school-objectid").val(), r = p.attr("id"), r = r[0].toUpperCase() + r.substr(1), w = "/schools/" + a + "/next_users", v = o.add(e), v.addClass("disabled"), $.ajax({ type: "POST", url: w, dataType: "json", data: { schoolId: a, nextLink: l }, success: function(n) {
            //   var l, i, u;
            //   if (n.error === "AdalException" || n.error === "Unauthorized") {
            //    	alert("Your current session has expired. Please click OK to refresh the page.");
            //     window.location.reload(!1);
            //     return
            //   }(l = n[r], i = l.Value, i instanceof Array && i.length != 0) && (f.html(""), $.each(i, function(n, t) {
            //       var i = '<div class="element ' + (t.ObjectType == "Teacher" ? "teacher-bg" : "student-bg") + '"><div class="userimg"><img src="/Images/header-default.jpg" realheader="/Photo/UserPhoto/' + t.O365UserId + '" /><\/div><div class="username">' + t.DisplayName + "<\/div><\/div>";
            //       $(i).appendTo(f) }), u = l.NextLink, y.val(u), s = typeof u == "string" && u.length > 0, t(!1, c, s, o, e, h, f)) }, complete: function() { v.removeClass("disabled") } })) 
          } 
      });
    $("#btnsearch").click(function() { n() });
    $(".txtsearch").on("keypress", function(t) { t.which === 13 && n() })
})