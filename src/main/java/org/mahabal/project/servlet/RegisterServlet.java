package org.mahabal.project.servlet;

import com.google.common.hash.Hashing;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;

public final class RegisterServlet extends ProjectServlet {

    public RegisterServlet(DBI dbi) {
        super(dbi);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // load the requested username and password from the request
        String username = req.getParameter("u");
        String email = req.getParameter("e");
        String md5pass = req.getParameter("m");

        // check and make sure the username and password are not null
        if (username == null || email == null || md5pass == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Handle h = dbi.open()) {
            // query the `student` table to search for the username
            List<Map<String, Object>> user = h.select("select uid from student where username = ?",
                    username.toLowerCase());
            if (user.size() == 0) {
                // since there are no users in the return set, there is no user with the same username.
                resp.setStatus(HttpServletResponse.SC_OK);
                // generate a salt to use with hashing the password
                final String salt = Hashing.sha512().hashString(String.valueOf(System.currentTimeMillis()),
                        Charset.forName("UTF-8")).toString();
                // generate a newly salted hash from the md5 password
                String pwHash = Hashing.sha512().hashString(salt + md5pass, Charset.forName("UTF-8")).toString();
                h.insert("insert into student (username, password, salt, email) values(?,?,?,?)",
                        username, pwHash, salt, email);
                //TODO: Generate a new session into the session table.
            } else {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().println("user exists.");
            }
        }
        super.doGet(req, resp);
    }

}
