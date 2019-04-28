package org.jeecgframework.web.system.pojo.base;

import org.jeecgframework.core.common.entity.IdEntity;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *菜单权限表
 * @author  张代浩
 */
@Entity
@Table(name = "t_s_function")

@org.hibernate.annotations.Proxy(lazy = false)


public class FunctionEntity extends IdEntity implements java.io.Serializable {
	private FunctionEntity TSFunction;//父菜单
	private String functionName;//菜单名称
	private Short functionLevel;//菜单等级
	private String functionUrl;//菜单地址
	private Short functionIframe;//菜单地址打开方式
	private String functionOrder;//菜单排序
	private Short functionType;//菜单类型
	private IconEntity TSIcon = new IconEntity();//菜单图标

	private String functionIconStyle;//菜单图标样式

	private IconEntity TSIconDesk;// 云桌面菜单图标

	/*private int subFunctionSize;
	@Formula(value = "(SELECT count(t_s_function.id) FROM t_s_function where t_s_function.parentfunctionid = id)")
	public int getSubFunctionSize() {
		return subFunctionSize;
	}*/


	/**创建时间*/
	private java.util.Date createDate;
	/**创建人ID*/
	private String createBy;
	/**创建人名称*/
	private String createName;
	/**修改时间*/
	private java.util.Date updateDate;
	/**修改人*/
	private String updateBy;
	/**修改人名称*/
	private String updateName;
	/**
	 *方法: 取得java.util.Date
	 *@return: java.util.Date  创建时间
	 */
	@Column(name ="create_date",nullable=true)
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
	 *@return: java.lang.String  创建人ID
	 */
	@Column(name ="create_by",nullable=true,length=32)
	public String getCreateBy(){
		return this.createBy;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  创建人ID
	 */
	public void setCreateBy(String createBy){
		this.createBy = createBy;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  创建人名称
	 */
	@Column(name ="create_name",nullable=true,length=32)
	public String getCreateName(){
		return this.createName;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  创建人名称
	 */
	public void setCreateName(String createName){
		this.createName = createName;
	}
	/**
	 *方法: 取得java.util.Date
	 *@return: java.util.Date  修改时间
	 */
	@Column(name ="update_date",nullable=true)
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
	 *@return: java.lang.String  修改人ID
	 */
	@Column(name ="update_by",nullable=true,length=32)
	public String getUpdateBy(){
		return this.updateBy;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  修改人ID
	 */
	public void setUpdateBy(String updateBy){
		this.updateBy = updateBy;
	}
	/**
	 *方法: 取得java.lang.String
	 *@return: java.lang.String  修改人名称
	 */
	@Column(name ="update_name",nullable=true,length=32)
	public String getUpdateName(){
		return this.updateName;
	}

	/**
	 *方法: 设置java.lang.String
	 *@param: java.lang.String  修改人名称
	 */
	public void setUpdateName(String updateName){
		this.updateName = updateName;
	}
	public boolean hasSubFunction(Map<Integer, List<FunctionEntity>> map) {
		if(map.containsKey(this.getFunctionLevel()+1)){
			return hasSubFunction(map.get(this.getFunctionLevel()+1));
		}
		return false;
	}

	public boolean hasSubFunction(List<FunctionEntity> functions) {
		for (FunctionEntity f : functions) {
			if(f!=null && f.getTSFunction()!=null){
				if(f.getTSFunction().getId().equals(this.getId())){
					return true;
				}
			}
			
		}
		return false;
	}
	/*public void setSubFunctionSize(int subFunctionSize) {
		this.subFunctionSize = subFunctionSize;
	}*/

    @ManyToOne(fetch = FetchType.EAGER)

    @JoinColumn(name = "desk_iconid")
    public IconEntity getTSIconDesk() {
        return TSIconDesk;
    }
    public void setTSIconDesk(IconEntity TSIconDesk) {
        this.TSIconDesk = TSIconDesk;
    }

    
	private List<FunctionEntity> TSFunctions = new ArrayList<FunctionEntity>();

	@ManyToOne(fetch = FetchType.EAGER)

	@JoinColumn(name = "iconid")
	public IconEntity getTSIcon() {
		return TSIcon;
	}
	public void setTSIcon(IconEntity tSIcon) {
		TSIcon = tSIcon;
	}

    @ManyToOne(fetch = FetchType.EAGER)

	@JoinColumn(name = "parentfunctionid")
	public FunctionEntity getTSFunction() {
		return this.TSFunction;
	}

	public void setTSFunction(FunctionEntity TSFunction) {
		this.TSFunction = TSFunction;
	}

	@Column(name = "functionname", nullable = false, length = 50)
	public String getFunctionName() {
		return this.functionName;
	}

	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}

	@Column(name = "functionlevel")
	public Short getFunctionLevel() {
		return this.functionLevel;
	}

	public void setFunctionLevel(Short functionLevel) {
		this.functionLevel = functionLevel;
	}
	
	@Column(name = "functiontype")
	public Short getFunctionType() {
		return this.functionType;
	}

	public void setFunctionType(Short functionType) {
		this.functionType = functionType;
	}
	
	@Column(name = "functionurl", length = 100)
	public String getFunctionUrl() {
		return this.functionUrl;
	}

	public void setFunctionUrl(String functionUrl) {
		this.functionUrl = functionUrl;
	}
	@Column(name = "functionorder")
	public String getFunctionOrder() {
		return functionOrder;
	}

	public void setFunctionOrder(String functionOrder) {
		this.functionOrder = functionOrder;
	}
	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "TSFunction")
	public List<FunctionEntity> getTSFunctions() {
		return TSFunctions;
	}
	public void setTSFunctions(List<FunctionEntity> TSFunctions) {
		this.TSFunctions = TSFunctions;
	}
	@Column(name = "functioniframe")
	public Short getFunctionIframe() {
		return functionIframe;
	}
	public void setFunctionIframe(Short functionIframe) {
		this.functionIframe = functionIframe;
	}

	@Column(name = "function_icon_style")
	public String getFunctionIconStyle() {
		return functionIconStyle;
	}

	public void setFunctionIconStyle(String functionIconStyle) {
		this.functionIconStyle = functionIconStyle;
	}

	

}