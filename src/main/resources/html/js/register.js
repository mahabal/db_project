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

            var successHandler = function(data) {
                console.error(JSON.stringify(data));
//                setCookie('sesh_id', data['token']);
                location.reload();
            };

            $.ajax({
                url: API_BASE_URL + '/login',
                type: 'GET',
                data: {
                        'u': username,
                        'm': passwordSha512
                    },
                    success: successHandler,
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
    var init = function() {
        initRegisterButton();
    };
    global.Project = {
        init: init
    }
})(this);