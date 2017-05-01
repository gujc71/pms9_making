package gu.project;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionException;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import gu.common.Field3VO;

@Service
public class TaskSvc {

    @Autowired
    private SqlSessionTemplate sqlSession;    

    @Autowired
    private DataSourceTransactionManager txManager;

    static final Logger LOGGER = LoggerFactory.getLogger(ProjectSvc.class);
    
    /**
     * Task 저장.
     */
    public List<?> selectTaskList(String param) {
        return sqlSession.selectList("selectTaskList", param);
    }
    /**
     * Task 저장.
     */
    public void insertTask(TaskVO param) {
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
        TransactionStatus status = txManager.getTransaction(def);
        
        try {
	        if (param.getTsno() == null || "N".equals(param.getTsno())) {
	            if ("".equals(param.getTsparent())) {
	            	param.setTsparent(null); 
	            }
	            sqlSession.insert("insertTask", param);
	        } else {
	            sqlSession.update("updateTask", param);
	            sqlSession.delete("deleteTaskUser", param.getTsno());
	        }
	        String userno = param.getUserno();
	        if (userno!=null) {
	        	Field3VO fld = new Field3VO(param.getTsno(), null, null);
	        	String[] usernos = userno.split(",");
	        	for (int i=0; i< usernos.length; i++){
	        		if ("".equals(usernos[i])) {continue;}
	        		fld.setField2(usernos[i]);
		            sqlSession.update("insertTaskUser", fld);
	        	}
	        }
            txManager.commit(status);
        } catch (TransactionException ex) {
            txManager.rollback(status);
            LOGGER.error("insertTask");
        }  
    }
 
    public void deleteTask(String param) {
        sqlSession.delete("deleteTask", param);
    }
    
    
}
