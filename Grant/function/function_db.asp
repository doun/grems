<%
function connect_db(strSQL) 
'--------------------------------------------------------------------------
'--���ƣ��������ݿ⺯��
'--���أ����ӳɹ�����"��"�������� ������룬�޼�¼�򷵻�"���ݿ��޼�¼!"
'--ע�⣺���ݿ����Ӵ�����Application��Session������
'--------------------------------------------------------------------------
    on error resume next
    dim adStateClosed 'Ĭ�ϣ�ָʾ�����ǹرյġ�
	dim adStateOpen   'ָʾ�����Ǵ򿪵ġ�
	adStateClosed=0  
	adStateOpen=1  
	if Session("OraAMSRs").State = adStateOpen then Session("OraAMSRs").Close   
	
	Session("OraAMSRs").Open strSQL, session("OraAMSCnn") ,3			'�������ݿ�
    if Err.number  <> 0 then												'���ݿ����ӳ���
		OraStr =replace(session("OraAMScnn").Errors.Item(0),Chr(13),"")	'ȥ���س����� 
		OraStr=replace(OraStr,"""","��")
		OraStr =server.HTMLEncode(replace(OraStr,Chr(10),""))
		connect_db="(ORACLE���󣬴�������ǣ�" & OraStr& ")������ϵͳ������Ա��ϵ"
		
		'----------�����������----------
	    Err.Clear
		session("OraAMScnn").Errors.Clear 
	    '----------------------------------
		exit function
    end if
    	
	if (Session("OraAMSRs").BOF and Session("OraAMSRs").EOF) then
		 connect_db="���ݿ��޼�¼!"
		 exit function
	end if
    connect_db="0"
end function

'----------------------------------------------------------------------
'-----------------   �� �� �� �� �⣨����ı�ִ�е���SQL������---------
'----------------------------------------------------------------------
function change_db(strSQL) 
		Set Session("OraAMSRs") =session("OraAMSCnn").Execute (strSQL)
	if Err.number  <> 0 then						'���ݿ����ӳ���
			OraStr=session("OraAMSCnn").Errors.Item(0)& " " &OraLWCnn.Errors.Item(0) 
			OraStr =replace(OraStr,Chr(13),"")		'ȥ���س����� 
			OraStr =replace(OraStr,Chr(10),"")
			change_db= "(ORACLE���󣬴�������ǣ�" & OraStr& ")"
            		
			'----------�����������----------
			Err.Clear
			OraLWCnn.Errors.Clear 
			Application("OraAMSCnn").Errors.Clear 
			'----------------------------------
			exit function
	end if
	change_db="0"
end function

'----------------------------------------------------------------------
'----------------- ��¼�˺źϷ��Լ��&��ʾ��Ա��ϸ��Ϣ ----------------
'----------------------------------------------------------------------
function check_valid() 
	dim returnStr

	EP_ID=session("LOGIN_ID")
    EP_Pass=session("LOGIN_Pass")
   
	strSQL="SELECT EP_ID,EP_NAME,EP_DEPNAME,WG_RIGHT,EP_PASSWD "&_
	" from AMS.VW_HAUTHORIZE where EP_ID='"&ucase(EP_ID)&"'"
	'����VW_HAUTHORIZEΪ��Ȩר�Ž�������ͼ
	
	returnStr=connect_db(strSQL)
	if cstr(returnStr) <> "0" then 
    	check_valid="ϵͳ����"&cstr(returnStr)
    	exit function
	else
		
		if (Session("OraAMSRs").BOF and Session("OraAMSRs").EOF) then
		     check_valid="�ʺŴ���"
		     exit function
		 end if
		 
         if EP_Pass<> Session("OraAMSRs").fields("EP_PASSWD") then
			   check_valid="�������"
			   exit function
		end if
    end if
	check_valid=0    
end function


%>
