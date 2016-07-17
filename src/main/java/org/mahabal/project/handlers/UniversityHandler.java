package org.mahabal.project.handlers;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.Organization;
import org.mahabal.project.entity.Session;
import org.mahabal.project.entity.Student;
import org.mahabal.project.entity.University;
import org.skife.jdbi.v2.DBI;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UniversityHandler extends AbstractProjectHandler {

    public UniversityHandler(DBI dbi) {
        super(dbi);
    }

    @Override
    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        final JsonObject o = new JsonObject();

        if (student.getUid() > 0) {
            University.Queries universities = h.attach(University.Queries.class);
            o.addProperty("rso_count", universities.organizationCount(student.getUid()));
            o.addProperty("studentCount", universities.studentCount(student.getUid()));
        } else {
            // student is not yet in a university
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);

    }
}
