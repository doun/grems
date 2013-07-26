<script language=javascript runat=server>
	function ModeRuleObject()  
	{
		_ModeRuleObject_prototype_Init()
	}
	function _ModeRuleObject_prototype_Init()
	{
		if(ModeRuleObject.prototype.___bInit___==true) return
		ModeRuleObject.prototype.___bInit___=true
		ModeRuleObject.prototype.Rules=
		{
			analyze:{
				_default:"F03",
				cancelanalyze:"",
				cancelanalyzemain:"",
				postnanalyze:"",
				postanalyze:"",
				postanalyzemain:""
			},
			apply:{
				_default:"F01",
				cancelapply:"",
				doapply:"",
				modifyapply:"",
				postter:"",
				postapply:""
			},	
			check:{
				_default:"F04",
				chekmain:"",
				postcheck:""
			},
			confirm:{
				_default:"F05",
				confirmmain:"",
				confirmmain2:"F06",
				postconfirm:"",
				postconfirm2:"F06"
			},
			release:{
				_default:"F07",
				endrelease:"",
				endreleasemain:"",
				releasemain:"",
				releasepost:""
			},
			sample:{
				_default:"F02",
				dosample:"",
				postsample:"",
				samplemain:"",
				startsample:"",
				untreadapply:"",
				untreadapplymain:""
			},
			include:{
				_default:"test",
				moderule:""
			},
			public:{
				setparam:"M01"
			},
			grantgroup:{
				_default:"M01",
				authgroupmain:"",
				authgrouptop:"",
				authgroupbtm:"",
				authgrouplist:"",
				save_to_group:"",
				userright:"",
				useradd:"",
				user_function:""
				
			},
			input:{
				_default:"F01",
				ter_input:"",
				teg_input:"",
				ety_input:"",
				sel_input:"",
				other_gas_input:"",
				other_liq_input:""
			},
			statistic:{
				_default:"O02",
				statisticlist:"",
				statisticmonth:"",
				statisticter:"",
				statisticsel:"",
				statisticety:"",
				statisticteg:"",
				statisticshape:"",
				statisticshapeeach:"",
				statisticsearch:"O01"			
						
			}
		}	
	}
	
	function getMode(sName,oMode)
	{	
		var sFlag=0
		if(oMode==null) {sFlag=1;oMode=new ModeRuleObject()}		
		if(sName==null)
		{
			sName=""+Request.ServerVariables("SCRIPT_NAME")
			sName=sName.replace(/^.*\/([^\/]*)\/([^\.\/]*)\..*$/,"$1.$2")
		}	
		sName=sName.toLowerCase()
		try {			
			//Response.Write(ModeRuleObject.sample=null)	
			var sReturn=eval("oMode.Rules."+sName)	
			if(sReturn=="") {sReturn=eval("oMode.Rules."+sName.split(".")[0]+"._default")}			
			delete oMode;return sReturn
		} catch(exp) {delete oMode;return null;}		
	}	
	function testGrant(sID,iFlag)
	{
		var sMode=getMode()
		if(sMode==null||sMode=="") return true
		return setGrant(sID,sMode,iFlag)
	}	
</script>