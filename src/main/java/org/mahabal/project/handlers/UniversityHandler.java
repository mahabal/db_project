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

        University.Queries universities = h.attach(University.Queries.class);
        o.add("rso_count", new JsonPrimitive(universities.organizationCount(student.getUid())));

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);

    }
}
