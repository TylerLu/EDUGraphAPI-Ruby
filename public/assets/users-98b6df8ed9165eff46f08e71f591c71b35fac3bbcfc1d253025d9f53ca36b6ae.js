$(document).ready(function(){function e(){$("img[realheader]").each(function(e,s){var t=$(s);t.attr("src",t.attr("realheader"))})}function s(e){var s,t,i;switch(e?(s="",$(".txtsearch").val("")):s=$(".txtsearch").val(),t=$(".filterlink-container .selected").text().trim().toLocaleLowerCase(),i="users",t){case"teachers":i="teachers";break;case"students":i="students";break;default:i="users"}s?$("#"+i+" .username").each(function(){$(this).text().search(new RegExp(s,"i"))<0?$(this).closest(".element").hide():$(this).closest(".element").show()}):$("#"+i+" .element").show()}e(),$(".teacher-student .filterlink-container .filterlink").click(function(){var e,t,i;s(!0),e=$(this),e.addClass("selected").siblings("a").removeClass("selected"),t=e.data("type"),i=$(".teacher-student .tiles-root-container"),i.removeClass(i.attr("class").replace("tiles-root-container","")).addClass(t+"-container")}),$(".teacher-student .tiles-root-container .pagination .prev, .teacher-student .tiles-root-container .pagination .next").on("click",function(){if(s(!0),_this=$(this),!_this.hasClass("current")&&!_this.hasClass("disabled")){var e=parseInt(_this.siblings("#curpage").val()),t=_this.closest(".tiles-secondary-container").attr("id");if(_this.hasClass("prev"))$("#"+t+"_"+e).hide(),$("#"+t+"_"+(e-1)).show(),_this.siblings("#curpage").val(e-1),e-1<=1&&_this.addClass("current");else{var i=$("#"+t+"_"+(e+1)),a=$(".teacher-student .tiles-root-container .pagination .prev");if(a.addClass("disabled"),i.length)$("#"+t+"_"+e).hide(),i.show(),e+1>1?_this.siblings(".prev").removeClass("current"):_this.siblings(".prev").addClass("current"),_this.siblings("#curpage").val(e+1),a.removeClass("disabled");else{var r=_this.siblings("#nextlink").val(),n=$("#school-objectid").val();_this.addClass("disabled"),$.post({url:"/schools/"+n+"/next_users",data:{school_number:n,next_link:r,type:t},success:function(s){if(s.expired)return alert("Your current session has expired. Please click OK to refresh the page."),void window.location.reload(!1);var i='<div class="content" id="'+t+"_"+(e+1)+'">';$.each(s.values,function(e,s){i+="Teacher"==s.object_type?'<div class="element teacher-bg"><div class="userimg"><img src="'+s.photo+'" realheader="'+s.photo+'" /></div><div class="username">'+s.displayName+"</div></div>":'<div class="element student-bg"><div class="userimg"><img src="'+s.photo+'" realheader="'+s.photo+'" /></div><div class="username">'+s.displayName+"</div></div>"}),i+="</div>",_this.closest(".tiles-secondary-container").prepend(i),_this.siblings("#nextlink").val(s.skip_token),_this.removeClass("disabled"),$("#"+t+"_"+e).hide(),e+1>1?_this.siblings(".prev").removeClass("current"):_this.siblings(".prev").addClass("current"),_this.siblings("#curpage").val(e+1),a.removeClass("disabled")}})}}}}),$("#btnsearch").click(function(){s()}),$(".txtsearch").on("keypress",function(e){13===e.which&&s()})});