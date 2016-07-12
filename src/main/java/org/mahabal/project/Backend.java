package org.mahabal.project;

import com.google.gson.Gson;
import com.zaxxer.hikari.HikariDataSource;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.mahabal.project.servlet.RegisterServlet;
import org.skife.jdbi.v2.DBI;

import java.nio.charset.Charset;

public class Backend {

    private final ServletHandler handler = new ServletHandler();
    final Charset UTF8 = Charset.forName("UTF-8");
    final Gson gson = new Gson();

    final DBI dbi;

    Backend() throws Exception {

        // setup the connection to the database
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl("jdbc:mysql://localhost:3306/project");
        ds.setUsername("root");
        ds.setPassword("b&");

        // set the datasource for jDBI
        dbi = new DBI(ds);

        // setup all of the handlers
        handler.addServletWithMapping(new ServletHolder(new RegisterServlet(dbi)), "/register");



    }


    public static void main(String[] args) throws Exception {

        final Backend backend = new Backend();

        final Server server = new Server(8080);
        server.setHandler(backend.handler);
        server.start();
        server.join();

    }


}
