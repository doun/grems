<%

	
	
	set GremsConn=server.createobject("adodb.connection")
    GremsConn.open Application("GREMS_ConnectionString")
    if err.number<>0 then 
        err.clear
        GremsConn.close
        set GremsConn=nothing
	    response.write "连接数据库错误!"
        Response.End 
    end if
    
    
	If Request.QueryString("Op") = "Add" then
		iResult = AddNewRecord				' 添加新记录
	End If


	
	Response.Write("<Script Language = 'javascript'>" & vbCrLf)

	Select Case iResult 
		Case -1		' 修改,增加,删除保存失败
			Response.Write("alert('数据保存时发生错误 !" & strError & "') ;" & vbCrLf)
		Case 1		' 修改,增加保存成功
				Response.Write("alert('保存成功！') ;" & vbCrLf)
				'Response.Write("parent.window.location.reload(true) ;" & vbCrLf)
				'Response.Write("parent.window.close() ;")
			
		Case 2		' 表示删除记录成功			
			Response.Write("parent.window.parent.window.location.reload(true) ;" & vbCrLf)	
		Case 3		' 表示支付记录成功			
			Response.Write("parent.window.parent.window.location.reload(true) ;" & vbCrLf)	
			
		Case -3		' 表示记录不存在
			Response.Write("alert('该记录已不存在 ！请刷新') ;" & vbCrLf)
		Case -4		' 表示记录存在
			Response.Write("alert('该记录已存在 ！请刷新') ;" & vbCrLf)		
		End Select 
	Response.Write("</Script>" & vbCrLf)


	
Function AddNewRecord
	'数据库变量定义
	
	Dim lb_special
	lb_special = Request.QueryString("Special")
	
	'状态表保存：ID, SYS_TYPE,Current_Status, Version
	
	Dim ID,Sys_Type,Current_Status,Version,station
	
	'申请表保存
	Dim Bucket_No,Liqut_Altitude,Cycle_Time,Sec_Pumps,Sec_Stages,Crf_Pumps,Seawater_Flow,Apply_Date,Apply_Memo,Apply_USRID,Special_Reason
		
	
	'取样表保存
	Dim sample_pubnum1,sample_pubnum2,sample_uid,sample_date,sample_start_User,sample_start_Date,sample_memo,sample_special_reason
	
	'分析表保存
	
	Dim Scale_Tritium,Scale_Y,Scale_B,Scale_Ag110,Scale_CO58,Scale_CO60,Scale_CS137,Scale_CS134,Scale_I131,Scale_I133,Scale_MN54
	Dim Scale_SB124,Scale_XE133,Scale_XE135,Scale_KR85,Scale_KR88,Scale_Release_Speed,Scale_Scale_ID
	Dim Scale_Scale_Date,Scale_Scale_Memo,Scale_Chimney_Speed,Scale_Special_Reason,Scale_Current_Divide
	
	'检查表保存
	Dim Check_ID,Check_Date,Check_Memo
	
	'审批表保存
	Dim Confirm_Special_Reason,Confirm_ID,Confirm_Date,Confirm_Memo
	
	'排放表保存
	Dim Release_Sub_ID,Release_Start_Time,Release_End_Time,Release_Okrt901ma,Release_Release_Speed
	Dim Release_Release_Liquid,Release_Chimney_Speed,Release_Direction80M,Release_Speed80M
	Dim Release_Bucket_Pressure,Release_Release_ID,Release_Release_Date,Release_Release_Memo
	Dim Release_NO_Conflect,Release_Bucket_Pressure2,Release_Confirm80M,Release_Special_reason
	DIm Release_Start_Release_Memo,Release_Start_User,Release_End_Release_Date
	
	
	'执行人员表保存
	Dim exe_app,exe_sam,exe_sal,exe_chk,exe_com,exe_cm2
	dim exe_rs1,exe_rs2,exe_rs3,exe_rs4,exe_rs5,exe_rs6,exe_rs7,exe_rs8,exe_rs9
	
	
	ID=Trim(Request.Form("ID"))
	
	station = Trim(Request.Form("station"))
	
	iYear = year(date())
	
	sys = trim(Request.QueryString("Sys"))
	
	machine = trim(Request.Form("Bucket_No"))
	
	if sys = "TER" or sys = "SEL" or sys="LIQ" then
		ID = "0" + cstr(sys) + cstr(iYear)
		strSql = "Select Max(SUBSTR(ID, 10, 13)) as max_id from Grems.Grems_Status where ID like '%"+ID+"%' "		
	end if
	if sys="ETY" then
		ID = cstr(sys) + cstr(iYear)
		strSql = "Select Max(SUBSTR(ID, 10, 13)) as max_id from Grems.Grems_Status where ID like '%"+ID+"%' "		
	end if
	if sys="TEG" then
		ID = "9" + cstr(sys) + cstr(iYear)
		strSql = "Select Max(SUBSTR(ID, 10, 13)) as max_id from Grems.Grems_Status where ID like '%"+ID+"%' "		
	end if
	
	

	
	Set rsTmp = Server.CreateObject("ADODB.Recordset")
	
	rsTmp.Open strSql,GremsConn
	
	IF not rsTmp.BOF Then
		Max_ID = Cint(rsTmp("max_id"))
		
		Max_ID = Max_ID + 1
		if Max_ID < 10 then
			True_Id = "000" + cstr(Max_ID)
		elseif Max_ID < 100 then
			True_Id = "00" +cstr(Max_ID)
		elseif Max_ID < 1000 then
			True_Id = "0" + cstr(Max_ID)
		elseif Max_ID < 10000 then
			True_Id = Cstr(Max_ID)
		end if
		
	else
		Max_ID = "0001"
		True_Id = cstr(Max_ID)
		
	end if
	
	
		if machine = "1号机" then
		   machine = 1
		else
		   machine = 2
		end if


	if sys = "TER" or sys = "SEL" or sys="LIQ" then
		ID = station + ID + True_Id
	end if
	if sys = "ETY" then
		ID = station + cstr(machine) + ID + True_Id
	end if
	if sys = "TEG" then
		ID = station + ID + True_Id
	end if
	
	
	Sys_Type = Trim(Request.Form("Sys_Type"))
	Current_Status = Trim(Request.Form("Current_Status"))
	Version =Trim(Request.Form("Version"))
			

	'检查状态表是否存在记录
	GremsConn.BeginTrans
	
	strSql = "SELECT ID From Grems.Grems_Status WHERE ID='"&ID&"'"
	Set rsTmp = Server.CreateObject("ADODB.Recordset")
	rsTmp.Open strSql,GremsConn
	
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存状态表
		if lb_special="True" then
		strSQL = "INSERT INTO Grems.Grems_Status(ID,Sys_Type,Current_Status,isspecial_app,isspecial_sam,isspecial_scl,isspecial_cfm,Version) values('"
		strSQl = strSQL & ID & "','"
		strSQl = strSQL & Sys_Type & "','"
		strSQl = strSQL & Current_Status & "','"
		strSQl = strSQL & "1" & "','"
		strSQl = strSQL & "1" & "','"
		strSQl = strSQL & "1" & "','"
		strSQl = strSQL & "1" & "','"
		strSQl = strSQL & Version & "')"

		else
		strSQL = "INSERT INTO Grems.Grems_Status(ID,Sys_Type,Current_Status,Version) values('"
		strSQl = strSQL & ID & "','"
		strSQl = strSQL & Sys_Type & "','"
		strSQl = strSQL & Current_Status & "','"
		strSQl = strSQL & Version & "')"
		end if		
		'Response.Write strSQL
		'Response.End
		
		 On Error Resume Next
         GremsConn.Execute(strSQL)
         
         If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			GremsConn.CommitTrans
			AddNewRecord=1
         
         End if
		
	End if
	
	Bucket_No=Trim(Request.Form("Bucket_No"))
	Liqut_Altitude = Trim(Request.Form("Liqut_Altitude"))
	Cycle_Time = Trim(Request.Form("Cycle_Time"))
	Sec_Pumps = Trim(Request.Form("Sec_Pumps"))
	Sec_Stages = Trim(Request.Form("Sec_Stages"))
	Crf_Pumps = Trim(Request.Form("Crf_Pumps"))
	Seawater_Flow = Trim(Request.Form("Seawater_Flow"))
	Apply_Date = Trim(Request.Form("Apply_Date"))
	Apply_Memo = Trim(Request.Form("Apply_Memo"))
	Apply_USRID = Trim(Request.Form("Apply_USRID")) 
	Special_Reason = Trim(Request.Form("Apply_Special_Reason")) 
	
	'检查申请表是否存在记录
	strSql = "SELECT ID From Grems.Grems_Status WHERE ID='"&ID&"'"
	rsTmp.Open strSql,GremsConn
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存申请表
		strSQL = "INSERT INTO Grems.Grems_Apply(ID,Bucket_No,Liqut_Altitude,Cycle_Time,Sec_Pumps,Sec_Stages,Crf_Pumps,Seawater_Flow,Apply_Date,Apply_Memo,Apply_USRID,Special_Reason) values('"
		strSQl = strSQL & ID & "','"
		strSQl = strSQL & Bucket_No &"','"
		strSQl = strSQL & Liqut_Altitude & "',"
		strSQl = strSQL & "to_date('"& Cycle_Time & "','YYYY-MM-DD hh24:mi'),'"
		strSQl = strSQL & Sec_Pumps & "','"
		strSQl = strSQL & Sec_Stages & "','"
		strSQl = strSQL & Crf_Pumps & "','"
		strSQl = strSQL & Seawater_Flow & "',"
		strSQl = strSQL & "to_date('"& Apply_Date & "','YYYY-MM-DD hh24:mi'),'"
		strSQl = strSQL & Apply_Memo & "','"
		strSQl = strSQL & Apply_UsrID & "','"
		strSQl = strSQL & Special_Reason & "')"
		
	
		Response.Write strSQL
		'Response.End
		
		 On Error Resume Next
         GremsConn.Execute(strSQL)
         
         If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			'GremsConn.CommitTrans
			'AddNewRecord=1
         
         End if
		
	End if
	
	
	
	sample_pubnum1 = trim(Request.Form("pubnum1"))
	sample_pubnum2 = trim(Request.Form("pubnum2"))
	sample_uid = trim(Request.Form("sample_uid"))
	sample_date = trim(Request.Form("sample_date"))
	sample_start_User = trim(Request.Form("sample_start_user"))       '放样人 
	sample_start_Date  = trim(Request.Form("sample_start_date")) '放样时间
	sample_start_date = "1999-01-01"
	sample_memo  = trim(Request.Form("sample_memo"))
	sample_special_reason  = trim(Request.Form("sample_special_reason"))
	
	'检查取样表是否存在记录
	strSql = "SELECT ID From Grems.Grems_Sample WHERE ID='"&ID&"'"
	rsTmp.Open strSql,GremsConn
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存取样表
		strSQL = "INSERT INTO Grems.Grems_Sample(ID,pubnum1,pubnum2,sample_uid,sample_date,start_user,start_date,sample_Memo,Special_Reason) values('"
		strSQl = strSQL & ID & "','"
		strSQl = strSQL & sample_pubnum1 &"','"
		strSQl = strSQL & sample_pubnum2 & "','"
		strSQl = strSQL & sample_uid & "',"
		strSQl = strSQL & "to_date('"& sample_date & "','YYYY-MM-DD hh24:mi'),'"
		strSQl = strSQL & sample_start_user & "',"
		if sys="LIQ" then
			strSQl = strSQL & "null,'"
		else
			strSQl = strSQL & "to_date('"& sample_start_date & "','YYYY-MM-DD hh24:mi'),'"
		end if
		strSQl = strSQL & sample_memo & "','"
		strSQl = strSQL & sample_special_Reason & "')"
		
	
		'Response.Write strSQL
		'Response.End
		
		 On Error Resume Next
         GremsConn.Execute(strSQL)
         
         If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			'GremsConn.CommitTrans
			'AddNewRecord=1
         
         End if
		
	End if
	
	Scale_Tritium = trim(Request.Form("scale_tritium"))
	Scale_Y = trim(Request.Form("scale_y"))
	Scale_B = trim(Request.Form("scale_b"))
	Scale_Ag110 = trim(Request.Form("scale_ag110"))
	Scale_CO58 = trim(Request.Form("scale_co58"))
	Scale_CO60 = trim(Request.Form("scale_co60"))
	Scale_CS137 = trim(Request.Form("scale_cs137"))
	Scale_CS134 = trim(Request.Form("scale_cs134"))
	Scale_I131 = trim(Request.Form("scale_i131"))
	Scale_I133 = trim(Request.Form("scale_i133"))
	Scale_MN54 = trim(Request.Form("scale_mn54"))
	Scale_SB124 = trim(Request.Form("scale_sb124"))
	Scale_XE133 = trim(Request.Form("scale_xe133"))
	Scale_XE135 = trim(Request.Form("scale_xe135"))
	Scale_KR85 = trim(Request.Form("scale_kr85"))
	Scale_KR88 = trim(Request.Form("scale_kr88"))
	Scale_Release_Speed = trim(Request.Form("scale_Release_speed"))
	Scale_Scale_ID = trim(Request.Form("scale_scale_id"))
	Scale_Scale_Date = trim(Request.Form("scale_scale_date"))
	Scale_Scale_Memo = trim(Request.Form("scale_scale_memo"))
	Scale_Chimney_Speed = trim(Request.Form("scale_chimney_speed"))
	Scale_Special_Reason = trim(Request.Form("scale_special_reason"))
	Scale_Current_Divide = trim(Request.Form("scale_current_divide"))
	
	'检查分析表是否存在记录
	
	strSql = "SELECT ID From Grems.Grems_Scale WHERE ID='"&ID&"'"
	rsTmp.Open strSql,GremsConn
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存分析表
		strSQL = "INSERT INTO Grems.Grems_Scale(ID,tritium,Y,B,ag110,CO58,CO60,CS137,CS134,I131,I133,MN54,"
		strSQL = strSQL & "SB124,XE133,XE135,KR85,KR88,Release_Speed,Scale_ID,"
		strSQL = strSQL & "Scale_Date,Scale_Memo,Chimney_Speed,Special_Reason,Current_Divide) values('"
		strSQl = strSQL & ID & "','"
		strSQl = strSQL & Scale_Tritium &"','"
		strSQl = strSQL & Scale_Y &"','"
		strSQl = strSQL & Scale_B &"','"
		strSQl = strSQL & Scale_Ag110 &"','"
		strSQl = strSQL & Scale_CO58 &"','"
		strSQl = strSQL & Scale_CO60 &"','"
		strSQl = strSQL & Scale_CS137 &"','"
		strSQl = strSQL & Scale_CS134 &"','"
		strSQl = strSQL & Scale_I131 &"','"
		strSQl = strSQL & Scale_I133 &"','"
		strSQl = strSQL & Scale_MN54 &"','"
		strSQl = strSQL & Scale_SB124 &"','"
		strSQl = strSQL & Scale_XE133 &"','"
		strSQl = strSQL & Scale_XE135 &"','"
		strSQl = strSQL & Scale_KR85 &"','"
		strSQl = strSQL & Scale_KR88 &"','"
		strSQl = strSQL & Scale_Release_Speed &"','"
		strSQl = strSQL & Scale_Scale_ID &"',"
		strSQl = strSQL & "to_date('"& Scale_Scale_Date & "','YYYY-MM-DD hh24:mi'),'"
		strSQl = strSQL & Scale_Scale_Memo &"','"
		strSQl = strSQL & Scale_Chimney_Speed &"','"
		strSQl = strSQL & Scale_Special_reason &"','"
		strSQl = strSQL & Scale_Current_Divide &"')"
		
		'Response.Write strSQL
		'Response.End
		
		 On Error Resume Next
         GremsConn.Execute(strSQL)
         
         If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			GremsConn.CommitTrans
			AddNewRecord=1
         
         End if
		
	End if
	
	Check_ID = trim(Request.Form("check_id"))
	Check_Date = trim(Request.Form("check_Date"))
	Check_Memo = trim(Request.Form("check_Memo"))
	
	'检查表是否存在记录
	strSql = "SELECT ID From Grems.Grems_Check WHERE ID='"&ID&"'"
	rsTmp.Open strSql,GremsConn
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存检查表
		strSQL = "INSERT INTO Grems.Grems_Check(ID,Check_ID,Check_Date,Check_Memo) values('"
		strSQl = strSQL & ID & "','"
		strSQl = strSQL & Check_ID &"',"
		strSQl = strSQL & "to_date('"& Check_Date & "','YYYY-MM-DD hh24:mi'),'"
		strSQl = strSQL & Check_Memo &"')"
	
		'Response.Write strSQL
		'Response.End
		
		 On Error Resume Next
         GremsConn.Execute(strSQL)
         
         If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			'GremsConn.CommitTrans
			'AddNewRecord=1
         
         End if
		
	End if
	
	
		
	Confirm_id = trim(Request.Form("Confirm_ID"))
	Confirm_date = trim(Request.Form("Confirm_date"))
	Confirm_memo = trim(Request.Form("Confirm_memo"))
	Confirm2_id = trim(Request.Form("Confirm_ID2"))
	Confirm2_date = trim(Request.Form("Confirm_date2"))
	
	Confirm_special_reason = trim(Request.Form("Confirm_special_reason"))
	
	'审批表是否存在记录
	strSql = "SELECT ID From Grems.Grems_Confirm WHERE ID='"&ID&"'"
	rsTmp.Open strSql,GremsConn
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存审批表
		strSQL = "INSERT INTO Grems.Grems_Confirm(ID,Confirm_ID,Confirm_Date,Confirm2_ID,Confirm2_Date,Confirm_Memo,special_reason) values('"
		strSQl = strSQL & ID & "','"
		strSQl = strSQL & Confirm_ID &"',"
		strSQl = strSQL & "to_date('"& Confirm_Date & "','YYYY-MM-DD hh24:mi'),'"
		strSQl = strSQL & Confirm2_ID &"',"
		strSQl = strSQL & "to_date('"& Confirm2_Date & "','YYYY-MM-DD hh24:mi'),'"
		strSQl = strSQL & Confirm_Memo &"','"
		strSQl = strSQL & Confirm_special_reason &"')"
	
		'Response.Write strSQL
		'Response.End
		
		 On Error Resume Next
         GremsConn.Execute(strSQL)
         
         If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			'GremsConn.CommitTrans
			'AddNewRecord=1
         
         End if
		
	End if
	
	
	Release_Sub_ID = trim(Request.form("Release_Sub_ID"))
	Release_Start_Time = trim(Request.form("Release_Start_Time"))
	Release_End_Time = trim(Request.form("Release_End_Time"))
	Release_Okrt901ma = trim(Request.form("Release_Okrt901ma"))
	Release_Release_Speed = trim(Request.form("Release_Speed"))
	Release_Release_Liquid = trim(Request.form("Release_Liquid"))
	Release_Chimney_Speed = trim(Request.form("Release_Chimney_Speed"))
	Release_Direction80M = trim(Request.form("Release_Direction80M"))
	Release_Speed80M = trim(Request.form("Release_Speed80M"))
	
	Release_Bucket_Pressure = trim(Request.form("Release_Bucket_Pressure"))
	Release_Release_ID = trim(Request.form("Release_Release_ID"))
	Release_Release_Date = trim(Request.form("Release_Release_Date"))
	Release_Release_Memo = trim(Request.form("Release_Release_Memo"))
	Release_NO_Conflect = trim(Request.form("Release_NO_Conflect"))
	Release_Bucket_Pressure2 = trim(Request.form("Release_Bucket_Pressure2"))
	Release_Confirm80M = trim(Request.form("Release_Confirm80M"))
	Release_Special_reason = trim(Request.form("Release_Special_reason"))
	Release_Start_Release_Memo = trim(Request.form("Release_Start_Release_Memo"))
	Release_Start_User = trim(Request.form("Release_Start_User"))
	Release_End_Release_Date = trim(Request.form("Release_End_Release_Date"))
	
	'排放表是否存在记录
	strSql = "SELECT ID From Grems.Grems_Release WHERE ID='"&ID&"'"
	rsTmp.Open strSql,GremsConn
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存排放表
		strSQL = "INSERT INTO Grems.Grems_Release(ID,SUb_ID,Start_Time,End_Time,Okrt901ma,Release_Speed,Release_Liquid,"
		strSQl = strSQL & "Chimney_Speed,Direction80M,Speed80M,Bucket_Pressure,Release_ID,Release_Date,Release_Memo,"
		strSQl = strSQL &"No_Conflect,Bucket_Pressure2,Confirm80M,Special_Reason,Start_Release_Memo,Start_User,End_Release_Date) values('"
		strSQL = strSQL & ID &"','"
		strSQL = strSQL & Release_Sub_ID &"',"
		strSQl = strSQL & "to_date('"& Release_Start_Time & "','YYYY-MM-DD hh24:mi'),"
		strSQl = strSQL & "to_date('"& Release_End_Time & "','YYYY-MM-DD hh24:mi'),'"
		strSQL = strSQL & Release_Okrt901ma & "','"
		strSQL = strSQL & Release_Release_Speed & "','"
		strSQL = strSQL & Release_Release_Liquid & "','"
		strSQL = strSQL & Release_Chimney_Speed & "','"
		strSQL = strSQL & Release_Direction80M & "','"
		strSQL = strSQL & Release_Speed80M & "','"
		strSQL = strSQL & Release_Bucket_Pressure & "','"
		strSQL = strSQL & Release_Release_ID & "',"
		strSQl = strSQL & "to_date('"& Release_Release_Date & "','YYYY-MM-DD hh24:mi'),'"
		strSQL = strSQL & Release_Release_Memo & "','"
		strSQL = strSQL & Release_NO_Conflect & "','"
		strSQL = strSQL & Release_Bucket_Pressure2 & "','"
		strSQL = strSQL & Release_Confirm80M & "','"
		strSQL = strSQL & Release_Special_reason & "','"
		strSQL = strSQL & Release_Start_Release_Memo & "','"
		strSQL = strSQL & Release_Start_User & "',"
		strSQl = strSQL & "to_date('"& Release_End_Release_Date & "','YYYY-MM-DD hh24:mi'))" 
	
		'Response.Write strSQL
		'Response.End
		
		 On Error Resume Next
         GremsConn.Execute(strSQL)
         
         If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			'GremsConn.CommitTrans
			'AddNewRecord=1
         
         End if
		
	End if
	

	'保存执行人表
	strSql = "SELECT ID From Grems.Grems_Executer WHERE ID='"&ID&"'"
	Set rsTmp = Server.CreateObject("ADODB.Recordset")
	rsTmp.Open strSql,GremsConn
	
	IF not rsTmp.BOF Then
		AddNewRecord = -4 
		rsTmp.Close : Set rsTmp = Nothing
		Exit Function
	else
		'保存执行人表
		strSQL = "INSERT INTO Grems.Grems_Executer(ID) values('"
		strSQl = strSQL & ID & "')"
		
		
		
		'Response.Write strSQL
		'Response.End
		


		
		 On Error Resume Next
          GremsConn.Execute(strSQL)
          If GremsConn.Errors.Count <> 0 Then
			strError = GetDatabaseErrorMsg(MmsConn.Errors.Item(0).Description)
			GremsConn.Errors.Clear
			GremsConn.RollbackTrans
			AddNewRecord = -1
		 else
			GremsConn.CommitTrans
			AddNewRecord=1
         
         End if
		
	End if
	

		Response.Write("<Script Language = 'javascript'>" & vbCrLf)

		Response.Write("alert('您保存的的排放单号码是："&ID&" 请记录！') ;" & vbCrLf)		
	
		Response.Write("</Script>" & vbCrLf)
	
GremsConn.Close


End Function

%>