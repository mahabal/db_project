package org.mahabal.project.handlers;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.Organization;
import org.mahabal.project.entity.Session;
import org.mahabal.project.entity.Student;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

public class DashboardHandler extends AbstractProjectHandler {

    public DashboardHandler(DBI dbi) {
        super(dbi);
    }

    @Override
    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        final JsonObject o = new JsonObject();

        Student.Queries students = h.attach(Student.Queries.class);
        o.add("total_students", new JsonPrimitive(students.count()));

        Session.Queries sessions = h.attach(Session.Queries.class);
        o.add("total_sessions", new JsonPrimitive(sessions.count()));
        o.addProperty("active_sessions", sessions.activeCount());

        Organization.Queries organizations = h.attach(Organization.Queries.class);
        o.addProperty("total_rsos", organizations.count());
        o.addProperty("unapproved_rsos", organizations.unapprovedCount());

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);

    }
}