(function (global) {
    'use strict';
    var token;
    var uid;
    var validate = function () {

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
            success: function (data) {
                // session checks out ... do nothing, let the page load like normal
                console.log("ok" + data);
                window.location = "index2.html";
            },
            error: function (response) {
                Cookies.remove("project_token");
                Cookies.remove("project_uid");
                // Cookies.remove("project_username");
            }
        });

        return false;
    };
    var validation = function (str) {
        var el = $('#error-banner');
        el.removeClass("hidden");
        var el2 = $('#error-msg')
        el2.text(str);
    };
    var removeValidation = function () {
        var el = $('#error-banner');
        el.addClass("hidden");
        var el2 = $('#error-msg')
        el2.text("");
    };
    var login = function (username, password) {
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
            success: function (data) {
                console.log("SUCCESS!");
                var json = JSON.parse(data);
                console.log("data:"  + data);
                console.log("json" + json);
                Cookies.set("project_uid", json['uid'], {expires: 1});
                Cookies.set("project_token", json['token'], {expires: 1});
                Cookies.set("project_username", json['name'], {expires: 1});
                window.location = 'index2.html';
            },
            error: function (data) {
                console.error("SOMETHING BROKE!");
            }

        });
        return true;
    };
    var registerAccount = function (username, password, email) {
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
            success: function () {
                login(username, password);
            },
            error: function (response) {
                var data = JSON.parse(response.responseText);
                validation(data['error']);
            }
        });
        return true;
    }
    var initRegisterButton = function () {
        var registerButton = $('#sign-up-button');
        registerButton.click(function () {
            removeValidation();
            var username = $('#username').val();
            var password = $('#password').val();
            var email = $('#email').val();
            registerAccount(username, password, email);
        });
    };
    var initLoginButton = function () {
        var loginButton = $('#log-in-button');

        loginButton.click(function () {
            removeValidation();
            var username = $('#username').val();
            var password = $('#password').val();
            login(username, password);
        });
    };
    var init = function () {
        validate();
        initRegisterButton();
        initLoginButton();
    };
    global.Project = {
        init: init
    }
})(this);