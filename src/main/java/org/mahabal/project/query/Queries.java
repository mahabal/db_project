package org.mahabal.project.query;

import org.mahabal.project.entity.Organization;
import org.mahabal.project.entity.Student;
import org.skife.jdbi.v2.sqlobject.Bind;
import org.skife.jdbi.v2.sqlobject.BindBean;
import org.skife.jdbi.v2.sqlobject.SqlQuery;
import org.skife.jdbi.v2.sqlobject.customizers.RegisterMapper;

import java.util.List;

public interface Queries {

    @SqlQuery("select * from student s, rso_data r where r.rid = :r.rid and s.sid = :r.sid")
    @RegisterMapper(Student.Mapper.class)
    Student getAdminByOrganization(@BindBean("r") Organization o);

    @SqlQuery("select * from rso_data where sid = :sid")
    @RegisterMapper(Organization.Mapper.class)
    List<Organization> getOrganizationsByAdminId(@Bind("sid") int sid);

}
