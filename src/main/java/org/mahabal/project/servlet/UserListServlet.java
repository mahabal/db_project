package org.mahabal.project.servlet;

import com.google.gson.JsonArray;
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

public class UserListServlet extends ProjectServlet {

    public UserListServlet(DBI dbi) {
        super(dbi);
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

                final List<Map<String, Object>> session = h.select("select * from session " +
                        "where uid = ? and token = ? and ip = INET6_ATON(?)", i, s, ip);

                if (session.size() == 0) {

                    // no session found, so do nothing
                    resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    final JsonObject obj = new JsonObject();
                    obj.add("error", new JsonPrimitive("Invalid session."));
                    resp.getWriter().println(obj);

                } else {

                    final JsonObject o = new JsonObject();
                    final JsonArray userArr = new JsonArray();

                    String rso = req.getParameter("r");

                    if (rso == null) {
                        // rso is null, so we want to query ALL of the users ... this should be super-admin only
                        // so check if id == 1.
                        if (Integer.parseInt(i) == 1) {
                            final List<Map<String, Object>> users = h.select("select uid, username, email, created from student;");
                            for (final Map<String, Object> map : users) {
                                final JsonObject user = new JsonObject();
                                for (final Map.Entry<String, Object> e : map.entrySet()) {
                                    user.add(e.getKey(), new JsonPrimitive(e.getValue().toString()));
                                }
                                userArr.add(user);
                            }
                        }
                    }

                    o.add("users", userArr);
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().println(o);
                    System.out.println(o);
                }
            }
        }


    }

}
