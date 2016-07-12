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
                    location = 'login.html';
                }
            });

            return false;
        }

        var logout = function() {
            Cookies.remove("project_token");
            Cookies.remove("project_uid");
            Cookies.remove("project_username");
        };

        var init = function() {
            validateSession();
        };

        global.Project = {
            init: init
        }

})(this);