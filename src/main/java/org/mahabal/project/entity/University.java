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

public class University {

    private final int uid;
    private String name;
    private String domain;
    private int sid;
    private final Timestamp created;
    private final double latitude;
    private final double longitude;
    private String desc;

    public University(int uid, String name, String domain, int sid, Timestamp created, double latitude, double longitude, String desc) {
        this.uid = uid;
        this.name = name;
        this.domain = domain;
        this.sid = sid;
        this.created = created;
        this.latitude = latitude;
        this.longitude = longitude;
        this.desc = desc;
    }

    public int getUid() {
        return uid;
    }

    public String getName() {
        return name;
    }

    public String getDomain() {
        return domain;
    }

    public int getSid() {
        return sid;
    }

    public Timestamp getCreated() {
        return created;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String getDesc() {
        return desc;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    public void setSid(int sid) {
        this.sid = sid;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    @RegisterMapper(Mapper.class)
    public interface Queries {

        @SqlQuery("select uid from university where domain = :domain")
        int getUidByDomain(@Bind("domain") String domain);

        @SqlQuery("select count(*) from university")
        long count();

        @SqlUpdate("insert into university (name, domain, sid, latitude, longitude, desc) values (:name, :domain, :s.sid, :latitude, :longitude, :desc)")
        int create(@Bind("name") String n, @Bind("domain") String domain, @Bind("latitude") double latitude,
                   @Bind("longitude") double longitude, @Bind("desc") String desc, @BindBean("s") Student s);

        @SqlQuery("select count(distinct(rid)) from rso_data where uid = :uid")
        int organizationCount(@Bind("uid") int uid);

        @SqlQuery("select * from rso_data where uid = :uid")
        @RegisterMapper(Organization.Mapper.class)
        List<Organization> organizations(@Bind("uid") int uid);

    }

    public static class Mapper implements ResultSetMapper<University> {
        @Override
        public University map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return null;
        }
    }

}