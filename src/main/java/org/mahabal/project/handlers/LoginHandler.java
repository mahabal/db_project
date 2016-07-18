package org.mahabal.project.handlers;

import com.google.common.hash.Hashing;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.Session;
import org.mahabal.project.entity.Student;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;

public class LoginHandler extends AbstractProjectHandler {

    public LoginHandler(DBI dbi) {
        super(dbi);
    }

    public static String generateHashedString(final String s, final int size) {
        return Hashing.sha512().hashString(s, Charset.forName("UTF-8")).toString().substring(0, size);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.addHeader("Access-Control-Allow-Origin", "*");

        // get IP address
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null) ip = req.getRemoteAddr();

        // first check and see if this is an ID and token, if it is, just validate it
        String i = req.getParameter("i");
        String s = req.getParameter("s");
        if (i != null && s != null) {
            try (Handle h = dbi.open()) {

                int sid = Integer.parseInt(i);


                student = h.attach(Student.Queries.class).findById(sid);
                session = h.attach(Session.Queries.class).get(sid, ip, s);

                if (session == null || student == null) {
                    // no session found, so do nothing
                    resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    final JsonObject obj = new JsonObject();
                    obj.add("error", new JsonPrimitive("Invalid session."));
                    resp.getWriter().println(obj);
                    debug("invalid session from " + ip + " for user " + i);
                    return;
                } else {

                    resp.setStatus(HttpServletResponse.SC_OK);
                    final JsonObject obj = new JsonObject();
                    obj.addProperty("sid", student.getSid());
                    obj.addProperty("uid", student.getUid());
                    obj.addProperty("name", student.getUsername());
                    obj.addProperty("token", session.getToken());
                    resp.getWriter().println(obj);
                    debug("(" + student.getUsername() + ") session validated " + obj.entrySet());
                    return;

                }

            }
        }

        // load the requested username and password from the request
        String username = req.getParameter("u");
        String md5pass = req.getParameter("m");

        // check and make sure the username and password are not null
        if (username == null || md5pass == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            debug("Bad request, username or md5password was null.");
            return;
        }

        int id;
        String hash, salt;
        try (Handle h = dbi.open()) {

            List<Map<String, Object>> user = h.select("select sid, password, salt from student where username = ?",
                    username.toLowerCase());

            if (user.size() == 0) {
                // there is no student with the provided username
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                final JsonObject o = new JsonObject();
                o.add("status", new JsonPrimitive("error"));
                o.add("desc", new JsonPrimitive("invalid username or password"));
                resp.getWriter().println(o);
                return;
            } else {
                id = (Integer) user.get(0).get("sid");
                hash = (String) user.get(0).get("password");
                salt = (String) user.get(0).get("salt");
            }

        }

        // create a hash using the provided password and the recently retrieved salt
        String test = Hashing.sha512().hashString(salt + md5pass, Charset.forName("UTF-8")).toString()
                .substring(0, 36);

        // see if the test hash is the same as the hash received from the database
        if (test.equals(hash)) {

            // stores the token that will be used for this user
            String token;

            try (Handle h = dbi.open()) {

                // check and see if a token already exists for this userId + IP
                List<Map<String, Object>> tokens = h.select("select token from session where sid = ? and " +
                        "ip = INET6_ATON(?)", id, ip);

                if (tokens.size() == 0) {
                    // no token exists, so create one (36 chars) and save it into the database
                    token = generateHashedString(id + "-" + ip + "-" + Math.random(), 36);
                    h.insert("insert into session (sid, ip, token) values (?,INET6_ATON(?),?)",
                            id, ip, token);
                } else {
                    token = (String) tokens.get(0).get("token");
                }
            }

            final JsonObject o = new JsonObject();
            o.add("sid", new JsonPrimitive(id));
            o.add("token", new JsonPrimitive(token));
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().println(o);

        } else {
            debug("(" + username + ") invalid username/password from " + ip);
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            final JsonObject o = new JsonObject();
            o.add("status", new JsonPrimitive("error"));
            o.add("desc", new JsonPrimitive("invalid username or password"));
            resp.getWriter().println(o);

        }

    }

}
