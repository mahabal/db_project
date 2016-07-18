package org.mahabal.project;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.zaxxer.hikari.HikariDataSource;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.jsoup.Jsoup;
import org.mahabal.project.entity.Event;
import org.mahabal.project.handlers.*;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import java.sql.Timestamp;
import java.util.Scanner;

public class Backend {

    private final ServletHandler handler = new ServletHandler();

    private Backend() throws Exception {

        // uncomment this to see Jetty + HikariCP + DBI output
//        BasicConfigurator.configure();

        // setup the connection to the database
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl("jdbc:mysql://localhost:3306/project");
        ds.setUsername("root");
        ds.setPassword("b&");

        // set the datasource for jDBI
        final DBI dbi = new DBI(ds);

        // setup all of the handlers
        handler.addServletWithMapping(new ServletHolder(new RegistrationHandler(dbi)), "/register");
        handler.addServletWithMapping(new ServletHolder(new LoginHandler(dbi)), "/login");
        handler.addServletWithMapping(new ServletHolder(new UserHandler(dbi)), "/users");
        handler.addServletWithMapping(new ServletHolder(new DashboardHandler(dbi)), "/dashboard");
        handler.addServletWithMapping(new ServletHolder(new RSOHandler(dbi)), "/rsos");
        handler.addServletWithMapping(new ServletHolder(new UniversityHandler(dbi)), "/university");
        handler.addServletWithMapping(new ServletHolder(new EventHandler(dbi)), "/events");

//        final Scanner s = new Scanner(System.in);
//        String line;
//        while ((line = s.nextLine()) != null) {
//            if (line.equals("exit")) {
//                break;
//            } else if (line.equals("ucf")) {
//
//                final int scope = 0; // 0 = public (anyone can come)
//                final int aid = 1;
//
//                String text = Jsoup.connect("http://events.ucf.edu/upcoming/feed.json").ignoreContentType(true).get().text();
//                final JsonArray array = new JsonParser().parse(text).getAsJsonArray();
//
//                System.out.println("Retrieving UCF events ... ");
//                int count = 0;
//
//                for (final JsonElement e : array) {
//                    if (e.isJsonObject()) {
//                        final JsonObject o = e.getAsJsonObject();
//
//                        String name = o.has("title") ? o.get("title").getAsString() : "";
//                        String desc = o.has("description") ? o.get("description").getAsString() : "";
//                        String location = o.has("location") ? o.get("location").getAsString() : "";
//                        String contant_name = o.has("contact_name") ? o.get("contact_name").getAsString() : "";
//                        String contant_phone = "";
//                        String contant_email = o.has("contact_email") ? o.get("contact_email").getAsString() : "";
//                        if (o.has("tags") && o.get("tags").isJsonArray()) {
//                            final JsonArray tagArray = o.getAsJsonArray("tags");
//                            String[] tags = new String[tagArray.size()];
//                            for (int i = 0; i < tagArray.size(); i++) {
//                                tags[i] = tagArray.get(i).getAsString();
//                            }
//                        }
//
//                        try (Handle h = dbi.open()) {
//
//                            try {
//                                Event.Queries event = h.attach(Event.Queries.class);
//                                count += event.insert(new Event(scope, aid, name, desc,
//                                        new Timestamp(System.currentTimeMillis()), location,
//                                        contant_name, contant_phone, contant_email));
//
//                            } catch (final Exception e2) {
//                                e2.printStackTrace();
//                            }
//                        }
//
//                    }
//                }
//
//                System.out.println("Inserted " + count + " entries into the database.");
//
//            }
//        }


    }


    public static void main(String[] args) throws Exception {

        final Backend backend = new Backend();

        final Server server = new Server(8080);
        server.setHandler(backend.handler);
        server.start();
        server.join();

    }


}
