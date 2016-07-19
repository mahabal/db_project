package org.mahabal.project.handlers;

import com.google.gson.JsonObject;
import org.mahabal.project.entity.Event;
import org.skife.jdbi.v2.DBI;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;

public class EventHandler extends AbstractProjectHandler {

    public EventHandler(DBI dbi) {
        super(dbi);
    }

    @Override
    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        final Event.Queries events = h.attach(Event.Queries.class);

        final JsonObject o = new JsonObject();

        String action = req.getParameter("a");
        if (action != null) {
            if (action.equalsIgnoreCase("create")) {

                String name = req.getParameter("name");
                String desc = req.getParameter("about");
                String scope = req.getParameter("scope");
                String tags = req.getParameter("tags");
                String location = req.getParameter("location");
                String latitude = req.getParameter("latitude");
                String longitude = req.getParameter("longitude");
                String date = req.getParameter("date");
                String startTime = req.getParameter("starttime");
                String endTime = req.getParameter("endtime");
                String contact_name = req.getParameter("cname");
                String contact_phone = req.getParameter("cphone");
                String contact_email = req.getParameter("cemail");

                if (name != null && desc != null&& scope != null) {
                    String[] dateParts = date.split("-");
                    System.out.println(Arrays.asList(dateParts));
                    final Timestamp sqlDate = new Timestamp(Integer.parseInt(dateParts[0]) - 1900, Integer.parseInt(dateParts[1]) - 1,
                            Integer.parseInt(dateParts[2]), 0, 0, 0, 0);

                    final Event event = new Event(0, 0, name, desc, tags, sqlDate, startTime, endTime, location, latitude, longitude, contact_name, contact_phone, contact_email);
                    System.out.println(events.insert(event));


                }


                System.out.println(req.getParameterMap().entrySet());
            }
        }


        if (student.getUid() == 1) {

            List<Event> allAvents = events.all();

        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);

    }
}
