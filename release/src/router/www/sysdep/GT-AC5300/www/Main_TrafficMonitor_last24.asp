﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<title><#Web_Title#> - <#traffic_monitor#> : <#menu4_2_2#></title>
<link rel="stylesheet" type="text/css" href="index_style.css"> 
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="tmmenu.css">
<link rel="stylesheet" type="text/css" href="menu_style.css">  <!--  Viz 2010.09 -->
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<script language="JavaScript" type="text/javascript" src="help.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmmenu.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmcal.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>

<script type='text/javascript'>

<% backup_nvram("wan_ifname,lan_ifname,wl_ifname,wan_proto,web_svg,rstats_enable,rstats_colors"); %>

var cprefix = 'bw_24';
var updateInt = 30;
var updateDiv = updateInt;
var updateMaxL = 2880;
var updateReTotal = 1;
var hours = 24;
var lastHours = 0;
var debugTime = 0;
var href_lang = get_supportsite_lang();
switch("<% nvram_get("preferred_lang"); %>"){
	case "KR":
						href_lang = "/";
						break;
	case "RO":
						href_lang = "/";
						break;
	case "HU":
						href_lang = "/";
						break;
	case "IT":
						href_lang = "/";
						break;
	case "DA":
						href_lang = "/";
						break;	
	case "BR":
						href_lang = "/";
						break;
	case "SV":
						href_lang = "/";
						break;
	case "FI":
						href_lang = "/";
						break;
	case "NO":
						href_lang = "/";
						break;
	case "TH":
						href_lang = "/";
						break;
	case "DE":
						href_lang = "/";
						break;
	case "PL":
						href_lang = "/";
						break;
	case "CZ":
						href_lang = "/";
						break;
	default:
						break;
}

// disable auto log out
AUTOLOGOUT_MAX_MINUTE = 0;

function showHours()
{
	if (hours == lastHours) return;
	showSelectedOption('hr', lastHours, hours);
	lastHours = hours;
}

function switchHours(h)
{
	if ((!svgReady) || (updating)) return;

	hours = h;
	updateMaxL = (updateMaxL / 24) * hours;
	showHours();
	loadData();
	cookie.set(cprefix + 'hrs', hours);
}

var ref = new TomatoRefresh('update.cgi', 'output=bandwidth&arg0=speed');

ref.refresh = function(text)
{
	++updating;
	try {
		this.refreshTime = 1500;
		speed_history = {};
		try {
			eval(text);
			if (rstats_busy) {
				E('rbusy').style.display = 'none';
				rstats_busy = 0;
			}
			this.refreshTime = (fixInt(speed_history._next, 1, 120, 60) + 2) * 1000;
		}
		catch (ex) {
			speed_history = {};
		}
		if (debugTime) E('dtime').innerHTML = (new Date()) + ' ' + (this.refreshTime / 1000);
		loadData();
	}
	catch (ex) {
//		alert('ex=' + ex);
	}
	--updating;
}

ref.showState = function()
{
//	E('refresh-button').value = this.running ? 'Stop' : 'Start';
}

ref.toggleX = function()
{
	this.toggle();
	this.showState();
	cookie.set(cprefix + 'refresh', this.running ? 1 : 0);
}

ref.initX = function()
{
	var a;

	a = fixInt(cookie.get(cprefix + 'refresh'), 0, 1, 1);
	if (a) {
		ref.refreshTime = 100;
		ref.toggleX();
	}
}

function init()
{
	if (nvram.rstats_enable != '1') return;

	try {
		<% bandwidth("speed"); %>
	}
	catch (ex) {
	//	speed_history = {};
	}
	rstats_busy = 0;
	if (typeof(speed_history) == 'undefined') {
		speed_history = {};
		rstats_busy = 1;
//		E('rbusy').style.display = '';	
	}

	hours = fixInt(cookie.get(cprefix + 'hrs'), 1, 24, 24);
	updateMaxL = (updateMaxL / 24) * hours;
	showHours();
	initCommon(1, 0, 0, 1);	   //Viz 2010.09
	ref.initX();
	document.getElementById("faq0").href = "https://www.asus.com/support/FAQ/114483/" ;
	if(bwdpi_support){
		document.getElementById('content_title').innerHTML = "<#menu5_3_2#> - <#traffic_monitor#>";
	}

	document.getElementById('traffic_unit').value = getTrafficUnit();
}

function switchPage(page){
	if(page == "1")
		location.href = "/Main_TrafficMonitor_realtime.asp";
	else if(page == "2")
		return false;
	else
		location.href = "/Main_TrafficMonitor_daily.asp";
}

function Zoom(func){
	if (func == "in")
		document.form.zoom.value = parseInt(document.form.zoom.value) - 1;
	else
		document.form.zoom.value = parseInt(document.form.zoom.value) + 1;;
		
	if(document.form.zoom.value == 1)
		switchHours("4");
	else if(document.form.zoom.value == 2)
		switchHours("6");
	else if(document.form.zoom.value == 3)
		switchHours("12");
	else if(document.form.zoom.value == 4)
		switchHours("18");
	else if(document.form.zoom.value == 5)
		switchHours("24");
	else if(document.form.zoom.value > 5)
		document.form.zoom.value = 5;
	else if(document.form.zoom.value < 1)
		document.form.zoom.value = 1;
	else
		return false;
}

function setUnit(unit){
	cookie.set('ASUS_TrafficMonitor_unit', unit);
	initCommon(1, 0, 0, 1);
}
</script>
</head>

<body onload="show_menu();init();" class="bg">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="apply.cgi" target="hidden_frame">
<input type="hidden" name="current_page" value="Main_TrafficMonitor_last24.asp">
<input type="hidden" name="next_page" value="Main_TrafficMonitor_last24.asp">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="action_wait" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="zoom" value="3">

<table class="content" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td width="23">&nbsp;</td>

<!--=====Beginning of Main Menu=====-->
	<td valign="top" width="202">
	  <div id="mainMenu"></div>
	  <div id="subMenu"></div>
	</td>
		
    <td valign="top">
	<div id="tabMenu" class="submenuBlock"></div>
<!--===================================Beginning of Main Content===========================================-->
      <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
      	<tr>
          		<td align="left"  valign="top" >         
            		<table width="100%" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">		
            		<tbody>	
            		<!--===================================Beginning of graph Content===========================================-->	
	      		<tr>
					<td bgcolor="#4D595D" valign="top"  >
		  				<table width="740px" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="TMTable">
        			<tr>
						<td>
						<table width="100%" >
							<tr>
							<td  class="formfonttitle" align="left">								
										<div id="content_title" style="margin-top:5px;"><#Menu_TrafficManager#> - <#traffic_monitor#></div>
									</td>
							<td>
     						<div align="right">
			    				<select onchange="switchPage(this.options[this.selectedIndex].value)" class="input_option" style="margin-top:8px;">
									<!--option><#switchpage#></option-->
									<option value="1"><#menu4_2_1#></option>
									<option value="2" selected><#menu4_2_2#></option>
									<option value="3"><#menu4_2_3#></option>
								</select>	
							</div>
							</td></tr></table>
						</td>
        			</tr>
        			<tr>
          				<td height="5"><div class="splitLine"></div></td>
        			</tr>
        			<tr>
          				<td height="30" align="left" valign="middle" >
							<div class="formfontcontent"><p class="formfontcontent"><#traffic_monitor_desc1#></p></div>										
          				</td>
        			</tr>
        			<tr>
          				<td align="left" valign="middle">
							<!-- add some hard code of style attributes to wordkaround for IE 11-->
							<table width="95%" border="1" align="left" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="DescTable" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;	border: 1px solid #000000; border-collapse: collapse;">
								<tr><th class="tm_title_bg" style="font-family:Arial, Helvetica, sans-serif; color:#FFFFFF; font-weight:normal; line-height:15px; height: 30px; text-align:left; font-size:12px;padding-left: 10px;	border-collapse: collapse;" width="16%"></th><th class="tm_title_bg" style="font-family:Arial, Helvetica, sans-serif;color:#FFFFFF; font-weight:normal; line-height:15px; height: 30px; text-align:left; font-size:12px;	padding-left: 10px;border-collapse: collapse;" width="26%"><#Internet#></th><th class="tm_title_bg" style="font-family:Arial, Helvetica, sans-serif;color:#FFFFFF; font-weight:normal; line-height:15px; height: 30px; text-align:left; font-size:12px;	padding-left: 10px;border-collapse: collapse;" width="29%"><#tm_wired#></th><th class="tm_title_bg" style="font-family:Arial, Helvetica, sans-serif;color:#FFFFFF; font-weight:normal; line-height:15px; height: 30px; text-align:left; font-size:12px;	padding-left: 10px;border-collapse: collapse;" width="29%"><#tm_wireless#></th></tr>
								<tr><th class="tm_title_bg" style="	font-family:Arial, Helvetica, sans-serif;color:#FFFFFF; font-weight:normal; line-height:15px; height: 30px; text-align:left; font-size:12px;	padding-left: 10px;	border-collapse: collapse;"><#tm_reception#></th><td style="color:#FF9000;padding-left: 10px;border-collapse: collapse;"><#tm_recp_int#></td><td style="color:#3CF;padding-left: 10px;border-collapse: collapse;"><#tm_recp_wired#></td><td style="color:#3CF;padding-left: 10px;border-collapse: collapse;"><#tm_recp_wireless#></td></tr>
								<tr><th class="tm_title_bg" style="	font-family:Arial, Helvetica, sans-serif; color:#FFFFFF; font-weight:normal; line-height:15px; height: 30px; text-align:left; font-size:12px;	padding-left: 10px;border-collapse: collapse;"><#tm_transmission#></th><td style="color:#3CF;padding-left: 10px;border-collapse: collapse;"><#tm_trans_int#></td><td style="color:#FF9000;padding-left: 10px;	border-collapse: collapse;"><#tm_trans_wired#></td><td style="color:#FF9000;padding-left: 10px;border-collapse: collapse;"><#tm_trans_wireless#></td></tr>
							</table>
							<!--End-->
          				</td>
					</tr>
					<tr>
						<td>
							<div style="display:flex;align-items: center;margin: 4px 0;">
								<div><#Statistic_show_type#></div>
								<div style="margin-left: 24px;">
									<select class="input_option" id="traffic_unit" onchange="setUnit(this.value);">
										<option value="0">KB</option>
										<option value="1">MB</option>
										<option value="2">GB</option>
										<option value="3">TB</option>
									</select>
								</div>
							</div>
							
						</td>
					</tr>
        			<tr>
          				<td height="30" align="left" valign="middle" >
							<div class="formfontcontent"><p><#traffic_monitor_desc2#></p></div>		
							<div class="formfontcontent"><p><a id="faq0" href="" target="_blank" style="font-weight: bolder;text-decoration:underline;"><#traffic_monitor#> FAQ</a></p></div>	
          				</td>
        			</tr>    			

        			<tr>
						<td>
							<span id="tab-area"></span>										
							<span style="display:none;">	
								<input title="Zoom in" type="button" onclick="Zoom('in');" class="zoomin_btn" name="button">
         						<input title="Zoom out" type="button" onclick="Zoom('out');" class="zoomout_btn" name="button">
							</span>
							<span id="iftitle" style="font-weight: bold; color: #91071F; position: absolute; margin-top: 30px; margin-left: 41%; min-width: 180px;"></span>
							<!--========= svg =========-->
							<!--[if IE]>
								<div id="svg-table" align="left" class="IE8HACK">
									<object id="graph" src="tm.svg" classid="image/svg+xml" width="730" height="350">
								</div>
							<![endif]-->
							<!--[if !IE]>-->
								<object id="graph" data="tm.svg" type="image/svg+xml" width="730" height="350">
							<!--<![endif]-->
								</object>
							<!--========= svg =========-->
                    	</td>
        	    	</tr>
        	    
  		     		<tr>
						<td>
				    	 	<table width="730px" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable_NWM" style="margin-top:0px;margin-left:-1px;*margin-left:-10px;margin-left:-12px \9;">
						  		<tr>
						  			<th style="text-align:center;width:160px;"><#Current#></th>
						  			<th style="text-align:center;width:160px;"><#Average#></th>
						  			<th style="text-align:center;width:160px;"><#Maximum#></th>
						  			<th style="text-align:center;width:160px;"><#Total#></th>
						  		</tr>
						  		<tr>
						  			<td style="text-align:center;font-weight: bold; background-color:#111;"><div id="rx-current"></div></td>
						  			<td style="text-align:center; background-color:#111;" id='rx-avg'></td>
						  			<td style="text-align:center; background-color:#111;" id='rx-max'></td>
						  			<td style="text-align:center; background-color:#111;" id='rx-total'></td>
						    	</tr>						    		
						    	<tr>
						    		<td style="text-align:center;font-weight: bold; background-color:#111;"><div id="tx-current"></div></td>
										<td style="text-align:center; background-color:#111;" id='tx-avg'></td>
										<td style="text-align:center; background-color:#111;" id='tx-max'></td>
										<td style="text-align:center; background-color:#111;" id='tx-total'></td>
								</tr>
							</table>
						</td>
					</tr>
						</table>
					</td>
				</tr>	
				<tr style="display:none">
					<td bgcolor="#FFFFFF">
		  				<table width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
		    				<thead>
								<tr>
									<td colspan="5" id="TriggerList">Display Options</td>
								</tr>
		    				</thead>
							<div id='bwm-controls'>						
								<tr>
									<th width='50%'>:&nbsp;</th>
									<td>
										<a href='javascript:switchHours(4);' id='hr4'>4</a>,
										<a href='javascript:switchHours(6);' id='hr6'>6</a>,
										<a href='javascript:switchHours(12);' id='hr12'>12</a>,
										<a href='javascript:switchHours(18);' id='hr18'>18</a>,
										<a href='javascript:switchHours(24);' id='hr24'>24</a>
									</td>
								</tr>						
								<tr>
									<th>:&nbsp;</th>
									<td>
										<a href='javascript:switchAvg(1)' id='avg1'>Off</a>,
										<a href='javascript:switchAvg(2)' id='avg2'>2x</a>,
										<a href='javascript:switchAvg(4)' id='avg4'>4x</a>,
										<a href='javascript:switchAvg(6)' id='avg6'>6x</a>,
										<a href='javascript:switchAvg(8)' id='avg8'>8x</a>
									</td>
								</tr>			
								<tr>
									<th>:&nbsp;</th>
									<td>
										<a href='javascript:switchScale(0)' id='scale0'>Uniform</a>,
										<a href='javascript:switchScale(1)' id='scale1'>Per IF</a>
									</td>
								</tr>			
								<tr>
									<th>:&nbsp;</th>
									<td>
										<a href='javascript:switchDraw(0)' id='draw0'>Solid</a>,
										<a href='javascript:switchDraw(1)' id='draw1'>Line</a>
									</td>
								</tr>		
								<tr>
									<th>:&nbsp; </th>
									<td>
										<a href='javascript:switchColor()' id='drawcolor'> </a><small><a href='javascript:switchColor(1)' id='drawrev'></a></small>
									</td>
								</tr>	
							</div>							
						</table>
					</td>
				</tr>
			</tbody>		
			</table>	
		</td>
	</tr>
	</table>				
	</td>   	 
	</tr>
</table>

<div id="footer"></div>
</body>
</html>

