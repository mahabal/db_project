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
    private final Timestamp created;
    private final double latitude;
    private final double longitude;
    private String name;
    private String domain;
    private int sid;
    private String desc;
    private String motto;
    private String image;

    public University(int uid, String name, String domain, int sid, Timestamp created, double latitude, double longitude, String desc, String motto, String image) {
        this.uid = uid;
        this.name = name;
        this.domain = domain;
        this.sid = sid;
        this.created = created;
        this.latitude = latitude;
        this.longitude = longitude;
        this.desc = desc;
        this.motto = motto;
        this.image = image;
    }

    public String getMotto() {
        return motto;
    }

    public void setMotto(String motto) {
        this.motto = motto;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getUid() {
        return uid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    public int getSid() {
        return sid;
    }

    public void setSid(int sid) {
        this.sid = sid;
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
        long organizationCount(@Bind("uid") int uid);


        @SqlQuery("select count(distinct(sid)) from student where uid = :uid")
        long studentCount(@Bind("uid") int uid);

        @SqlQuery("select * from rso_data where uid = :uid")
        @RegisterMapper(Organization.Mapper.class)
        List<Organization> organizations(@Bind("uid") int uid);

        @SqlQuery("select * from university u where u.sid = :s.sid")
        List<University> getByAdmin(@BindBean("s") Student s);

        @SqlQuery("select * from university where uid = :uid")
        University getById(@Bind("uid") int uid);

        @SqlQuery("select name from university where uid = :uid")
        String getNameById(@Bind("uid") int uid);


    }

    public static class Mapper implements ResultSetMapper<University> {
        @Override
        public University map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return new University(r.getInt("uid"), r.getString("name"), r.getString("domain"), r.getInt("sid"), r.getTimestamp("created"),
                    r.getDouble("latitude"), r.getDouble("longitude"), r.getString("desc"), r.getString("motto"), r.getString("image"));
        }
    }

}
