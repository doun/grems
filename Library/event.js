
function SetEvent(sEventHandler,insSen,delay)
{ 
        var reg=/\{([\W|\w]*)\}/; 
        if(typeof(sEventHandler)!="string")
        {
                alert("sEventHandler�������ַ�����")
                return
        }
        if(typeof(insSen)=="function") insSen=reg.exec(insSen.toString())[1]
        else if(typeof(insSen)=="string") 
        {
                if(typeof(delay)=="number") insSen='setTimeout("'+insSen+'",'+delay+')'
                insSen="\t"+insSen
        }
        if(typeof(insSen)!="string"        )
        {
                alert("insSen�������ַ������ߺ�����")
                return
        }
    /*������䵽�����¼�����У�����һ���µ�Function����*/ 
        var oEventHandler=eval(sEventHandler)
        if (oEventHandler!=null)
        { 
                var preBody=reg.exec(oEventHandler.toString())[1]
        }else { 
                preBody=""; 
        }        
        var Args=SetEvent.arguments
        var sFun="function("
        if(Args.length>2&&typeof(delay)!="number") {
                for(var i=2;i<Args.length;i++)
                {
                        if(i==2) sFun+=Args[i]
                        else sFun+=","+Args[i]
                }
        }
        sFun+=") {"+preBody+insSen+"\n}"
        eval(sEventHandler+"="+sFun)
} 

function LoadEvent(Fun,delay)
{
        SetEvent("window.onload",Fun,delay)
}
function CopyFunction(Fun)
{
        Fun=Fun.toString()
        return Fun.replace(/function[^\(]*/,"function")        
}