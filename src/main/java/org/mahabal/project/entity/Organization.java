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

public class Organization {

    private final int rid;
    private String name;
    private String desc;
    private final Timestamp created;
    private int sid;
    private int uid;
    private int approved;

    public Organization(int rid, String name, String desc, Timestamp created, int sid, int uid, final int approved) {
        this.rid = rid;
        this.name = name;
        this.desc = desc;
        this.created = created;
        this.sid = sid;
        this.uid = uid;
        this.approved = approved;
    }

    public int getRid() {
        return rid;
    }

    public String getName() {
        return name;
    }

    public String getDesc() {
        return desc;
    }

    public Timestamp getCreated() {
        return created;
    }

    public int getSid() {
        return sid;
    }

    public int getUid() {
        return uid;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public void setSid(int sid) {
        this.sid = sid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public int getApproved() {
        return approved;
    }

    public void setApproved(int approved) {
        this.approved = approved;
    }

    @RegisterMapper(Mapper.class)
    public static interface Queries {

        @SqlQuery("select * from rso_data")
        List<Organization> all();

        @SqlQuery("select count(*) from rso_data")
        long count();

        @SqlQuery("select count(*) from rso_data where approved = 0")
        long unapprovedCount();

        @SqlUpdate("update rso_data r, university u set r.approved = 1 where r.rid = :rid and r.uid = u.uid and u.sid = :s.sid")
        int approve(@Bind("rid") int rid, @BindBean("s") Student s);

        @SqlUpdate("insert into rso_membership (`rid`, `sid`) values (:rid, :s.sid)")
        int join(@Bind("rid") int rid, @BindBean("s") Student s);

        @SqlQuery("select * from rso_data where uid = :s.uid and rid not in (select distinct(rid) from rso_membership rm where rm.sid = :s.sid)")
        List<Organization> canJoin(@BindBean("s") Student s);

        @SqlUpdate("insert into rso_data (`name`, `desc`, `sid`, `uid`) values (:name, :desc, :s.sid, :s.uid)")
        int create(@Bind("name") String name, @Bind("desc") String desc, @BindBean("s") Student s);

        @SqlQuery("select count(distinct(sid)) from rso_membership where rid = :rid")
        long memberCount(@Bind("rid") int rid);

        @SqlQuery("select * from student s, rso_data r where s.sid = r.sid and r.rid = :rid")
        @RegisterMapper(Student.Mapper.class)
        Student admin(@Bind("rid") int rid);

        @SqlQuery("select * from rso_data where sid = :sid")
        List<Organization> getByAdminId(@Bind("sid") int sid);

        @SqlQuery("select * from rso_data where sid = :s.sid")
        List<Organization> getByAdmin(@BindBean("s") Student s);

    }


    public static class Mapper implements ResultSetMapper<Organization> {
        @Override
        public Organization map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return new Organization(
                    r.getInt("rid"),
                    r.getString("name"),
                    r.getString("desc"),
                    r.getTimestamp("created"),
                    r.getInt("sid"),
                    r.getInt("uid"),
                    r.getInt("approved")
            );
        }
    }

}
