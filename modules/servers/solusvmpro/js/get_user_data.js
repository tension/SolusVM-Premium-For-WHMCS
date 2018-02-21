$(function () {
    window.solusvmpro_get_and_fill_client_data = function (vserverid) {
        if (typeof vserverid === 'undefined') {
            return false;
        }
        $.ajax({
            method: "GET",
            url: "modules/servers/solusvmpro/get_client_data.php",
            data: {vserverid: vserverid},
            cache: false,
            dataType: 'json'/*,
             timeout: 2000*/
        }).done(function (data) {
            $('#displayState').hide();
            $('.solusvm').show();
			if (data.state=='online' || data.state=='offline') {
            	$('.detail').show();
            } else {
	            var suspendreason = $(".suspendreason").html();
            	$('.detail').show();
            	$('#solusvmpro_accordion').hide();
	            //$('.detail .panel-body').addClass('text-center').html('<h4>'+data.displaystatus+'</h4><h5>'+suspendreason+'</h5>');
            }

            if (data.controlpanellink) {
                $("#controlpanellink").attr("onclick", "window.open('" + data.controlpanellink + "','_blank')");
            }

        }).fail(function (jqXHR, textStatus) {
            $('#displayState').hide();
            $('#displayStateUnavailable').show();
        });

        return true;
    }
});

