
<SCRIPT LANGUAGE=javascript>
//Run function scrollIn,set like the follow:
//var sMessage = "欢迎您光临行政物质管理系统，希望此系统给您带来方便!";
var place = 1;
function scrollIn()
{
 window.status = sMessage.substring(0,place);
 if( place >= sMessage.length)
 {
 place=1;
 window.setTimeout("scrollOut()",300);
 }
 else
 {
  place++;
  window.setTimeout("scrollIn()",100);
  }
 }

function scrollOut()
{
 window.status =sMessage.substring(place,sMessage.length);
 if(place>=sMessage.length)
 {
  place=1;
  window.setTimeout("scrollIn()",200);
  }
  else
  {
  place++;
  window.setTimeout ("scrollOut()",100);
  }
 }
</SCRIPT>
