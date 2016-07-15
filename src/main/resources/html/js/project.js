(function (global) {
    'use strict';

    var token;
    var uid;

    var validateSession = function () {

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
            success: function () {
                // session checks out ... do nothing, let the page load like normal
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
                    'i': uid,
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

    var initDashboard = function () {
        // use ajax to connect to the login api and make sure the session is valid
        $.ajax({
            url: API_BASE_URL + "/dashboard",
            type: 'GET',
            data: {
                'i': uid,
                's': token
            },
            success: function (data) {
                var json = JSON.parse(data);
                console.log(json);

                for (var key in json) {
                    if (json.hasOwnProperty(key)) {
                        // get the block
                        var block = $('#' + key + "_block");
                        if (json[key] < 0) block.addClass("hidden");
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
                    var tbody = $('#' + type + '_tbody').append(row);
                }
            }

            var table = $('#' + type + '_table');
            table.addClass('datatable');
            table.DataTable();
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
                        'i': uid,
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

    var initRSOTables = function () {
        // use ajax to connect to the login api and make sure the session is valid
        $.ajax({
            url: API_BASE_URL + "/rsos",
            type: 'GET',
            data: {
                'i': uid,
                's': token
            },
            success: rso_success,
            error: function (response) {
                // session is not valid ... purge everything and then load the login screen.
                logout();
            }
        });
    }


    var logout = function () {
        Cookies.remove("project_token");
        Cookies.remove("project_uid");
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
        var page = location.pathname.split("/").pop();
        if (page === 'index2.html') {
            initDashboard();
        } else if (page === 'rsos.html') {
            initRSOTables();
            create_rso_submit_button();
        }
    };

    global.Project = {
        init: init,
        approve_row: approve_row
    }

})(this);