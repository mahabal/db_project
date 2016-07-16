package org.mahabal.project.handlers;

import com.google.common.hash.Hashing;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.University;
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

public class RegistrationHandler extends AbstractProjectHandler {

    public RegistrationHandler(DBI dbi) {
        super(dbi);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.addHeader("Access-Control-Allow-Origin", "*");

        // load the requested username, email, and password from the request
        String username = req.getParameter("u");
        String email = req.getParameter("e");
        String md5pass = req.getParameter("m");

        // check and make sure the username and password are not null
        if (username == null || email == null || md5pass == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if (email.split("@").length == 2 && email.endsWith(".edu")) {

            try (Handle h = dbi.open()) {

                // query the `student` table to search for the username
                List<Map<String, Object>> user = h.select("select uid from student where username = ?",
                        username.toLowerCase());

                // see how many users are in the result set
                if (user.size() == 0) {

                    String[] email_parts = email.split("@")[1].split("\\.");
                    if (email_parts.length < 2) {
                        resp.setStatus(HttpServletResponse.SC_CONFLICT);
                        final JsonObject obj = new JsonObject();
                        obj.addProperty("error", "E-mail address has an invalid domain");
                        resp.getWriter().println(obj);
                        return;
                    }
                    String domain = email_parts[email_parts.length - 2] + "." + email_parts[email_parts.length - 1];

                    University.Queries universities = h.attach(University.Queries.class);
                    int uid = universities.getUidByDomain(domain);

                    System.out.println("DOMAIN: " + domain + " IS FOR: " + uid);

                    // there are no users in the result set, that means we can create the user.
                    // generate a salt to use with hashing the password, then trim it to 12 characters
                    final String salt = Hashing.sha512().hashString(String.valueOf(new Random().nextDouble()),
                            Charset.forName("UTF-8")).toString().substring(0, 12);
                    // generate a newly salted hash from the md5 password, them trim it to 36 characters
                    final String pwHash = Hashing.sha512().hashString(salt + md5pass, Charset.forName("UTF-8"))
                            .toString().substring(0, 36);

                    // insert data into the student table
                    h.insert("insert into student (uid, username, password, salt, email) values(?,?,?,?,?)",
                            uid, username, pwHash, salt, email);
                    System.out.println("Student created: " + username);

                    // set the response code and print out the object
                    resp.setStatus(HttpServletResponse.SC_OK);

                } else {

                    final JsonObject obj = new JsonObject();
                    obj.add("error", new JsonPrimitive("Username is already in use."));
                    resp.setStatus(HttpServletResponse.SC_CONFLICT);
                    resp.getWriter().println(obj);
                    System.out.println(obj);
                    return;

                }

            }
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            final JsonObject obj = new JsonObject();
            obj.addProperty("error", "Invalid E-mail format, must be a .edu address.");
            resp.getWriter().println(obj);
        }

    }

}
