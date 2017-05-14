/*   
 *   * Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
 *   * See LICENSE in the project root for license information.  
 */
$(document).ready(function () {
    function bindShowDetail(tiles) {
        tiles.hover(function inFn(e) {
            $(this).children().last().show();
        }, function outFn(e) {
            $(this).children().last().hide();
        }).find(".detail #termdate").each(function (i, e) {
            var $e = $(e);
            var dateStr = $e.text();
            if (dateStr) {
                $e.text(moment.utc(dateStr).local().format('MMMM D YYYY'));
            }
        });
    };

    function hasSection(section, sections) {
        if (!(sections instanceof Array)) {
            return false;
        }
        var result = false;
        $.each(sections, function (i, s) {
            if (section.Email == s.Email) {
                return result = true;
            }
        });
        return result;
    }

    bindShowDetail($(".section-tiles .tile-container"));

    $(".sections .filterlink-container .filterlink").click(function () {
        var element = $(this);
        element.addClass("selected").siblings("a").removeClass("selected");
        var filterType = element.data("type");
        var tilesContainer = $(".sections .tiles-root-container");
        tilesContainer.removeClass(tilesContainer.attr("class").replace("tiles-root-container", "")).addClass(filterType + "-container");
    });

    // $("#see-more  span").click(function () {
    //     search(true);
    //     var element = $(this);
    //     if (element.hasClass("disabled") || element.hasClass("nomore")) {
    //         return;
    //     }

    //     var schoolId = element.siblings("input#schoolid").val();
    //     var url = "/Schools/" + schoolId + "/Classes/Next";
    //     var nextLinkElement = element.siblings("input#nextlink");

    //     element.addClass("disabled");
    //     $.ajax({
    //         type: 'GET',
    //         url: url,
    //         dataType: 'json',
    //         data: { schoolId: schoolId, nextLink: nextLinkElement.val() },
    //         contentType: "application/json; charset=utf-8",
    //         success: function (data) {
    //             if (data.error === "AdalException" || data.error === "Unauthorized") {
    //                 alert("Your current session has expired. Please click OK to refresh the page.");
    //                 window.location.reload(false);
    //                 return;
    //             }

    //             var tiles = element.parent().prev(".content");
    //             var newTiles = $();
    //             $.each(data.Sections.Value, function (i, s) {
    //                 var isMine = hasSection(s, data.MySections);
    //                 var newTile = $('<div class="tile-container"></div>');
    //                 var tileContainer = newTile;
    //                 if (isMine) {
    //                     tileContainer = $('<a class="mysectionlink" href="/Schools/' + schoolId + '/Classes/' + s.ObjectId + '"></a>').appendTo(newTile);
    //                 }
    //                 var tile = $('<div class="tile"><h5>' + s.DisplayName + '</h5><h2>' + s.CombinedCourseNumber + '</h2></div>');
    //                 tile.appendTo(tileContainer);
    //                 var tileDetail = $('<div class="detail" style="display: none;">' +
    //                                         '<h5>Course Id:</h5>' +
    //                                         '<h6>' + s.CourseId + '</h6>' +
    //                                         '<h5>Description:</h5>' +
    //                                         '<h6>' + s.CourseDescription + '</h6>' +
    //                                         '<h5>Teachers:</h5>' +
    //                                         ((s.Members instanceof Array) ?
    //                                         s.Members.reduce(function (accu, cur) {
    //                                             if (cur.ObjectType == 'Teacher') {
    //                                                 accu += '<h6>' + cur.DisplayName + '</h6>';
    //                                             }
    //                                             return accu;
    //                                         }, '') : '') +

    //                                         '<h5>Term Name:</h5>' +
    //                                         '<h6>' + s.TermName + '</h6>' +
    //                                         '<h5>Start/Finish Date:</h5>' +
    //                                         ((s.TermStartDate || s.TermEndDate) ?
    //                                         ('<h6><span id="termdate">' + s.TermStartDate + '</span>' +
    //                                         '<span> - </span>' +
    //                                         '<span id="termdate">' + s.TermEndDate + '</span>' +
    //                                         '</h6>') : '') +
    //                                         '<h5>Period:</h5>' +
    //                                         '<h6>' + s.Period + '</h6>' +
    //                                     '</div>');
    //                 tileDetail.appendTo(newTile);
    //                 newTiles = newTiles.add(newTile);
    //             });
    //             newTiles.appendTo(tiles).hide().fadeIn("slow");
    //             bindShowDetail(newTiles);

    //             var newNextLink = data.Sections.NextLink;
    //             nextLinkElement.val(newNextLink);
    //             if (typeof (newNextLink) != "string" || newNextLink.length == 0) {
    //                 element.addClass("nomore");
    //             }
    //             $(window).scrollTop($(document).height() - $(window).height())
    //         },
    //         complete: function () {
    //             element.removeClass("disabled");
    //         }
    //     });
    // });
    // 
    
    // $("#see-more").click(function () {
    //     search(true);
    //     var start_index = parseInt($(this).data('index'));
    //     var all_count = parseInt($(this).data('count'));

    //     for(var i = start_index; i < start_index + 12; i++){
    //         if(i >= all_count){   
    //             $(this).unbind('click');
    //             $(this).find('span').html('END');
    //             return;
    //         }
    //         $("#course_" + i).removeClass('hidden_course');
    //     }
    //     $(this).data('index', start_index + 12);
    // });
    // 
    $("#see-more").click(function () {
        var element = $(this);
        var skip_token = element.data('skip-token');
        var school_number = element.data('school-number');
        var school_id = element.data('school-id');
        var school_object_id = element.data('school-object-id');
        var url_params = element.data('url-params');

        element.find('span').addClass('disabled');

        if(skip_token != ''){
            $.ajax({
                type: 'POST',
                url: '/schools/' + school_object_id + '/next_classes',
                dataType: 'json',
                data: { skip_token: skip_token, school_id: school_id },
                success: function(res){
                    var html = '';
                    $.each(res['values'], function(index, value){
                        html += '<div class="tile-container">';
                        if(value['is_my_course'] == true){
                            html += '<a class="mysectionlink" href="/schools/'+ school_object_id +'/classes/'+ value['object_id'] +'">' + 
                            '<div class="tile"><h5>' +value['display_name']+ '</h5><h2>' + value['combined_course_number'] + '</h2></div></a>';
                        }else{
                            html += '<div class="tile"><h5>' +value['display_name']+ '</h5><h2>' + value['combined_course_number'] + '</h2></div>';
                        }
                        html += '<div class="detail"><h5>Course Id:</h5><h6>' +value['course_id']+ '</h6><h5>Description:</h5><h6>'+ value['course_description'] +'</h6>' + 
                            '<h5>Teachers:</h5><h5>Term Name:</h5><h6>' + value['teacher_name'] + '</h6><h5>Start/Finish Date:</h5><h6><span id="termdate">'+ value['term_start_time'] +'</span><span> - </span>' + 
                            '<span id="termdate">'+value['term_end_time']+'</span></h6><h5>Period:</h5><h6>' + value['period'] + '</h6></div>';
                        html += '</div>';
                    })
                    _ = $(html);
                    _.appendTo($('#class_content')).hide().fadeIn("slow");
                    bindShowDetail(_);
                    // $("#class_content").append(html);
                    // bindShowDetail($("#class_content"));
                    element.data('skip-token', res['skip_token']);
                    element.find('span').removeClass('disabled');
                }
            })
        }
    });

    $("#my-see-more").click(function(){
        var start_index = parseInt($(this).data('index'));
        var all_count = parseInt($(this).data('count'));

        for(var i = start_index; i < start_index + 12; i++){
            if(i >= all_count){   
                $(this).unbind('click');
                $(this).find('span').html('END');
                return;
            }
            $("#my_course_" + i).removeClass('hidden_course');
        }
        $(this).data('index', start_index + 12); 
    })
});