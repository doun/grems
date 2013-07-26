
<%
userid=trim(Request.QueryString("userid"))
Stimes=trim(Request.QueryString("Stimes"))
V=trim(Request.QueryString("V"))
if Stimes="Y" then
	ownStr="排放次数矩形图表"
	desc="次数"
	TER_num1=trim(Request.QueryString("TER_num1"))
	TER_num2=trim(Request.QueryString("TER_num2"))
	TER_num3=trim(Request.QueryString("TER_num3"))	
	SEL_num1=trim(Request.QueryString("SEL_num1"))
	SEL_num2=trim(Request.QueryString("SEL_num2"))
	SEL_num3=trim(Request.QueryString("SEL_num3"))	
	ETY_num1=trim(Request.QueryString("ETY_num1"))	
	ETY_num2=trim(Request.QueryString("ETY_num2"))	
	ETY_num3=trim(Request.QueryString("ETY_num3"))			
	TEG_num1=trim(Request.QueryString("TEG_num1"))			
	TEG_num2=trim(Request.QueryString("TEG_num2"))	
	TEG_num3=trim(Request.QueryString("TEG_num3"))	
	'TER_num1=2
	'TER_num2=5
	'TER_num3=7
	'SEL_num1=1
	'SEL_num2=5
	'SEL_num3=6
	'ETY_num1=3
	'ETY_num2=2
	'ETY_num3=5
	'TEG_num1=1
	'TEG_num2=1
	'TEG_num3=2
	

	
else
	if V="Y" then
		ownStr="排放体积矩形图表"
		desc="体积(m3)"
		TER_num1=trim(Request.QueryString("TER_V1"))
		TER_num2=trim(Request.QueryString("TER_V2"))
		TER_num3=trim(Request.QueryString("TER_V3"))	
		SEL_num1=trim(Request.QueryString("SEL_V1"))
		SEL_num2=trim(Request.QueryString("SEL_V2"))
		SEL_num3=trim(Request.QueryString("SEL_V3"))	
		ETY_num1=0	
		ETY_num2=0	
		ETY_num3=0			
		TEG_num1=0			
		TEG_num2=0	
		TEG_num3=0		
		
	end if
end if

'if TER_num3>=SEL_num3 and TER_num3>=ETY_num3 and TER_num3>=TEG_num3 then
'	A_num=TER_num3
'elseif SEL_num3>=TER_num3 and SEL_num3>=ETY_num3 and SEL_num3>=TEG_num3 then
'	A_num=SEL_num3
'elseif ETY_num3>=TER_num3 and ETY_num3>=SEL_num3 and ETY_num3>=TEG_num3 then
'	A_num=ETY_num3
'elseif TEG_num3>=TER_num3 and TEG_num3>=SEL_num3 and TEG_num3>=ETY_num3 then
'	A_num=TEG_num3
'end if


if clng(TER_num3)>= clng(SEL_num3) then
	A_num = TER_num3

else
    A_num = SEL_num3
end if



if clng(A_num) >= clng(ETY_num3) then
else
	A_num = ETY_num3
end if	

if clng(A_num) >= clng(TEG_num3) then
else
	A_num = TEG_num3
end if

'Response.Write A_num
'Response.end
%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<head>
	<title>Thinking in VML</title>
</head>
<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<style>
TABLE
{
    FONT-SIZE: 12px;
    WIDTH: 100%;
    COLOR: black;
    BORDER-COLLAPSE: collapse
}
</style>
<script>

//画纵坐标
function drawLinesX(m,num)
{
//alert(num);
  count=0; 
 if(num<=10){
	num=10;}
 else if(num>10 && num<=50){
	num=50;
 }
 else if(num>50 && num<=100){
	num=100;
 }
 else if(num>100 && num<=150){
	num=150;
 }
 else if(num>150 && num<=300){
	num=300;
 }
 else if(num>300 && num<=500){
	num=500;
 }
 else if(num>500 && num<=1000){
	num=1000;
 }
  else if(num>1000 && num<=5000){
	num=5000;
 }
  else if(num>5000 && num<=10000){
	num=10000;
 }
  else if(num>10000 && num<=50000){
	num=50000;
 }
  else if(num>50000 && num<=100000){
	num=100000;
 }
  else if(num>100000 && num<=500000){
	num=500000;
 }
  else if(num>500000 && num<=1000000){
	num=1000000;
 }
 
 var textPoint;
 textPoint=num/10
 for(var i=1;i<=12;i++){
    var py=2500-i*215;
    var strTo=m+" "+py;
    var newLine = document.createElement("<v:line from='300 "+py+"' to='"+strTo+"' style='position:absolute;z-index:8'></v:line>");
    group1.insertBefore(newLine);
    if(count%2!=0){
	    var newStroke = document.createElement("<v:stroke color='#c0c0c0'>");
	    newLine.insertBefore(newStroke);	
        var newShape= document.createElement("<v:shape style='position:absolute;left:0;top:"+(py-50)+";WIDTH:300px;HEIGHT:200px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
        group1.insertBefore(newShape);        
        var newText = document.createElement("<v:textbox id='tx"+textPoint+"' inset='3pt,0pt,3pt,0pt' style='font-size:10pt;v-text-anchor:bottom-right-baseline'></v:textbox>");
        newShape.insertBefore(newText);
        newText.innerText=textPoint*i;
	}
	else
	{
	    var newStroke = document.createElement("<v:stroke dashstyle='dot' color='black'/>");
	    newLine.insertBefore(newStroke);
	}
	count++;
 }
var newShape= document.createElement("<v:shape style='position:absolute;left:150;top:60;WIDTH:300px;HEIGHT:200px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
group1.insertBefore(newShape);        
var newText = document.createElement("<v:textbox id='txName' inset='0pt,0pt,0pt,0pt' style='font-size:9pt;v-text-anchor:bottom-right-baseline'></v:textbox>");
newShape.insertBefore(newText);
newText.innerText="<%=desc%>";
}


//画横坐标
function drawLinesY(n)
{
 var textPoint,N;
 for(var i=1;i<=n;i++){
	if(i>4 && i<=8){
		N=1
	}
	else if(i>8 && i<=12){
		N=2
	}
	else if(i>12 && i<=16){
		N=3
	}
	else{
		N=0
	}
	var py=350+i*220+N*80;
	//alert(py);
   
    var newLine = document.createElement("<v:line from='"+py+" 2500' to='"+py+" 2550' style='position:absolute;z-index:8'></v:line>");
    group1.insertBefore(newLine);
    var newStroke = document.createElement("<v:stroke color='black'>");
    newLine.insertBefore(newStroke);	
    var newShape= document.createElement("<v:shape style='position:absolute;left:"+py+";top:2550;WIDTH:220px;HEIGHT:150px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
    group1.insertBefore(newShape);        
   
    var newText = document.createElement("<v:textbox id='ty"+textPoint+"' inset='3pt,0pt,3pt,0pt' style='font-size:9pt;v-text-anchor:bottom-right-baseline'></v:textbox>");
    newShape.insertBefore(newText);
    var result=i % 4;
    textPoint="";
    /*
    if(result>0){
		switch(result){
			case 1:textPoint="GNPs";break
			case 2:textPoint="LNPS";break
			case 3:textPoint="GNP";break
		} 
	newText.innerHTML=textPoint;
	}
	*/
 }

var newShape= document.createElement("<v:shape style='position:absolute;left:570;top:2680;WIDTH:660px;HEIGHT:200px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
group1.insertBefore(newShape);        
var newText = document.createElement("<v:textbox id='txName' inset='3pt,0pt,3pt,0pt' style='font-size:10pt;v-text-anchor:bottom-right-baseline;font-weight:bold;'></v:textbox>");
newShape.insertBefore(newText);
newText.innerText="TER";
var newShape= document.createElement("<v:shape style='position:absolute;left:1530;top:2680;WIDTH:660px;HEIGHT:200px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
group1.insertBefore(newShape);        
var newText = document.createElement("<v:textbox id='txName' inset='3pt,0pt,3pt,0pt' style='font-size:10pt;v-text-anchor:bottom-right-baseline;font-weight:bold'></v:textbox>");
newShape.insertBefore(newText);
newText.innerText="SEL";
var newShape= document.createElement("<v:shape style='position:absolute;left:2490;top:2680;WIDTH:660px;HEIGHT:200px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
group1.insertBefore(newShape);        
var newText = document.createElement("<v:textbox id='txName' inset='3pt,0pt,3pt,0pt' style='font-size:10pt;v-text-anchor:bottom-right-baseline;font-weight:bold'></v:textbox>");
newShape.insertBefore(newText);
newText.innerText="ETY";
var newShape= document.createElement("<v:shape style='position:absolute;left:3450;top:2680;WIDTH:660px;HEIGHT:200px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
group1.insertBefore(newShape);        
var newText = document.createElement("<v:textbox id='txName' inset='3pt,0pt,3pt,0pt' style='font-size:10pt;v-text-anchor:bottom-right-baseline;font-weight:bold'></v:textbox>");
newShape.insertBefore(newText);
newText.innerText="TEG";
}


//画矩形
function drawBar(v,t,num)
{
  
  var h=v*215/num;
  var px=2500-v*215/num;
  var result=t/3;
  var Modresult=t % 3
  //alert(Modresult);
  var py;
  var color;
  if(result>3){
  py=350+t*220+3*300;
  }
  else if(result>2){
  py=350+t*220+2*300;
  }
  else if(result>1){
  py=350+t*220+300;
  }
  else{
  py=350+t*220;
  }
 
  switch(Modresult){
			case 0:color="#1e90ff";break
			case 1:color="red";break
			case 2:color="Fuchsia";break
		} 
  

  
  if(v!=0){
  pp=px-110
  var newShape= document.createElement("<v:shape style='position:absolute;left:"+py+";top:"+pp+";WIDTH:220px;HEIGHT:100px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
  group1.insertBefore(newShape);        
  var newText = document.createElement("<v:textbox id='txCount' inset='0pt,0pt,0pt,0pt' style='font-size:9pt;v-text-anchor:bottom-right-baseline'></v:textbox>");
  newShape.insertBefore(newText);
  newText.innerText=v;
  var newShape= document.createElement("<v:rect style='position:absolute;left:"+py+";top:"+px+";WIDTH:220px;HEIGHT:"+h+"px;z-index:9' coordsize='21600,21600' fillcolor="+color+"></v:rect>")    
  group1.insertBefore(newShape);

  }
}


function drawBars(num)
{
 if(num<=10){
	count=1;}
 else if(num>10 && num<=50){
	count=5;
 }
 else if(num>50 && num<=100){
	count=10;
 }
 else if(num>100 && num<=150){
	count=15;
 }
 else if(num>150 && num<=300){
	count=30;
 }
 else if(num>300 && num<=500){
	count=50;
 }
 
 else if(num>500 && num<=1000){
	count=100;
 }
 else if(num>1000 && num<=5000){
	count=500;
 }
 else if(num>5000 && num<=10000){
	count=1000;
 }
 else if(num>10000 && num<=50000){
	count=5000;
 }
 else if(num>50000 && num<=100000){
	count=10000;
 }
  else if(num>100000 && num<=1000000){
	count=100000;
 }
 drawBar(<%=TER_num1%>,1,count);
 drawBar(<%=TER_num2%>,2,count);
 drawBar(<%=TER_num3%>,3,count);
 drawBar(<%=SEL_num1%>,4,count);
 drawBar(<%=SEL_num2%>,5,count);
 drawBar(<%=SEL_num3%>,6,count);
 drawBar(<%=ETY_num1%>,7,count); 
 drawBar(<%=ETY_num2%>,8,count); 
 drawBar(<%=ETY_num3%>,9,count); 
 drawBar(<%=TEG_num1%>,10,count);
 drawBar(<%=TEG_num2%>,11,count);
 drawBar(<%=TEG_num3%>,12,count);
}
</script>
<%
content=trim(Request.QueryString("content"))
sdate=trim(Request.QueryString("sdate"))
if sdate="M" then
	datestr=year(content)&"年"&month(content)&"月"
	str=datestr&"统计数据"
	'Lstr="StatisticMonth.asp?content="&content&"&userid="&userid&""
	Lstr="StatisticMonth.asp"
elseif sdate="Y" then
	datestr=year(content)&"年"
	str=datestr&"统计数据"
	'Lstr="StatisticList.asp?content="&content&"&userid="&userid&""
	Lstr="StatisticList.asp"
end if

%>
<script language=javascript>
function LoadList()
{
	var sID=parent.parent.document.all['__USER_ROLE'].value
	//alert('<%=Lstr%>')
	form1.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
	form1.action='<%=Lstr%>'; 
	form1.submit()
}
</script>
<body onload="drawLinesX(4400,<%=A_num%>);drawLinesY(16);drawBars(<%=A_num%>)">
<form name=form1 method=post>
<input type=hidden name=content value=<%=content%>>
<table align="center" bgcolor=#ffffff width=100% HEIGHT=100% border=0>
<tr>
<td  height=30>&nbsp;&nbsp;&nbsp;&nbsp;<strong><%=datestr%>&nbsp;<%=ownStr%></strong>
</td>
<td align=right><a href='' onclick="LoadList()"><font color=#FF0000><%=str%></font></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
<tr>
<td align=center HEIGHT=100% colspan=2>&nbsp;
<v:group ID="group1" style="width:100%;HEIGHT:100%" coordsize="4900,3000">
		<v:line from="300,200" to="300,2500" style="Z-INDEX:8;POSITION:absolute" strokeweight="1pt">
		<v:stroke StartArrow="classic"/>
		</v:line>
		<v:line from="300,2500" to="4400,2500" style="Z-INDEX:8;POSITION:absolute" strokeweight="1pt">
		<v:stroke EndArrow="classic"/>
		</v:line>
		<v:rect style="WIDTH:4600px;HEIGHT:2900px" coordsize="21600,21600" fillcolor="white" strokecolor="black">
		<v:shadow on="t" type="single" color="silver" offset="4pt,3pt"></v:shadow>
		</v:rect>
        <v:shape style="position:absolute;left:0;top:2450;WIDTH:300px;HEIGHT:200px;z-index:8" coordsize="21600,21600" fillcolor="white">
            <v:textbox id="text1" inset="3pt,0pt,3pt,0pt"  style="font-size:10pt;">0</v:textbox>
        </v:shape>
        <v:shape style="position:absolute;left:0;top:2450;WIDTH:300px;HEIGHT:200px;z-index:8" coordsize="21600,21600" fillcolor="white">
            <v:textbox id="text1" inset="3pt,0pt,3pt,0pt"  style="font-size:10pt;">0</v:textbox>
        </v:shape>
        <v:rect style='position:absolute;left:3000;top:50;WIDTH:80px;HEIGHT:80px;z-index:9' coordsize='21600,21600' fillcolor=red></v:rect>
        <v:shape style="position:absolute;left:3080;top:25;WIDTH:300px;HEIGHT:200px;z-index:8" coordsize="21600,21600" fillcolor="white">
            <v:textbox id="text1" inset="3pt,0pt,3pt,0pt"  style="font-size:10pt;">GNPS</v:textbox>
        </v:shape>
        <v:rect style='position:absolute;left:3450;top:50;WIDTH:80px;HEIGHT:80px;z-index:9' coordsize='21600,21600' fillcolor=Fuchsia></v:rect>
        <v:shape style="position:absolute;left:3530;top:25;WIDTH:300px;HEIGHT:200px;z-index:8" coordsize="21600,21600" fillcolor="white">
            <v:textbox id="text1" inset="3pt,0pt,3pt,0pt"  style="font-size:10pt;">LNPS</v:textbox>
        </v:shape>
        <v:rect style='position:absolute;left:3900;top:50;WIDTH:80px;HEIGHT:80px;z-index:9' coordsize='21600,21600' fillcolor=#1e90ff></v:rect>
        <v:shape style="position:absolute;left:3980;top:25;WIDTH:300px;HEIGHT:200px;z-index:8" coordsize="21600,21600" fillcolor="white">
            <v:textbox id="text1" inset="3pt,0pt,3pt,0pt"  style="font-size:10pt;">GNP</v:textbox>
        </v:shape>
</v:group>
</td>
</tr>
</table>
</form>
</body>
</html>
