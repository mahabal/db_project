package org.mahabal.project.handlers;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.Session;
import org.mahabal.project.entity.Student;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public abstract class AbstractProjectHandler extends HttpServlet {

    final DBI dbi;

    protected Student student;
    protected Session session;
    protected Handle h;

    AbstractProjectHandler(final DBI dbi) {
        this.dbi = dbi;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.addHeader("Access-Control-Allow-Origin", "*");

        // get IP address
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null) ip = req.getRemoteAddr();

        // first check and see if this is an ID and token, if it is, just validate it
        String i = req.getParameter("i");
        String s = req.getParameter("s");
        if (i != null && s != null) {

            int id = Integer.parseInt(i);

            try (Handle h = dbi.open()) {

                this.h = h;

                this.student = h.attach(Student.Queries.class).findById(id);
                this.session = h.attach(Session.Queries.class).get(id, ip, s);

                if (session == null || student == null) {

                    // no session or student was found
                    final JsonObject error = new JsonObject();
                    error.add("error", new JsonPrimitive("Invalid Session"));
                    resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    resp.getWriter().println(error);

                } else {

                    // session and student are valid
                    doValidatedGet(req, resp);

                }
            }
        }
    }

    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    }

}
