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
		 if tempStr<>"" and tempStr<>trim(Session("Group_ID")) then
			   check_user_in_group="��Ա��:"&ep_id&"�Ѿ�������:"&Session("OraAMSRs").fields("ep_workgroup")&",���ܼ��룡"
			   exit function
		 end if
	end if
     check_user_in_group="0"
end function

sub save_to_group()
    'on error resume next
	'session("OraAMSCnn").BeginTrans				'���������¹�����Ϊһ�����ﴦ��
    StrSQL="update ams.Hemployee set ep_workGroup='' where ep_workGroup='"&Session("Group_ID")&"'"
	Set Session("OraAMSRs") =session("OraAMSCnn").Execute (StrSQL)  '�Ƚ����б������Աɾ��
	
	for i=1 to Request.Form("select_users").Count 
			iCount=instr(1,Request.Form("select_users").Item(i)," ")
			ep_id=mid(Request.Form("select_users").Item(i),1,iCount-1)
			
			returnStr=check_user_in_group(trim(ep_id)) '�жϴ�Ա���������������Ƿ����
			if cstr(returnStr) <> "0" then 
    			message "����:",cstr(returnStr),0
    			call gotopage("GroupUser.asp?WG_ID="&Session("Group_ID"))
    			exit sub
    		else
				StrSQL="update ams.Hemployee set ep_workGroup='"&session("Group_ID")&"' where ep_ID='"&trim(ep_id)&"'" 
				Set Session("OraAMSRs") =session("OraAMSCnn").Execute (StrSQL)
				
				if Err.number  <> 0 then					'���ݿ����ӳ���
				Exit for		
			end if							'�����������κδ����Ժ���
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
	 message "��ϲ��","�޸ĳɹ���",0
     call gotopage("GroupUser.asp?WG_ID="&Session("Group_ID"))
end sub

call  save_to_group()
%>

