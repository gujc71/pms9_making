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

import gu.common.SearchVO;

@Service
public class ProjectSvc {

    @Autowired
    private SqlSessionTemplate sqlSession;    
    @Autowired
    private DataSourceTransactionManager txManager;

    static final Logger LOGGER = LoggerFactory.getLogger(ProjectSvc.class);
    
    /**
     * 리스트.
     */
    public Integer selectProjectCount(SearchVO param) {
        return sqlSession.selectOne("selectProjectCount", param);
    }
    
    public List<?> selectProjectList(SearchVO param) {
        return sqlSession.selectList("selectProjectList", param);
    }
    
    /**
     * 저장.
     */
    public void insertProject(ProjectVO param) {
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
        TransactionStatus status = txManager.getTransaction(def);
        
        try {
            if (param.getPrno()==null || "".equals(param.getPrno())) {
                sqlSession.insert("insertProject", param);
            } else {
                sqlSession.update("updateProject", param);
            }
            txManager.commit(status);
        } catch (TransactionException ex) {
            txManager.rollback(status);
            LOGGER.error("insertProject");
        }            
    }

    /**
     * 읽기.
     */
    public ProjectVO selectProjectOne(ProjectVO param) {
        return sqlSession.selectOne("selectProjectOne", param);
    }

    /**
     * 삭제.
     */
    public void deleteProject(ProjectVO param) {
        sqlSession.update("deleteProject", param);
    }

}
