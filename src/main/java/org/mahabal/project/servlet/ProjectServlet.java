package org.mahabal.project.servlet;

import org.skife.jdbi.v2.DBI;

import javax.servlet.http.HttpServlet;

public abstract class ProjectServlet extends HttpServlet {

    final DBI dbi;

    ProjectServlet(final DBI dbi) {
        this.dbi = dbi;
    }

}
