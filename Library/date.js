var oDHTMLCelendar=window.createPopup()
WebCalendar = new WebCalendar();
var strIframe = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=gb2312'><style>"+
    "*{font-size: 12px; font-family: ����}"+
    ".bg{  color: "+ WebCalendar.lightColor +"; cursor: default; background-color: "+ WebCalendar.darkColor +";}"+
    "table#tableMain{ width: 142; height: 180;}"+
    "table#tableWeek td{ color: "+ WebCalendar.lightColor +";}"+
    "table#tableDay  td{ font-weight: bold;}"+
    "td#meizzYearHead, td#meizzYearMonth{color: "+ WebCalendar.wordColor +"}"+
    ".out { text-align: center; border-top: 1px solid "+ WebCalendar.DarkBorder +"; border-left: 1px solid "+ WebCalendar.DarkBorder +";"+
    "border-right: 1px solid "+ WebCalendar.lightColor +"; border-bottom: 1px solid "+ WebCalendar.lightColor +";}"+
    ".over{ text-align: center; border-top: 1px solid #FFFFFF; border-left: 1px solid #FFFFFF;"+
    "border-bottom: 1px solid "+ WebCalendar.DarkBorder +"; border-right: 1px solid "+ WebCalendar.DarkBorder +"}"+
    "input{ border: 1px solid "+ WebCalendar.darkColor +"; padding-top: 1px; height: 18; cursor: hand;"+
    "       color:"+ WebCalendar.wordColor +"; background-color: "+ WebCalendar.btnBgColor +";font-weight:bold}"+
    "</style></head><body onselectstart='return false' style='margin: 0px;border:0;overflow:hidden' oncontextmenu='return false'><form name=meizz>";

    if (WebCalendar.drag){ strIframe += "<scr"+"ipt language=javascript>"+
    "var drag=false, cx=0, cy=0, o = parent.WebCalendar.calendar; function document.onmousemove(){"+
    "if(parent.WebCalendar.drag && drag){if(o.style.left=='')o.style.left=0; if(o.style.top=='')o.style.top=0;"+
    "o.style.left = parseInt(o.style.left) + window.event.clientX-cx;"+
    "o.style.top  = parseInt(o.style.top)  + window.event.clientY-cy;}}"+
    "function document.onkeydown(){ switch(window.event.keyCode){  case 27 : parent.hiddenCalendar(); break;"+
    "case 37 : parent.prevM(); break; case 38 : parent.prevY(); break; case 39 : parent.nextM(); break; case 40 : parent.nextY(); break;"+
    "case 84 : document.forms[0].today.click(); break;} window.event.keyCode = 0; window.event.returnValue= false;}"+
    "function dragStart(){cx=window.event.clientX; cy=window.event.clientY; drag=true;}</scr"+"ipt>"}

    strIframe += "<select name=tmpYearSelect  onblur='parent.hiddenSelect(this)' style='z-index:1;position:absolute;top:3;left:18;display:none'"+
    " onchange='parent.WebCalendar.thisYear =this.value; parent.hiddenSelect(this); parent.writeCalendar();'></select>"+
    "<select name=tmpMonthSelect onblur='parent.hiddenSelect(this)' style='z-index:1; position:absolute;top:3;left:74;display:none'"+
    " onchange='parent.WebCalendar.thisMonth=this.value; parent.hiddenSelect(this); parent.writeCalendar();'></select>"+

    "<table id=tableMain class=bg border=0 cellspacing=2 cellpadding=0>"+
    "<tr><td width=140 height=19 bgcolor='"+ WebCalendar.lightColor +"'>"+
    "    <table width=140 id=tableHead border=0 cellspacing=1 cellpadding=0><tr align=center>"+
    "    <td width=15 height=19 class=bg title='��ǰ�� 1 ��&#13;��ݼ�����' style='cursor: hand' onclick='parent.prevM()'><b>&lt;</b></td>"+
    "    <td width=60 id=meizzYearHead  title='����˴�ѡ�����' onclick='parent.funYearSelect(parseInt(this.innerText, 10))'"+
    "        onmouseover='this.bgColor=parent.WebCalendar.darkColor; this.style.color=parent.WebCalendar.lightColor'"+
    "        onmouseout='this.bgColor=parent.WebCalendar.lightColor; this.style.color=parent.WebCalendar.wordColor'></td>"+
    "    <td width=50 id=meizzYearMonth title='����˴�ѡ���·�' onclick='parent.funMonthSelect(parseInt(this.innerText, 10))'"+
    "        onmouseover='this.bgColor=parent.WebCalendar.darkColor; this.style.color=parent.WebCalendar.lightColor'"+
    "        onmouseout='this.bgColor=parent.WebCalendar.lightColor; this.style.color=parent.WebCalendar.wordColor'></td>"+
    "    <td width=15 class=bg title='��� 1 ��&#13;��ݼ�����' onclick='parent.nextM()' style='cursor: hand'><b>&gt;</b></td></tr></table>"+
    "</td></tr><tr><td height=20><table id=tableWeek border=1 width=140 cellpadding=0 cellspacing=0 ";
    if(WebCalendar.drag){strIframe += "onmousedown='dragStart()' onmouseup='drag=false' onmouseout='drag=false'";}
    strIframe += " borderColorLight='"+ WebCalendar.darkColor +"' borderColorDark='"+ WebCalendar.lightColor +"'>"+
    "    <tr align=center><td height=20>��</td><td>һ</td><td>��</td><td>��</td><td>��</td><td>��</td><td>��</td></tr></table>"+
    "</td></tr><tr><td valign=top width=140 bgcolor='"+ WebCalendar.lightColor +"'>"+
    "    <table id=tableDay height=120 width=140 border=0 cellspacing=1 cellpadding=0>";
         for(var x=0; x<5; x++){ strIframe += "<tr>";
         for(var y=0; y<7; y++)  strIframe += "<td class=out id='meizzDay"+ (x*7+y) +"'></td>"; strIframe += "</tr>";}
         strIframe += "<tr>";
         for(var x=35; x<39; x++) strIframe += "<td class=out id='meizzDay"+ x +"'></td>";
         strIframe +="<td colspan=3 class=out title='"+ WebCalendar.regInfo +"'><input style=' background-color: "+
         WebCalendar.btnBgColor +";text-align:center;cursor: hand; padding-top: 4px; width: 100%; height: 100%; border: 0' onfocus='this.blur()'"+
         " type=button value='�ر�' onclick='parent.hiddenCalendar()'></td></tr></table>"+
    "</td></tr><tr><td height=20 width=140 bgcolor='"+ WebCalendar.lightColor +"'>"+
    "    <table border=0 cellpadding=0 cellspacing=0 width=140>"+
    "    <tr><td style='width:1;border-left:1px solid white'><nobr><input name=prevYear title='��ǰ�� 1 ��&#13;��ݼ�����' onclick='parent.prevY()' type=button value='|&lt;'"+
    "    onfocus='this.blur()' style='meizz:expression(this.disabled=parent.WebCalendar.thisYear==1000)' style='border-right:1px solid white'><input"+
    "    onfocus='this.blur()' name=prevMonth title='��ǰ�� 1 ��&#13;��ݼ�����' onclick='parent.prevM()' style='border-right:1px solid white' type=button value='&lt;&nbsp;'>"+
    "    </nobr></td><td align=center><input name=today type=button value='����' onfocus='this.blur()' style='width: 100%;border-right:1px solid white' title='��ǰ����&#13;��ݼ���T'"+
    "    onclick=\"parent.returnDate(new Date().getDate() +'/'+ (new Date().getMonth() +1) +'/'+ new Date().getFullYear())\">"+
    "    </td><td style='width:1;border-right:1px solid white'><nobr><input title='��� 1 ��&#13;��ݼ�����' name=nextMonth onclick='parent.nextM()' style='border-right:1px solid white' type=button value='&nbsp;&gt;'"+
    "    onfocus='this.blur()'><input name=nextYear title='��� 1 ��&#13;��ݼ�����' onclick='parent.nextY()' type=button value='&gt;|'"+
    "    onfocus='this.blur()' style='meizz:expression(this.disabled=parent.WebCalendar.thisYear==9999)'></td></tr></table>"+
    "</td></tr><table></form></body></html>";
oDHTMLCelendar.document.write(strIframe);    
function writeIframe()
{      
    for(var i=0; i<39; i++)
    {
         WebCalendar.dayObj[i] = eval(" WebCalendar.iframe.document.all['meizzDay"+ i+"']");
         WebCalendar.dayObj[i].onmouseover = dayMouseOver;
         WebCalendar.dayObj[i].onmouseout  = dayMouseOut;
         WebCalendar.dayObj[i].onclick     = returnDate;
    }    
}
function WebCalendar() //��ʼ������������
{
    this.regInfo    = "�رյĿ�ݼ���[Esc]";
    this.daysMonth  = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    this.day        = new Array(39);            //��������չʾ�õ�����
    this.dayObj     = new Array(39);            //��������չʾ�ؼ�����
    this.dateStyle  = null;                     //�����ʽ������������
    this.objExport  = null;                     //�����ش�����ʾ�ؼ�
    this.eventSrc   = null;                     //������ʾ�Ĵ����ؼ�
    this.inputDate  = null;                     //ת��������������(d/m/yyyy)
    this.thisYear   = new Date().getFullYear(); //������ı����ĳ�ʼֵ
    this.thisMonth  = new Date().getMonth()+ 1; //�����µı����ĳ�ʼֵ
    this.thisDay    = new Date().getDate();     //�����յı����ĳ�ʼֵ
    this.today      = this.thisDay +"/"+ this.thisMonth +"/"+ this.thisYear;   //����(d/m/yyyy)
    this.iframe     = window.oDHTMLCelendar.document.parentWindow; //������ iframe ����
    this.dateReg    = "";           //������ʽ��֤������ʽ

    this.yearFall   = 50;           //����������������ֵ
    this.format     = "yyyy-mm-dd"; //�ش����ڵĸ�ʽ
    this.timeShow   = false;        //�Ƿ񷵻�ʱ��
    this.drag       = true;         //�Ƿ������϶�
    this.darkColor  = "#5b5";    //�ؼ��İ�ɫ
    this.lightColor = "#FFFFFF";    //�ؼ�����ɫ
    this.btnBgColor = "#5b5";    //�ؼ��İ�ť����ɫ
    this.wordColor  = "green";    //�ؼ���������ɫ
    this.wordDark   = "orange";    //�ؼ��İ�������ɫ
    this.dayBgColor = "#F5F5FA";    //�������ֱ���ɫ
    this.todayColor = "#5b5";    //�����������ϵı�ʾ����ɫ
    this.DarkBorder = "#D4D0C8";    //������ʾ��������ɫ
    
    this.calendar=window.oDHTMLCelendar
}  


function funMonthSelect() //�·ݵ�������
{
    var m = isNaN(parseInt(WebCalendar.thisMonth, 10)) ? new Date().getMonth() + 1 : parseInt(WebCalendar.thisMonth);
    var e = WebCalendar.iframe.document.forms[0].tmpMonthSelect;
    for (var i=1; i<13; i++) {
		var o2=new WebCalendar.iframe.Option(i +"��",""+ i)
		e.options.add(o2);
	}	
    e.style.display = ""; e.value = m;  window.status = e.style.top;
}
function funYearSelect() //��ݵ�������
{
    var n = WebCalendar.yearFall;
    var e = WebCalendar.iframe.document.forms[0].tmpYearSelect;
    var y = isNaN(parseInt(WebCalendar.thisYear, 10)) ? new Date().getFullYear() : parseInt(WebCalendar.thisYear);
        y = (y <= 1000)? 1000 : ((y >= 9999)? 9999 : y);
    var min = (y - n >= 1000) ? y - n : 1000;
    var max = (y + n <= 9999) ? y + n : 9999;
        min = (max == 9999) ? max-n*2 : min;
        max = (min == 1000) ? min+n*2 : max;
    for (var i=min; i<=max; i++) e.options.add(new WebCalendar.iframe.Option(i +"��", i));
    e.style.display = ""; e.value = y; ;
}
function prevM()  //��ǰ���·�
{
    WebCalendar.thisDay = 1;
    if (WebCalendar.thisMonth==1)
    {
        WebCalendar.thisYear--;
        WebCalendar.thisMonth=13;
    }
    WebCalendar.thisMonth--; writeCalendar();
}
function nextM()  //�����·�
{
    WebCalendar.thisDay = 1;
    if (WebCalendar.thisMonth==12)
    {
        WebCalendar.thisYear++;
        WebCalendar.thisMonth=0;
    }
    WebCalendar.thisMonth++; writeCalendar();
}
function prevY(){WebCalendar.thisDay = 1; WebCalendar.thisYear--; writeCalendar();}//��ǰ�� Year
function nextY(){WebCalendar.thisDay = 1; WebCalendar.thisYear++; writeCalendar();}//���� Year
function hiddenSelect(e){for(var i=e.options.length; i>-1; i--) e.options.remove(i); e.style.display="none";}
function getObjectById(id){ if(document.all) return(eval("document.all."+ id)); return(eval(id)); }
function hiddenCalendar(){window.oDHTMLCelendar.hide();};
function appendZero(n){return(("00"+ n).substr(("00"+ n).length-2));}//�����Զ��������
function String.prototype.trim(){return this.replace(/(^\s*)|(\s*$)/g,"");}

function dayMouseOver()
{
    this.className = "over";
    this.style.backgroundColor = WebCalendar.darkColor;
    if(WebCalendar.day[this.id.substr(8)].split("/")[1] == WebCalendar.thisMonth)
    this.style.color = WebCalendar.lightColor;
}
function dayMouseOut()
{
    this.className = "out"; var d = WebCalendar.day[this.id.substr(8)], a = d.split("/");
    this.style.removeAttribute('backgroundColor');
    if(a[1] == WebCalendar.thisMonth && d != WebCalendar.today)
    {
        if(WebCalendar.dateStyle && a[0] == parseInt(WebCalendar.dateStyle[4], 10))
        this.style.color = WebCalendar.lightColor;
        this.style.color = WebCalendar.wordColor;
    }
}
function writeCalendar() //��������ʾ�����ݵĴ������
{
    var y = WebCalendar.thisYear;
    var m = WebCalendar.thisMonth; 
    var d = WebCalendar.thisDay;
    WebCalendar.daysMonth[1] = (0==y%4 && (y%100!=0 || y%400==0)) ? 29 : 28;
    if (!(y<=9999 && y >= 1000 && parseInt(m, 10)>0 && parseInt(m, 10)<13 && parseInt(d, 10)>0)){
        alert("�Բ����������˴�������ڣ�");
        WebCalendar.thisYear   = new Date().getFullYear();
        WebCalendar.thisMonth  = new Date().getMonth()+ 1;
        WebCalendar.thisDay    = new Date().getDate(); }
    y = WebCalendar.thisYear;
    m = WebCalendar.thisMonth;
    d = WebCalendar.thisDay;
    WebCalendar.iframe.meizzYearHead.innerText  = y +" ��";
    WebCalendar.iframe.meizzYearMonth.innerText = parseInt(m, 10) +" ��";
    WebCalendar.daysMonth[1] = (0==y%4 && (y%100!=0 || y%400==0)) ? 29 : 28; //�������Ϊ29��
    var w = new Date(y, m-1, 1).getDay();
    var prevDays = m==1  ? WebCalendar.daysMonth[11] : WebCalendar.daysMonth[m-2];
    for(var i=(w-1); i>=0; i--) //������ for ѭ��Ϊ����������Դ������ WebCalendar.day����ʽ�� d/m/yyyy
    {
        WebCalendar.day[i] = prevDays +"/"+ (parseInt(m, 10)-1) +"/"+ y;
        if(m==1) WebCalendar.day[i] = prevDays +"/"+ 12 +"/"+ (parseInt(y, 10)-1);
        prevDays--;
    }
    for(var i=1; i<=WebCalendar.daysMonth[m-1]; i++) WebCalendar.day[i+w-1] = i +"/"+ m +"/"+ y;
    for(var i=1; i<39-w-WebCalendar.daysMonth[m-1]+1; i++)
    {
        WebCalendar.day[WebCalendar.daysMonth[m-1]+w-1+i] = i +"/"+ (parseInt(m, 10)+1) +"/"+ y;
        if(m==12) WebCalendar.day[WebCalendar.daysMonth[m-1]+w-1+i] = i +"/"+ 1 +"/"+ (parseInt(y, 10)+1);
    }
    for(var i=0; i<39; i++)    //���ѭ���Ǹ���Դ����д����������ʾ
    {
        var a = WebCalendar.day[i].split("/");
        WebCalendar.dayObj[i].innerText    = a[0];
        WebCalendar.dayObj[i].title        = a[2] +"-"+ appendZero(a[1]) +"-"+ appendZero(a[0]);
        WebCalendar.dayObj[i].bgColor      = WebCalendar.dayBgColor;
        WebCalendar.dayObj[i].style.color  = WebCalendar.wordColor;
        if ((i<10 && parseInt(WebCalendar.day[i], 10)>20) || (i>27 && parseInt(WebCalendar.day[i], 10)<12))
            WebCalendar.dayObj[i].style.color = WebCalendar.wordDark;
        if (WebCalendar.inputDate==WebCalendar.day[i])    //�����������������������ϵ���ɫ
        {WebCalendar.dayObj[i].bgColor = WebCalendar.darkColor; WebCalendar.dayObj[i].style.color = WebCalendar.lightColor;}
        if (WebCalendar.day[i] == WebCalendar.today)      //���ý����������Ϸ�Ӧ��������ɫ
        {WebCalendar.dayObj[i].bgColor = WebCalendar.todayColor; WebCalendar.dayObj[i].style.color = WebCalendar.lightColor;}
    }
}
function returnDate() //�������ڸ�ʽ�ȷ����û�ѡ��������
{
    if(WebCalendar.objExport)
    {
        var returnValue;
        var a = (arguments.length==0) ? WebCalendar.day[this.id.substr(8)].split("/") : arguments[0].split("/");
        var d = WebCalendar.format.match(/^(\w{4})(-|\/)(\w{1,2})\2(\w{1,2})$/);
        if(d==null){alert("���趨�����������ʽ���ԣ�\r\n\r\n�����¶��� WebCalendar.format ��"); return false;}
        var flag = d[3].length==2 || d[4].length==2; //�жϷ��ص����ڸ�ʽ�Ƿ�Ҫ����
        returnValue = flag ? a[2] +d[2]+ appendZero(a[1]) +d[2]+ appendZero(a[0]) : a[2] +d[2]+ a[1] +d[2]+ a[0];
        if(WebCalendar.timeShow)
        {
            var h = new Date().getHours(), m = new Date().getMinutes(), s = new Date().getSeconds();
            returnValue += flag ? " "+ appendZero(h) +":"+ appendZero(m) +":"+ appendZero(s) : " "+  h  +":"+ m +":"+ s;
        }
        WebCalendar.objExport.value = returnValue;
        hiddenCalendar();
    }
}

Number.prototype.String=function()
{
	return (""+this).replace(/^(\d)$/,"0$1")
}

function oDateTime(id,name)
{
	eval("window."+id+"=this")
	this.id=id
	this.name=name			
}
oDateTime.prototype.calendar=function() //��������
{
    var e = window.event.srcElement; writeIframe();
    WebCalendar.eventSrc = e;
	if (arguments.length == 0) WebCalendar.objExport = e;
    else WebCalendar.objExport = eval(arguments[0]);
    window.oDHTMLCelendar.show(0,-199,144,199,WebCalendar.objExport)
    WebCalendar.iframe.tableWeek.style.cursor = WebCalendar.drag ? "move" : "default";    
    if  (!WebCalendar.timeShow) WebCalendar.dateReg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/;
    else WebCalendar.dateReg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
    try{
        if (WebCalendar.objExport.value.trim() != ""){
            WebCalendar.dateStyle = WebCalendar.objExport.value.trim().match(WebCalendar.dateReg);
            if (WebCalendar.dateStyle == null)
            {
                WebCalendar.thisYear   = new Date().getFullYear();
                WebCalendar.thisMonth  = new Date().getMonth()+ 1;
                WebCalendar.thisDay    = new Date().getDate();
                //alert("ԭ�ı�����������д���\n�������㶨�����ʾʱ�����г�ͻ��");
                writeCalendar(); return false;
            }
            else
            {
                WebCalendar.thisYear   = parseInt(WebCalendar.dateStyle[1], 10);
                WebCalendar.thisMonth  = parseInt(WebCalendar.dateStyle[3], 10);
                WebCalendar.thisDay    = parseInt(WebCalendar.dateStyle[4], 10);
                WebCalendar.inputDate  = parseInt(WebCalendar.thisDay, 10) +"/"+ parseInt(WebCalendar.thisMonth, 10) +"/"+ 
                parseInt(WebCalendar.thisYear, 10); writeCalendar();
            }
        }  else writeCalendar();
    }  catch(e){writeCalendar();}
}
oDateTime.prototype.reset=function()
{
	var iLeft=parseInt((parseInt(document.body.clientWidth)-280)/2)
	var iTop=parseInt((parseInt(document.body.clientHeight)-150)/2)
	with(this.dateObject.style)
	{
		left=iLeft
		top=iTop
	}
}
oDateTime.prototype.make=function(name,type,sDefault,readonly)
{
	var md=""
	if(name==null) name=""
	if(readonly==null) md="onmousedown=\"this.blur();"+this.id+".calendar(this.parentNode.parentNode.all.tags('INPUT')[0])\" "
	
	var str="<nobr><table id='"+name+"' isDateBox='t' datemsg='"+name+"' style='width:100%;height:1;border:0' cellspacing=0 cellpadding=0>"+
			"<TBODY><tr><td><input type=text readOnly class=FormText "+md+" style='width:100%;height:18px;cursor:default' value='@datevalue' /></td>"+
			"<td style='width:1;text-align:center'>"+
			"<span "+md+" class=FormText style='cursor:default;width:17px;height:18px;font-family:wingdings 3;"+
			"font-size:11px;border-left:0;color:#393;background-color:white' "+
			">&#128;</span></td>"
	var d,d1;
	if(sDefault==null) d=new Date()
	else d=new Date((""+sDefault).replace(/\-/g,"\/"))
	if(isNaN(d)) d1=""
	else d1=this.formatDate(d)	
	str=str.replace("@datevalue",""+d1)	
	if(type==true)	
	{				
		str+="<td style='width:1'>&nbsp;</td><td style='width:1'>"+
			"<input DatePart='h' class=FormText maxlength=2 style='height:18px;width:18px' value='@hour' onkeyup='"+this.id+".checkPress(this)' />"+
			"</td> <td style='width:1'>:</td><td style='width:1'>"+
			"<input DatePart='m' class=FormText maxlength=2 style='height:18px;width:18px' value='@minute' /></td>"
		var hour,minute
		if(d1=="")
		{
			hour=""
			minute=""
		} else {
			hour=d.getHours().String()
			minute=d.getMinutes().String()
		}
		str=str.replace("@hour",hour)
		str=str.replace("@minute",minute)
	}		
	str+="</TR></TBODY></TABLE></nobr>"
	return str			
}
oDateTime.prototype.SetDate=function()
{
	var e=event.srcElement
	if(e!=null&&e.className=="btnClose")
	{
		e.blur();		
	} else {
		var d=new Date(e.children[0].Value)		
		this.boundObject.getElementsByTagName("INPUT")[0].value=this.formatDate(d)
		this.CheckDate(this.boundObject)
	}	
}
oDateTime.prototype.formatDate=function(d)
{
	m=(d.getMonth()+1).String()	
	d2=d.getDate().String()	
	return d.getFullYear()+"-"+m+"-"+d2
}
oDateTime.prototype.CheckDate=function(e)
{
	var d
	var oInputs=e.getElementsByTagName("INPUT")
	var w0=oInputs[0].value.Trim()
	//������ڿ�Ϊ�գ�����null��������ڸ�ʽ���Ϸ�������false
	//������ڸ�ʽ��ȷ���򷵻����ڵ��ַ�����ʽ
	if(oInputs.length==3)
	{
		var w1=oInputs[1].value.Trim().replace(/^0(\w+)/,"$1")
		var w2=oInputs[2].value.Trim().replace(/^0(\w+)/,"$1")
		if(isNaN(parseInt(w1))||isNaN(parseInt(w2))) 
		{
			if(w0==""&&w1==""&&w2=="") return null
			return false
		}			
		d=w0+" "+parseInt(w1).String()+":"+parseInt(w2).String()
	} else {
		d=w0
		if(d=="") return null
	}		
	var d1=new Date(d.replace(/\-/g,"\/"))
	if(isNaN(d1)) return false
	return d
}
oDateTime.prototype.checkPress=function(o)
{
	o.value=o.value.replace(/[^\d]/g,"")
	if(o.value.length==2||parseInt(o.value)>2)
	{
		var o1=o.parentNode.nextSibling.nextSibling.children[0]
		o1.focus()
		o1.select()
	}
}