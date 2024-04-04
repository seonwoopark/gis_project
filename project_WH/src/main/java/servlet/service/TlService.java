package servlet.service;

import java.util.List;
import java.util.Map;

import servlet.DTO.SdDTO;

public interface TlService {

	List<SdDTO> selectSd();


	List<Map<String, Object>> selectSgg(String name);


	List<Map<String, Object>> selectGeom(String name);


	List<Map<String, Object>> selectbjdGeom(String sggnm);


	List<Map<String, Object>> selectLegend(String legendFlag);


	List<Map<String, Object>> getChart(String sdmn);


	List<Map<String, Object>> sdChart();
}
