(function (global) {
    'use strict';

    var token;
    var sid;

    var validateSession = function () {

        // read the cookies into variables for easy access
        token = Cookies.get("project_token");
        sid = Cookies.get("project_sid");

        // use ajax to connect to the login api and make sure the session is valid
        $.ajax({
            url: API_BASE_URL + "/login",
            type: 'GET',
            data: {
                'i': sid,
                's': token
            },
            success: function (data) {

                // session is valid, use the output to show the navigation elements
                var json = JSON.parse(data);
                if (json.hasOwnProperty("uid") && json['uid'] <= 0) {
                    // user is not in a university, so hide everything that
                    // requires a student to be in a university
                    $('#show_events_nav').addClass("hidden");
                    $("#show_organizations_nav").addClass("hidden");
                } else {
                    $('#show_events_nav').removeClass("hidden");
                    $("#show_organizations_nav").removeClass("hidden");
                }

            },
            error: function (response) {
                // session is not valid ... purge everything and then load the login screen.
                logout();
            }
        });

        return false;
    };

    var create_rso_submit_button = function () {
        var create_rso_form = $('#create_rso_form');
        var submit_rso_button = $('#create_rso_button');
        submit_rso_button.click(function () {
            $.ajax({
                url: API_BASE_URL + '/rsos',
                type: 'GET',
                data: {
                    'i': sid,
                    's': token,
                    'n': create_rso_form.find("#create_rso_name").val(),
                    'd': create_rso_form.find("#create_rso_desc").val(),
                    'a': 'create'
                },
                success: function (data) {
                    console.log("nigga we made it");
                }
            })
        });
    };

    var submit_new_university = function () {
        var create_rso_form = $('#create_university_form');
        var submit = $('#create_university_submit');
        submit.click(function () {
            console.log("Test: " + create_rso_form.find('#input_university_name').val());
            $.ajax({
                url: API_BASE_URL + '/university',
                type: 'GET',
                data: {
                    'i': sid,
                    's': token,
                    'a': 'create',
                    'name': create_rso_form.find('#input_university_name').val(),
                    'desc': create_rso_form.find("#input_university_desc").val(),
                    'domain': create_rso_form.find("#input_university_domain").val(),
                    'image': create_rso_form.find("#input_university_image").val(),
                    'motto': create_rso_form.find("#input_university_motto").val(),
                    'latitude': create_rso_form.find("#input-lat").val(),
                    'longitude': create_rso_form.find("#input-long").val()
                },
                success: function (data) {
                    console.log(this.url);
                    console.log(data);
                }
            })
        });
    };

    var initDashboard = function () {
        // use ajax to connect to the login api and make sure the session is valid
        $.ajax({
            url: API_BASE_URL + "/dashboard",
            type: 'GET',
            data: {
                'i': sid,
                's': token
            },
            success: function (data) {
                var json = JSON.parse(data);
                console.log(json);

                for (var key in json) {
                    if (json.hasOwnProperty(key)) {

                        // get the block
                            var block = $('#' + key + "_block");
                        if (json[key] <= 0) block.addClass("hidden");
                            else block.removeClass("hidden");
                            // get the text
                            var text = $('#' + key);
                            text.text(json[key]);
                        }

                }

            },
            error: function (response) {
                // session is not valid ... purge everything and then load the login screen.
                logout();
            }
        });
    };

    var rso_success = function (data) {
        var json = JSON.parse(data);
        for (var type in json) {
            if (json.hasOwnProperty(type)) {
                var arr = json[type];
                var block = $('#' + type + '_panel');
                if (arr.length <= 0) block.addClass("hidden");
                else block.removeClass("hidden");
                for (var i = 0; i < arr.length; i++) {
                    var o = arr[i];
                    var row = $('<tr></tr>').attr("id", type + "_row_" + o["rid"]);
                    for (var key in o) {
                        if (o.hasOwnProperty(key)) {
                            var element = $('<td></td>').attr("id", "td_" + i + "_" + key).text(o[key]);
                            if (type === 'owned_rsos') {
                                if (key === 'approved') {
                                    if (o[key] === 0) {
                                        element.text('').append('<span class=\"label label-warning\">Unapproved</span>');
                                    } else if (o[key] === 1) {
                                        element.text('').append('<span class=\"label label-success\">Approved</span>');
                                    }
                                }
                            } else if (type === 'membership_rsos') {
                                if (key === 'approved') {
                                    element.text('');
                                    if (o[key] === 0) {
                                        row.addClass("warning")
                                    }
                                }
                            }
                            row.append(element);
                        }
                    }
                    if (type === 'unapproved_rsos') {
                        // create the button

                        row.append('<td><button class="btn btn-success btn-rounded btn-condensed btn-sm ' + (o['members'] < 5 ? 'disabled"' : '" onclick="Project.approve_row(\'' + type + '_row_' + o["rid"] + '\');"') + '><span class="fa fa-check"></span></button></td>');
                        if (o['members'] >= 5) row.addClass("success");
                    }
                    if (type === 'can_join') {
                        // create the button

                        row.append('<td><button class="btn btn-success btn-rounded btn-condensed btn-sm " onclick="Project.join_row(\'' + type + '_row_' + o["rid"] + '\');"><span class="fa fa-thumbs-up"></span></button></td>');
                        // if (o['members'] >= 5) row.addClass("success");
                    }
                    var tbody = $('#' + type + '_tbody').append(row);
                }


                var table = $('#' + type + '_table');
                table.addClass('datatable');
                table.DataTable();
            }
        }
    };

    var approve_row = function (row) {
        var box = $("#mb-approve-row");
        box.addClass("open");
        box.find(".mb-control-yes").on("click", function () {
            box.removeClass("open");
            $('#' + row).hide("medium", function () {
                $(this).remove();
                $.ajax({
                    url: API_BASE_URL + "/rsos",
                    type: 'GET',
                    data: {
                        'i': sid,
                        's': token,
                        'a': 'approve',
                        'n': row.split("_").pop()
                    },
                    success: location.reload(),
                    error: function (data) {

                    }
                });
            });
        });
    };

    var join_row = function (row) {
        var box = $("#mb-approve-row");
        box.addClass("open");
        box.find(".mb-control-yes").on("click", function () {
            box.removeClass("open");
            $('#' + row).hide("medium", function () {
                $(this).remove();
                $.ajax({
                    url: API_BASE_URL + "/rsos",
                    type: 'GET',
                    data: {
                        'i': sid,
                        's': token,
                        'a': 'join',
                        'n': row.split("_").pop()
                    },
                    success: location.reload(),
                    error: function (data) {

                    }
                });
            });
        });
    };

    var submitEvent = function() {

        var name = $('#input_event_name').val();
        var about = $('#input_event_desc').val();
        var scope = $('#input_event_scope').val();
        var tags = $('#input_event_tags').val();
        var location = $('#location-input').val();
        var latitude = $('#input_event_latitude').val();
        var longitude = $('#input_event_longitude').val();
        var date = $('#input_event_date').val();
        var start_time = $('#input_event_start_time').val();
        var end_time = $('#input_event_end_time').val();
        var contact_name = $("#input_event_contact").val();
        var contact_phone = $('#input_event_phone').val();
        var contact_email = $('#input_event_email').val();

        $.ajax({
            url: API_BASE_URL + "/events",
            type: 'GET',
            data: {
                'i': sid,
                's': token,
                'a': 'create',
                'name': name,
                'about': about,
                'scope': scope,
                'tags': tags,
                'location': location,
                'latitude': latitude,
                'longitude': longitude,
                'date': date,
                'starttime': start_time,
                'endtime': end_time,
                'cname': contact_name,
                'cphone': contact_phone,
                'cemail': contact_email
            },
            success: function(data) {
                // result should be a json object
                var json = JSON.parse(data);

                if (json.hasOwnProperty("events")) {

                    var eventsArray = json['events'];

                    eventsArray.forEach(function(obj) {

                        console.log(obj);

                        for (var key in obj) {
                            if (obj.hasOwnProperty(key))
                                console.log(key + "=" + obj[key]);
                        }

                    });

                    for (var i = 0; i < eventsArray.length; i++) {

                        var event = eventsArray[i];
                        console.log("event: " + event);

                    }

                }

            }
        });

    };

    var initRSOTables = function () {
        // use ajax to connect to the login api and make sure the session is valid
        $.ajax({
            url: API_BASE_URL + "/rsos",
            type: 'GET',
            data: {
                'i': sid,
                's': token
            },
            success: rso_success,
            error: function (response) {
                // session is not valid ... purge everything and then load the login screen.
                logout();
            }
        });
    };

    // Start Smart Wizard
    var uiSmartWizard = function () {

        if ($(".wizard").length > 0) {

            //Check count of steps in each wizard
            $(".wizard > ul").each(function () {
                $(this).addClass("steps_" + $(this).children("li").length);
            });//end

            $(".wizard").smartWizard({
                // This part of code can be removed FROM
                onLeaveStep: function (obj) {
                    // things to do when leaving
                    return true;
                },// <-- TO

                //This is important part of wizard init
                onShowStep: function (obj) {
                    var wizard = obj.parents(".wizard");

                    if (wizard.hasClass("show-submit")) {

                        var step_num = obj.attr('rel');
                        var step_max = obj.parents(".anchor").find("li").length;

                        if (step_num == step_max) {
                            obj.parents(".wizard").find(".actionBar .btn-primary").css("display", "block");
                        }
                    }

                    $('#event-location-map').locationpicker("refresh");

                    return true;
                }//End
            });
        }

    };// End Smart Wizard

    var initEventSuccess = function(data) {
        // result should be a json object
        var json = JSON.parse(data);

        if (json.hasOwnProperty("events")) {

            $('#timeline').empty();

            $('#create_event_panel').addClass("panel-toggled");
            $('#create_event_arrow').removeClass("fa-angle-down").addClass("fa-angle-up");

            var eventsArray = json['events'];

            eventsArray.forEach(function(obj) {

                var timeline_item_info = $('<div></div>').addClass("timeline-item-info");
                var icon_span = $('<span></span>').addClass("fa");
                var timeline_item_icon = $('<div class="timeline-item-icon"></div>').append(icon_span);
                var timeline_heading = $('<div></div>').addClass("timeline-heading").addClass("panel-heading");
                var timeline_item_content = $('<div></div>').addClass("timeline-item-content").append(timeline_heading);
                var timeline_body = $('<div></div>').addClass("panel-body").addClass("timeline-body");
                var timeline_tags = $('<ul class="list-tags"></ul>');
                var timeline_comments = $('<div></div>').addClass("timeline-body").addClass("comments");
                var right = $('<div></div>').addClass("pull-right");
                var timeline_footer = $("<div></div>").addClass("timeline-footer");
                timeline_footer.append(right);


                if (obj.hasOwnProperty("likes") && obj.hasOwnProperty("eid")) {
                    right.append($('<a></a>').attr("href", "javascript:void(0);").attr("onclick", "Project.like(" + obj['eid'] + ");").append($('<span></span>').addClass("fa fa-heart").text(' ' + obj['likes'])));
                }


                for (var key in obj) {

                    if (obj.hasOwnProperty(key)) {

                        if (key === 'scope') {
                            var scope = obj[key];
                            if (scope === 0) {
                                icon_span.addClass("fa-globe");
                            } else if (scope == 1) {
                                icon_span.addClass("fa-building");
                            } else if (scope == 2) {
                                icon_span.addClass("fa-users")
                            }
                        } else if (key === 'date') {
                            timeline_item_info.text(obj[key]);
                        } else if (key === 'contactname') {

                            timeline_heading.append($('<a href="#">' + obj[key] + '</a>'));
                            if (obj.hasOwnProperty("name")) {
                                timeline_heading.append(" created ");
                                timeline_heading.append($('<a href="#">' + obj['name'] + '</a>'));
                                if (obj.hasOwnProperty("location")) {
                                    timeline_heading.append(" at ");
                                    timeline_heading.append($('<a href="#">' + obj['location'] + '</a>'));
                                }
                            }
                            timeline_item_content.attr("id", "ic_" + obj['eid']);
                            timeline_heading.append($('<button onclick="Project.toggleHeading(' + obj['eid'] + ');"  class="btn btn-sm btn-default btn-condensed pull-right"><span class="fa fa-angle-down"></span></button>'));
                        } else if (key === 'desc') {
                            if (obj.hasOwnProperty('latitude') && obj.hasOwnProperty('longitude'))
                                timeline_body.append($('<img src="https://maps.googleapis.com/maps/api/staticmap?zoom=15&size=150x150&maptype=roadmap&markers=color:red%7Clabel:%7C' + obj['latitude'] + ',' + obj['longitude'] + '&key=AIzaSyB2BcpCrLMpbJ4Crc-Z9yIlrU2qX9F2W7A" class="img-text" width="150" align="left"/>'));
                            timeline_body.append($("<p>" + obj['desc'] + "</p>"));
                            if (obj.hasOwnProperty('contactphone')) {
                                timeline_body.append($('<span></span>').addClass("fa").addClass("fa-phone").text(" " + obj['contactphone']));
                                timeline_body.append($('<br/>'))
                            }
                            if (obj.hasOwnProperty('contactemail')) {
                                var email = $('<a></a>').attr("href", "mailto:" + obj['contactemail']).text(" " + obj['contactemail']);
                                timeline_body.append($('<span></span>').addClass("fa").addClass("fa-envelope").append(email));
                                timeline_body.append($('<br/>'))
                            }
                        } else if (key === 'tags') {
                            var tags = obj[key].split(",");
                            for (var i = 0; i < tags.length; i++) {
                                var t = $('<li><a href="#"><span class="fa fa-tag"></span>' + tags[i] + '</a></li>');
                                timeline_tags.append(t);
                            }
                        } else if (key === 'messages') {

                            var messages = obj[key];

                            right.append($('<a></a>').attr("href", "#").append($('<span></span>').addClass("fa fa-comments").text(' ' + messages.length)));

                            messages.forEach(function (obj) {

                                if (obj.hasOwnProperty("username") && obj.hasOwnProperty("message") && obj.hasOwnProperty("time")) {

                                    var comment_item = $('<div></div>').addClass("comment-item");
                                    var comment_head = $('<p></p>').addClass("comment-head");
                                    comment_head.append($('<a></a>').attr("href", "#").text(obj['username']));
                                    comment_item.append(comment_head);
                                    comment_item.append($('<p></p>').text(obj['message']));
                                    comment_item.append($('<small></small>').addClass("text-muted").text(obj['time']));
                                    timeline_comments.append(comment_item);
                                }

                            });

                        } else {
                        }

                    }
                }

                timeline_comments.append($('<div class="comment-write input-group"><input type="text" id=\"' + obj['eid'] + '_message_input'
                    + '\" class="form-control" placeholder="What you thinkin\' homie?" rows="1"><div class="input-group-btn"><button onclick="Project.sendMessage(' + obj['eid'] + ');" class="btn btn-default">Send</button></div></div>'));

                var timeline_item = $("<div></div>").addClass('timeline-item timeline-item-right');
                timeline_item.append(timeline_item_info);
                timeline_item.append(timeline_item_icon);
                timeline_body.append("<br/><br/>");
                timeline_body.append(timeline_tags);
                timeline_body.append(timeline_comments);
                timeline_item_content.append(timeline_body);
                right.append($('<a></a>').attr("href", "#").append($('<span></span>').addClass("fa fa-share")));
                timeline_item_content.append(timeline_footer);
                timeline_item.append(timeline_item_content);


                // <div class="timeline-footer">
                //     <div class="pull-right">
                //     <a href="#"><span class="fa fa-user"></span> 84</a>
                //     <a href="#"><span class="fa fa-comment"></span> 35</a>
                //     <a href="#"><span class="fa fa-share"></span></a>
                //     </div>
                //     </div>

                console.log(timeline_item);

                $('#timeline').append(timeline_item);

            });

        }
        var scopeSelect = $('#input_event_scope');
        scopeSelect.empty();

        scopeSelect.append("<Option>Public</Option>");
        scopeSelect.append("<Option>Private (University Only)</Option>");

        if (json.hasOwnProperty("organizations")) {

            // get the json array
            var orgArr = json['organizations'];

            // iterate the json array and add options
            orgArr.forEach(function(obj) {

                if (obj.hasOwnProperty("rid") && obj.hasOwnProperty("orgName")) {
                    var rid = obj['rid'];
                    var rName = obj['orgName'];
                    scopeSelect.append($('<Option>' + rid + ':' + rName + '</Option>'));
                }

            });

        }


        scopeSelect.selectpicker("refresh");

    };


    var sendMessage = function (eid) {

        var message_input = $("#" + eid + "_message_input");

        if (message_input !== 'undefined' && message_input.val() !== 'undefined') {
            var message = message_input.val();
            console.log(message);
            $.ajax({
                url: API_BASE_URL + "/events",
                type: 'GET',
                data: {
                    'i': sid,
                    's': token,
                    'a': 'post',
                    'e': eid,
                    'm': message
                },
                success: function(data) {
                    message_input.val("");
                    initEventSuccess(data);
                }
            });
        }

    };


    var like = function (eid) {

        console.log("like: " + eid);
        $.ajax({
            url: API_BASE_URL + "/events",
            type: 'GET',
            data: {
                'i': sid,
                's': token,
                'a': 'like',
                'e': eid,
            },
            success: function(data) {
                initEventSuccess(data);
            }
        });

    };



    var toggleHeading = function (eid) {

        console.log(eid);

        var panel = $("#ic_" + eid);
        if (panel !== 'undefined') {

            if (panel.attr("class").indexOf("panel-toggled") > -1) {
                panel.removeClass("panel-toggled");
            } else {
                panel.addClass("panel-toggled");
            }

        }


    };


    var initEvents = function () {

        $.ajax({
            url: API_BASE_URL + "/events",
            type: 'GET',
            data: {
                'i': sid,
                's': token
            },
            success: initEventSuccess

        });

        $('#event-location-map').locationpicker({
            location: {latitude: 28.6005706, longitude: -81.19767969999998},
            zoom: 15,
            enableAutocomplete: true,
            enableReverseGeocode: true,
            radius: 0,
            inputBinding: {
                latitudeInput: $('#input_event_latitude'),
                longitudeInput: $('#input_event_longitude'),
                locationNameInput: $('#location-input')
            }
        });
    };

    var initUniversity = function () {
        // use ajax to connect to the login api and make sure the session is valid
        $.ajax({
            url: API_BASE_URL + "/university",
            type: 'GET',
            data: {
                'i': sid,
                's': token
            },
            success: function (data) {

                var json = JSON.parse(data);

                if (json.hasOwnProperty('university_name')) {

                    $('#create_university').addClass("hidden");
                    $('#display_university').removeClass("hidden");

                    for (var o in json) {
                        if (json.hasOwnProperty(o)) {
                            if (o !== 'image') {
                                var element = $('#' + o);
                                element.text(json[o]);
                            }
                        }
                    }

                    $('#image_img').attr('src', json['image']);

                    if ($("#google_ptm_map").length > 0) {
                        var gPTMCords = new google.maps.LatLng(json['latitude'], json['longitude']);
                        var gPTMOptions = {zoom: 13, center: gPTMCords, mapTypeId: google.maps.MapTypeId.ROADMAP}
                        var gPTM = new google.maps.Map(document.getElementById("google_ptm_map"), gPTMOptions);

                        var cords = new google.maps.LatLng(json['latitude'], json['longitude']);
                        var marker = new google.maps.Marker({position: cords, map: gPTM, title: "Marker 1"});
                    }

                } else if (json.hasOwnProperty('domain')) {

                    $('#input_university_domain').val(json['domain']);

                    $('#location-component').locationpicker({
                        location: {latitude: 28.6005706, longitude: -81.19767969999998},
                        zoom: 15,
                        enableAutocomplete: true,
                        enableReverseGeocode: true,
                        radius: 0,
                        inputBinding: {
                            latitudeInput: $('#input-lat'),
                            longitudeInput: $('#input-long'),
                            locationNameInput: $('#location-input')
                        }
                    });

                }

            },
            error: function (response) {
                // session is not valid ... purge everything and then load the login screen.
                logout();
            }
        });
    };

    var logout = function () {
        Cookies.remove("project_token");
        Cookies.remove("project_sid");
        Cookies.remove("project_username");
        window.location = 'login.html';
    };

    var initLogoutButton = function () {
        var logoutButton = $('#logout-link');
        logoutButton.click(function () {
            logout();
        });
    };

    var init = function () {
        validateSession();
        initLogoutButton();
        uiSmartWizard();
        var page = location.pathname.split("/").pop();
        if (page === 'dashboard.html') {
            initDashboard();
        } else if (page === 'rsos.html') {
            initRSOTables();
            create_rso_submit_button();
        } else if (page === 'university.html') {
            initUniversity();
            submit_new_university();
        } else if (page === 'events.html') {
            initEvents();
        }
    };

    global.Project = {
        init: init,
        approve_row: approve_row,
        join_row: join_row,
        submitEvent: submitEvent,
        sendMessage: sendMessage,
        toggleHeading: toggleHeading,
        like: like
    }

})(this);