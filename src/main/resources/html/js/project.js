(function(global) {
    'use strict';

        var token;
        var uid;

        var validateSession = function() {

            // read the cookies into variables for easy access
            token = Cookies.get("project_token");
            uid = Cookies.get("project_uid");

            // use ajax to connect to the login api and make sure the session is valid
            $.ajax({
                url: API_BASE_URL + "/login",
                type: 'GET',
                data: {
                    'i': uid,
                    's': token
                },
                success: function() {
                    // session checks out ... do nothing, let the page load like normal
                },
                error: function(response) {
                    // session is not valid ... purge everything and then load the login screen.
                    logout();
                }
            });

            return false;
        }

        var initDashboard = function() {
            // use ajax to connect to the login api and make sure the session is valid
            $.ajax({
                url: API_BASE_URL + "/dashboard",
                type: 'GET',
                data: {
                    'i': uid,
                    's': token
                },
                success: function(data) {
                    var json = JSON.parse(data);
                    console.log(json);

                    for (var key in json) {
                        // get the block
                        var block = $('#' + key + "_block");
                        if (json[key] < 0) block.addClass("hidden");
                        else block.removeClass("hidden");
                        // get the text
                        var text = $('#' + key);
                        text.text(json[key]);
                    }

                },
                error: function(response) {
                    // session is not valid ... purge everything and then load the login screen.
                    logout();
                }
            });
        }

        var initRSOTables = function() {
            // use ajax to connect to the login api and make sure the session is valid
            $.ajax({
                url: API_BASE_URL + "/rsos",
                type: 'GET',
                data: {
                    'i': uid,
                    's': token
                },
                success: function(data) {
                    var json = JSON.parse(data);
                    console.log(json);
                    if (json["unapproved_rsos"] !== 'undefined'){
                        var arr = json["unapproved_rsos"];

                            var block = $('#unapproved_rsos_panel');
                            if (arr.length <= 0) block.addClass("hidden");
                            else block.removeClass("hidden");
                        for (var i = 0; i < arr.length; i++) {
                            var o = arr[i];
                            var row = $('<tr></tr>').attr("id", "trow_" + o["rid"]);
                            for (var key in o) {
                                var element = $('<td></td>').text(o[key]);
                                row.append(element);
                            }
                            // create the button
                            row.append('<td><button class="btn btn-success btn-rounded btn-condensed btn-sm"><span class="fa fa-check"></span></button></td>');
                            var tbody = $('#unapproved_rsos_tbody').append(row);
                        }
                    }
                },
                error: function(response) {
                    // session is not valid ... purge everything and then load the login screen.
                    logout();
                }
            });
        }

//        function approve_row(row){
//
//            var box = $("#mb-approve-row");
//            box.addClass("open");
//
//            box.find(".mb-control-yes").on("click",function(){
//                box.removeClass("open");
//                $("#"+row).hide("slow",function(){
//                    $(this).remove();
//                     $.ajax({
//                        url: API_BASE_URL + "/rsos",
//                        type: 'GET',
//                        data: {
//                            'i': uid,
//                            's': token,
//                            'a': 'approve'
//                        },
//                        success: function(data) {
//                            var json = JSON.parse(data);
//                            console.log(json);
//                            if (json["unapproved_rsos"] !== 'undefined'){
//                                var arr = json["unapproved_rsos"];
//
//                                    var block = $('#unapproved_rsos_panel');
//                                    if (arr.length <= 0) block.addClass("hidden");
//                                    else block.removeClass("hidden");
//                                for (var i = 0; i < arr.length; i++) {
//                                    var o = arr[i];
//                                    var row = $('<tr></tr>').attr("id", "trow_" + o["rid"]);
//                                    for (var key in o) {
//                                        var element = $('<td></td>').text(o[key]);
//                                        row.append(element);
//                                    }
//                                    // create the button
//                                    row.append('<td><button class="btn btn-success btn-rounded btn-condensed btn-sm"><span class="fa fa-check"></span></button></td>');
//                                    var tbody = $('#unapproved_rsos_tbody').append(row);
//                                }
//                            }
//                        },
//                        error: function(response) {
//                            // session is not valid ... purge everything and then load the login screen.
//                            logout();
//                        }
//                    });
//                });
//            });
//
//        }

        var logout = function() {
            Cookies.remove("project_token");
            Cookies.remove("project_uid");
            Cookies.remove("project_username");
            location = 'login.html';
        };

        var initLogoutButton = function() {
            var logoutButton = $('#logout-link');
            logoutButton.click(function() {
                logout();
            });
        };

        var init = function() {
            validateSession();
            initLogoutButton();
            var page = location.pathname.split("/").pop();
            if (page === 'index2.html') {
                initDashboard();
            } else if (page === 'rsos.html') {
                initRSOTables();
            }
        };

        global.Project = {
            init: init
        }

})(this);