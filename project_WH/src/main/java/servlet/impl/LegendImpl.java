package servlet.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.service.LegendService;

@Service("LegendService")
public class LegendImpl implements LegendService{
	
	@Autowired
	private LegendDAO legendDAO;
	
	@Override
	public Map<String, Object> getLegend(String sggno) {
		// TODO Auto-generated method stub
		return legendDAO.getLegend(sggno);
	}

}
