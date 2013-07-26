<!--#include file="Statistic.asp"-->

<%
userid=trim(Request.QueryString("userid"))
Stimes=trim(Request.QueryString("Stimes"))
Ttimes=trim(Request.QueryString("Ttimes"))
V=trim(Request.QueryString("V"))
Bq=trim(Request.QueryString("Bq"))
if Stimes="Y" then
	ownStr="排放次数矩形图表"
	desc="次数"
end if
if Ttimes="Y" then
	ownStr="排放时间矩形图表"
	desc="时间"
end if
if V="Y" then
	ownStr="排放体积矩形图表"
	desc="体积"
end if
if Bq="Y" then
	ownStr="氚排放量矩形图表"
	desc="氚排放"
end if
dim num(12)
dim lum(12)
num(1)=trim(Request.QueryString("num1"))
num(2)=trim(Request.QueryString("num2"))
num(3)=trim(Request.QueryString("num3"))	
num(4)=trim(Request.QueryString("num4"))
num(5)=trim(Request.QueryString("num5"))
num(6)=trim(Request.QueryString("num6"))	
num(7)=trim(Request.QueryString("num7"))	
num(8)=trim(Request.QueryString("num8"))	
num(9)=trim(Request.QueryString("num9"))			
num(10)=trim(Request.QueryString("num10"))			
num(11)=trim(Request.QueryString("num11"))	
num(12)=trim(Request.QueryString("num12"))	
lum(1)=trim(Request.QueryString("Lum1"))
lum(2)=trim(Request.QueryString("Lum2"))
lum(3)=trim(Request.QueryString("Lum3"))	
lum(4)=trim(Request.QueryString("Lum4"))
lum(5)=trim(Request.QueryString("Lum5"))
lum(6)=trim(Request.QueryString("Lum6"))	
lum(7)=trim(Request.QueryString("Lum7"))	
lum(8)=trim(Request.QueryString("Lum8"))	
lum(9)=trim(Request.QueryString("Lum9"))			
lum(10)=trim(Request.QueryString("Lum10"))			
lum(11)=trim(Request.QueryString("Lum11"))	
lum(12)=trim(Request.QueryString("Lum12"))	
'num(12)="60000000000000"
A_num1=0
for i=1 to 12 
	if cdbl(num(i))>=cdbl(A_num1) then
		A_num1=num(i)
	end if
next
A_num2=0
for i=1 to 12 
	if cdbl(lum(i))>=cdbl(A_num2) then
		A_num2=lum(i)
	end if
next
if cdbl(A_num1)>cdbl(A_num2) then
	A_num=A_num1
else
	A_num=A_num2
end if
A_num = A_num
'Response.Write A_num
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
  count=0; 
 if(num<=10){
	num=10;}
 else if(num>10 && num<=50){
	num=50;
 }
 else if(num>50 && num<=100){
	num=100;
 }
 else if(num>100 && num<=500){
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
 else if(num>100000 && num<=1000000){
	num=1000000;
 }
 else if(num>1000000 && num<=10000000){
	num=10000000;
 }
 else if(num>10000000 && num<=100000000){
	num=100000000;
 }
 else if(num>100000000 && num<=1000000000){
	num=1000000000;
 }
 else if(num>1000000000 && num<=10000000000){
	num=10000000000;
 }
 else if(num>10000000000 && num<=100000000000){
	num=100000000000;
 }
 else if(num>100000000000 && num<=1000000000000){
	num=1000000000000;
 }
 else if(num>1000000000000 && num<=10000000000000){
	num=10000000000000;
 }
 else if(num>10000000000000 && num<=100000000000000){
	num=100000000000000;
 }

 //alert(num);
 var textPoint;
 textPoint=num/10
 for(var i=1;i<=10;i++){
    var py=2500-i*215;
    var strTo=m+" "+py;
    var newLine = document.createElement("<v:line from='300 "+py+"' to='"+strTo+"' style='position:absolute;z-index:8'></v:line>");
    group1.insertBefore(newLine);
    if(count%2!=0){
	    var newStroke = document.createElement("<v:stroke color='#c0c0c0'>");
	    newLine.insertBefore(newStroke);	
        var newShape= document.createElement("<v:shape style='position:absolute;left:0;top:"+(py-50)+";WIDTH:320px;HEIGHT:200px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
        group1.insertBefore(newShape);        
        var newText = document.createElement("<v:textbox id='tx"+textPoint+"' inset='3pt,0pt,3pt,0pt' style='font-size:10pt;v-text-anchor:bottom-right-baseline'></v:textbox>");
        newShape.insertBefore(newText);
        tt=FormatNum(textPoint*i,1);
		//alert(tt);
        newText.innerText=tt;
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
var newText = document.createElement("<v:textbox id='txName' inset='3pt,0pt,3pt,0pt' style='font-size:9pt;v-text-anchor:bottom-right-baseline'></v:textbox>");
newShape.insertBefore(newText);
newText.innerText="<%=desc%>";
}


//画横坐标
function drawLinesY(n)
{
 var textPoint=1;
 for(var i=1;i<=n;i++){
    var py=300+i*110;
    if((i-2)%3==0){
	    var newLine = document.createElement("<v:line from='"+py+" 2500' to='"+py+" 2550' style='position:absolute;z-index:8'></v:line>");
    }
    else{
		var newLine = document.createElement("<v:line from='"+py+" 2500' to='"+py+" 2500' style='position:absolute;z-index:8'></v:line>");
    }
    group1.insertBefore(newLine);
    var newStroke = document.createElement("<v:stroke color='black'>");
    newLine.insertBefore(newStroke);	
    var result=(i-1)%3;
    if(result==0){
    var newShape= document.createElement("<v:shape style='position:absolute;left:"+py+";top:2580;WIDTH:220px;HEIGHT:150px;z-index:8' coordsize='21600,21600' fillcolor='white'></v:shape>")    
    group1.insertBefore(newShape);        
    var newText = document.createElement("<v:textbox id='ty"+textPoint+"' inset='3pt,0pt,3pt,0pt' style='font-size:9pt;v-text-anchor:bottom-right-baseline'></v:textbox>");
    newShape.insertBefore(newText);
    newText.innerHTML=textPoint+"月";
    textPoint++;
	}
	}
 }


//画矩形
function drawBar(v,t,num)
{
  var h=v*215/num;
  var px=2500-v*215/num;
  var result=t%3;
  //alert(result);
  var py;
  var color;
  if(result==2){
  py=300+t*110;
  color="Fuchsia"
  }
  else if(result==1){
  py=300+t*110;
  color="red"
  }
  
  if(v!=0){
  var newShape= document.createElement("<v:rect style='position:absolute;left:"+py+";top:"+px+";WIDTH:110px;HEIGHT:"+h+"px;z-index:9' coordsize='21600,21600' fillcolor="+color+"></v:rect>")    
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
 else if(num>100 && num<=500){
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
 else if(num>1000000 && num<=10000000){
	count=1000000;
 }
 else if(num>10000000 && num<=100000000){
	count=10000000;
 }
 else if(num>100000000 && num<=1000000000){
	count=100000000;
 }
 else if(num>1000000000 && num<=10000000000){
	count=1000000000;
 }
 else if(num>10000000000 && num<=100000000000){
	count=10000000000;
 }
 else if(num>100000000000 && num<=1000000000000){
	count=100000000000;
 }
 else if(num>1000000000000 && num<=10000000000000){
	count=1000000000000;
 }
 else if(num>10000000000000 && num<=100000000000000){
	count=10000000000000;
 }
 
 drawBar(<%=num(1)%>,1,count);
 drawBar(<%=lum(1)%>,2,count);
 drawBar(0,3,count);
 drawBar(<%=num(2)%>,4,count);
 drawBar(<%=lum(2)%>,5,count);
 drawBar(0,6,count);
 drawBar(<%=num(3)%>,7,count);
 drawBar(<%=lum(3)%>,8,count);
 drawBar(0,9,count);
 drawBar(<%=num(4)%>,10,count);
 drawBar(<%=lum(4)%>,11,count);
 drawBar(0,12,count);
 drawBar(<%=num(5)%>,13,count);
 drawBar(<%=lum(5)%>,14,count);
 drawBar(0,15,count);
 drawBar(<%=num(6)%>,16,count);
 drawBar(<%=lum(6)%>,17,count);
 drawBar(0,18,count);
 drawBar(<%=num(7)%>,19,count);
 drawBar(<%=lum(7)%>,20,count);
 drawBar(0,21,count);
 drawBar(<%=num(8)%>,22,count);
 drawBar(<%=lum(8)%>,23,count);
 drawBar(0,24,count);
 drawBar(<%=num(9)%>,25,count);
 drawBar(<%=lum(9)%>,26,count);
 drawBar(0,27,count);
 drawBar(<%=num(10)%>,28,count);
 drawBar(<%=lum(10)%>,29,count);
 drawBar(0,30,count);
 drawBar(<%=num(11)%>,31,count);
 drawBar(<%=lum(11)%>,32,count);
 drawBar(0,33,count);
 drawBar(<%=num(12)%>,34,count);
 drawBar(<%=lum(12)%>,35,count);
}
</script>
<%
content=trim(Request.QueryString("content"))
name=trim(Request.QueryString("name"))
if name="TER" then
	datestr="TER&nbsp;"&year(content)&"年"
	str=datestr&"统计数据"
	Lstr="StatisticTER.asp"
elseif name="SEL" then
	datestr="SEL&nbsp;"&year(content)&"年"
	str=datestr&"统计数据"
	Lstr="StatisticSEL.asp"
elseif name="ETY" then
	datestr="ETY&nbsp;"&year(content)&"年"
	str=datestr&"统计数据"
	Lstr="StatisticETY.asp"
elseif name="TEG" then
	datestr="TEG&nbsp;"&year(content)&"年"
	str=datestr&"统计数据"
	Lstr="StatisticTEG.asp"
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
<body onload="drawLinesX(4400,<%=A_num%>);drawLinesY(36);drawBars(<%=A_num%>)">
<form name=form1 method=post>
<input type=hidden name=content value=<%=content%>>
<table align="center" bgcolor=#ffffff width=100% HEIGHT=100% border=0>
<tr>
<td  height=30>&nbsp;&nbsp;&nbsp;&nbsp;<strong><%=datestr%>&nbsp;<%=ownStr%></strong>&nbsp;&nbsp;&nbsp;&nbsp;
</td>
<td align=right><a href=''  onclick="LoadList()"><font color=#FF0000><%=str%></font></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
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
        <v:rect style='position:absolute;left:3500;top:50;WIDTH:80px;HEIGHT:80px;z-index:9' coordsize='21600,21600' fillcolor=red></v:rect>
        <v:shape style="position:absolute;left:3580;top:25;WIDTH:300px;HEIGHT:200px;z-index:8" coordsize="21600,21600" fillcolor="white">
            <v:textbox id="text1" inset="3pt,0pt,3pt,0pt"  style="font-size:10pt;">GNPS</v:textbox>
        </v:shape>
        <v:rect style='position:absolute;left:3950;top:50;WIDTH:80px;HEIGHT:80px;z-index:9' coordsize='21600,21600' fillcolor=Fuchsia></v:rect>
        <v:shape style="position:absolute;left:4030;top:25;WIDTH:300px;HEIGHT:200px;z-index:8" coordsize="21600,21600" fillcolor="white">
            <v:textbox id="text1" inset="3pt,0pt,3pt,0pt"  style="font-size:10pt;">LNPS</v:textbox>
        </v:shape>
</v:group>

</td>
</tr>
</table>
</form>
</body>
</html>
<%
'redim num(0)
'redim lum(0)
%>