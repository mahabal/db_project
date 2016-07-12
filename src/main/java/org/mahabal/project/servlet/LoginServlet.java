package org.mahabal.project.servlet;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class LoginServlet extends ProjectServlet {

    public LoginServlet(DBI dbi) {
        super(dbi);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // get IP address
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null) ip = req.getRemoteAddr();

        // load the requested username and password from the request
        String username = req.getParameter("u");
        String md5pass = req.getParameter("m");

        // check and make sure the username and password are not null
        if (username == null || md5pass == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Handle h = dbi.open()) {

            List<Map<String, Object>> user = h.select("select uid, password, salt from student where username = ?",
                    username);

            if (user.size() == 0) {
                // there is no student with the provided username
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                final JsonObject o = new JsonObject();
                o.add("status", new JsonPrimitive("error"));
                o.add("desc", new JsonPrimitive("invalid username or password"));
                resp.getWriter().println(o);
            }

        }

        resp.setStatus(HttpServletResponse.SC_OK);

    }

}
