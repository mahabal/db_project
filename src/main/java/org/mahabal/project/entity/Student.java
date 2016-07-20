package org.mahabal.project.entity;

import org.skife.jdbi.v2.StatementContext;
import org.skife.jdbi.v2.sqlobject.Bind;
import org.skife.jdbi.v2.sqlobject.BindBean;
import org.skife.jdbi.v2.sqlobject.SqlQuery;
import org.skife.jdbi.v2.sqlobject.SqlUpdate;
import org.skife.jdbi.v2.sqlobject.customizers.RegisterMapper;
import org.skife.jdbi.v2.tweak.ResultSetMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class Student {

    private int sid;

    public void setUid(int uid) {
        this.uid = uid;
    }

    private int uid;
    private String username;
    private String password;
    private String email;
    private String salt;
    private Timestamp created;

    public Student(final int sid, final int uid, final String username, final String passwordHash, final String salt,
                   final Timestamp created, final String email) {
        this.sid = sid;
        this.uid = uid;
        this.username = username;
        this.password = passwordHash;
        this.salt = salt;
        this.created = created;
        this.email = email;
    }

    public int getSid() {
        return sid;
    }

    public int getUid() {
        return uid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public String getSalt() {
        return salt;
    }

    public Timestamp getCreated() {
        return created;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @RegisterMapper(Mapper.class)
    public static interface Queries {

        @SqlQuery("select * from student where sid = :id")
        Student findById(@Bind("id") int id);

        @SqlQuery("select count(*) from student")
        long count();

        @SqlUpdate("update student set username = :username where sid = :sid")
        int updateUsername(@BindBean Student s);

        @SqlUpdate("update student set uid = :uid where sid = :sid")
        int updateUid(@BindBean Student s);

        @SqlQuery("select * from rso_data o, rso_membership r where o.rid = r.rid and o.uid = :s.uid and r.sid = :s.sid")
        @RegisterMapper(Organization.Mapper.class)
        List<Organization> getOrganizations(@BindBean("s") Student s);

    }

    public static class Mapper implements ResultSetMapper<Student> {

        @Override
        public Student map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return new Student(
                    r.getInt("sid"),
                    r.getInt("uid"),
                    r.getString("username"),
                    r.getString("password"),
                    r.getString("salt"),
                    r.getTimestamp("created"),
                    r.getString("email")
            );
        }

    }
}
