package gu.project;

import java.util.List;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import gu.common.SearchVO;
import gu.etc.EtcSvc;

@Controller 
public class ProjectCtr {

    @Autowired
    private ProjectSvc projectSvc;
    
    @Autowired
    private EtcSvc etcSvc; 
    
    static final Logger LOGGER = LoggerFactory.getLogger(ProjectCtr.class);
    
    /**
     * 리스트.
     */
    @RequestMapping(value = "/projectList")
    public String projectList(HttpServletRequest request, SearchVO searchVO, ModelMap modelMap) {
        // 페이지 공통: alert
        String userno = request.getSession().getAttribute("userno").toString();
        
        Integer alertcount = etcSvc.selectAlertCount(userno);
        modelMap.addAttribute("alertcount", alertcount);
    	
        // CRUD 관련
        searchVO.pageCalculate( projectSvc.selectProjectCount(searchVO) ); // startRow, endRow
        List<?> listview  = projectSvc.selectProjectList(searchVO);
        
        modelMap.addAttribute("searchVO", searchVO);
        modelMap.addAttribute("listview", listview);
        
        return "project/ProjectList";
    }
    
    /** 
     * 쓰기. 
     */
    @RequestMapping(value = "/projectForm")
    public String projectForm(HttpServletRequest request, ProjectVO projectInfo, ModelMap modelMap) {
        // 페이지 공통: alert
        String userno = request.getSession().getAttribute("userno").toString();
        
        Integer alertcount = etcSvc.selectAlertCount(userno);
        modelMap.addAttribute("alertcount", alertcount);
    	
        // CRUD 관련
        if (projectInfo.getPrno() != null) {
            projectInfo = projectSvc.selectProjectOne(projectInfo);
        
            modelMap.addAttribute("projectInfo", projectInfo);
        }
        
        return "project/ProjectForm";
    }
    
    /**
     * 저장.
     */
    @RequestMapping(value = "/projectSave")
    public String projectSave(HttpServletRequest request, ProjectVO projectInfo, ModelMap modelMap) {
        String userno = request.getSession().getAttribute("userno").toString();
    	projectInfo.setUserno(userno);
    	
        projectSvc.insertProject(projectInfo);

        return "redirect:/projectList";
    }

    /**
     * 읽기.
     */
    @RequestMapping(value = "/projectRead")
    public String projectRead(HttpServletRequest request, ProjectVO projectVO, ModelMap modelMap) {
        // 페이지 공통: alert
        String userno = request.getSession().getAttribute("userno").toString();
        
        Integer alertcount = etcSvc.selectAlertCount(userno);
        modelMap.addAttribute("alertcount", alertcount);
    	
        // CRUD 관련
        
        ProjectVO projectInfo = projectSvc.selectProjectOne(projectVO);

        modelMap.addAttribute("projectInfo", projectInfo);
        
        return "project/ProjectRead";
    }
    
    /**
     * 삭제.
     */
    @RequestMapping(value = "/projectDelete")
    public String projectDelete(HttpServletRequest request, ProjectVO projectVO) {

        projectSvc.deleteProject(projectVO);
        
        return "redirect:/projectList";
    }
   
}
