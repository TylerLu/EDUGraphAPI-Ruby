$(document).ready(function(){function e(e){e.hover(function(){$(this).children().last().show()},function(){$(this).children().last().hide()}).find(".detail #termdate").each(function(e,s){var t=$(s),a=t.text();a&&t.text(moment.utc(a).local().format("MMMM D YYYY"))})}function s(e){var s;e?(s="",$(".txtsearch").val("")):s=$(".txtsearch").val(),s?$(".tile-container h2").each(function(){$(this).text().search(new RegExp(s,"i"))<0?$(this).closest(".tile-container").hide():$(this).closest(".tile-container").show()}):$(".tile-container").show()}e($(".section-tiles .tile-container")),$(".sections .filterlink-container .filterlink").click(function(){s(!0);var e=$(this);e.addClass("selected").siblings("a").removeClass("selected");var t=e.data("type"),a=$(".sections .tiles-root-container");a.removeClass(a.attr("class").replace("tiles-root-container","")).addClass(t+"-container")}),$("#see-more").click(function(){s(!0);var e=$(this),t=e.data("token"),a=e.data("school-number"),i=e.data("school-id"),n=e.data("url-params");e.find("span").addClass("disabled"),""!=t&&$.ajax({type:"POST",url:"/schools/"+i+"/next_class",dataType:"json",data:{school_number:a,skip_token:t,school_id:i,url_params:n},success:function(s){var t="";$.each(s.values,function(e,a){t+='<div class="tile-container">',t+=1==a.is_my_course?'<a class="mysectionlink" href="/schools/'+s.school_id+"/classes/"+a.class_id+"?"+s.url_params+'"><div class="tile"><h5>'+a.displayName+"</h5><h2>"+a.course_subject+a.course_number+"</h2></div></a>":'<div class="tile"><h5>'+a.displayName+"</h5><h2>"+a.course_subject+a.course_number+"</h2></div>",t+='<div class="detail"><h5>Course Id:</h5><h6>'+a.course_id+"</h6><h5>Description:</h5><h6>"+a.course_desc+"</h6><h5>Teachers:</h5><h5>Term Name:</h5><h6>"+a.teacher_name+'</h6><h5>Start/Finish Date:</h5><h6><span id="termdate">'+a.start_time+'</span><span> ~ </span><span id="termdate">'+a.end_time+"</span></h6><h5>Period:</h5><h6>"+a.period+"</h6></div>",t+="</div>"}),$("#class_content").append(t),e.data("token",s.skip_token),e.find("span").removeClass("disabled")}})}),$("#my-see-more").click(function(){s(!0);for(var e=parseInt($(this).data("index")),t=parseInt($(this).data("count")),a=e;a<e+12;a++){if(a>=t)return $(this).unbind("click"),void $(this).find("span").html("END");$("#my_course_"+a).removeClass("hidden_course")}$(this).data("index",e+12)}),$("#btnsearch").click(function(){s()}),$(".txtsearch").on("keypress",function(e){13===e.which&&s()})});