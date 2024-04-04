package servlet.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.DTO.SdDTO;
import servlet.DTO.SggDTO;

@Repository
public class TlDAO extends EgovComAbstractDAO{
	
	@Autowired
	private SqlSession sqlsession;
	
	public List<SdDTO> selectSd(){
		// TODO Auto-generated method stub
		return selectList("tl.selectSd");
	}

	public List<Map<String, Object>> selectSgg(String name) {
		// TODO Auto-generated method stub
		return selectList("tl.selectSgg",name);
	}

	public List<Map<String, Object>> selectGeom(String name) {
		// TODO Auto-generated method stub
		return sqlsession.selectList("tl.selectGeom",name);
	}

	public List<Map<String, Object>> selectbjdGeom(String sggnm) {
		// TODO Auto-generated method stub
		return sqlsession.selectList("tl.selectbjdGeom",sggnm);
	}

	public List<Map<String, Object>> selectLegend(String legendFlag) {
		// TODO Auto-generated method stub
		if(Integer.parseInt(legendFlag) == 1) {
			return sqlsession.selectList("tl.selectLegend1");			
		} else {
			return sqlsession.selectList("tl.selectLegend2");
		}
	}

	public List<Map<String, Object>> getChart(String sdcd) {
		// TODO Auto-generated method stub
		return sqlsession.selectList("tl.getChart",sdcd);
	}

	public List<Map<String, Object>> sdChart() {
		// TODO Auto-generated method stub
		return sqlsession.selectList("tl.sdChart");
	}

}
