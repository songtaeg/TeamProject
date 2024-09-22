package com.example.bagStrap.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.bagStrap.dao.CSCenterService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CSCenterController {
	
	@Autowired
	CSCenterService csService;
	
	@RequestMapping("/cscenter") 
    public String CScenter(Model model) throws Exception{
         return "cscenter";
    }
	
	@RequestMapping("/noticelist") 
    public String noticelist(Model model) throws Exception{
         return "noticelist";
    }
	
	@RequestMapping("/noticedetail") 
    public String noticedetail(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		 System.out.println(map);
		 request.setAttribute("noticeId", map.get("noticeId"));
         return "noticedetail";
    }
	@RequestMapping("/faqlist") 
    public String faqlist(Model model) throws Exception{
         return "faqlist";
    }
	@RequestMapping("/cslist") 
    public String cslist(Model model) throws Exception{
         return "cslist";
    }
	
	@RequestMapping(value = "/notice-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String NoticeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		//System.out.println(map);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap=csService.NoticeList(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/notice-detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String NoticeDetail( Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		//System.out.println(map);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap=csService.searchNoticeInfo(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/cs-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String CSList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		//System.out.println(map);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap=csService.searchCS(map);

		return new Gson().toJson(resultMap);
	}

}
