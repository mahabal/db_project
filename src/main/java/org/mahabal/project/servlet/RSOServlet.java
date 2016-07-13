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
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

public class RSOServlet extends ProjectServlet {

    public RSOServlet(DBI dbi) {
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


                    final JsonArray uArr = new JsonArray();
                    final JsonArray aArr = new JsonArray();
                    final JsonArray yArr = new JsonArray();

                    // if root, dump all
                    if (Integer.parseInt(i) == 1) {
                        System.out.println("root query");
                        String query = "select r.rid, r.name, r.created, s.username, s.email, r.approved from rso_data as r," +
                                "student as s where r.sid = s.uid";
                        final List<Map<String, Object>> rsos = h.select(query);
                        if (rsos.size() > 0) {
                            for (Map<String, Object> r : rsos) {
                                int rid = (Integer) r.get("rid");
                                String name = (String) r.get("name");
                                String username = (String) r.get("username");
                                String email = (String) r.get("email");
                                Timestamp t = (Timestamp) r.get("created");
                                boolean approved = ((Integer) r.get("approved")).equals(1);
                                final JsonObject o = new JsonObject();
                                o.add("rid", new JsonPrimitive(rid));
                                o.add("name", new JsonPrimitive(name));
                                o.add("created", new JsonPrimitive(t.toString()));
                                o.add("username", new JsonPrimitive(username));
                                o.add("email", new JsonPrimitive(email));
                                if (!approved)
                                    uArr.add(o);
                                else
                                    aArr.add(o);
                            }
                        }
                    } else {
                        // not root, lookup user in the RSO db and see if they are an admin, then just dump out
                        // rsos where they are admins
                        String query = "select r.rid, r.name, r.created, s.username, s.email from rso_data as r," +
                                "student as s where r.sid = ? and r.sid = s.uid";
                        System.out.println(query);
                        final List<Map<String, Object>> rsos = h.select(query, i);
                        if (rsos.size() > 0) {
                            for (Map<String, Object> r : rsos) {
                                int rid = (Integer) r.get("rid");
                                String name = (String) r.get("name");
                                String username = (String) r.get("username");
                                String email = (String) r.get("email");
                                Timestamp t = (Timestamp) r.get("created");
                                final JsonObject o = new JsonObject();
                                o.add("rid", new JsonPrimitive(rid));
                                o.add("name", new JsonPrimitive(name));
                                o.add("created", new JsonPrimitive(t.toString()));
                                o.add("username", new JsonPrimitive(username));
                                o.add("email", new JsonPrimitive(email));
                                uArr.add(o);
                            }
                        }
                    }

                    final JsonObject o = new JsonObject();
                    o.add("unapproved_rsos", uArr);
                    o.add("approved_rsos", aArr);
                    o.add("member_rsos", yArr);
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().println(o);
                    System.out.println(o);
                }
            }
        }


    }

}
