package servlet.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.service.FileService;

@Service("FileService")
public class FileImpl implements FileService{
	
	@Autowired
	private FileDAO fileDAO;

	@Override
	public void uploadFile(List<Map<String, Object>> list) {
		// TODO Auto-generated method stub
		fileDAO.uploadFile(list);
	}
	
	
}
