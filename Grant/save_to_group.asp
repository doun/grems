<%session("id")="D03"%>
<!--#include file=../../login/check_valid.asp-->

<!--#include file=../function/function_pub.asp-->
<!--#include file=../function/function_db.asp-->


<%

function check_user_in_group(ep_id)
     StrSQL="select ep_id,ep_workgroup from ams.Hemployee where ep_ID='"&ep_id&"'" 
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
		 if tempStr<>"" and tempStr<>trim(Session("Group_ID")) then
			   check_user_in_group="此员工:"&ep_id&"已经属于组:"&Session("OraAMSRs").fields("ep_workgroup")&",不能加入！"
			   exit function
		 end if
	end if
     check_user_in_group="0"
end function

sub save_to_group()
    'on error resume next
	'session("OraAMSCnn").BeginTrans				'将整个更新过程作为一个事物处理
    StrSQL="update ams.Hemployee set ep_workGroup='' where ep_workGroup='"&Session("Group_ID")&"'"
	Set Session("OraAMSRs") =session("OraAMSCnn").Execute (StrSQL)  '先将所有本组的人员删除
	
	for i=1 to Request.Form("select_users").Count 
			iCount=instr(1,Request.Form("select_users").Item(i)," ")
			ep_id=mid(Request.Form("select_users").Item(i),1,iCount-1)
			
			returnStr=check_user_in_group(trim(ep_id)) '判断此员工在其他的组里是否存在
			if cstr(returnStr) <> "0" then 
    			message "错误:",cstr(returnStr),0
    			call gotopage("GroupUser.asp?WG_ID="&Session("Group_ID"))
    			exit sub
    		else
				StrSQL="update ams.Hemployee set ep_workGroup='"&session("Group_ID")&"' where ep_ID='"&trim(ep_id)&"'" 
				Set Session("OraAMSRs") =session("OraAMSCnn").Execute (StrSQL)
				
				if Err.number  <> 0 then					'数据库连接出错
				Exit for		
			end if							'跳出而不做任何处理，稍后处理。
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
	 message "恭喜：","修改成功！",0
     call gotopage("GroupUser.asp?WG_ID="&Session("Group_ID"))
end sub

call  save_to_group()
%>

