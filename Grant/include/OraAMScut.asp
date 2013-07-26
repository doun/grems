<%
	'-------------------------
	'断 开 数 据 库 连 接
	'-------------------------
if OraAmsRs.State = 1 then OraAmsRs.Close 
OraAmscnn.close
set OraAmsRs = nothing
set OraAmscnn = nothing
%>