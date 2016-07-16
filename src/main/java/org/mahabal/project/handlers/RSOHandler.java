package org.mahabal.project.handlers;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.Organization;
import org.mahabal.project.entity.Session;
import org.mahabal.project.query.Queries;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class RSOHandler extends AbstractProjectHandler {

    public RSOHandler(DBI dbi) {
        super(dbi);
    }

    @Override
    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("Recv: " + req.getParameterMap().keySet());

        final JsonArray uArr = new JsonArray();
        final JsonArray aArr = new JsonArray();
        final JsonArray yArr = new JsonArray();
        final JsonArray mArr = new JsonArray();
        final JsonArray jArr = new JsonArray();

        // attach the handle to the organization queries
        Organization.Queries organizations = h.attach(Organization.Queries.class);

        String a = req.getParameter("a");
        if (a != null) {
            if (a.equalsIgnoreCase("approve")) {
                String num = req.getParameter("n");
                if (num != null) {
                    organizations.approve(Integer.parseInt(num), student);
                }
                resp.setStatus(HttpServletResponse.SC_OK);
            } else if (a.equalsIgnoreCase("create") && student != null && student.getUid() > 0) {
                String name = req.getParameter("n");
                String desc = req.getParameter("d");
                if (name != null && desc != null) {
                    organizations.create(name, desc, student);
                }
            } else if (a.equals("join") && student != null && student.getUid() > 0) {
                String num = req.getParameter("n");
                if (num != null) {
                    System.out.println(student.getUsername() + " wants to join " + Integer.parseInt(num));
                    organizations.join(Integer.parseInt(num), student);
                }
            }
        }

        // if root, dump all
        if (session.getSid() == 1) {



            String query = "select r.rid, r.name, r.created, s.username, s.email, r.approved, u.name as uname, " +
                    "count(rm.rid) as members from rso_data as r, student as s, university as u, rso_membership as rm" +
                    " where r.sid = s.sid and r.uid = u.uid and rm.rid = r.rid group by r.rid";
            final List<Map<String, Object>> rsos = h.select(query);
            if (rsos.size() > 0) {
                for (Map<String, Object> r : rsos) {
                    int rid = (Integer) r.get("rid");
                    String name = (String) r.get("name");
                    String uname = (String) r.get("uname");
                    String username = (String) r.get("username");
                    String email = (String) r.get("email");
                    long members = (Long) r.get("members");
                    Timestamp t = (Timestamp) r.get("created");
                    boolean approved = r.get("approved").equals(1);
                    final JsonObject o = new JsonObject();
                    o.add("rid", new JsonPrimitive(rid));
                    o.add("name", new JsonPrimitive(name));
                    o.add("members", new JsonPrimitive(members));
                    o.add("uname", new JsonPrimitive(uname));
                    o.add("created", new JsonPrimitive(t.toString()));
                    o.add("username", new JsonPrimitive(username));
                    o.add("email", new JsonPrimitive(email));
                    if (!approved)
                        uArr.add(o);
                    else
                        aArr.add(o);
                }
            }
        }


        // List the RSOs owned by this user...
        String query = "select r.rid, r.name, u.name as university, " +
                "(select count(rm.sid) as memberships from rso_membership as rm where rm.rid = r.rid) as members, " +
                "r.created, r.approved from rso_data as r,student as s, university as u" +
                " where r.sid = ? and r.sid = s.sid and u.uid = r.uid;";
        Queries queries = h.attach(Queries.class);
        List<Organization> administers = queries.getOrganizationsByAdminId(student.getSid());
        System.out.println("This user is an admin of: " + administers.size() + " organizations.");
        System.out.println("\t" + administers.stream().map(Organization::getName).collect(Collectors.joining(", ")));
        List<Map<String, Object>> rsos = h.select(query, session.getSid());
        if (rsos.size() > 0) {
            for (Map<String, Object> r : rsos) {
                int rid = (Integer) r.get("rid");
                String name = (String) r.get("name");
                String university = (String) r.get("university");
                long members = (Long) r.get("members");
                Timestamp t = (Timestamp) r.get("created");
                int approved = (Integer) r.get("approved");
                final JsonObject o = new JsonObject();
                o.add("rid", new JsonPrimitive(rid));
                o.add("name", new JsonPrimitive(name));
                o.add("university", new JsonPrimitive(university));
                o.add("member", new JsonPrimitive(members));
                o.add("created", new JsonPrimitive(t.toString()));
                o.add("approved", new JsonPrimitive(approved));
                yArr.add(o);
            }
        }

        // List the RSOs joined by this user...
        query = "select rm.rid, r.name, u.name as university, (select count(rm2.rid) from rso_membership as rm2 where rm2.rid = rm.rid) as members, r.created, s.username, s.email, r.approved from rso_membership as rm, rso_data as r, university as u, student as s where rm.sid = ? and rm.rid = r.rid and r.uid = u.uid and s.sid = r.sid group by rm.rid; ";
        rsos = h.select(query, session.getSid());
        if (rsos.size() > 0) {
            for (Map<String, Object> r : rsos) {
                int rid = (Integer) r.get("rid");
                String name = (String) r.get("name");
                String uni = (String) r.get("university");
                Long members = (Long) r.get("members");
                String username = (String) r.get("username");
                String email = (String) r.get("email");
                Timestamp t = (Timestamp) r.get("created");
                int approved = (Integer) r.get("approved");
                final JsonObject o = new JsonObject();
                o.add("rid", new JsonPrimitive(rid));
                o.add("name", new JsonPrimitive(name));
                o.add("university", new JsonPrimitive(uni));
                o.add("members", new JsonPrimitive(members));
                o.add("created", new JsonPrimitive(t.toString()));
                o.add("username", new JsonPrimitive(username));
                o.add("email", new JsonPrimitive(email));
                o.add("approved", new JsonPrimitive(approved));
                mArr.add(o);
            }
        }

        try {
            List<Organization> canJoins = organizations.canJoin(student);
            for (Organization org : canJoins) {
                final JsonObject o = new JsonObject();
                o.add("rid", new JsonPrimitive(org.getRid()));
                o.add("name", new JsonPrimitive(org.getName()));
                jArr.add(o);
            }
        } catch (final Exception ignored) {
            ignored.printStackTrace();
        }

        final JsonObject o = new JsonObject();
        o.add("unapproved_rsos", uArr);
        o.add("approved_rsos", aArr);
        o.add("owned_rsos", yArr);
        o.add("membership_rsos", mArr);
        o.add("can_join", jArr);
        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);
    }
}
