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

public class Student {

    private int sid;
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

    public String getPassword() {
        return password;
    }

    public String getSalt() {
        return salt;
    }

    public Timestamp getCreated() {
        return created;
    }

    public void setUsername(String username) {
        this.username = username;
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
        int update(@BindBean Student s);

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
