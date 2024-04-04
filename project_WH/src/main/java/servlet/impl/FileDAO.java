package servlet.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FileDAO extends EgovComAbstractDAO{

	@Autowired
	private SqlSession sqlsession;
	
	public void uploadFile(List<Map<String, Object>> list) {
		
		for(int i=0; i<list.size();i++) {
			Map<String, Object> map = list.get(i);
			sqlsession.insert("file.uploadFile", map);	
		}
	}

}
