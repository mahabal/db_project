package org.mahabal.project.handlers;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public abstract class AbstractProjectHandler extends HttpServlet {

    final DBI dbi;

    AbstractProjectHandler(final DBI dbi) {
        this.dbi = dbi;
    }

    @Override
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

                final List<Map<String, Object>> session = h.select("select student.username from session, student " +
                        "where session.sid = ? and session.token = ? and session.ip = INET6_ATON(?) and " +
                        "session.sid = student.sid", i, s, ip);

                if (session.size() == 0) {

                    // no session found, so do nothing
                    resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    final JsonObject obj = new JsonObject();
                    obj.add("error", new JsonPrimitive("Invalid session."));
                    resp.getWriter().println(obj);

                } else {

                    doValidatedGet(req, resp, h, i, s);

                }
            }
        }
    }

    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp,
                                           Handle h, String i, String s) throws ServletException, IOException { };

}
