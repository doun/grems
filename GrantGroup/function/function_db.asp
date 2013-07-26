<%
function connect_db(strSQL) 
'--------------------------------------------------------------------------
'--名称：连接数据库函数
'--返回：连接成功返回"０"，出错返回 错误代码，无记录则返回"数据库无记录!"
'--注意：数据库连接串放在Application和Session对象中
'--------------------------------------------------------------------------
    on error resume next
    dim adStateClosed '默认，指示对象是关闭的。
	dim adStateOpen   '指示对象是打开的。
	adStateClosed=0  
	adStateOpen=1  
	if Session("OraAMSRs").State = adStateOpen then Session("OraAMSRs").Close   
	
	Session("OraAMSRs").Open strSQL, session("OraAMSCnn") ,3			'连接数据库
    if Err.number  <> 0 then												'数据库连接出错
		OraStr =replace(session("OraAMScnn").Errors.Item(0),Chr(13),"")	'去掉回车换行 
		OraStr=replace(OraStr,"""","”")
		OraStr =server.HTMLEncode(replace(OraStr,Chr(10),""))
		connect_db="(ORACLE错误，错误代码是：" & OraStr& ")，请与系统管理人员联系"
		
		'----------清除错误集内容----------
	    Err.Clear
		session("OraAMScnn").Errors.Clear 
	    '----------------------------------
		exit function
    end if
    	
	if (Session("OraAMSRs").BOF and Session("OraAMSRs").EOF) then
		 connect_db="数据库无记录!"
		 exit function
	end if
    connect_db="0"
end function

'----------------------------------------------------------------------
'-----------------   修 改 数 据 库（纯粹改变执行单条SQL变量）---------
'----------------------------------------------------------------------
function change_db(strSQL) 
		Set Session("OraAMSRs") =session("OraAMSCnn").Execute (strSQL)
	if Err.number  <> 0 then						'数据库连接出错
			OraStr=session("OraAMSCnn").Errors.Item(0)& " " &OraLWCnn.Errors.Item(0) 
			OraStr =replace(OraStr,Chr(13),"")		'去掉回车换行 
			OraStr =replace(OraStr,Chr(10),"")
			change_db= "(ORACLE错误，错误代码是：" & OraStr& ")"
            		
			'----------清除错误集内容----------
			Err.Clear
			OraLWCnn.Errors.Clear 
			Application("OraAMSCnn").Errors.Clear 
			'----------------------------------
			exit function
	end if
	change_db="0"
end function

'----------------------------------------------------------------------
'----------------- 登录账号合法性检查&显示人员详细信息 ----------------
'----------------------------------------------------------------------
function check_valid() 
	dim returnStr

	EP_ID=session("LOGIN_ID")
    EP_Pass=session("LOGIN_Pass")
   
	strSQL="SELECT EP_ID,EP_NAME,EP_DEPNAME,WG_RIGHT,EP_PASSWD "&_
	" from AMS.VW_HAUTHORIZE where EP_ID='"&ucase(EP_ID)&"'"
	'其中VW_HAUTHORIZE为授权专门建立的视图
	
	returnStr=connect_db(strSQL)
	if cstr(returnStr) <> "0" then 
    	check_valid="系统错误！"&cstr(returnStr)
    	exit function
	else
		
		if (Session("OraAMSRs").BOF and Session("OraAMSRs").EOF) then
		     check_valid="帐号错误！"
		     exit function
		 end if
		 
         if EP_Pass<> Session("OraAMSRs").fields("EP_PASSWD") then
			   check_valid="密码错误！"
			   exit function
		end if
    end if
	check_valid=0    
end function


%>
