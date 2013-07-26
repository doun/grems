<!--#include file="check.asp"-->

<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->


<%

function check_user_in_group(ep_id,WorkGroup)
     StrSQL="select ep_id,ep_workgroup from "&Application("DBOwner")&".Grems_Employee where ep_id='"&ep_id&"'" 
	 returnStr=connect_DB(StrSQL) 
     'Response.Write StrSQL
     if cstr(returnStr) <> "0" then 
		if returnStr="数据库无记录!" then
			check_user_in_group="无此员工号：‘"&ep_id&"’！"
		else
    		check_user_in_group="系统错误！"&cstr(returnStr)
    	end if
    	exit function
     end if
    
     if (Session("OraAMSRs").BOF and Session("OraAMSRs").EOF) then
		 check_user_in_group="没有此用户！"
	     exit function
	 else
	     tempStr=trim(Session("OraAMSRs").fields("ep_workgroup"))
	     if tempStr="" or  isnull(tempStr) then
			check_user_in_group="2"   '为空
		 else
			if instr(1,tempStr,WorkGroup)<>0 then
				check_user_in_group="1"  '存在
			else
				check_user_in_group="0"  '不存在
			end if
		end if
	end if
end function


sub del_group(WorkGroup)
	uStr=","&WorkGroup
	'delStr="delete  from "&Application("DBOwner")&".grems_user_info a where a.id in (select EP_ID from "&Application("DBOwner")&".Grems_Employee b where b.ep_workgroup='"&uStr&"')"
	'session("OraAMSCnn").Execute(delStr)
	StrSql="update "&Application("DBOwner")&".Grems_Employee set ep_workgroup=replace(ep_workgroup,'"&uStr&"','') where ep_workgroup like '%"&WorkGroup&"%'"	
	'Response.Write StrSql
	'Response.End 
	session("OraAMSCnn").Execute(StrSql) 
	'if cstr(returnDelStr) <> "0" then 
	'	if returnStr<>"数据库无记录!" then
	'		message "错误：","系统错误！"&cstr(returnDelStr),0
    '	end if
    '	exit sub
     'end if
end sub


sub save_to_group()
	call del_group(session("Group_ID"))
    'on error resume next
	'session("OraAMSCnn").BeginTrans				'将整个更新过程作为一个事物处理
    'StrSQL="update "&Application("DBOwner")&".Grems_Employee set ep_workGroup='' where ep_workGroup='"&Session("Group_ID")&"'"
	'Set Session("OraAMSRs") =session("OraAMSCnn").Execute (StrSQL)  '先将所有本组的人员删除
	if Request.Form("select_users").Count>=1 then 
	
	for i=1 to Request.Form("select_users").Count 
			iCount=instr(1,Request.Form("select_users").Item(i)," ")
			sCount=instr(iCount,Request.Form("select_users").Item(i)," ")
			ep_id=mid(Request.Form("select_users").Item(i),1,iCount-1)
			'ep_name=trim(mid(Request.Form("select_users").Item(i),iCount,sCount-1))
			'cc=instr(1,ep_name," ")
			'if cc>0 then
			'	ep_name=left(ep_name,cc)
			'end if
			'Response.Write trim(ep_name)
			'Response.Write len(trim(ep_name))
			returnStr=check_user_in_group(trim(ep_id),session("Group_ID")) '判断此员工在组里是否存在
			'if cstr(returnStr) <> "0" then 
    		'	message "错误:",cstr(returnStr),0
    		'	call gotopage("GroupUser.asp?WG_ID="&Session("Group_ID"))
    		'	exit sub
    		'else
    		'Response.Write  returnStr
			if returnStr="0" or returnStr="2" then
				'if returnStr="2" then
				'	upStr=session("Group_ID")
				'elseif returnStr="0" then
					upStr=","&session("Group_ID")
				'end if
				'set rs=server.CreateObject("Adodb.recordset") 
				'sStr="select count(ID) from  "&Application("DBOwner")&".Grems_user_info where ID='"&trim(ep_id)&"'"
				'set rs=session("OraAMSCnn").Execute (sStr)
				'if cint(rs.Fields(0).Value)=0 then
				'	instrSql="insert into "&Application("DBOwner")&".Grems_user_info (ID,NAME) values ('"&trim(ep_id)&"','"&trim(ep_name)&"')"
				'	session("OraAMSCnn").Execute(instrSql)
				'end if
				'rs.Close 
				'set rs=nothing
				StrSQL="update "&Application("DBOwner")&".Grems_Employee set ep_workGroup=ep_workGroup ||'"&upStr&"' where ep_ID='"&trim(ep_id)&"'" 
				Set Session("OraAMSRs") =session("OraAMSCnn").Execute (StrSQL)
				
				if Err.number  <> 0 then					'数据库连接出错
				Exit for		
			
			end if
			'end if							'跳出而不做任何处理，稍后处理。
		end if
	next
	
	 if Err.number  <> 0 then						'数据库连接出错
			OraStr=session("OraAMSCnn").Errors.Item(0)& " " &OraLWCnn.Errors.Item(0) 
			OraStr =replace(OraStr,Chr(13),"")		'去掉回车换行 
			OraStr =replace(OraStr,Chr(10),"")
			trans_data="(ORACLE错误，错误代码是：" & OraStr& ")"
		
			'----------清除错误集内容----------
			Err.Clear
			OraLWCnn.Errors.Clear 
			session("OraAMSCnn").Errors.Clear 
			'----------------------------------
		    'session("OraAMSCnn").RollbackTrans  '全部回退
			exit sub
		end if
	 'Application("OraAMSCnn").CommitTrans			'全部更新
	 end if
	 message "恭喜：","修改成功！",0
     call gotopage("GroupUser.asp?WG_ID="&Session("Group_ID"))
end sub

call  save_to_group()
%>

<!--#include file=../include/ApplicationAdd.asp-->
<%
CreateApplicationGrant("ALL")
%>


