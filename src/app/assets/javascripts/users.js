/*   
 *   * Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
 *   * See LICENSE in the project root for license information.  
 */

$(document).ready(function() {

    function loadImages() {
        $("img[realheader]").each(function (i, e) {
            var $e = $(e);
            $e.attr("src", $e.attr("realheader"));
        });
    }
  
    loadImages();

    $(".teacher-student .filterlink-container .filterlink").click(function() {
        tabname = $(this).attr("id");
        showDemoHelper(tabname);

        var element = $(this);
        element.addClass("selected").siblings("a").removeClass("selected");
        var filterType = element.data("type");
        var tilesContainer = $(".teacher-student .tiles-root-container");
        tilesContainer.removeClass(tilesContainer.attr("class").replace("tiles-root-container", "")).addClass(filterType + "-container")         
    });

    $(".teacher-student .tiles-root-container .pagination .prev, .teacher-student .tiles-root-container .pagination .next").on('click', function() {
        var element = $(this);
        if (element.hasClass("current") || element.hasClass("disabled")) {
            return;
        }

        var current_page = parseInt(element.siblings('#curpage').val());
        var type = element.closest(".tiles-secondary-container").attr('id');
        if(element.hasClass('prev')) {            
            $("#" + type + "_" + current_page).hide();
            $("#" + type + "_" + (current_page - 1)).show();
            element.siblings('#curpage').val(current_page - 1); 
            if(current_page - 1 <= 1){
                element.addClass('current');
            }
        }
        else {    
            var next_page = $('#' + type + '_' + (current_page + 1));
            var prev_obj = $(".teacher-student .tiles-root-container .pagination .prev");
            prev_obj.addClass("disabled");

            if(next_page.length){
                $('#' + type + '_' + current_page).hide(); 
                next_page.show();

                if(current_page + 1 > 1) {
                    element.siblings('.prev').removeClass('current');
                }
                else {
                    element.siblings('.prev').addClass('current');
                }
                element.siblings('#curpage').val(current_page + 1); 
                prev_obj.removeClass("disabled");
            }
            else {
                var skip_token = element.siblings('#skip_token').val();
                var school_object_id = $('#school-object-id').val();
                var school_id = $('#school-id').val();

                element.addClass('disabled');
                $.get({
                    url: '/schools/' + school_object_id + '/users_next',
                    data: {
                        school_id: school_id,
                        skip_token: skip_token,
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
                                html += '<div class="element teacher-bg"><div class="userimg"><img src="/Images/header-default.jpg" realheader="/users/'+ user['object_id'] +'/photo" /></div><div class="username">'+ user['display_name'] +'</div></div>';
                            }else{
                                html += '<div class="element student-bg"><div class="userimg"><img src="/Images/header-default.jpg" realheader="/users/'+ user['object_id'] +'/photo" /></div><div class="username">'+ user['display_name'] +'</div></div>';
                            }
                        });
                        html += '</div>';
                        element.closest(".tiles-secondary-container").prepend(html);
                        element.siblings('#skip_token').val(res['skip_token']);
                        element.removeClass('disabled');
                        $('#'+ type +'_' + current_page).hide();

                        if(current_page + 1 > 1){
                            element.siblings('.prev').removeClass('current');
                        }else{
                            element.siblings('.prev').addClass('current');
                        }

                        element.siblings('#curpage').val(current_page + 1); 
                        prev_obj.removeClass("disabled");
                    }
                })
            }
        }          
    })

    var tabname = '';
    if ($(".filterlink-container a.selected").length > 0) {
        tabname = $(".filterlink-container a.selected").attr("id");
    }
    showDemoHelper(tabname);
})