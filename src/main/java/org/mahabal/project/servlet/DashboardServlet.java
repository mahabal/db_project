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

public class DashboardServlet extends ProjectServlet {

    public DashboardServlet(DBI dbi) {
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

                    long userCount = -1;
                    long sessionCount = -1;
                    long activeSessionCount = -1;
                    long rsoCount = -1;
                    long unapprovedRsoCount = -1;

                    String total_students = "total_students";
                    String total_rsos = "total_rsos";
                    String unapproved_rsos = "unapproved_rsos";
                    String total_sessions = "total_sessions";
                    String active_sessions = "active_sessions";


                    String rso = req.getParameter("r");

                    if (rso == null) {
                        // rso is null, so we want to query ALL of the users ... this should be root only
                        // so check if id == 1.
                        if (Integer.parseInt(i) == 1) {

                            String totalStudentCount = "select count(*) from student";
                            String totalSessionCount = "select count(*) from session";
                            String totalRsosCount = "select count(*) from rso_data";
                            String unapprovedRsosConstraint = "where rso_data.approved = 0";
                            String activeSessionConstraint = "where session.created > now() - interval 24 hour";

                            final List<Map<String, Object>> counts = h.select(String.format("select " +
                                            "(%s) as %s," +
                                            "(%s) as %s," +
                                            "(%s %s) as %s," +
                                            "(%s) as %s," +
                                            "(%s %s) as %s;",
                                    totalStudentCount, total_students,
                                    totalSessionCount, total_sessions,
                                    totalSessionCount, activeSessionConstraint, active_sessions,
                                    totalRsosCount, total_rsos,
                                    totalRsosCount, unapprovedRsosConstraint, unapproved_rsos
                            ));
                            if (counts.size() > 0) {
                                userCount = (Long) counts.get(0).get(total_students);
                                sessionCount = (Long) counts.get(0).get(total_sessions);
                                activeSessionCount = (Long) counts.get(0).get(active_sessions);
                                rsoCount = (Long) counts.get(0).get(total_rsos);
                                unapprovedRsoCount = (Long) counts.get(0).get(unapproved_rsos);

                            }
                        }
                    }

                    final JsonObject o = new JsonObject();
                    o.add(total_students, new JsonPrimitive(userCount));
                    o.add(total_sessions, new JsonPrimitive(sessionCount));
                    o.add(active_sessions, new JsonPrimitive(activeSessionCount));
                    o.add(total_rsos, new JsonPrimitive(rsoCount));
                    o.add(unapproved_rsos, new JsonPrimitive(unapprovedRsoCount));
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().println(o);
                    System.out.println(o);
                }
            }
        }


    }

}
