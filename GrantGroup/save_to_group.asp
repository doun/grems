<!--#include file="check.asp"-->

<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->


<%

function check_user_in_group(ep_id,WorkGroup)
     StrSQL="select ep_id,ep_workgroup from "&Application("DBOwner")&".Grems_Employee where ep_id='"&ep_id&"'" 
	 returnStr=connect_DB(StrSQL) 
     'Response.Write StrSQL
     if cstr(returnStr) <> "0" then 
		if returnStr="���ݿ��޼�¼!" then
			check_user_in_group="�޴�Ա���ţ���"&ep_id&"����"
		else
    		check_user_in_group="ϵͳ����"&cstr(returnStr)
    	end if
    	exit function
     end if
    
     if (Session("OraAMSRs").BOF and Session("OraAMSRs").EOF) then
		 check_user_in_group="û�д��û���"
	     exit function
	 else
	     tempStr=trim(Session("OraAMSRs").fields("ep_workgroup"))
	     if tempStr="" or  isnull(tempStr) then
			check_user_in_group="2"   'Ϊ��
		 else
			if instr(1,tempStr,WorkGroup)<>0 then
				check_user_in_group="1"  '����
			else
				check_user_in_group="0"  '������
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
	'	if returnStr<>"���ݿ��޼�¼!" then
	'		message "����","ϵͳ����"&cstr(returnDelStr),0
    '	end if
    '	exit sub
     'end if
end sub


sub save_to_group()
	call del_group(session("Group_ID"))
    'on error resume next
	'session("OraAMSCnn").BeginTrans				'���������¹�����Ϊһ�����ﴦ��
    'StrSQL="update "&Application("DBOwner")&".Grems_Employee set ep_workGroup='' where ep_workGroup='"&Session("Group_ID")&"'"
	'Set Session("OraAMSRs") =session("OraAMSCnn").Execute (StrSQL)  '�Ƚ����б������Աɾ��
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
			returnStr=check_user_in_group(trim(ep_id),session("Group_ID")) '�жϴ�Ա���������Ƿ����
			'if cstr(returnStr) <> "0" then 
    		'	message "����:",cstr(returnStr),0
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
				
				if Err.number  <> 0 then					'���ݿ����ӳ���
				Exit for		
			
			end if
			'end if							'�����������κδ����Ժ���
		end if
	next
	
	 if Err.number  <> 0 then						'���ݿ����ӳ���
			OraStr=session("OraAMSCnn").Errors.Item(0)& " " &OraLWCnn.Errors.Item(0) 
			OraStr =replace(OraStr,Chr(13),"")		'ȥ���س����� 
			OraStr =replace(OraStr,Chr(10),"")
			trans_data="(ORACLE���󣬴�������ǣ�" & OraStr& ")"
		
			'----------�����������----------
			Err.Clear
			OraLWCnn.Errors.Clear 
			session("OraAMSCnn").Errors.Clear 
			'----------------------------------
		    'session("OraAMSCnn").RollbackTrans  'ȫ������
			exit sub
		end if
	 'Application("OraAMSCnn").CommitTrans			'ȫ������
	 end if
	 message "��ϲ��","�޸ĳɹ���",0
     call gotopage("GroupUser.asp?WG_ID="&Session("Group_ID"))
end sub

call  save_to_group()
%>

<!--#include file=../include/ApplicationAdd.asp-->
<%
CreateApplicationGrant("ALL")
%>


