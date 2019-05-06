<!DOCTYPE html>
<html>
<head>
${config_iframe}
<link type="text/css" rel="stylesheet" href="online/template/${this_olstylecode}/css/rowedit.css"/>
<script type="text/javascript" src="online/template/${this_olstylecode}/js/rowedit.js"></script>
</head>
<body>
<#--update-start--Author:luobaoli  Date:20150703 for：将本文档中所有href="#"修改为href="javascript:void(0)",避免rest风格下新增/删除等操作跳转到主页问题-->
<script type="text/javascript">
/**
*表单的高度,表单的宽度
**/
var ${config_id}Fw = 700,${config_id}Fh = 400;

$(function(){
	var comboboxDataObj = {};
	$.get("cgFormHeadController.do?checkIsExit&checkIsTableCreate&name=${config_id}",
	function(data){
		data = $.parseJSON(data);
		if(data.success){
			createDataGrid${config_id}(comboboxDataObj);
		}else{
			alertTip('表:<span style="color:red;">${config_id}</span>还没有生成,请到表单配置生成表');
		}
	});
});

function createDataGrid${config_id}(comboboxDataObj){
	var initUrl = 'cgAutoListController.do?datagrid&configId=${config_id}&field=${fileds}${initquery}';
	initUrl = encodeURI(initUrl);
	$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>(
	{
	<#if config_istree=="Y">treeField:'text',</#if>
	url:initUrl,
	idField: 'id', <#if config_istree=="Y">treeField:"${tree_fieldname}",</#if>
	title: '${config_name}',
	fit:true,
	fitColumns:true,
	striped:true,
	autoRowHeight: true,
	pageSize: 10,
	<#if config_ispagination =="Y">pagination:true,</#if>
	<#if config_ischeckbox=="Y">singleSelect:false,<#else>singleSelect:true,</#if>
	<#if fileds?index_of("create_datetime")!=-1 >
		sortName:'create_datetime',
	<#elseif fileds?index_of("create_date")!=-1 && fileds?index_of("create_datetime")==-1>
		sortName:'create_date',
	<#else>
		sortName:'id',
	</#if>
	pageList:[10,30,50,100],
	sortOrder:'desc',
	rownumbers:true,
	showFooter:true,
	frozenColumns:[[]],
	columns:[
		[	
			<#if config_istree=="Y">
				<#list config_fieldList  as x>  
					<#if x_index==0>{field:"id", title:"${x['field_title']}", hidden:true}, </#if>
					<#if x_index!=0>{field:"${x['field_id']}", title:"${x['field_title']}",<#if x['field_isShow'] == "N" >hidden:true,</#if><#if x['field_href'] != "">formatter:function(value,rec,index){var href='';href+="<a href='javascript:void(0)' onclick=\"addOneTab('字段链接','${x['field_href']}')\" ><u>"+value+"</u></a>";return href;},</#if> width:100}, </#if>
				</#list>
			<#else>
					{field:'ck',checkbox:true},
					<#list config_fieldList  as x>  
						 {	field:'${x['field_id']}',
						 <#--  update-begin--Author: chenj  Date:20160808 for：TASK 行编辑模式标题修改 -->
						 	title:'${x['field_title']}',
						 	<#-- update-begin--Author:taoyan date:20181022 for：行编辑radio类型 编辑完成显示value bug -->
						 	<#if x['field_showType']=="radio">
						 	formatter: function(value,row){
								if('${x['field_id']}' in comboboxDataObj){
									var arr = comboboxDataObj['${x['field_id']}'];
									for(var a = 0;a<arr.length;a++){
										if(arr[a].code == value){
											return arr[a].typename;
										}
									}
								}
								return value;
							},
						 	</#if>
						 	<#-- update-end--Author:taoyan date:20181022 for：行编辑radio类型 编辑完成显示value bug -->
						 <#--  update-end--Author: chenj  Date:20160808 for：TASK 行编辑模式标题修改 -->
						 <#--  update-begin--Author: taoyan  Date:20180824 for：TASK 行编辑模式支持文件上传 -->
						 <#if x['field_showType']=="file" || x['field_showType']=="image">
						  editor: {
				                type: 'filecontrol',
				                options: {
				                    btnclass: 'ace_button'
				                }
				            },
						 <#else>
						 	editor:<#switch x['field_type']>
                                                  <#case "string">
                                                  <#--  update-begin--Author: chenj  Date:20160805 for：TASK #1247 [bug]论坛问题处理 -->
											 	<#if x['field_showType']=="list">
											 	{
												 	type:'combobox',
													options:{
														valueField:'code',
														textField:'typename',
														data:
														<#if  (x['field_dictlist']?size >0)>
															[
															<#list x['field_dictlist']  as xd>
																{
																"code":"${xd['code']}",
																"typename":"${xd['typename']}"
																},
															</#list>
															],
														</#if>
													<#-- add-begin--Author:xuelin  Date:20170425 for：#1781 【online模板】online行编辑模板，非空判断-------------------- -->
													<#if x['field_isNull'] != "Y">required:true</#if>
													<#-- add-end--Author:xuelin  Date:20170425 for：#1781 【online模板】online行编辑模板，非空判断-------------------- -->
													}
												}
											 	<#elseif x['field_showType']=="radio">
											 	{
												 	type:'combobox',
													options:{
														valueField:'code',
														textField:'typename',
														<#-- update-begin--Author:taoyan date:20181022 for：行编辑radio类型 编辑完成显示value bug -->
														<#-- add-begin--Author:xuelin  Date:20170425 for：#1781 【online模板】online行编辑模板，非空判断-------------------- -->
														<#if x['field_isNull'] != "Y">required:true,</#if>
														<#-- add-end--Author:xuelin  Date:20170425 for：#1781 【online模板】online行编辑模板，非空判断-------------------- -->
														data:(function(){
															var dataObj = [];
															<#if  (x['field_dictlist']?size >0)>
																<#list x['field_dictlist']  as xd>
																	dataObj.push({
																	"code":"${xd['code']}",
																	"typename":"${xd['typename']}"
																	});
																</#list>
															</#if>
															comboboxDataObj['${x['field_id']}'] = dataObj;
															return dataObj;
														})()
														<#-- update-end--Author:taoyan date:20181022 for：行编辑radio类型 编辑完成显示value bug -->
													}
												}
												<#-- add-begin--Author:xuelin  Date:20170425 for：#1781 【online模板】online 选择行编辑模板，添加数据，保存没有校验功能，需要改模板-------------------- -->
											 	<#elseif x['field_showType']=="text">
											 		<#if x['field_isShow'] != "N" >
													{
														type:'validatebox',
														options:{
														<#if x['field_isNull'] != "Y">required:true</#if>
														}
													}
													<#else>
													'text'
													</#if>
											 	<#-- add-end--Author:xuelin  Date:20170425 for：#1781 【online模板】online 选择行编辑模板，添加数据，保存没有校验功能，需要改模板-------------------- -->							 	
											 	<#else>
											 	'text'
											 	</#if>
											 	<#-- update-end--Author: chenj  Date:20160805 for：TASK #1247 [bug]论坛问题处理 -->
                                                <#break>
                                                  <#case "interger">'numberbox'<#break>
                                                  <#case "int">'numberbox'<#break>
                                                  <#case "Date">
	                                                  <#if x['field_showType']=="date">
												 	  {
													 	type:'datebox',
														options:{
														}
													  }
												 	<#elseif x['field_showType']=="datetime">
												 	{
													 	type:'datetimebox',
														options:{
														}
													  }
												 	<#else>
												 	'datebox'
												 	</#if>
                                                  <#break>
                                                  <#default>'text'
                                    </#switch> ,
                            </#if>
                            <#--  update-end--Author: taoyan  Date:20180824 for：TASK 行编辑模式支持文件上传 -->
						 	<#if x['field_isShow'] == "N" >hidden:true,
						 	</#if>
						 	<#if x['field_href'] != "">
						 	formatter:function(value,rec,index){
						 		var href='';
						 		href+=applyHref('字段链接','${x['field_href']}',value,rec,index);
						 		return href;
						 	},
						 	</#if>
						 	<#if x['field_showType']=="file">
						 	formatter:function(value,rec,index){
						 		var href='';
						 		if(value==null || value.length==0){
						 			return href;
						 		}
						 		if(value.indexOf(".jpg")>-1 || value.indexOf(".gif")>-1 || value.indexOf(".png")>-1){
						 			<#-- update--begin--author:zhangjiaqiang date:20170606 for:TASK #2056 【上传附件功能】Online 一对多对上传组件支持 -->
						 			href+="<img src='"+value+"' onmouseover='tipImg(this)' onmouseout='moveTipImg()' width=30 height=30/>";
						 			<#-- update--end--author:zhangjiaqiang date:20170606 for:TASK #2056 【上传附件功能】Online 一对多对上传组件支持 -->
						 		}else{
						 			<#-- //update-begin--Author:zhangjiaqiang Date:20160925 for：TASK #1344 [链接图标] online功能测试的按钮链接图标修改 -->
						 			<#-- update--begin--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
						 			<#-- update-begin- author:taoyan date:20181023 for:txt文件下载bug -->
						 			var value2="systemController/downloadFile.do?filePath="+value
						 			<#if brower_type?? && brower_type == 'Microsoft%20Internet%20Explorer'>
						 			href+="[<a href='"+value2+"' style='text-decoration:none;' target=_blank>点击下载</a>]";
						 			<#else>
						 			href+="<a href='"+value2+"' class='ace_button' style='text-decoration:none;' target=_blank><u><i class='fa fa-download'></i>点击下载</u></a>";
						 			</#if>
						 			<#-- update-end- author:taoyan date:20181023 for:txt文件下载bug -->
						 			<#-- update--end--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
						 			<#-- //update-begin--Author:zhangjiaqiang Date:20160925 for：TASK #1344 [链接图标] online功能测试的按钮链接图标修改 -->
						 		}
						 		return href;
						 	},
						 	</#if>
						 	<#-- update-start--Author: jg_huangxg  Date:20160113 for：TASK #824 【online开发】控件类型扩展增加一个图片类型 image -->
						 	<#-- update-start--Author: zhoujf  Date:20170207 for：列表加时间格式化 -->
						 	<#if x['field_showType']=="date">
						 	formatter:function(value,rec,index){
						 		if (value == undefined) {
						            return "";
						        }
						        return new Date().format('yyyy-MM-dd', value);
						 	},
						 	</#if>
						 	<#if x['field_showType']=="datetime">
						 	formatter:function(value,rec,index){
						 		if (value == undefined) {
						            return "";
						        }
						        return new Date().format('yyyy-MM-dd hh:mm:ss', value);
						 	},
						 	</#if>
						 	<#-- update-end--Author: zhoujf  Date:20170207 for：列表加时间格式化 -->
						 	<#if x['field_showType']=="image">
						 	formatter:function(value,rec,index){
						 		var href='';
						 		if(value==null || value.length==0){
						 			return href;
						 		}
						 		<#-- update--begin--author:zhangjiaqiang date:20170606 for:TASK #2056 【上传附件功能】Online 一对多对上传组件支持 -->
						 		href+="<img src='"+value+"' width=30 height=30 onmouseover='tipImg(this)' onmouseout='moveTipImg()'/>";
						 		<#-- update--end--author:zhangjiaqiang date:20170606 for:TASK #2056 【上传附件功能】Online 一对多对上传组件支持 -->
						 		return href;
						 	},
						 	styler: function(value,row,index){
								return 'text-align: left;';
						 	},
						 	</#if>
						 	<#--return row.${x['field_id']}; update-end--Author: jg_huangxg  Date:20160113 for：TASK #824 【online开发】控件类型扩展增加一个图片类型 image -->
						 	<#--  update-begin--Author: chenj  Date:20160805 for：TASK #1247 [bug]论坛问题处理 -->
						 	<#if x['field_showType']=="list">
							 	formatter:function(value,row){
								 	<#if  (x['field_dictlist']?size >0)>
										<#list x['field_dictlist']  as xd>
											if(value =='${xd['code']}'){
												return '${xd['typename']}';
											}
										</#list>
									</#if>
							 		return row.${x['field_id']};
							 	},
						 	</#if>
							<#--  update-end--Author: chenj  Date:20160805 for：TASK #1247 [bug]论坛问题处理 -->					
						 	sortable:true,
						 	width:${x['field_length']}
						 	},
					</#list>
			</#if>
			{field:'opt',title:'操作',width:200,formatter:function(value,rec,index){
						if(!rec.id){return '';}
						var href='';
						<#if config_noliststr?index_of("delete")==-1>
						<#-- //update-begin--Author:zhangjiaqiang Date:20160925 for：TASK #1344 [链接图标] online功能测试的按钮链接图标修改 -->
						<#-- update--begin--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
						<#if brower_type?? && brower_type == 'Microsoft%20Internet%20Explorer'>
							href+="[<a href='javascript:void(0)' onclick=delObj('cgAutoListController.do?del&configId=${config_id}&id="+rec.id+"','${config_id}List')>";
							href+="删除</a>]";
						<#else>
							href+="<a href='javascript:void(0)' class='ace_button' onclick=delObj('cgAutoListController.do?del&configId=${config_id}&id="+rec.id+"','${config_id}List')>";
							href+="<i class='fa fa-trash-o'></i>删除</a>";
						</#if>
						<#-- update--end--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
						<#-- //update-end--Author:zhangjiaqiang Date:20160925 for：TASK #1344 [链接图标] online功能测试的按钮链接图标修改 -->
						</#if>
						<#list config_buttons as x>
							<#if x['buttonStyle'] == 'link' && x['buttonStatus']=='1' && config_noliststr?index_of("${x['buttonCode']}")==-1>
								<#--update-begin--Author:gj_shaojc  Date:20180606 for：TASK #2753 【论坛问题确认】online 开发，自定义按钮显示表达式问题-->
									<#if x['exp'] != '' ||x['exp'] !=null>
										if(<@exp exp="${ x['exp']}" data="rec" />){
								 	 </#if>
								<#--update-end--Author:gj_shaojc  Date:20180606 for：TASK #2753 【论坛问题确认】online 开发，自定义按钮显示表达式问题-->
								<#-- //update-begin--Author:zhangjiaqiang Date:20160925 for：TASK #1344 [链接图标] online功能测试的按钮链接图标修改 -->
								<#-- update--begin--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
								<#if brower_type?? && brower_type == 'Microsoft%20Internet%20Explorer'>
									href+="[<a href='javascript:void(0)' buttonCode='${x['buttonCode']}' formId ='${x['formId']}' ";
								<#else>
									href+="<a style='margin-left:5px;' href='javascript:void(0)' class='ace_button' buttonCode='${x['buttonCode']}' formId ='${x['formId']}' ";
								
								</#if>
								<#-- update--end--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
								<#if x['optType'] == 'action'>
								href+=" onclick=\"doBusButtonForLink('cgFormBuildController.do?doButton&formId=${x['formId']}&buttonCode=${x['buttonCode']}&tableName=${config_id}','${x['buttonName']}','${config_id}List','"+rec.id+"')\"";
								<#else>
								href+=" onclick=\"${x['buttonCode']}('"+rec.id+"');\"";
								</#if>
								href+=" id=\"${x['buttonCode']}\">";
								<#-- update--begin--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
								<#if brower_type?? && brower_type == 'Microsoft%20Internet%20Explorer'>
									href+="${x['buttonName']}</a>]";
								<#else>
									<#if x['buttonName']?index_of("测试") gt -1>
										href+="<i class='fa fa-wrench'></i>${x['buttonName']}</a>";
									<#elseif x['buttonName']?index_of("配置") gt -1 ||  x['buttonName']?index_of("设置") gt -1>
										href+="<i class='fa fa-cog'></i>${x['buttonName']}</a>";
									<#elseif x['buttonName']?index_of("导入") gt -1 || x['buttonName']?index_of("下载") gt -1>
										href+="<i class='fa fa-download'></i>${x['buttonName']}</a>";
									<#elseif x['buttonName']?index_of("导出") gt -1 || x['buttonName']?index_of("上传") gt -1>
										href+="<i class='fa fa-upload'></i>${x['buttonName']}</a>";
									<#elseif x['buttonName']?index_of("复制") gt -1>
										href+="<i class='fa fa-copy'></i>${x['buttonName']}</a>";
									<#elseif x['buttonName']?index_of("剪切") gt -1>
										href+="<i class='fa fa-cut'></i>${x['buttonName']}</a>";
									<#else>
										href+="<i class='fa fa-wrench'></i>${x['buttonName']}</a>";
									</#if>
								</#if>
								<#-- update--end--author:zhangjiaqiang date:20170628 for: TASK #2194 【online链接样式切换】Online 功能测试的列表链接样式，需要根据浏览器IE进行切换 -->
								<#-- //update-end--Author:zhangjiaqiang Date:20160925 for：TASK #1344 [链接图标] online功能测试的按钮链接图标修改 -->
								<#--update-begin--Author:gj_shaojc  Date:20180606 for：TASK #2753 【论坛问题确认】online 开发，自定义按钮显示表达式问题-->
									<#if x['exp'] != '' ||x['exp'] !=null>
										}
								 	 </#if>
								 <#--update-end--Author:gj_shaojc  Date:20180606 for：TASK #2753 【论坛问题确认】online 开发，自定义按钮显示表达式问题-->
							</#if>
						</#list>
						return href;
						}
			}
		]
	],
	onLoadSuccess:function(data){
		$("#${config_id}List").<#if config_istree=="Y">treegrid<#else>datagrid</#if>("clearSelections");
	},
	onClickRow:function(rowIndex,rowData)
		{rowid=rowData.id;gridname='${config_id}List';}
	});
	$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('getPager').pagination({beforePageText:'',afterPageText:'/{pages}',displayMsg:'{from}-{to}共{total}条',showPageList:true,showRefresh:true});
	$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('getPager').pagination({onBeforeRefresh:function(pageNumber, pageSize){ $(this).pagination('loading');$(this).pagination('loaded'); }});
	//将没有权限的按钮屏蔽掉
	<#list config_nolist as x>
		$("#${config_id}Listtb").find("${x}").hide();
	</#list>
	}
	
	//列表刷新
	function reloadTable(){	
		try{
		<#if config_istree=="Y">
			$('#'+gridname).treegrid('reload');
		<#else>
			$('#'+gridname).datagrid('reload');
		</#if>
		}catch(ex){
			//donothing
		}
	}
	//列表刷新-推荐使用
	function reload${config_id}List(){
		$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('reload');
	}
	/**
	 * 获取列表中选中行的数据-推荐使用
	 * @param field 数据中字段名
	 * @return 选中行的给定字段值
	 */
	function get${config_id}ListSelected(field){
		var row = $('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('getSelected');
		if(row!=null){value= row[field];
		}else{
			value='';
		}
		return value;
	}
	/**
	 * 获取列表中选中行的数据
	 * @param field 数据中字段名
	 * @return 选中行的给定字段值
	 */
	function getSelected(field){
		var row = $('#'+gridname).<#if config_istree=="Y">treegrid<#else>datagrid</#if>('getSelected');
		if(row!=null){value= row[field];
		}else{
			value='';
		}
		return value;
	}
	
	/**
	 * 获取表格对象
	 * @return 表格对象
	 */
	function getDataGrid(){
		var datagrid = $('#'+gridname);
		return datagrid;
	}
	/**
	 * 获取列表中选中行的数据（多行）
	 * @param field 数据中字段名-不传此参数则获取全部数据
	 * @return 选中行的给定字段值，以逗号分隔
	 */
	function get${config_id}ListSelections(field){
		var ids = '';
		var rows = $('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('getSelections');
		for(var i=0;i<rows.length;i++){
			ids+=rows[i][field];
			ids+=',';
		}
		ids = ids.substring(0,ids.length-1);
		return ids;
	}
	/**
	 * 列表查询
	 */
	function ${config_id}Listsearch(){
		var queryParams=$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('options').queryParams;
		$('#${config_id}Listtb').find('*').each(
			function(){
			queryParams[$(this).attr('name')]=$(this).val();});
			$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>({url:'cgAutoListController.do?datagrid&configId=${config_id}&field=${fileds}',pageNumber:1});
	}
	function dosearch(params){
		var jsonparams=$.parseJSON(params);
		$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>({url:'cgAutoListController.do?datagrid&configId=${config_id}&field=${fileds},',queryParams:jsonparams});
	}
	function ${config_id}Listsearchbox(value,name){
		var queryParams=$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('options').queryParams;
		queryParams[name]=value;
		queryParams.searchfield=name;
		$('#${config_id}List').<#if config_istree=="Y">treegrid<#else>datagrid</#if>('reload');
	}
	$('#${config_id}Listsearchbox').searchbox({
		searcher:function(value,name){
			${config_id}Listsearchbox(value,name);
		},
		menu:'#${config_id}Listmm',
		prompt:'请输入查询关键字'
	});
	//查询重置
	function ${config_id}searchReset(name){ 
		$("#searchColumsForm")[0].reset();
		//$("#"+name+"tb").find("input[type!='hidden']").val("");
		<#if config_istree=="Y">
		//为树形表单时，删除id查询参数
		delete $('#${config_id}List').treegrid('options').queryParams.id;  
		</#if>
		${config_id}Listsearch();
	}
	//将字段href中的变量替换掉
	function applyHref(tabname,href,value,rec,index){
		//addOneTab(tabname,href);
		var hrefnew = href;
		var re = "";
		var p1 = /\#\{(\w+)\}/g;
		try{
			var vars =hrefnew.match(p1); 
			for(var i=0;i<vars.length;i++){
				var keyt = vars[i];
				var p2 = /\#\{(\w+)\}/g;
				var key = p2.exec(keyt);
				 hrefnew =  hrefnew.replace(keyt,rec[key[1]]);
			}
		}catch(ex){
		}
		re += "<a href = '#' onclick=\"addOneTab('"+tabname+"','"+ hrefnew+"')\" ><u>"+value+"</u></a>";
		return re;
	}
	//SQL增强入口-按钮
	function doBusButton(url,content,gridname){
		var rowData = $('#'+gridname).datagrid('getSelected');
		if (!rowData) {
			tip('请选择一条信息');
			return;
		}	
		url = url + '&id='+rowData.id;
		createdialog('确认 ', '确定'+content+'吗 ?', url,gridname);
	}
	//SQL增强入口-操作列里的链接
	function doBusButtonForLink(url,content,gridname,rowData){
		if (!rowData) {
			tip('请选择一条信息');
			return;
		}	
		url = url + '&id='+rowData;
		createdialog('确认 ', '确定'+content+'吗 ?', url,gridname);
	}
    //----author:jg_xugj---start----date:20151219-------- for：#813 【online表单】扩展出三个请求：独立的添加、查看、编辑请求，原来的保留
	//新增
	function ${config_id}add(){
		//update-begin--Author:luobaoli  Date:20150705 for：请求URL修改为REST风格
		//add('${config_name}录入','rest/cgform/form/${config_id}','${config_id}List',${config_id}Fw,${config_id}Fh);
		//update-end--Author:luobaoli  Date:20150705 for：请求URL修改为REST风格
		
		add('${config_name}录入','cgFormBuildController/ftlForm/${config_id}/goAdd.do?olstylecode=${_olstylecode}','${config_id}List',${config_id}Fw,${config_id}Fh);
	}
	//修改
	function ${config_id}update(){
		//update-begin--Author:luobaoli  Date:20150705 for：请求URL修改为REST风格
		//update('${config_name}编辑','rest/cgform/form/${config_id}','${config_id}List',${config_id}Fw,${config_id}Fh,true);
		//update-end--Author:luobaoli  Date:20150705 for：请求URL修改为REST风格
		
		update('${config_name}编辑','cgFormBuildController/ftlForm/${config_id}/goUpdate.do?olstylecode=${_olstylecode}','${config_id}List',${config_id}Fw,${config_id}Fh);
	}
	
//-------------------------------------------------------------------------------------------------------------------------

	<#-- add-begin--Author:xuelin  Date:20170425 for：#1781 【online模板】online 选择行编辑模板，添加数据，保存没有校验功能，需要改模板-------------------- -->
	//扩展校验
	$.extend($.fn.validatebox.defaults.rules, {
	   	length : {
	        validator : function(value, param) {
	        	if(value.length < Number(param[0]) || value.length > Number(param[1])){
	        		return false;
	        	}
	        	return true;
	        },
	        message : '字数限制在{0}-{1}个字符！'
	    }
	});
   <#-- add-end--Author:xuelin  Date:20170425 for：#1781 【online模板】online 选择行编辑模板，添加数据，保存没有校验功能，需要改模板-------------------- -->
	
		//添加行
	function ${config_id}addRow(){
	var gname="${config_id}List";
		$('#'+gname).datagrid('appendRow',{});
		var editIndex = $('#'+gname).datagrid('getRows').length-1;
		$('#'+gname).datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
	}
	
		//编辑行  ('编辑','null','jeecgDemoList2',null,null)">
	function ${config_id}editRow(){
		var gname="${config_id}List";
		var rows=$('#'+gname).datagrid("getChecked");
		if(rows.length==0){
			tip("请选择条目");
			return false;
		}
		for(var i=0;i<rows.length;i++){
			var index= $('#'+gname).datagrid('getRowIndex', rows[i]);
			$('#'+gname).datagrid('beginEdit', index);
		}
	}
	
	//取消编辑
	function ${config_id}reject(){
	    var gname="${config_id}List";
		$('#'+gname).datagrid('clearChecked');
		$('#'+gname).datagrid('rejectChanges');
	}
	
		//保存数据
	function ${config_id}saveData(){
	    var gname="${config_id}List";
	    var addurl="";
		if(!endEdit(gname))
			return false;
		var rows=$('#'+gname).datagrid("getChanges","inserted");
		var uprows=$('#'+gname).datagrid("getChanges","updated");
		rows=rows.concat(uprows);
		if(rows.length<=0){
			tip("没有需要保存的数据！")
			return false;
		}
		var result={};
		for(var i=0;i<rows.length;i++){
			for(var d in rows[i]){
				result[d]=rows[i][d];
			}
			result["tableName"]="${config_id}";
			$.ajax({
				url:"cgFormBuildController.do?saveOrUpdate",
				type:"post",
				data:result,
				dataType:"json",
				success:function(data){
					tip(data.msg);
					if(data.success){
						//reloadTable();
					}
				}
			})
		}

	}
	
		//结束编辑
	function endEdit(gname){
		var  editIndex = $('#'+gname).datagrid('getRows').length-1;
		for(var i=0;i<=editIndex;i++){
			if($('#'+gname).datagrid('validateRow', i))
				$('#'+gname).datagrid('endEdit', i);
			else
				return false;
		}
		return true;
	}
	
	//-------------------------------------------------------------------------------------------------------------------------------
	//查看
	function ${config_id}view(){
		detail('查看','cgFormBuildController/ftlForm/${config_id}/goDetail.do?olstylecode=${_olstylecode}','${config_id}List',${config_id}Fw,${config_id}Fh);
	}
    //----author:jg_xugj---end----date:20151219-------- for：#813 【online表单】扩展出三个请求：独立的添加、查看、编辑请求，原来的保留
	
	
	//批量删除
	function ${config_id}delBatch(){
		//获取选中的ID串
		var ids = get${config_id}ListSelections('id');
		if(ids.length<=0){
			tip('请选择至少一条信息');
			return;
		}
		$.dialog.confirm('确定删除吗?', function(r) {
			if(!r){return;}
			$.ajax({
			    url:"cgAutoListController.do?delBatch",
			    data:{'ids':ids,'configId':'${config_id}'},
				type:"Post",
			    dataType:"json",
			    success:function(data){
					tip(data.msg);
					reload${config_id}List();
			    },
				error:function(data){
					$.messager.alert('错误',data.msg);
				}
			});
			}
		);
	}

	function ${config_id}ExportExcel(){
		var queryParams = $('#${config_id}List').datagrid('options').queryParams;
		$('#${config_id}Listtb').find('*').each(function() {
		    queryParams[$(this).attr('name')] = $(this).val();
		});
		var params = '&';
		$.each(queryParams, function(key, val){
			params+='&'+key+'='+val;
		}); 
		var fields = '&field=';
		$.each($('#${config_id}List').datagrid('options').columns[0], function(i, val){
			if(val.field != 'opt'&&val.field != 'ck'){
				fields+=val.field+',';
			}
		});
        <#--//update-begin--Author:dangzhenghui  Date:20170429 for：TASK #1906 【online excel】Online excel 导出功能改进 -->
        var id='&id=';
        $.each($('#${config_id}List').datagrid('getSelections'), function(i, val){
            id+=val.id+",";
        });
        window.location.href = "excelTempletController.do?exportXls&tableName=${config_id}"+encodeURI(params+fields+id)
        <#-- //update-end--Author:dangzhenghui  Date:20170429 for：TASK #1906 【online excel】Online excel 导出功能改进 -->
	}
	<#--update--begin--author:zhangjiaqiang Date:20170507 for:修订页面回车查询异常 -->
	//回车查询
	function EnterPress(e){
		var e = e || window.event;
		if(e.keyCode == 13){
			${config_id}Listsearch();
			return false;
		}
	}
	<#--update--end--author:zhangjiaqiang Date:20170507 for:修订页面回车查询异常 -->
	
	//JS增强
	${config_jsenhance}
</script>
<table width="100%"   id="${config_id}List" toolbar="#${config_id}Listtb"></table>
<div id="${config_id}Listtb" style="padding:3px; height: auto">
<#if config_querymode == "group">
	<div name="searchColums">
	<form name="searchColumsForm" id="searchColumsForm" onkeydown="EnterPress(event);">
	<#--update--begin--author:zhangjiaqiang date:20171115 for:TASK #2420 【online功能】查询按钮位置调整 -->
	<span style="max-width: 83%;display: inline-block;display:-moz-inline-box;">
	<#--update--end--author:zhangjiaqiang date:20171115 for:TASK #2420 【online功能】查询按钮位置调整 -->
	<#list config_queryList  as x>
		<#if x['field_isQuery']=="Y">
		<#--update--begin--author:zhangjiaqiang date:20171115 for:TASK #2420 【online功能】查询按钮位置调整 -->
		<span style="display:-moz-inline-box;display:inline-block;margin-bottom:2px;text-align:justify;">
		<#--update--end--author:zhangjiaqiang date:20171115 for:TASK #2420 【online功能】查询按钮位置调整 -->
		<span style="vertical-align:middle;display:-moz-inline-box;display:inline-block;width: 100px;text-align:right;text-align:right;text-overflow:ellipsis;-o-text-overflow:ellipsis; overflow: hidden;white-space:nowrap;" title="${x['field_title']}">${x['field_title']}：</span>
		</#if>
		<#if x['field_queryMode']=="group">
			<#if x['field_isQuery']=="Y">
			<input type="text" name="${x['field_id']}_begin"  style="width: 120px"  <#if x['field_type']=="Date">class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"</#if> value="${x['field_value_begin']}" />
			<span style="display:-moz-inline-box;display:inline-block;width: 8px;text-align:right;">~</span>
			<input type="text" name="${x['field_id']}_end"  style="width: 120px" <#if x['field_type']=="Date">class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"</#if> value="${x['field_value_end']}"/>
			<#else>
			<input type="hidden" name="${x['field_id']}_begin"   value="${x['field_value_begin']}"/>
			<input type="hidden" name="${x['field_id']}_end"    value="${x['field_value_end']}"/>
			</#if>
		</#if>
		<#if x['field_queryMode']=="single">
			<#if x['field_isQuery']=="Y">
				<#if  (x['field_dictlist']?size >0)>
					<select name = "${x['field_id']}"  style="width: 120px">
					<option value = ""></option>
					<#list x['field_dictlist']  as xd>
						<option value = "${xd['code']}">${xd['typename']}</option>
					</#list>
					</select>
				</#if>
				<#if  (x['field_dictlist']?size <= 0)>
					<#if x['field_showType']!='popup'>
					<input type="text" name="${x['field_id']}" style="width: 120px" <#if x['field_type']=="Date">class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"</#if>  value="${x['field_value']?if_exists?default('')}" />
					<#else>
					<input type="text" name="${x['field_id']}"  style="width: 120px" 
									class="searchbox-inputtext" value="${x['field_value']?if_exists?default('')}"
									<#--update--begin--author:gj_shaojc date:20180316 for:TASK #2557 【问题确认】网友问题确认 -->
							       onClick="popupClick(this,'${x['field_dictText']?if_exists?html}','${x['field_dictField']?if_exists?html}','${x['field_dictTable']?if_exists?html}');" />
									<#--update--end--author:gj_shaojc date:20180316 for:TASK #2557 【问题确认】网友问题确认 -->					</#if>
				</#if>
			<#else>
					<input type="hidden" name="${x['field_id']}"    value="${x['field_value']?if_exists?default('')}" />
			</#if>
		</#if>
		</span>	
	</#list>
	<#--update--begin--author:zhangjiaqiang date:20171115 for:TASK #2420 【online功能】查询按钮位置调整 -->
	</span>
	<#if  (config_queryList?size >0)>
	<#if config_querymode == "group" >
		<span style="float:right">
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="${config_id}Listsearch()">查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" onclick="${config_id}searchReset('${config_id}List')">重置</a>
		</span>
	</#if>
	</#if>
	<#--update--end--author:zhangjiaqiang date:20171115 for:TASK #2420 【online功能】查询按钮位置调整 -->
	</form>
	</div>
</#if>

	<div class="datagrid-toolbar">
	<span style="float:left;" >
	<a  id="add" href="javascript:void(0)"  class="easyui-linkbutton" plain="true"  icon="icon-add" onclick="${config_id}addRow()">增加行</a>
	<a  id="update" href="javascript:void(0)"  class="easyui-linkbutton" plain="true"  icon="icon-edit" onclick="${config_id}editRow()">编辑</a>
		<a id="detail" href="javascript:void(0)" class="easyui-linkbutton" plain="true"  icon="icon-search" onclick="${config_id}saveData()">保存</a>
		<a id="detail" href="javascript:void(0)" class="easyui-linkbutton" plain="true"  icon="icon-search" onclick="${config_id}reject()">取消编辑</a>
	<a id="delete" href="javascript:void(0)" class="easyui-linkbutton" plain="true"  icon="icon-remove" onclick="${config_id}delBatch()">批量删除</a>
	<a id="import" href="javascript:void(0)"  class="easyui-linkbutton" plain="true"  icon="icon-put" onclick="add('${config_name}Excel数据导入','excelTempletController.do?goImplXls&tableName=${config_id}','${config_id}List')">Excel数据导入</a>
	<a id="excel" href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="${config_id}ExportExcel()"  icon="icon-putout">Excel导出</a>
	
	<#list config_buttons as x>
		<#if x['buttonStyle'] == 'button' && x['buttonStatus']=='1'>
			<a id="${x['buttonCode']}" href="javascript:void(0)" class="easyui-linkbutton" plain="true"  icon="${x['buttonIcon']?if_exists?default('pictures')}" 
				<#if x['optType'] == 'action'>
				onclick="doBusButton('cgFormBuildController.do?doButton&formId=${x['formId']}&buttonCode=${x['buttonCode']}&tableName=${config_id}','${x['buttonName']}','${config_id}List')">${x['buttonName']}</a>
				<#else>
				onclick="${x['buttonCode']}();">${x['buttonName']}</a>
				</#if>
		</#if>
	</#list>
	</span>
	
<#if  (config_queryList?size >0)>
	<#if config_querymode == "single">
		<span style="float:right">
		<input id="${config_id}Listsearchbox" class="easyui-searchbox"  data-options="searcher:${config_id}Listsearchbox,prompt:'请输入关键字',menu:'#${config_id}Listmm'"></input>
		<div id="${config_id}Listmm" style="width:120px">
		<#list config_queryList  as x>
			<#if x['field_isQuery']=="Y">
			<div data-options="name:'${x['field_id']}',iconCls:'icon-ok'  ">${x['field_title']}</div>
			<#else>
			</#if>
		</#list>
		</div>
		</span>
	</#if>
</#if>
	</div>
</div>
</body>
</html>
<#--update-end--Author:luobaoli  Date:20150703 for：将本文档中所有href="#"修改为href="javascript:void(0)",避免rest风格下新增/删除等操作跳转到主页问题-->