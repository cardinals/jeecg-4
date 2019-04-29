package org.jeecgframework.web.system.service;

import java.util.List;

import org.jeecgframework.web.system.pojo.base.AttachmentEntity;

import org.jeecgframework.core.common.service.CommonService;

/**
 * 
 * @author  张代浩
 *
 */
public interface DeclareService extends CommonService{
	
	public List<AttachmentEntity> getAttachmentsByCode(String businessKey,String description);
	
}
