<script type="text/javascript" src="modules/servers/solusvmpro/js/get_user_data.js?v66"></script>
<script type="text/javascript" src="modules/servers/solusvmpro/js/rebuild.js?5"></script>
<script type="text/javascript" src="modules/servers/solusvmpro/js/hostname.js"></script>
{if $info['type'] != 'kvm'}
<script type="text/javascript" src="modules/servers/solusvmpro/js/rootpassword.js"></script>
{/if}
<script type="text/javascript" src="modules/servers/solusvmpro/js/vncpassword.js"></script>
<link rel="stylesheet" href="modules/servers/solusvmpro/templates/assets/css/style.css?4">
<link rel="stylesheet" href="modules/servers/solusvmpro/templates/assets/css/sweetalert.css?v66">
<script type="text/javascript" src="modules/servers/solusvmpro/js/uilang.js"></script>
<script type="text/javascript" src="modules/servers/solusvmpro/js/sweetalert.min.js?v65"></script>

{literal}
<script>
    $(function () {

        var reload = false;
        var url = window.location.href;
        patPre = '&serveraction=custom&a=';
        patAr = ['shutdown', 'reboot', 'boot'];
        for (var testPat in patAr) {
            pat = patPre + patAr[testPat];
            if(url.indexOf(pat) > 0){
                alertModuleCustomButtonSuccess = $('#alertModuleCustomButtonSuccess');
                if(alertModuleCustomButtonSuccess){
                    url = url.replace(pat,'');
                    window.location.href = url;
                    reload = true;
                }
                break;
            }
        }

        if(!reload){
            var vserverid = {/literal}{$data.vserverid}{literal};
            window.solusvmpro_get_and_fill_client_data(vserverid);
            window.solusvmpro_hostname(vserverid, {'solusvmpro_invalidHostname': '{/literal}{$LANG.solusvmpro_invalidHostname}{literal}','solusvmpro_change':'{/literal}{$LANG.solusvmpro_change}{literal}'});
            {/literal}
            {if $info['type'] != 'kvm'}
            {literal}
            window.solusvmpro_rootpassword(vserverid, {'solusvmpro_invalidRootpassword': '{/literal}{$LANG.solusvmpro_invalidRootpassword}{literal}','solusvmpro_change':'{/literal}{$LANG.solusvmpro_change}{literal}','solusvmpro_confirmRootPassword':'{/literal}{$LANG.solusvmpro_confirmRootPassword}{literal}','solusvmpro_confirmErrorPassword':'{/literal}{$LANG.solusvmpro_confirmErrorPassword}{literal}','solusvmpro_confirmPassword':'{/literal}{$LANG.solusvmpro_confirmPassword}{literal}'});
            {/literal}
            {/if}
            {literal}
            window.solusvmpro_vncpassword(vserverid, {'solusvmpro_invalidVNCpassword': '{/literal}{$LANG.solusvmpro_invalidVNCpassword}{literal}','solusvmpro_change':'{/literal}{$LANG.solusvmpro_change}{literal}','solusvmpro_confirmVNCPassword':'{/literal}{$LANG.solusvmpro_confirmVNCPassword}{literal}','solusvmpro_confirmErrorPassword':'{/literal}{$LANG.solusvmpro_confirmErrorPassword}{literal}','solusvmpro_confirmPassword':'{/literal}{$LANG.solusvmpro_confirmPassword}{literal}'});

            var cookieNameForAccordionGroup = 'solusvmpro_activeAccordionGroup_Client';
            var last = document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(cookieNameForAccordionGroup).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")
            $("#solusvmpro_accordion .panel-collapse").removeClass('in');
            if (last == "") {
                last = "solusvmpro_collapseSix";
            }
            if(last !== 'none') {
                $("#" + last).addClass("in");
            }

            $("#solusvmpro_accordion").on('shown.bs.collapse', function() {
                var active = $("#solusvmpro_accordion .in").attr('id');
                document.cookie = cookieNameForAccordionGroup + "=" + active;
            });

            $("#solusvmpro_accordion").on('hidden.bs.collapse', function() {
                var active = 'none';
                document.cookie = cookieNameForAccordionGroup + "=" + active;
            });
        }
    });
{/literal}
{if $info['type'] == 'kvm'}
{literal}
	var completeFlag = true;
	function KVMChangeRootPassword(userID, vserverID) {
		swal({
			title: "{/literal}{$LANG.solusvmpro_ResetPassword}{literal}",
			type: "info",
			showCancelButton: true,
			closeOnConfirm: false,
			showLoaderOnConfirm: true,
			cancelButtonText: "{/literal}{$LANG.cancel}{literal}",
			confirmButtonText: "{/literal}{$LANG.confirm}{literal}",
		},
		function(){
			if(!completeFlag) {
				return;
			}
			$.ajax({
				method: "POST",
				url: "modules/servers/solusvmpro/password.php",
				data: {userid: userID, vserverid: vserverID},
				dataType: 'json',
				cache: false,
				beforeSend:function() {
					completeFlag = false;
				},
				complete:function() {
					completeFlag = true;
				},
				success: function(value) {
					if(value.status=='success') {
						swal({
							title: "{/literal}{$LANG.solusvmpro_PasswordResetSuccess}{literal}",
							text: value.rootpassword,
							type: "success"
		  				});
		  				$('#password').html(value.rootpassword);
					} else if (value.status=='error') {
						swal({
							title: "{/literal}{$LANG.solusvmpro_PasswordResetError}{literal}",
							text: value.statusmsg,
							type: "error"
		  				});
					};
				},
				error:function() {
					swal("服务器忙，请稍后重试");
				}
			});
		});
	}
{/literal}
{/if}
{literal}
</script>
{/literal}

<div class="row">
	
	<div class="col-md-12">
		<div class="meta-main">
			<div class="pull-left">
				<h4 class="head-title">{$product} | {$domain}</h4>
			</div>
			<div class="pull-right">
				<a href="javascript:location.reload()" class="btn btn-sm btn-primary"><span class="fa fa-refresh"></span> {$LANG.solusvmpro_refresh}</a>
				<a href="index.php?m=ReNew&amp;id={$id}" class="btn btn-sm btn-primary"><span class="zmdi zmdi-balance-wallet"></span> 续费</a>
				{if $showcancelbutton || $packagesupgrade}
					{if $packagesupgrade}
	                	<a href="upgrade.php?type=package&amp;id={$id}" class="btn btn-sm btn-success"><span class="fa fa-arrow-up" aria-hidden="true"></span>{$LANG.upgrade}</a>
	                {/if}
					<a href="clientarea.php?action=cancel&amp;id={$id}" class="btn btn-sm btn-danger {if $pendingcancellation}disabled{/if}"><span class="zmdi zmdi-delete"></span> {if $pendingcancellation}{$LANG.cancellationrequested}{else}{$LANG.clientareacancelrequestbutton}{/if}</a>
				{/if}
			</div>
		</div>
	</div>
	
</div>

<div id="displayState" class="text-center">
	<div class="loading">
        <span></span>
        <span></span>
        <span></span>
        <span></span>
        <span></span>
	</div>
    {$LANG.solusvmpro_loading}
</div>

<div id="displayStateUnavailable" style="display: none">
    <strong>{$LANG.solusvmpro_unavailable}</strong>
</div>

<div class="row solusvm" style="display: none">

	<div class="col-sm-6 col-md-3">
		<div class="info-main">
			<div class="title">
				CPU：
			</div>
			<div class="info">
				{$info['cpus']}
			</div>
		</div>
	</div>
	<div class="col-sm-6 col-md-3">
		<div class="info-main">
			<div class="title">
				{$LANG.solusvmpro_memory}{if $info['swap'] != '0 KB'}/SWAP{/if}：
			</div>
			<div class="info">
				{$info['memory']}{if $info['swap'] != '0 KB'}<span> / {$info['swap']}</span>{/if}
			</div>
		</div>
	</div>
	<div class="col-sm-6 col-md-3">
		<div class="info-main">
			<div class="title">
				{$LANG.solusvmpro_disk}：
			</div>
			<div class="info">
				{$info['disk']}
			</div>
		</div>
	</div>
	{if $info['mac']}
	<div class="col-sm-6 col-md-3">
		<div class="info-main">
			<div class="title">
				MAC：
			</div>
			<div class="info">
				<span>{$info['mac']}</span>
			</div>
		</div>
	</div>
	{else}
	<div class="col-sm-6 col-md-3">
		<div class="info-main">
			<div class="title">
				Virtualization：
			</div>
			<div class="info">
				{$info['type']}
			</div>
		</div>
	</div>
	{/if}
	
	<div class="col-md-12 detail" style="display: none">
		<div class="row">
        	<div class="col-md-7">
	        	<div class="left-main">
		        	<ul class="list-unstyled" style="margin-bottom: 0;">
		        		<li>{$LANG.solusvmpro_status}：
		        			<span>{$info['displaystatus']}</span>
						</li>
		        		<li>{$LANG.solusvmpro_hostname}：<span>{$info['hostname']}</span></li>
		        		<li>{$LANG.solusvmpro_ipAddress}：<span>{$info['mainip']} {if $info['ipcsv'] != $info['mainip']}<span class="icons icon-settings" style="vertical-align: middle;height: 16px;width: 15px;font-size: 15px;" data-container="body" data-toggle="popover" data-placement="bottom" data-content="{$info['ipcsv']}"></span>{/if}</span></li>
		        		<li>{$LANG.solusvmpro_operatingsystem}：<span class="templates">{$info['template']}</span></li>
		        		<li>{$LANG.solusvmpro_rootPassword}：
		        			<span onclick="javascript:$(this).hide();$('#password').show();">{$LANG.solusvmpro_ViewPassword}</span>
		        			<span id="password" style="display: none">{$rootpass}</span>
		        		</li>
		        	</ul>
	        	</div>
        	</div>
        	<div class="col-md-5">
	        	<div class="right-main">
		        	{if ($info['type'] == 'openvz')}
		        	<h6>{$LANG.solusvmpro_memory}:
			        		<span class="pull-right">{$info['memoryused']} / {$info['memorytotal']} <i>({$info['memoryfree']} {$LANG.solusvmpro_free})</i></span></h6>
						<div class="progress active progress-lg">
							<span class="pull-left">{$info['memoryused']}</span>
							<span class="pull-right">{$info['memorytotal']}</span>
							<div class="progress-bar {$info['memorycolor']} progress-bar-striped" role="progressbar" aria-valuenow="{$info['memorypercent']}" aria-valuemin="0" aria-valuemax="100" style="width: {$info['memorypercent']}%;"></div>
						</div>
		        	{/if}
		        	{if $info['type'] == 'openvz' || $info['type'] == 'xen'}
		        		<h6>{$LANG.solusvmpro_disk}:
			        		<span class="pull-right">{$info['hddused']} / {$info['hddtotal']} <i>({$info['hddfree']} {$LANG.solusvmpro_free})</i></span></h6>
						<div class="progress active progress-lg">
							<span class="pull-left">{$info['hddused']}</span>
							<span class="pull-right">{$info['hddtotal']}</span>
							<div class="progress-bar {$info['hddcolor']} progress-bar-striped" role="progressbar" aria-valuenow="{$info['hddpercent']}" aria-valuemin="0" aria-valuemax="100" style="width: {$info['hddpercent']}%;"></div>
						</div>
		        	{/if}
		        	<h6>{$LANG.solusvmpro_bandwidth}:
			        	<span class="pull-right">{$info['bandwidthused']} / {$info['bandwidthtotal']} <i>({$info['bandwidthfree']} {$LANG.solusvmpro_free})</i></span></h6>
					<div class="progress active progress-lg">
						<span class="pull-left">{$info['bandwidthused']}</span>
						<span class="pull-right">{$info['bandwidthtotal']}</span>
						<div class="progress-bar {$info['bandwidthcolor']} progress-bar-striped" role="progressbar" aria-valuenow="{$info['bandwidthpercent']}" aria-valuemin="0" aria-valuemax="100" style="width: {$info['bandwidthpercent']}%;"></div>
					</div>
	        	</div>
        	</div>
        	<div class="col-md-12">
	        	<div class="btm-main">
		        	<ul class="list-unstyled row">
			        	{if $info['displayreboot'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a href="javascript:if(confirm('您确定要{$LANG.solusvmpro_reboot}吗？'))location='clientarea.php?action=productdetails&id={$serviceid}&serveraction=custom&a=reboot';" class="btn btn-default"><span class="fa fa-repeat text-primary"></span>{$LANG.solusvmpro_reboot}</a>
			        	</li>
			        	{/if}
			        	{if $info['displayboot'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a href="javascript:if(confirm('您确定要{$LANG.solusvmpro_boot}吗？'))location='clientarea.php?action=productdetails&id={$serviceid}&serveraction=custom&a=boot';" class="btn btn-default"><span class="fa fa-play text-success"></span>{$LANG.solusvmpro_boot}</a>
			        	</li>
			        	{/if}
			        	{if $info['displayshutdown'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a href="javascript:if(confirm('您确定要{$LANG.solusvmpro_shutdown}吗？'))location='clientarea.php?action=productdetails&id={$serviceid}&serveraction=custom&a=shutdown';" class="btn btn-default"><span class="fa fa-stop text-danger"></span>{$LANG.solusvmpro_shutdown}</a>
			        	</li>
			        	{/if}
			        	{if $info['displayrebuild'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a id="rebuild" class="btn btn-default">
			        			<span class="fa fa-retweet text-info"></span>
			        			{$LANG.solusvmpro_reinstall}
			        		</a>
			        	</li>
			        	{/if}
			        	{if $info['type'] == 'kvm'}
			        	<li class="col-sm-4 col-md-2">
			        		<a onClick="javascript:KVMChangeRootPassword({$userid}, {$data['vserverid']});" class="btn btn-default">
			        			<span class="fa fa-key text-info"></span>
			        			{$LANG.solusvmpro_reset}{$LANG.solusvmpro_password}
			        		</a>
			        	</li>
			        	{/if}
			        	{if $info['displayconsole'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a href="#" onClick="window.open('modules/servers/solusvmpro/console.php?id={$serviceid}','_blank','width=670,height=400,status=no,location=no,toolbar=no,menubar=no')" class="btn btn-default"><span class="fa fa-terminal"></span>{$LANG.solusvmpro_serialConsole}</a>
			        	</li>
			        	{/if}
			        	{if $info['displayhtml5console'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a href="#" onClick="window.open('modules/servers/solusvmpro/html5console.php?id={$serviceid}','_blank','width=870,height=600,status=no,resizable=yes,copyhistory=no,location=no,toolbar=no,menubar=no,scrollbars=1')" class="btn btn-default"><span class="fa fa-terminal"></span>{$LANG.solusvmpro_html5Console}</a>
			        	</li>
			        	{/if}
			        	{if $info['displayvnc'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a href="#" onClick="window.open('modules/servers/solusvmpro/vnc.php?id={$serviceid}','_blank','width=400,height=200,status=no,location=no,toolbar=no,menubar=no')" class="btn btn-default"><span class="fa fa-terminal"></span>{$LANG.solusvmpro_vnc}</a>
			        	</li>
			        	{/if}
			        	{if $info['displaypanelbutton'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<a href="#" id="controlpanellink" class="btn btn-default"><span class="fa fa-terminal"></span>{$LANG.solusvmpro_controlPanel}</a>
			        	</li>
			        	{/if}
			        	{if $info['displayclientkeyauth'] == 1}
			        	<li class="col-sm-4 col-md-2">
			        		<form action="" name="solusvm" method="post">
			                    <input type="submit" class="btn btn-success" name="logintosolusvm" value="{$LANG.solusvmpro_manage}">
			                </form>
			        	</li>
			        	{/if}
		        	</ul>
	        	</div>
        	</div>
    	</div>
	</div>
	 
    <div class="col-md-12">
        <div class="panel-group" id="solusvmpro_accordion" role="tablist" aria-multiselectable="false">
            
            {if $info['displaygraphs'] == 1}
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingSix">
                    <h4 class="panel-title">
                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#solusvmpro_accordion" href="#solusvmpro_collapseSix" aria-expanded="false" aria-controls="solusvmpro_collapseSix">
                            {$LANG.solusvmpro_graphs}
                        </a>
                    </h4>
                </div>
                <div id="solusvmpro_collapseSix" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingSix">
                    <div class="panel-body text-center">
						{if $info['displaytrafficgraph'] == 1}
                            <img src="data:image/jpeg;base64,{$info['trafficgraphurl']}" alt="Traffic Graph Unavailable" />
                        {/if}
						{if $info['displayloadgraph'] == 1}
                            <img src="data:image/jpeg;base64,{$info['loadgraphurl']}" id="loadgraphurlImg" alt="Load Graph Unavailable" />
                        {/if}
						{if $info['displaymemorygraph'] == 1}
                            <img src="data:image/jpeg;base64,{$info['memorygraphurl']}" id="memorygraphurlImg" alt="Memory Graph Unavailable" />
                        {/if}
                    </div>
                </div>
            </div>
            {/if}
            {if $info['displayrootpassword'] == 1}
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingOne">
                    <h4 class="panel-title">
                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#solusvmpro_accordion" href="#solusvmpro_collapseOne" aria-expanded="false" aria-controls="solusvmpro_collapseOne">
                            {$LANG.solusvmpro_rootPassword}
                        </a>
                    </h4>
                </div>
                <div id="solusvmpro_collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body">

                        <div class="row">
                            <div id="rootpasswordMsgSuccess" class="alert alert-success" role="alert" style="display: none"></div>
                            <div id="rootpasswordMsgError" class="alert alert-danger" role="alert" style="display: none"></div>
                        </div>
                        <div class="row margin-10">
                            <div class="col-xs-2"></div>
                            <div class="col-xs-8">
                                <div class="form-group">
                                    <label for="newrootpassword">{$LANG.solusvmpro_newPassword}</label>
                                    <input type="password" class="form-control" name="newrootpassword" id="newrootpassword"
                                           placeholder="{$LANG.solusvmpro_enterRootPassword}" value="">
                                </div>
                            </div>
                            <div class="col-xs-2"></div>
                        </div>
                        <div class="row margin-10">
                            <div class="col-xs-2"></div>
                            <div class="col-xs-8">
                                <div class="form-group">
                                    <label for="confirmnewrootpassword">{$LANG.solusvmpro_confirmPassword}</label>
                                    <input type="password" class="form-control" name="confirmnewrootpassword" id="confirmnewrootpassword"
                                           placeholder="{$LANG.solusvmpro_confirmRootPassword}" value="">
                                </div>
                                <button type="button" id="changerootpassword" class="btn btn-success">{$LANG.solusvmpro_change}</button>
                            </div>
                            <div class="col-xs-2"></div>
                        </div>

                    </div>
                </div>
            </div>
            {/if}
            {if $info['displayhostname'] == 1}
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingThree">
                    <h4 class="panel-title">
                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#solusvmpro_accordion" href="#solusvmpro_collapseThree" aria-expanded="false" aria-controls="solusvmpro_collapseThree">
                            {$LANG.solusvmpro_hostname}
                        </a>
                    </h4>
                </div>
                <div id="solusvmpro_collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                    <div class="panel-body">

                        <div class="row">
                            <div id="hostnameMsgSuccess" class="alert alert-success" role="alert" style="display: none"></div>
                            <div id="hostnameMsgError" class="alert alert-danger" role="alert" style="display: none"></div>
                        </div>
                        <div class="row margin-10">
                            <div class="col-xs-2"></div>
                            <div class="col-xs-8">
                                <div class="form-group">
                                    <label for="newhostname">{$LANG.solusvmpro_newHostname}</label>
                                    <input type="text" class="form-control" name="newhostname" id="newhostname"
                                           placeholder="{$LANG.solusvmpro_enterHostname}" value="">
                                </div>
                                <button type="button" id="changehostname" class="btn btn-success">{$LANG.solusvmpro_change}</button>
                            </div>
                            <div class="col-xs-2"></div>
                        </div>


                    </div>
                </div>
            </div>
            {/if}
            {if $info['displayvncpassword'] == 1}
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingFive">
                    <h4 class="panel-title">
                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#solusvmpro_accordion" href="#solusvmpro_collapseFive" aria-expanded="false" aria-controls="solusvmpro_collapseFive">
                            {$LANG.solusvmpro_vncPassword}
                        </a>
                    </h4>
                </div>
                <div id="solusvmpro_collapseFive" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingFive">
                    <div class="panel-body">

                        <div class="row">
                            <div id="vncpasswordMsgSuccess" class="alert alert-success" role="alert" style="display: none"></div>
                            <div id="vncpasswordMsgError" class="alert alert-danger" role="alert" style="display: none"></div>
                        </div>
                        <div class="row margin-10">
                            <div class="col-xs-2"></div>
                            <div class="col-xs-8">
                                <div class="form-group">
                                    <label for="newvncpassword">{$LANG.solusvmpro_newPassword}</label>
                                    <input type="password" class="form-control" name="newvncpassword" id="newvncpassword"
                                           placeholder="{$LANG.solusvmpro_enterVNCPassword}" value="">
                                </div>
                            </div>
                            <div class="col-xs-2"></div>
                        </div>
                        <div class="row margin-10">
                            <div class="col-xs-2"></div>
                            <div class="col-xs-8">
                                <div class="form-group">
                                    <label for="confirmnewvncpassword">{$LANG.solusvmpro_confirmPassword}</label>
                                    <input type="password" class="form-control" name="confirmnewvncpassword" id="confirmnewvncpassword"
                                           placeholder="{$LANG.solusvmpro_confirmVNCPassword}" value="">
                                </div>
                                <button type="button" id="changevncpassword" class="btn btn-success">{$LANG.solusvmpro_change}</button>
                            </div>
                            <div class="col-xs-2"></div>
                        </div>

                    </div>
                </div>
            </div>
            {/if}
        </div>

    </div>

    <div id="clientkeyautherror" style="display: none">
        <div class="col-md-12 bg-danger">
            {$LANG.solusvmpro_accessUnavailable}
        </div>
    </div>
	
	<div class="col-md-12">
		<div class="panel panel-default panel-amount">
			<div class="panel-heading">
            	<h3 class="panel-title"><span class="fa fa-star"></span>&nbsp;{$LANG.solusvmpro_paymentDetails}</h3>
        	</div>
        	<div class="panel-body">
	        	<ul class="row list-unstyled top-main">
		        	<li class="col-sm-6"><span>{$LANG.clientareahostingregdate}</span>{$regdate}</li>
		
					{if $firstpaymentamount neq $recurringamount}
		            <li class="col-sm-6"><span>{$LANG.firstpaymentamount}</span>{$firstpaymentamount}</li>
					{/if}
		
					{if $billingcycle != $LANG.orderpaymenttermonetime && $billingcycle != $LANG.orderfree}
		            <li class="col-sm-6"><span>{$LANG.recurringamount}</span>{$recurringamount}</li>
					{/if}
		
					<li class="col-sm-6"><span>{$LANG.orderbillingcycle}</span>{$billingcycle}</li>
		
					<li class="col-sm-6"><span>{$LANG.clientareahostingnextduedate}</span>{$nextduedate}</li>
		
					<li class="col-sm-6"><span>{$LANG.orderpaymentmethod}</span>{$paymentmethod}</li>
		
					{if $suspendreason}
		            <li class="suspendreason col-sm-6"><span>{$LANG.suspendreason}</span>{$suspendreason}</li>
					{/if}
	        	</ul>
        	</div>
		</div>
	</div>
	
</div>

<div class="rebuildmsg text-center">
	<div class="loading">
        <span></span>
        <span></span>
        <span></span>
        <span></span>
        <span></span>
	</div>
    <span class="msg">{$LANG.rebuildloading}</span>
</div>

<div id="overlay">
	<form id="rebuild_form">
		<div class="rebuild-header">
			<a href=# class=close>Close</a>
			<h1>{$LANG.solusvmpro_reinstall}</h1>
		</div>
		<div class="rebuild-content">
			<div class="row" id="templates">
				<input type="hidden" class="vserverid" name="vserverid" value="{$data['vserverid']}" />
				<input type="hidden" class="userid" name="userid" value="{$userid}" />
				{foreach $result as $key => $value}
				<div class="{if {$key|count} <= 3}col-sm-3{else}col-sm-4{/if}">
					<div class="template">
						<span class="os-icon os-icon-lg os-{$key} os-linux"></span>
						<strong class="systemname">{$key}</strong>
						<span class="select-name" data-select="{$LANG.Selectsystem}">{$LANG.Selectsystem}</span>
						<ul class="list-unstyled system">
						{foreach from=$value item=os}
							<li data-os="{$key}" data-template="{$os['filename']}">{$os['friendlyname']}</li>
						{/foreach}
						</ul>
					</div>
				</div>
				{/foreach}
		    </div>
		    <div class="text-center" id="loading" style="display: none">
			      <span class="text-center fa fa-spinner fa-pulse fa-5x fa-fw margin-bottom" style="margin: 50px;"></span>
			</div>
		</div>
		
	    <div class="rebuild-footer">
		    <span class="pull-left" id="systemname"></span>
		    <button type="submit" class="confirm" id="confirmbtn" disabled>{$LANG.orderForm.yes}</button>
	    </div>
	</form>
    <div class="text-center rootpass_loading" style="display: none">
	      <span class="text-center fa fa-spinner fa-pulse fa-5x fa-fw margin-bottom" style="margin: 20px;color: #FFF;"></span>
	</div>
	<code>
	  clicking on "#rebuild" adds class "open" on "#overlay, #rebuild_form"
	  clicking on ".close, .rebuild-footer .btn-primary" removes class "open" on "#overlay, #rebuild_form"
	</code>
</div>