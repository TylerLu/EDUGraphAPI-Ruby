$(document).ready(function(){$("#userinfolink").click(function(o){o.stopPropagation?o.stopPropagation():o.cancelBubble=!0,$("#userinfoContainer").toggle(),$("#caret").toggleClass("transformcaret")}),$(document).click(function(){$("#userinfoContainer").hide(),$("#caret").removeClass("transformcaret")}),$(".demo-helper-control .header").on("click",function(){console.log(12321),console.log($(this).closest(".demo-helper-control").html()),$(this).closest(".demo-helper-control").toggleClass("collapsed")}),$(".message-container").fadeOut(5e3)});