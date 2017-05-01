package gu.project;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import gu.common.UtilEtc;

@Controller 
public class TaskCtr {

    @Autowired
    private TaskSvc taskSvc;
    
    static final Logger LOGGER = LoggerFactory.getLogger(ProjectCtr.class);
    
    /**
     * Task 저장.
     */
    @RequestMapping(value = "/taskSave")
    public void taskSave(HttpServletRequest request, HttpServletResponse response, TaskVO taskInfo) {
        
    	taskSvc.insertTask(taskInfo);
        
        UtilEtc.responseJsonValue(response, taskInfo.getTsno());
    }
    
    /**
     * Task 삭제.
     */
    @RequestMapping(value = "/taskDelete")
    public void taskDelete(HttpServletRequest request, HttpServletResponse response) {
        String tsno = request.getParameter("tsno");

        taskSvc.deleteTask(tsno);
        
        UtilEtc.responseJsonValue(response, "OK");
    }
    
    
}
