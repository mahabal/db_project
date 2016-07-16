package org.mahabal.project.entity;

import org.skife.jdbi.v2.StatementContext;
import org.skife.jdbi.v2.sqlobject.Bind;
import org.skife.jdbi.v2.sqlobject.SqlQuery;
import org.skife.jdbi.v2.sqlobject.customizers.RegisterMapper;
import org.skife.jdbi.v2.tweak.ResultSetMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class Session {

    private final Timestamp created;
    private final int sid;
    private final String ip;
    private final String token;

    public Session(Timestamp created, int sid, String ip, String token) {
        this.created = created;
        this.sid = sid;
        this.ip = ip;
        this.token = token;
    }

    public Timestamp getCreated() {
        return created;
    }

    public int getSid() {
        return sid;
    }

    public String getIp() {
        return ip;
    }

    public String getToken() {
        return token;
    }


    @RegisterMapper(Mapper.class)
    public interface Queries {

        @SqlQuery("select * from session where sid = :sid and ip = INET6_ATON(:ip) and token = :token")
        Session get(@Bind("sid") int sid, @Bind("ip") String ip, @Bind("token") String token);

        @SqlQuery("select count(*) from session")
        long count();

        @SqlQuery("select count(*) from session where created > now() - interval 1 day")
        long activeCount();

    }

    public static class Mapper implements ResultSetMapper<Session> {
        @Override
        public Session map(int index, ResultSet r, StatementContext ctx) throws SQLException {
            return new Session(r.getTimestamp("created"), r.getInt("sid"), r.getString("ip"), r.getString("token"));
        }
    }

}
