package org.mahabal.project.handlers;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.Organization;
import org.mahabal.project.entity.Student;
import org.mahabal.project.entity.University;
import org.skife.jdbi.v2.DBI;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

public class RSOHandler extends AbstractProjectHandler {

    public RSOHandler(DBI dbi) {
        super(dbi);
    }

    @Override
    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        final JsonArray uArr = new JsonArray();         // unapproved organizations (uso)
        final JsonArray aArr = new JsonArray();         // approved organizations (rso)
        final JsonArray yArr = new JsonArray();         // your organizations (this student is admin)
        final JsonArray mArr = new JsonArray();         // memberships (this student is a part of these)
        final JsonArray jArr = new JsonArray();         // can join (this student is not a member, but can be)

        // attach the handle to the organization queries
        Organization.Queries organizations = h.attach(Organization.Queries.class);

        // handle any actions before returning the json
        String action = req.getParameter("a");
        if (action != null) {
            if (action.equalsIgnoreCase("approve")) {
                String num = req.getParameter("n");
                if (num != null) {
                    organizations.approve(Integer.parseInt(num), student);
                }
                resp.setStatus(HttpServletResponse.SC_OK);
            } else if (action.equalsIgnoreCase("create") && student != null && student.getUid() > 0) {
                String name = req.getParameter("n");
                String desc = req.getParameter("d");
                if (name != null && desc != null) {
                    organizations.create(name, desc, student);
                }
            } else if (action.equals("join") && student != null && student.getUid() > 0) {
                String num = req.getParameter("n");
                if (num != null) {
                    organizations.join(Integer.parseInt(num), student);
                }
            }
        }

        University.Queries universities = h.attach(University.Queries.class);

        //region UNIVERSITY ADMINISTRATORS
        if (session.getSid() == 1) {

            // user is root, so dump all unapproved and approved organizations
            for (final Organization o : organizations.all()) {
                // get this organization's admin
                Student admin = organizations.admin(o.getRid());
                final JsonObject org = new JsonObject();
                // get this organizations university
                University u = universities.getById(o.getUid());
                org.addProperty("rid", o.getRid());
                org.addProperty("name", o.getName());
                org.addProperty("members", organizations.memberCount(o.getRid()));
                org.addProperty("uname", u.getName());
                org.addProperty("created", o.getCreated().toString());
                org.addProperty("username", admin.getUsername());
                org.addProperty("email", admin.getEmail());
                if (o.getApproved() == 0) uArr.add(org);
                else aArr.add(org);

            }

        } else {

            // not root, so get only the rsos for the universities that this user administers
            List<University> unis = universities.getAllByAdmin(student);
            for (University u : unis) {
                List<Organization> rsos = universities.organizations(u.getUid());
                for (final Organization o : rsos) {
                    // get this organization's admin
                    Student admin = organizations.admin(o.getRid());
                    final JsonObject org = new JsonObject();
                    org.addProperty("rid", o.getRid());
                    org.addProperty("name", o.getName());
                    org.addProperty("members", organizations.memberCount(o.getRid()));
                    org.addProperty("uname", u.getName());
                    org.addProperty("created", o.getCreated().toString());
                    org.addProperty("username", admin.getUsername());
                    org.addProperty("email", admin.getEmail());
                    if (o.getApproved() == 0) uArr.add(org);
                    else aArr.add(org);
                }
            }
        }
        //endregion

        try {
            // List the organizations owned by this user...
            List<Organization> administers = organizations.getByAdmin(student);
            for (final Organization o : administers) {
                final JsonObject org = new JsonObject();
                org.addProperty("rid", o.getRid());
                org.addProperty("name", o.getName());
                org.addProperty("university", universities.getNameById(o.getUid()));
                org.addProperty("members", organizations.memberCount(o.getRid()));
                org.addProperty("created", o.getCreated().toString());
                org.addProperty("approved", o.getApproved());
                yArr.add(org);
            }
        } catch (final Exception e) {
            e.printStackTrace();
        }

        // List the RSOs joined by this user...
        String query = "select rm.rid, r.name, u.name as university, (select count(rm2.rid) from rso_membership as rm2 where rm2.rid = rm.rid) as members, r.created, s.username, s.email, r.approved from rso_membership as rm, rso_data as r, university as u, student as s where rm.sid = ? and rm.rid = r.rid and r.uid = u.uid and s.sid = r.sid group by rm.rid; ";
        List<Map<String, Object>> rsos = h.select(query, session.getSid());
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

        //region Organizations this student can join
        List<Organization> canJoins = organizations.canJoin(student);
        for (Organization org : canJoins) {
            final JsonObject o = new JsonObject();
            o.add("rid", new JsonPrimitive(org.getRid()));
            o.add("name", new JsonPrimitive(org.getName()));
            jArr.add(o);
        }
        //endregion


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
