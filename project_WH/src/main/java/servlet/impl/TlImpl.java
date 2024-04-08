package servlet.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.DTO.SdDTO;
import servlet.DTO.SggDTO;
import servlet.service.TlService;

@Service("TlService")
public class TlImpl implements TlService{

	@Autowired
	private TlDAO tlDAO;

	@Override
	public List<SdDTO> selectSd() {
		// TODO Auto-generated method stub
		return tlDAO.selectSd();
	}

	@Override
	public List<Map<String, Object>> selectSgg(String name) {
		// TODO Auto-generated method stub
		return tlDAO.selectSgg(name);
	}

	@Override
	public List<Map<String, Object>> selectGeom(String name) {
		// TODO Auto-generated method stub
		return tlDAO.selectGeom(name);
	}

	@Override
	public List<Map<String, Object>> selectbjdGeom(String sggnm) {
		// TODO Auto-generated method stub
		return tlDAO.selectbjdGeom(sggnm);
	}

	@Override
	public List<Map<String, Object>> selectLegend(String legendFlag,String sggno) {
		// TODO Auto-generated method stub
		return tlDAO.selectLegend(legendFlag,sggno);
	}

	@Override
	public List<Map<String, Object>> getChart(String sdcd) {
		// TODO Auto-generated method stub
		return tlDAO.getChart(sdcd);
	}

	@Override
	public List<Map<String, Object>> sdChart() {
		// TODO Auto-generated method stub
		return tlDAO.sdChart();
	}

}
