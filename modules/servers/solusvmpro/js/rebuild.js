$(function () {
	
    $("#templates > div").click(function () {
	    $(this).siblings().find('.system').removeClass('show');
        $(this).addClass("selected").find('input[type=radio]').attr("checked", "checked");
        $(this).siblings().removeClass("selected").find('input[type=radio]').removeAttr("checked");
        var selectname = $('.select-name').data('select');
        $(this).siblings().find('.select-name').html(selectname);
    });
    
    $('.select-name').click(function () {
	    $(this).parent().find('.system').toggleClass('show');
    });
    
    $(".system > li").click(function () {
		$(this).addClass('active');
        $(this).siblings().removeClass('active');
        var osname = $(this).data('os');
        var osver = $(this).text();
        $(this).parent().removeClass('show');
        $(this).parent().parent().find('.select-name').html(osver);
        $('#systemname').html(osver);
        $('#confirmbtn').removeAttr("disabled");
	});
    
	var form = $('#rebuild_form');
	form.submit(function(e){
		e.preventDefault();
	
		var rebuild_userID = $('#rebuild_form .userid').val();
		var rebuild_vserverID = $('#rebuild_form .vserverid').val();
		var rebuild_tempLate = $('.system .active').data('template');
		
		$('#overlay').removeClass('open');
		$('#templates').hide();
		$('#templates #loading').show();
		
		RebuildVirtualServer(rebuild_userID, rebuild_vserverID, rebuild_tempLate);
		$('#rebuild_form').empty();
	});
	
});

var completeFlag = true;
function RebuildVirtualServer(userID, vserverID, tempLate) {
	
	if(!completeFlag) {
		return;
	}
	
	$.ajax({
		method: "POST",
		url: "modules/servers/solusvmpro/rebuild.php",
		data: {userid: userID, vserverid: vserverID, template: tempLate},
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
				$('.solusvm').hide();
				$('.rebuildmsg').show();
				if (value.rootpassword != '') {
					$('#password').text(value.rootpassword);
				}
				RebuildLoading(vserverID);
			} else if (value.status=='error') {
				$('.solusvm').hide();
				$('.rebuildmsg').show();
				swal("Error", value.statusmsg, "error");
			};
		},
		error:function() {
			swal("服务器忙，请稍后重试");
			$(".solusvm").show();
		}
	});
}
function RebuildLoading(vserverID) {
	
    $.ajax({
        method: "GET",
        url: "modules/servers/solusvmpro/get_client_data.php",
        data: {vserverid: vserverID},
        cache: false,
        dataType: 'json'/*,
         timeout: 2000*/
    }).done(function (data) {
	    if (data.state=='online') {
	        $('.rebuildmsg').hide();
	        $('.solusvm').show();
			$(".templates").html(data.template);
		
			$('#templates').show();
			$('#templates #loading').hide();
	    } else {
		    setTimeout(function(){RebuildLoading(vserverID)},5000);
	    }
    }).fail(function (jqXHR, textStatus) {
        $('#displayState').hide();
        $('#displayStateUnavailable').show();
    });

    return true;
    
}