package org.jeecgframework.web.system.service.impl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.lang.StringUtils;
import org.jeecgframework.core.common.service.impl.CommonServiceImpl;
import org.jeecgframework.core.util.ApplicationContextUtil;
import org.jeecgframework.core.util.MyClassLoader;
import org.jeecgframework.core.util.StringUtil;
import org.jeecgframework.web.cgform.enhance.CgformEnhanceJavaInter;
import org.jeecgframework.web.system.enums.InterfaceEnum;
import org.jeecgframework.web.system.pojo.base.InterfaceRuleDto;
import org.jeecgframework.web.system.pojo.base.InterfaceDdataRuleEntity;
import org.jeecgframework.web.system.pojo.base.InterfaceEntity;
import org.jeecgframework.web.system.service.InterfaceService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("tSInterfaceService")
@Transactional
public class TSInterfaceServiceImpl extends CommonServiceImpl implements InterfaceService {


	public void delete(InterfaceEntity entity) throws Exception{
		super.delete(entity);
		//执行删除操作增强业务
		this.doDelBus(entity);
	}

	public Serializable save(InterfaceEntity entity) throws Exception{
		Serializable t = super.save(entity);
		//执行新增操作增强业务
		this.doAddBus(entity);
		return t;
	}

	public void saveOrUpdate(InterfaceEntity entity) throws Exception{
		super.saveOrUpdate(entity);
		//执行更新操作增强业务
		this.doUpdateBus(entity);
	}

	/**
	 * 新增操作增强业务
	 * @param t
	 * @return
	 */
	private void doAddBus(InterfaceEntity t) throws Exception{
	}
	/**
	 * 更新操作增强业务
	 * @param t
	 * @return
	 */
	private void doUpdateBus(InterfaceEntity t) throws Exception{
	}
	/**
	 * 删除操作增强业务
	 * @param id
	 * @return
	 */
	private void doDelBus(InterfaceEntity t) throws Exception{
	}

	private Map<String,Object> populationMap(InterfaceEntity t){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("id", t.getId());
		map.put("create_name", t.getCreateName());
		map.put("create_by", t.getCreateBy());
		map.put("create_date", t.getCreateDate());
		map.put("update_name", t.getUpdateName());
		map.put("update_by", t.getUpdateBy());
		map.put("update_date", t.getUpdateDate());
		map.put("interface_name", t.getInterfaceName());
		map.put("interface_order", t.getInterfaceOrder());
		map.put("interface_url", t.getInterfaceUrl());
		return map;
	}

	/**
	 * 替换sql中的变量
	 * @param sql
	 * @param t
	 * @return
	 */
	public String replaceVal(String sql,InterfaceEntity t){
		sql  = sql.replace("#{id}",String.valueOf(t.getId()));
		sql  = sql.replace("#{create_name}",String.valueOf(t.getCreateName()));
		sql  = sql.replace("#{create_by}",String.valueOf(t.getCreateBy()));
		sql  = sql.replace("#{create_date}",String.valueOf(t.getCreateDate()));
		sql  = sql.replace("#{update_name}",String.valueOf(t.getUpdateName()));
		sql  = sql.replace("#{update_by}",String.valueOf(t.getUpdateBy()));
		sql  = sql.replace("#{update_date}",String.valueOf(t.getUpdateDate()));
		sql  = sql.replace("#{interface_name}",String.valueOf(t.getInterfaceName()));
		sql  = sql.replace("#{interface_order}",String.valueOf(t.getInterfaceOrder()));
		sql  = sql.replace("#{interface_url}",String.valueOf(t.getInterfaceUrl()));
		sql  = sql.replace("#{UUID}",UUID.randomUUID().toString());
		return sql;
	}

	/**
	 * 执行JAVA增强
	 */
	private void executeJavaExtend(String cgJavaType,String cgJavaValue,Map<String,Object> data) throws Exception {
		if(StringUtil.isNotEmpty(cgJavaValue)){
			Object obj = null;
			try {
				if("class".equals(cgJavaType)){
					//因新增时已经校验了实例化是否可以成功，所以这块就不需要再做一次判断
					obj = MyClassLoader.getClassByScn(cgJavaValue).newInstance();
				}else if("spring".equals(cgJavaType)){
					obj = ApplicationContextUtil.getContext().getBean(cgJavaValue);
				}
				if(obj instanceof CgformEnhanceJavaInter){
					CgformEnhanceJavaInter javaInter = (CgformEnhanceJavaInter) obj;
					javaInter.execute("t_s_interface",data);
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception("执行JAVA增强出现异常！");
			} 
		}
	}

	@Override
	public InterfaceRuleDto getInterfaceRuleByUserNameAndCode(String userName,InterfaceEnum interfaceEnum) {
		StringBuilder sb = new StringBuilder();
		sb.append("select tsi.id,tsi.interface_code,tsii.data_rule from t_s_interface tsi ");
		sb.append(" left join t_s_interrole_interface tsii on tsi.id = tsii.interface_id ");
		sb.append(" left join t_s_interrole_user tsiu on  tsii.interrole_id = tsiu.interrole_id");
		sb.append(" left join t_s_base_user tsbu on tsiu.user_id = tsbu.id");
		sb.append(" where tsbu.username = ? and tsi.interface_code=? ");
		InterfaceRuleDto interfaceRuleDto = null;
		Map<String,Object> map=this.findOneForJdbc(sb.toString(), userName,interfaceEnum.getCode());
		if(map!=null && map.size()>0){
			String id = (String) map.get("id");
			String interfaceCode = (String)map.get("interface_code");
			String dataRuleIds = (String)map.get("data_rule");
			interfaceRuleDto = new InterfaceRuleDto();
			interfaceRuleDto.setInterfaceCode(interfaceCode);
			interfaceRuleDto.setDataRule(dataRuleIds);
			//根据数据规则id获取数据规则
			List<InterfaceDdataRuleEntity> ruleList = new ArrayList<InterfaceDdataRuleEntity>();
			if(StringUtils.isNotEmpty(dataRuleIds)){
				String[] dataRuleIdArr = dataRuleIds.split(",");
				String hql = "from InterfaceDdataRuleEntity where id in (:ids)";
				ruleList = commonDao.getSession().createQuery(hql).setParameterList("ids", dataRuleIdArr).list();
			}else if(StringUtils.isNotEmpty(id)){
				ruleList=this.findByProperty(InterfaceDdataRuleEntity.class, "TSInterface.id", id);
			}
			interfaceRuleDto.setInterfaceDataRule(ruleList);
		}
		return interfaceRuleDto;
	}
}