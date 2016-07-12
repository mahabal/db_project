(function(global) {
    'use strict';
    var emailRegex = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/i;
    var validateRegistration = function() {
        var email = $('email').find('#register').val();
    };
        var validation = function(str) {
            var el = $('#error-banner');
            el.removeClass("hidden");
            var el2 = $('#error-msg')
            el2.text(str);
        };
        var removeValidation = function() {
            var el = $('#error-banner');
            el.addClass("hidden");
            var el2 = $('#error-msg')
            el2.text("");
        };
        var login = function(username, password) {
            if (typeof global.sha512 === 'undefined') {
                console.error("Missing the sha2 include");
                return false;
            }

            var passwordSha512 = sha512(password);

            $.ajax({
                url: API_BASE_URL + '/login',
                type: 'GET',
                data: {
                        'u': username,
                        'm': passwordSha512
                    },
                    success: function(data) {
                        var json = JSON.parse(data);
                        Cookies.set("project_uid", json['uid'], { expires: 1} );
                        Cookies.set("project_username", json['name'], { expires: 1 });
                        Cookies.set("project_token", json['token'], { expires: 1 });
                        console.log(Cookies.get("token"));
                        location.reload();
                    },
                    error: function(data) {
                        console.error("SOMETHING BROKE!");
                    }

            });
            return true;
        };
    var registerAccount = function(username, password, email) {
        if (typeof global.sha512 === 'undefined') {
            console.error("Missing the sha2 include");
            return false;
        }
        var passwordSha512 = sha512(password);
        console.log(passwordSha512);
        $.ajax({
            url: API_BASE_URL + "/register",
            type: 'GET',
            data: {
                'u': username,
                'e': email,
                'm': passwordSha512
            },
            success: function() {
                login(username, password);
            },
            error: function(response) {
                var data = JSON.parse(response.responseText);
                validation(data['error']);
            }
        });
        return true;
    }
    var initRegisterButton = function() {
        var registerButton = $('#sign-up-button');
        registerButton.click(function() {
                removeValidation();
                var username = $('#username').val();
                var password = $('#password').val();
                var email = $('#email').val();
                registerAccount(username, password, email);
        });
    };
    var logout = function() {
        Cookies.remove("project_token");
        Cookies.remove("project_uid");
        Cookies.remove("project_username");
    };
    var init = function() {
        validateSession();
        initRegisterButton();
    };
    global.Project = {
        init: init
    }
})(this);