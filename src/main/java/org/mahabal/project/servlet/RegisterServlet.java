package org.mahabal.project.servlet;

import com.google.common.hash.Hashing;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class RegisterServlet extends ProjectServlet {

    public RegisterServlet(DBI dbi) {
        super(dbi);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // load the requested username, email, and password from the request
        String username = req.getParameter("u");
        String email = req.getParameter("e");
        String md5pass = req.getParameter("m");

        // check and make sure the username and password are not null
        if (username == null || email == null || md5pass == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Handle h = dbi.open()) {

            // query the `student` table to search for the username
            List<Map<String, Object>> user = h.select("select uid from student where username = ?",
                    username.toLowerCase());

            // see how many users are in the result set
            if (user.size() == 0) {

                // there are no users in the result set, that means we can create the user.
                // generate a salt to use with hashing the password, then trim it to 12 characters
                final String salt = Hashing.sha512().hashString(String.valueOf(new Random().nextDouble()),
                        Charset.forName("UTF-8")).toString().substring(0, 12);
                // generate a newly salted hash from the md5 password, them trim it to 36 characters
                final String pwHash = Hashing.sha512().hashString(salt + md5pass, Charset.forName("UTF-8"))
                        .toString().substring(0, 36);

                // insert data into the student table
                h.insert("insert into student (username, password, salt, email) values(?,?,?,?)",
                        username, pwHash, salt, email);

                // create json object with return data
                final JsonObject object = new JsonObject();
                object.add("status", new JsonPrimitive("success"));

                // set the response code and print out the object
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().println(object);

            } else {

                final JsonObject obj = new JsonObject();
                obj.add("status", new JsonPrimitive("error"));
                obj.add("description", new JsonPrimitive("user exists"));

                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().println(obj);

            }

        }

        resp.setStatus(HttpServletResponse.SC_OK);

    }

}
