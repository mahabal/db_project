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

public final class Message {

    private final int mid;
    private final int eid;
    private final int sid;
    private String message;
    private final Timestamp time;

    public Message(int mid, int eid, int sid, String message, Timestamp time) {
        this.mid = mid;
        this.eid = eid;
        this.sid = sid;
        this.message = message;
        this.time = time;
    }

    public int getMid() {
        return mid;
    }

    public int getEid() {
        return eid;
    }

    public int getSid() {
        return sid;
    }

    public String getMessage() {
        return message;
    }

    public Timestamp getTime() {
        return time;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @RegisterMapper(Mapper.class)
    public interface Queries {

        @SqlUpdate("insert into message (`eid`, `sid`, `message`) values (:eid, :sid, :message")
        int insert(@Bind("eid") int eid, @Bind("sid") int sid, @Bind("message") String message);

        @SqlQuery("select * from message where eid = :e.eid")
        List<Message> getAll(@BindBean("e") Event e);

        @SqlQuery("select * from message where eid = :e.eid order by mid desc")
        List<Message> getAllDesc(@BindBean("e") Event e);

        @SqlQuery("select * from student where sid = :m.sid")
        @RegisterMapper(Student.Mapper.class)
        Student getPoster(@BindBean("m") Message m);

    }

    public static class Mapper implements ResultSetMapper<Message> {
        @Override
        public Message map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return new Message(r.getInt("mid"), r.getInt("eid"), r.getInt("sid"), r.getString("message"), r.getTimestamp("created"));
        }
    }

}
