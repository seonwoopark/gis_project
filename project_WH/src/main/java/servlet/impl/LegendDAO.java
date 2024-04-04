package servlet.impl;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository	
public class LegendDAO {
	@Autowired
	private SqlSession sqlsession;

	public Map<String, Object> getLegend(String sggno) {
		// TODO Auto-generated method stub
		return sqlsession.selectOne("legend.getLegend", sggno);
	}

}
