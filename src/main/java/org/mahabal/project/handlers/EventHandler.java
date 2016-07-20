package org.mahabal.project.handlers;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.mahabal.project.entity.*;
import org.skife.jdbi.v2.DBI;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;

public class EventHandler extends AbstractProjectHandler {

    private Message.Queries messages = null;
    private Like.Queries likes = null;

    public EventHandler(DBI dbi) {
        super(dbi);
    }

    public static void main(String[] args) {

        final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd h:mm aaa");

        System.out.println(df.format(System.currentTimeMillis()));

    }

    @Override
    protected void doValidatedGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        messages = h.attach(Message.Queries.class);
        likes = h.attach(Like.Queries.class);
        final Event.Queries events = h.attach(Event.Queries.class);
        final Student.Queries students = h.attach(Student.Queries.class);

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
                long time = System.currentTimeMillis();
                if (name != null && desc != null && scope != null && date != null && startTime != null) {
                    // mysql is weird ... must do programming magic to convert normal date to mysql
                    final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm aaa");
                    try {
                        time = df.parse(date + " " + startTime).getTime();
                    } catch (ParseException e) {
                        e.printStackTrace();
                    }
                    final Timestamp sqlDate = new Timestamp(time);
                    int sc = 0;
                    int aid = 0;
                    if (scope.equalsIgnoreCase("public")) {
                        sc = 0;
                        aid = 0;
                    } else if (scope.equalsIgnoreCase("private (university only)")) {
                        sc = 1;
                        aid = student.getUid();
                    } else {
                        final String[] parts = scope.split(":");
                        if (parts.length == 2) {
                            sc = 2;
                            aid = Integer.parseInt(parts[0]);
                        }
                    }
                    // create the event
                    final Event event = new Event(sc, aid, name, desc, tags,
                            sqlDate, startTime, endTime,
                            location, latitude, longitude,
                            contact_name, contact_phone, contact_email);
                    events.insert(event);
                }
            } else if (action.equalsIgnoreCase("post")) {
                String e = req.getParameter("e");
                String m = req.getParameter("m");
                if (e != null && m != null) {
                    int eid = Integer.parseInt(e);
                    messages.insert(eid, student.getSid(), m);
                }
            } else if (action.equalsIgnoreCase("like")) {
                String e = req.getParameter("e");
                if (e != null) {

                    final int eid = Integer.parseInt(e);
                    Like l = likes.get(student.getSid(), eid);
                    if (l == null) {
                        likes.insert(student.getSid(), eid);
                        System.out.println(student.getUsername() + " has liked an event");
                    } else {
                        likes.insert(student.getSid(), eid);
                        System.out.println(student.getUsername() + " has unliked an event");
                    }

                }
            }
        }


        if (student.getUid() == 1) {

            final List<Event> allEvents = events.all();
            if (allEvents.size() > 0) {
                o.add("events", getJsonArrayOfEvents(allEvents));
            }

        } else {

            // add all of the university events
            final JsonArray array = getJsonArrayOfEvents(events.allPrivate(student.getUid()));

            // add all of the RSO events
            for (final Organization org : students.getOrganizations(student)) {
                array.addAll(getJsonArrayOfEvents(events.allRSO(org.getRid())));
            }

            if (array.size() > 0) {
                o.add("events", array);
            }

        }

        final JsonArray orgArray = new JsonArray();
        List<Organization> orgs = students.getOrganizations(student);
        if (!orgs.isEmpty()) {
            for (final Organization org : orgs) {
                final JsonObject orgObj = new JsonObject();
                orgObj.addProperty("rid", org.getRid());
                orgObj.addProperty("orgName", org.getName());
                orgArray.add(orgObj);
            }
            o.add("organizations", orgArray);
        }


        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().println(o);

    }

    private JsonArray getJsonArrayOfEvents(List<Event> allEvents) {
        final JsonArray array = new JsonArray();
        for (final Event e : allEvents) {
            final JsonObject obj = new JsonParser().parse(e.toJsonObject()).getAsJsonObject();
            obj.addProperty("likes", likes.count(e.getEid()));
            final List<Message> messagesForEvent = messages.getAllDesc(e);
            if (!messagesForEvent.isEmpty()) {
                final JsonArray messageArray = new JsonArray();
                for (final Message m : messages.getAllDesc(e)) {
                    final Student s = messages.getPoster(m);
                    final JsonObject mObj = new JsonObject();
                    mObj.addProperty("username", s.getUsername());
                    mObj.addProperty("message", m.getMessage());
                    mObj.addProperty("time", m.getTime().toString());
                    messageArray.add(mObj);
                }
                obj.add("messages", messageArray);
            }
            array.add(obj);
        }
        return array;
    }

}
