package org.mahabal.project.entity;

import org.skife.jdbi.v2.StatementContext;
import org.skife.jdbi.v2.sqlobject.BindBean;
import org.skife.jdbi.v2.sqlobject.SqlQuery;
import org.skife.jdbi.v2.sqlobject.SqlUpdate;
import org.skife.jdbi.v2.sqlobject.customizers.RegisterMapper;
import org.skife.jdbi.v2.tweak.ResultSetMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public final class Event {

    private final int eid;
    private int scope;
    private int aid;
    private String name;
    private String desc;
    private Timestamp created;
    private Timestamp date;
    private String location;
    private double latitude;
    private double longitude;
    private String contactname;
    private String contactphone;
    private String contactemail;

    public Event(int scope, int aid, String name, String desc, Timestamp date, String location, String contactname, String contactphone, String contactemail) {
        this(0, scope, aid, name, desc, null, date, location, 0, 0, contactname, contactphone, contactemail);
    }

    public Event(int eid, int scope, int aid, String name, String desc, Timestamp created, Timestamp date, String location,
                 double latitude, double longitude, String contactname, String contactphone, String contactemail) {
        this.eid = eid;
        this.scope = scope;
        this.aid = aid;
        this.name = name;
        this.desc = desc;
        this.created = created;
        this.date = date;
        this.location = location;
        this.latitude = latitude;
        this.longitude = longitude;
        this.contactname = contactname;
        this.contactphone = contactphone;
        this.contactemail = contactemail;
    }

    public int getEid() {
        return eid;
    }

    public int getScope() {
        return scope;
    }

    public void setScope(int scope) {
        this.scope = scope;
    }

    public int getAid() {
        return aid;
    }

    public void setAid(int aid) {
        this.aid = aid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public Timestamp getCreated() {
        return created;
    }

    public void setCreated(Timestamp created) {
        this.created = created;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getContactname() {
        return contactname;
    }

    public void setContactname(String contactname) {
        this.contactname = contactname;
    }

    public String getContactphone() {
        return contactphone;
    }

    public void setContactphone(String contactphone) {
        this.contactphone = contactphone;
    }

    public String getContactemail() {
        return contactemail;
    }

    public void setContactemail(String contactemail) {
        this.contactemail = contactemail;
    }

    @RegisterMapper(Mapper.class)
    public interface Queries {

        /**
         * @return      number of events in the database
         */
        @SqlQuery("select count(*) from events")
        long count();

        @SqlQuery("select count(*) from events where scope = 0")
        long countPublic();

        @SqlQuery("select count(*) from events where scope = 1")
        long countPrivate();

        @SqlQuery("select * from events where scope = 1 and aid = :u.uid")
        List<Event> allPrivate(@BindBean("u") University u);

        @SqlQuery("select count(*) from events where (scope = 1 or scope = 0) and aid = :u.uid")
        long count(@BindBean("u") University u);

        @SqlQuery("select * from events")
        List<Event> all();



        @SqlUpdate("insert into events (`eid`, `scope`, `aid`, `name`, `desc`, `date`, `location`, `latitude`, `longitude`, `contactname`, `contactphone`, `contactemail`) values (:e.eid, :e.scope, :e.aid, :e.name, :e.desc, :e.date, :e.location, :e.latitude, :e.longitude, :e.contactname, :e.contactphone, :e.contactemail)")
        int insert(@BindBean("e") Event e);

    }

    public static class Mapper implements ResultSetMapper<Event> {
        @Override
        public Event map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return new Event(r.getInt("eid"), r.getInt("scope"), r.getInt("aid"), r.getString("name"), r.getString("desc"), r.getTimestamp("created"),
                    r.getTimestamp("date"), r.getString("location"), r.getDouble("latitude"), r.getDouble("longitude"), r.getString("contactname"),
                    r.getString("contactphone"), r.getString("contactemail"));
        }
    }

}
