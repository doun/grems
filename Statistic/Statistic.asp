<%
session("userid")=Request.form("userid")
'设定常量
const ID=0
const SCALE_TRITIUM=1
const RELEASW_START_TIME=2
const RELEASE_END_TIME=3
const RELEASE_BUCKET_PRESSURE=4
const RELEASE_BUCKET_PRESSURE2=5

function p(str)
	p=Response.Write(str)
end function

function NowMonth(n)
	if n=1 then
		NowMonth=year(date())&"年"
	elseif n=0 then
		NowMonth=year(date())&"年"&month(date())&"月"
	end if
end function


Sub dbQuery(sql,sqlcount,myArray,myRows) '查询结果转换为二维数组
	set rs=server.CreateObject("adodb.recordset")
	set conn=server.createobject("adodb.connection")
    conn.open Application("GREMS_ConnectionString")
	rs.Open sql,conn,1,3
	if not rs.EOF then
		myArray	=rs.GetRows()
		set Rs1=server.CreateObject("adodb.recordset")
		Rs1.Open sqlcount,conn,1,3
			myRows	=cint(Rs1.Fields(0))-1
		Rs1.Close 
		set Rs1=nothing
	else
		myRows	=-1
	end if
	rs.Close
	set rs=nothing
	conn.close
	set conn=nothing
End Sub


%>

<%
function ID_num(Num,Name)  '获取GNPS,LNPS,GNP的排放次数
	if Num="GNPS" then
		R_num=count_num("D",Name)
	elseif Num="LNPS" then
		R_num=count_num("L",Name)	
	elseif Num="GNP" then
		R_num=count_num("A",Name)
	end if
	ID_num=R_num
end function


function count_num(W,Name)  '统计排放次数
	count_num=0
	if W<>"A" then
		for i=0 to ssRows
			if left(ssArray(ID,i),1)=W then
				if mid(ssArray(ID,i),3,3)=Name then
					count_num=count_num+1
				end if	
			end if
		next
	else
		for i=0 to ssRows
			if mid(ssArray(ID,i),3,3)=Name then
				count_num=count_num+1
			end if	
		next
	end if
end function


function ID_num_Count(Num,Name)  '获取GNPS,LNPS,GNP的排放次数
	if Num="GNPS" then
		R_num=count_num_Count("D",Name)
	elseif Num="LNPS" then
		R_num=count_num_Count("L",Name)	
	elseif Num="GNP" then
		R_num=count_num_Count("A",Name)
	end if
	ID_num_Count=R_num
end function


function count_num_Count(W,Name)  '统计排放次数
	count_num_Count=0
	if W<>"A" then
		for i=0 to ssRows_Count
			if left(ssArray_Count(ID,i),1)=W then
				if mid(ssArray_Count(ID,i),3,3)=Name then
					count_num_Count=count_num_Count+1
				end if	
			end if
		next
	else
		for i=0 to ssRows_Count
			if mid(ssArray_Count(ID,i),3,3)=Name then
				count_num_Count=count_num_Count+1
			end if	
		next
	end if
end function
'--------------------------------------------------------------------

function Timers_num(otype,Name) '获取GNPS,LNPS,GNP的排放时间
	if otype="GNPS" then
		R_num=count_Times("D",Name)
	elseif otype="LNPS" then
		R_num=count_Times("L",Name)	
	elseif otype="GNP" then
		R_num=count_Times("A",Name)
	end if
	Timers_num=formatNumber(R_num / 60,1)
end function


function count_Times(W,Name)  '统计排放时间
	count_Times=0
	if W<>"A" then
		for i=0 to ssRows
			if left(ssArray(ID,i),1)=W then
				if mid(ssArray(ID,i),3,3)=Name then
					if len(ssArray(RELEASW_START_TIME,i))>1 and len(ssArray(RELEASE_END_TIME,i))>1 then
						e_Times=datediff("n",ssArray(RELEASW_START_TIME,i),ssArray(RELEASE_END_TIME,i))
					else
						e_Times=0
					end if
					if len(e_Times)<=0 then
						e_Times=0
					end if
					count_Times=count_Times+e_Times
				end if	
			end if
		next	
	else
		for i=0 to ssRows
			if mid(ssArray(ID,i),3,3)=Name then
				if len(ssArray(RELEASW_START_TIME,i))>1 and len(ssArray(RELEASE_END_TIME,i))>1 then
					e_Times=datediff("n",ssArray(RELEASW_START_TIME,i),ssArray(RELEASE_END_TIME,i))
				else
					e_Times=0
				end if
				if len(e_Times)<=0 then
					e_Times=0
				end if
				count_Times=count_Times+e_Times
			end if	
		next	
	end if 
end function



'----------------------------------------------------------------
function V_num_TER(Vnum,Name)  '获取GNPS,LNPS,GNP的TER排放体积

	
	if Vnum="GNPS" then
		R_num=count_V_TER("D",Name)
	elseif Vnum="LNPS" then
		R_num=count_V_TER("L",Name)	
	elseif Vnum="GNP" then
		R_num=count_V_TER("A",Name)
	end if
	V_num_TER=R_num
end function


function count_V_TER(W,Name)
	count_V_TER=0
	Ter_Sub_ID=0
	
	if W<>"A" then
		for i=0 to ssRows
			if left(ssArray(ID,i),1)=W then
				if mid(ssArray(ID,i),3,3)=Name then
					if trim(ssArray(6,i))<>"" then
							'提取排放序列最大的一行记录
						for j = 0 to ssRows
							if ssArray(ID,j) = ssArray(ID,i) then
								Ter_Sub_ID = cint(ssArray(8,j))
							end if
						next
						if Ter_Sub_ID = 1 then
							count_V_TER=count_V_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						else
							i = i + cint(Ter_Sub_ID)-1
							count_V_TER=count_V_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						end if
					
					end if
				end if	
			end if
		next
	else
		for i=0 to ssRows
			if mid(ssArray(ID,i),3,3)=Name then
				if trim(ssArray(6,i))<>"" then	
						for j = 0 to ssRows
							if ssArray(ID,j) = ssArray(ID,i) then
								Ter_Sub_ID = cint(ssArray(8,j))
							end if
						next				
						if Ter_Sub_ID = 1 then
							count_V_TER=count_V_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						else
							i = i + cint(Ter_Sub_ID)-1
							count_V_TER=count_V_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						end if
					
				end if
			end if	
		next
	end if
	count_V_TER = cint(count_V_TER * 50)
End Function


function V_num(Vnum,Name)  '获取GNPS,LNPS,GNP的排放体积
	if Vnum="GNPS" then
		R_num=count_V("D",Name)
	elseif Vnum="LNPS" then
		R_num=count_V("L",Name)	
	elseif Vnum="GNP" then
		R_num=count_V("A",Name)
	end if
	V_num=R_num
end function

function count_V(W,Name) '统计排放体积
	count_V=0
	if W<>"A" then
		for i=0 to ssRows
			if left(ssArray(ID,i),1)=W then
				if mid(ssArray(ID,i),3,3)=Name then
					if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then
						count_V=count_V+cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i))
						'count_V=count_V+cint(ssArray(3,i))
					end if
				end if	
			end if
		next
	else
		for i=0 to ssRows
			if mid(ssArray(ID,i),3,3)=Name then
				if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
					count_V=count_V+cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i))
					'count_V=count_V+cint(ssArray(3,i))
				end if
			end if	
		next
	end if
	count_V = count_V * 50
end function


'----------------------------------------------------

function Bq_num(Bnum,Name)  '获取GNPS,LNPS,GNP的氚排放量
	if Bnum="GNPS" then
		R_num=count_B_Ter("D",Name)
	elseif Bnum="LNPS" then
		R_num=count_B_Ter("L",Name)	
	elseif Bnum="GNP" then
		R_num=count_B_Ter("A",Name)
	end if
	Bq_num=R_num
end function

function count_B_Ter(W,Name)  '统计TER氚排放量
	count_B_Ter=0
	if W<>"A" then
		for i=0 to ssRows
			if left(ssArray(ID,i),1)=W then
				if mid(ssArray(ID,i),3,3)=Name then
					if trim(ssArray(6,i))<>"" then	
						count_B_Ter=count_B_Ter+(cdbl(ssArray(7,i))-cdbl(ssArray(6,i)))*ssArray(SCALE_TRITIUM,i)
					end if					'count_B=count_B+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
				end if	
			end if
		next
	else
		for i=0 to ssRows
			if mid(ssArray(ID,i),3,3)=Name then
				if trim(ssArray(6,i))<>"" then	
					count_B_Ter=count_B_Ter+(cdbl(ssArray(7,i))-cdbl(ssArray(6,i)))*ssArray(SCALE_TRITIUM,i)
				end if
			end if	
		next
	end if
	if mid(count_B_Ter,1,1)="." then
		count_B_Ter="0"&count_B_Ter
	end if
end function



function count_B(W,Name)  '统计氚排放量
	count_B=0
	if W<>"A" then
		for i=0 to ssRows
			if left(ssArray(ID,i),1)=W then
				if mid(ssArray(ID,i),3,3)=Name then
					if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
						count_B=count_B+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
					end if					'count_B=count_B+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
				end if	
			end if
		next
	else
		for i=0 to ssRows
			if mid(ssArray(ID,i),3,3)=Name then
				if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
					count_B=count_B+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
				end if
			end if	
		next
	end if
	if mid(count_B,1,1)="." then
		count_B="0"&count_B
	end if
end function
%>


<%
function ID_num_E_TER(Num,Name,M)  '获取GNPS,LNPS,GNP的TER每月排放次数
	if Num="GNPS" then
		R_num=count_num_E_TER("D",Name,M)
	elseif Num="LNPS" then
		R_num=count_num_E_TER("L",Name,M)	
	elseif Num="GNP" then
		R_num=count_num_E_TER("A",Name,M)
	end if
	ID_num_E_TER=R_num
end function

function count_num_E_TER(W,Name,M)  '统计每月TER排放次数
	count_num_E_TER=0
	if M="0" then
		if W<>"A" then
			for i=0 to ssRows_Count
				if left(ssArray_Count(ID,i),1)=W then
					if mid(ssArray_Count(ID,i),3,3)=Name then
						count_num_E_TER=count_num_E_TER+1
					end if	
				end if
			next
		else
			for i=0 to ssRows_Count
				if mid(ssArray_Count(ID,i),3,3)=Name then
					count_num_E_TER=count_num_E_TER+1
				end if	
			next
		end if
	else
		if W<>"A" then
			for i=0 to ssRows_Count
				if left(ssArray_Count(ID,i),1)=W then
					if mid(ssArray_Count(ID,i),3,3)=Name then
						if month(ssArray_Count(RELEASE_END_TIME,i))=M or month(ssArray_Count(RELEASE_END_TIME,i))="0"&M then
							count_num_E_TER=count_num_E_TER+1
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows_Count
				if mid(ssArray_Count(ID,i),3,3)=Name then
					if month(ssArray_Count(RELEASE_END_TIME,i))=M or month(ssArray_Count(RELEASE_END_TIME,i))="0"&M then
						count_num_E_TER=count_num_E_TER+1
					end if
				end if	
			next
		end if
	end if
end function


function ID_num_E(Num,Name,M)  '获取GNPS,LNPS,GNP的每月排放次数
	if Num="GNPS" then
		R_num=count_num_E("D",Name,M)
	elseif Num="LNPS" then
		R_num=count_num_E("L",Name,M)	
	elseif Num="GNP" then
		R_num=count_num_E("A",Name,M)
	end if
	ID_num_E=R_num
end function

function count_num_E(W,Name,M)  '统计每月排放次数
	count_num_E=0
	if M="0" then
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						count_num_E=count_num_E+1
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					count_num_E=count_num_E+1
				end if	
			next
		end if
	else
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
							count_num_E=count_num_E+1
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
						count_num_E=count_num_E+1
					end if
				end if	
			next
		end if
	end if
end function


'---------------------------------------------------------------------
function V_num_E_TER(Vnum,Name,M)  '获取GNPS,LNPS,GNP的TER每月排放体积 -----by lb
	if Vnum="GNPS" then
		R_num_TER=count_V_E_TER("D",Name,M)
	elseif Vnum="LNPS" then
		R_num_TER=count_V_E_TER("L",Name,M)	
	elseif Vnum="GNP" then
		R_num_TER=count_V_E_TER("A",Name,M)
	end if
	V_num_E_TER=R_num_TER
end function


function count_V_E_TER(W,Name,M)  '统计每月TER排放体积-------------by lb
	count_V_E_TER=0
	
	Ter_Sub_ID=0
	

	if M="0" then
		if W<>"A" then
			for i=0 to ssRows
			
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
					
						if ssArray(6,i)<>"" then
							if trim(ssArray(6,i))<>"" then
							'提取排放序列最大的一行记录
							
							
							for j = 0 to ssRows
								if ssArray(ID,j) = ssArray(ID,i) then
									Ter_Sub_ID = cint(ssArray(8,j))
								end if
							next
							if Ter_Sub_ID = 1 then
								count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
							else
								i = i + cint(Ter_Sub_ID)-1
								count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
							end if
					
						 end if
					 end if
				end if	
			 end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if trim(ssArray(6,i))<>"" then	
						for j = 0 to ssRows
							if ssArray(ID,j) = ssArray(ID,i) then
								Ter_Sub_ID = cint(ssArray(8,j))
							end if
						next				
						if Ter_Sub_ID = 1 then
							count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						else
							i = i + cint(Ter_Sub_ID)-1
							count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						end if
					
					end if
				end if	
			next
		end if
	else
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
					
						if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
							if trim(ssArray(6,i))<>"" then
								for j = 0 to ssRows
									if ssArray(ID,j) = ssArray(ID,i) then
										Ter_Sub_ID = cint(ssArray(8,j))
									end if
								next				
								if Ter_Sub_ID = 1 then
									count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
								else
									i = i + cint(Ter_Sub_ID)-1
									count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
								end if
							end if
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
						if trim(ssArray(6,i))<>"" then	
						for j = 0 to ssRows
							if ssArray(ID,j) = ssArray(ID,i) then
								Ter_Sub_ID = cint(ssArray(8,j))
							end if
						next				
						if Ter_Sub_ID = 1 then
							count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						else
							i = i + cint(Ter_Sub_ID)-1
							count_V_E_TER=count_V_E_TER+cdbl(ssArray(7,i))-cdbl(ssArray(6,i))
						end if
					
						end if
					end if
				end if	
			next
		end if
	end if
	count_V_E_TER = cint(count_V_E_TER * 50)
end function



function V_num_E(Vnum,Name,M)  '获取GNPS,LNPS,GNP的每月排放体积
	if Vnum="GNPS" then
		R_num=count_V_E("D",Name,M) * 50
	elseif Vnum="LNPS" then
		R_num=count_V_E("L",Name,M)	* 50
	elseif Vnum="GNP" then
		R_num=count_V_E("A",Name,M)* 50
	end if
	V_num_E=R_num
end function

function count_V_E(W,Name,M)  '统计每月排放体积
	count_V_E=0
	if M="0" then
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if ssArray(3,i)<>"" then
							if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
								count_V_E=count_V_E+cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i))
							end if
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if ssArray(RELEASE_BUCKET_PRESSURE,i)<>"" then
						count_V_E=count_V_E+cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i))
					end if
				end if	
			next
		end if
	else
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
							if ssArray(RELEASE_BUCKET_PRESSURE,i)<>"" then
								count_V_E=count_V_E+cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i))
							end if
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
						if ssArray(RELEASE_BUCKET_PRESSURE,i)<>"" then
							count_V_E=count_V_E+cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i))
						end if
					end if
				end if	
			next
		end if
	end if
	
end function

'--------------------------------------------------------------------------------------------

function Bq_num_E_TER(Bnum,Name,M)  '获取GNPS,LNPS,GNP每月的氚排放量-----by lb
	if Bnum="GNPS" then
		R_num=count_B_E_TER("D",Name,M)
	elseif Bnum="LNPS" then
		R_num=count_B_E_TER("L",Name,M)	
	elseif Bnum="GNP" then
		R_num=count_B_E_TER("A",Name,M)
	end if
	Bq_num_E_TER=R_num
end function

function count_B_E_TER(W,Name,M)  '统计每月氚排放量-------------by lb
	count_B_E_TER=0
	if M="0" then
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if trim(ssArray(6,i))<>"" and trim(ssArray(7,i))<>"" then	
							count_B_E_TER=count_B_E_TER+(cdbl(ssArray(7,i))-cdbl(ssArray(6,i)))*ssArray(SCALE_TRITIUM,i)
						end if	
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
						if trim(ssArray(6,i))<>""  and trim(ssArray(7,i))<>"" then	
							count_B_E_TER=count_B_E_TER+(cdbl(ssArray(7,i))-cdbl(ssArray(6,i)))*ssArray(SCALE_TRITIUM,i)
						end if	
				end if	
			next
		end if
	else
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
						if trim(ssArray(6,i))<>"" and trim(ssArray(7,i))<>"" then	
							count_B_E_TER=count_B_E_TER+(cdbl(ssArray(7,i))-cdbl(ssArray(6,i)))*ssArray(SCALE_TRITIUM,i)
						end if	
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(0,i),3,3)=Name then
					if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
						if trim(ssArray(6,i))<>"" and trim(ssArray(7,i))<>"" then	
							count_B_E_TER=count_B_E_TER+(cdbl(ssArray(7,i))-cdbl(ssArray(6,i)))*ssArray(SCALE_TRITIUM,i)
						end if	
					end if
				end if	
			next
		end if
	end if
	if mid(count_B_EE_TER,1,1)="." then
		count_B_E_TER="0"&count_B_E_TER
	end if
end function

function Bq_num_E(Bnum,Name,M)  '获取GNPS,LNPS,GNP每月的氚排放量
	if Bnum="GNPS" then
		R_num=count_B_E("D",Name,M)
	elseif Bnum="LNPS" then
		R_num=count_B_E("L",Name,M)	
	elseif Bnum="GNP" then
		R_num=count_B_E("A",Name,M)
	end if
	Bq_num_E=R_num
end function

function count_B_E(W,Name,M)  '统计每月氚排放量
	count_B_E=0
	if M="0" then
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
							count_B_E=count_B_E+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
						count_B_E=count_B_E+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
					end if
				end if	
			next
		end if
	else
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
							if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
								count_B_E=count_B_E+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
							end if
						end if
					end if	
				end if
			next
		else
			for i=0 to ssRows
				if mid(ssArray(0,i),3,3)=Name then
					if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
						if trim(ssArray(RELEASE_BUCKET_PRESSURE,i))<>"" then	
							count_B_E=count_B_E+(cdbl(ssArray(RELEASE_BUCKET_PRESSURE,i))-cdbl(ssArray(RELEASE_BUCKET_PRESSURE2,i)))*ssArray(SCALE_TRITIUM,i)
						end if
					end if
				end if	
			next
		end if
	end if
	if mid(count_B_E,1,1)="." then
		count_B_E="0"&count_B_E
	end if
end function


'--------------------------------------------------------------------------------------------------------------


function Timers_num_E(otype,Name,M)   '获取GNPS,LNPS,GNP每月的排放时间
	if otype="GNPS" then
		R_num=count_Times_E("D",Name,M)
	elseif otype="LNPS" then
		R_num=count_Times_E("L",Name,M)	
	elseif otype="GNP" then
		R_num=count_Times_E("A",Name,M)
	end if
	Timers_num_E=formatNumber(R_num / 60,1)
	'Timers_num_E=R_num
end function


function count_Times_E(W,Name,M)		'统计每月排放时间
	count_Times_E=0
	if M="0" then
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if len(ssArray(RELEASW_START_TIME,i))>1 and len(ssArray(RELEASE_END_TIME,i))>1 then
							e_Times=datediff("n",ssArray(RELEASW_START_TIME,i),ssArray(RELEASE_END_TIME,i))
						else
							e_Times=0
						end if
						if len(e_Times)<=0 then
							e_Times=0
						end if
						count_Times_E=count_Times_E+e_Times
					end if	
				end if
			next	
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if len(ssArray(RELEASW_START_TIME,i))>1 and len(ssArray(RELEASE_END_TIME,i))>1 then
						e_Times=datediff("n",ssArray(RELEASW_START_TIME,i),ssArray(RELEASE_END_TIME,i))
					else
						e_Times=0
					end if
					if len(e_Times)<=0 then
						e_Times=0
					end if
					count_Times_E=count_Times_E+e_Times
				end if	
			next	
		end if 
	else
		if W<>"A" then
			for i=0 to ssRows
				if left(ssArray(ID,i),1)=W then
					if mid(ssArray(ID,i),3,3)=Name then
						if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
							if len(ssArray(RELEASW_START_TIME,i))>1 and len(ssArray(RELEASE_END_TIME,i))>1 then
								e_Times=datediff("n",ssArray(RELEASW_START_TIME,i),ssArray(RELEASE_END_TIME,i))
							else
								e_Times=0
							end if

							if len(e_Times)<=0 then
								e_Times=0
							end if
							count_Times_E=count_Times_E+e_Times
						end if
					end if	
				end if
			next	 
		else
			for i=0 to ssRows
				if mid(ssArray(ID,i),3,3)=Name then
					if month(ssArray(RELEASE_END_TIME,i))=M or month(ssArray(RELEASE_END_TIME,i))="0"&M then
						if len(ssArray(RELEASW_START_TIME,i))>1 and len(ssArray(RELEASE_END_TIME,i))>1 then
							e_Times=datediff("n",ssArray(RELEASW_START_TIME,i),ssArray(RELEASE_END_TIME,i))
						else
							e_Times=0
						end if
						if len(e_Times)<=0 then
							e_Times=0
						end if
						count_Times_E=count_Times_E+e_Times
					end if
				end if	
			next	
		end if 
	end if
end function



	sub Bqc(Bq)   '转换成科学记数法
		if Bq="0" then
			p ""&Bq&""
		else
			p "<script language=javascript>document.write(FormatNum("&Bq&",2))</script>"
		end if
	end sub
	
	'VB的科学计数法 ----------by lb
function testnum(bq)
	js = 0
	zs = 1
	
	if bq = 0 then
		testnum=cstr(0)
	else	
	
	
	for i =1 to len(cstr(bq))-1
		zs = zs * 10
	next
	js =bq/zs
	js = formatnumber(js,2)
	testnum = cstr(js) + "E" + cstr(len(cstr(bq))-1)
	end if
end function
%>


<script language=javascript>
function FormatNum(iLength,suf){
	var sValue1,p
	var sLength=""+iLength
	if(iLength<1)
	{
		var a=/^0\.(0*[1-9])/.exec(sLength)
		p=a[1].length+1
		sLength=sLength.replace(".","")
		sValue1=sLength.substring(0,p).replace(/^0+/,"")
		if(sLength.length>p) sValue1+="."+sLength.substring(p)+"000"
		else sValue1+=".000"					
		p=-1*(p-1)
	} else {
		sLength=sLength.replace(/^0+/,"")
		a=/^(\d+)(\.\d+)?$/.exec(sLength)
		p=a[1].length
		if(p==1) {sValue1=sLength+".000";p=0}
		else {
			sLength=sLength.replace(".","")
			sValue1=sLength.substring(0,1)+"."+sLength.substring(1)+"000"
			--p
			}	
	}
	if(suf!=null) sValue1=sValue1.substring(0,suf+2)
	return (sValue1+"E"+p)
	}	
	
	
	function FocusWin(oOpener,openStr,sStyle){
//------------------------------------------------------------------
//---功能：用于获取已经打开窗口的焦点-------------------------------
//---参数：oOpener表示打开窗口的句柄,openStr:打开的字符串-----------
//---用法：

	try{	
		if (oOpener != null){
			oOpener.focus();
	     }else{
		    oOpener=window.open(openStr,"s",sStyle);
	    	oOpener.focus();
	    }
	 }catch(exceptionl){
		oOpener=window.open(openStr,"s",sStyle);
	 }
	return oOpener
	 }
	 
	 
	 function openWin(link){
	//alert(link);
	var oOpener
	openStr=link;
	var sStyle=""
	oOpener=FocusWin(oOpener,openStr,sStyle);
	return false;
}
</script>

