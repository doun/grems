<%
	'-------------------------
	'�� �� �� �� �� �� ��
	'-------------------------
if OraAmsRs.State = 1 then OraAmsRs.Close 
OraAmscnn.close
set OraAmsRs = nothing
set OraAmscnn = nothing
%>