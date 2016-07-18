package org.mahabal.project.handlers;

import com.google.gson.JsonObject;
import org.mahabal.project.entity.Event;
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

        University.Queries universities = h.attach(University.Queries.class);

        final String action = req.getParameter("a");
        if (action != null) {
            if (action.equals("create")) {

                final String name = req.getParameter("name");
                final String desc = req.getParameter("desc");
                final String domain = req.getParameter("domain");
                final String image = req.getParameter("image");
                final String motto = req.getParameter("motto");
                final String latitude = req.getParameter("latitude");
                final String longitude = req.getParameter("longitude");


                if (name != null && desc != null && domain != null && image != null &&
                        motto != null && latitude != null && longitude != null) {
                    try {
                        final University u = new University(name, domain,
                                student.getSid(), Double.parseDouble(latitude), Double.parseDouble(longitude),
                                desc, motto, image);
                        universities.create(u, student);
                        int uid = universities.getUidByDomain(domain);
                        student.setUid(uid);
                        h.attach(Student.Queries.class).updateUid(student);
                    } catch (final Exception e) {
                        e.printStackTrace();
                    }
                }

            }
        }

        final JsonObject o = new JsonObject();

        if (student.getUid() > 0) {
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
            debug("(" + student.getUsername() + ") is a student of \"" + university.getName() + "\"");
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
                debug("(" + student.getUsername() + ") is an un-enrolled user");
            }
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);

    }
}
