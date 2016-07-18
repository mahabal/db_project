package org.mahabal.project.handlers;

import com.google.gson.JsonObject;
import org.mahabal.project.entity.Event;
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
            University university = universities.getById(student.getUid());
            Event.Queries events = h.attach(Event.Queries.class);
            o.addProperty("description", university.getDesc());
            o.addProperty("rso_count", universities.organizationCount(student.getUid()));
            o.addProperty("student_count", universities.studentCount(student.getUid()));
            o.addProperty("latitude", university.getLatitude());
            o.addProperty("longitude", university.getLongitude());
            o.addProperty("university_name", university.getName());
            o.addProperty("motto", university.getMotto());
            o.addProperty("all_events", events.count(university));
            o.addProperty("image", university.getImage());
        } else {
            // student is not yet in a university
            final String email = student.getEmail();
            if (email.contains("@")) {
                final String[] e_parts = email.split("@");
                if (e_parts.length == 2) {
                    final String end = e_parts[1];
                    final String[] parts = end.split("\\.");
                    if (parts.length < 2) {
                        o.addProperty("domain", end);
                    } else {
                        o.addProperty("domain", parts[parts.length - 2] + "." + parts[parts.length - 1]);
                    }
                }
            }
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);

    }
}
