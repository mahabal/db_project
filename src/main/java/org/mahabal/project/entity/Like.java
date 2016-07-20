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

public final class Like {

    private final int lid;
    private final int eid;
    private final int sid;
    private final Timestamp time;

    public Like(int lid,int sid, int eid, Timestamp time) {
        this.lid = lid;
        this.sid = sid;
        this.eid = eid;
        this.time = time;
    }

    public int getLid() {
        return lid;
    }

    public int getEid() {
        return eid;
    }

    public int getSid() {
        return sid;
    }

    public Timestamp getTime() {
        return time;
    }

    @RegisterMapper(Mapper.class)
    public interface Queries {

        @SqlQuery("select count(*) from likes where eid = :e.eid")
        long count(@BindBean("e") Event e);

        @SqlQuery("select count(*) from likes where eid = :eid")
        long count(@Bind("eid") int eid);

        @SqlQuery("select * from likes where sid = :sid and eid = :eid")
        Like get(@Bind("sid") int sid, @Bind("eid") int eid);

        @SqlUpdate("insert into likes (`sid`, `eid`) values (:sid, :eid)")
        int insert(@Bind("sid") int sid, @Bind("eid") int eid);


        @SqlUpdate("delete from likes where sid = :sid and eid = :eid")
        int delete(@Bind("sid") int sid, @Bind("eid") int eid);

    }

    public static class Mapper implements ResultSetMapper<Like> {
        @Override
        public Like map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return new Like(r.getInt("lid"), r.getInt("sid"), r.getInt("eid"), r.getTimestamp("created"));
        }
    }

}
