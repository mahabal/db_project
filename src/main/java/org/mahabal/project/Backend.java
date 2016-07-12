package org.mahabal.project;

import com.zaxxer.hikari.HikariDataSource;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.mahabal.project.servlet.LoginServlet;
import org.mahabal.project.servlet.RegisterServlet;
import org.skife.jdbi.v2.DBI;

public class Backend {

    private final ServletHandler handler = new ServletHandler();

    private Backend() throws Exception {

        // setup the connection to the database
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl("jdbc:mysql://localhost:3306/project");
        ds.setUsername("root");
        ds.setPassword("b&");

        // set the datasource for jDBI
        final DBI dbi = new DBI(ds);

        // setup all of the handlers
        handler.addServletWithMapping(new ServletHolder(new RegisterServlet(dbi)), "/register");
        handler.addServletWithMapping(new ServletHolder(new LoginServlet(dbi)), "/login");
    }


    public static void main(String[] args) throws Exception {

        final Backend backend = new Backend();

        final Server server = new Server(8080);
        server.setHandler(backend.handler);
        server.start();
        server.join();

    }


}
