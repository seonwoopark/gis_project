package servlet.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import servlet.DTO.SdDTO;
import servlet.DTO.SggDTO;
import servlet.service.ServletService;
import servlet.service.TlService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@Resource(name="TlService")
	private TlService TlService;
	
	@GetMapping("/text.do")
	public String text(ModelMap model) {
		List<SdDTO> list = TlService.selectSd();
		model.addAttribute("sdlist",list);
		return "main/text";
	}
	
	@GetMapping(value = "/main.do")
	public String mainTest(ModelMap model) throws Exception {
		List<SdDTO> list = TlService.selectSd();
		model.addAttribute("sdlist",list);
		
		return "main/main";
	}
}
