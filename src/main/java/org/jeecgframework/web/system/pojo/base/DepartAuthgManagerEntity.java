package org.jeecgframework.web.system.pojo.base;

import org.hibernate.annotations.GenericGenerator;
import org.jeecgframework.poi.excel.annotation.Excel;

import javax.persistence.*;

/**   
 * @Title: Entity
 * @Description: 部门管理员关联表
 * @author onlineGenerator
 * @date 2017-12-01 18:19:12
 * @version V1.0   
 *
 */
@Entity
@Table(name = "t_s_depart_authg_manager", schema = "")
@SuppressWarnings("serial")
public class DepartAuthgManagerEntity implements java.io.Serializable {
	/**ID*/
	private String id;
	/**权限组ID*/
	@Excel(name="权限组ID",width=15)
	private String groupId;
	/**用户ID*/
	@Excel(name="用户ID",width=15)
	private String userId;
	/**权限组类型*/
	@Excel(name="权限组类型",width=15)
	private Integer type;
	/**创建人*/
	@Excel(name="创建人",width=15)
	private String createName;
	/**创建人id*/
	@Excel(name="创建人id",width=15)
	private String createBy;
	/**创建时间*/
	@Excel(name="创建时间",width=15,format = "yyyy-MM-dd")
	private java.util.Date createDate;
	/**修改人*/
	@Excel(name="修改人",width=15)
	private String updateName;
	/**修改人id*/
	@Excel(name="修改人id",width=15)
	private String updateBy;
	/**修改时间*/
	@Excel(name="修改时间",width=15,format = "yyyy-MM-dd")
	private java.util.Date updateDate;
	/**所属部门*/
	@Excel(name="所属部门",width=15)
	private String sysOrgCode;
	/**所属公司*/
	@Excel(name="所属公司",width=15)
	private String sysCompanyCode;

	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  ID
	 */
	@Id
	@GeneratedValue(generator = "paymentableGenerator")
	@GenericGenerator(name = "paymentableGenerator", strategy = "uuid")

	@Column(name ="ID",nullable=false,length=36)
	public String getId(){
		return this.id;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  ID
	 */
	public void setId(String id){
		this.id = id;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  权限组ID
	 */

	@Column(name ="GROUP_ID",nullable=true,length=36)
	public String getGroupId(){
		return this.groupId;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  权限组ID
	 */
	public void setGroupId(String groupId){
		this.groupId = groupId;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  用户ID
	 */

	@Column(name ="USER_ID",nullable=true,length=36)
	public String getUserId(){
		return this.userId;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  用户ID
	 */
	public void setUserId(String userId){
		this.userId = userId;
	}
	/**
	 *方法: 取得java.lang.Integer
	 *@return: java.lang.Integer  权限组类型
	 */

	@Column(name ="TYPE",nullable=true,length=3)
	public Integer getType(){
		return this.type;
	}

	/**
	 *方法: 设置java.lang.Integer
	 *@param: java.lang.Integer  权限组类型
	 */
	public void setType(Integer type){
		this.type = type;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  创建人
	 */

	@Column(name ="CREATE_NAME",nullable=true,length=50)
	public String getCreateName(){
		return this.createName;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  创建人
	 */
	public void setCreateName(String createName){
		this.createName = createName;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  创建人id
	 */

	@Column(name ="CREATE_BY",nullable=true,length=50)
	public String getCreateBy(){
		return this.createBy;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  创建人id
	 */
	public void setCreateBy(String createBy){
		this.createBy = createBy;
	}
	/**
	 *方法: 取得java.util.Date
	 *@return: java.util.Date  创建时间
	 */

	@Column(name ="CREATE_DATE",nullable=true)
	public java.util.Date getCreateDate(){
		return this.createDate;
	}

	/**
	 *方法: 设置java.util.Date
	 *@param: java.util.Date  创建时间
	 */
	public void setCreateDate(java.util.Date createDate){
		this.createDate = createDate;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  修改人
	 */

	@Column(name ="UPDATE_NAME",nullable=true,length=50)
	public String getUpdateName(){
		return this.updateName;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  修改人
	 */
	public void setUpdateName(String updateName){
		this.updateName = updateName;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  修改人id
	 */

	@Column(name ="UPDATE_BY",nullable=true,length=50)
	public String getUpdateBy(){
		return this.updateBy;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  修改人id
	 */
	public void setUpdateBy(String updateBy){
		this.updateBy = updateBy;
	}
	/**
	 *方法: 取得java.util.Date
	 *@return: java.util.Date  修改时间
	 */

	@Column(name ="UPDATE_DATE",nullable=true)
	public java.util.Date getUpdateDate(){
		return this.updateDate;
	}

	/**
	 *方法: 设置java.util.Date
	 *@param: java.util.Date  修改时间
	 */
	public void setUpdateDate(java.util.Date updateDate){
		this.updateDate = updateDate;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  所属部门
	 */

	@Column(name ="SYS_ORG_CODE",nullable=true,length=50)
	public String getSysOrgCode(){
		return this.sysOrgCode;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  所属部门
	 */
	public void setSysOrgCode(String sysOrgCode){
		this.sysOrgCode = sysOrgCode;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  所属公司
	 */

	@Column(name ="SYS_COMPANY_CODE",nullable=true,length=50)
	public String getSysCompanyCode(){
		return this.sysCompanyCode;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  所属公司
	 */
	public void setSysCompanyCode(String sysCompanyCode){
		this.sysCompanyCode = sysCompanyCode;
	}
}
