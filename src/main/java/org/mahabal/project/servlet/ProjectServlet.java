package org.mahabal.project.servlet;

import org.skife.jdbi.v2.DBI;

import javax.servlet.http.HttpServlet;

public abstract class ProjectServlet extends HttpServlet {

    protected final DBI dbi;

    public ProjectServlet(final DBI dbi) {
        this.dbi = dbi;
    }

}
