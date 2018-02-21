<?php
define('WHMCS', '');

require( "../../../init.php" );
session_start();

require_once __DIR__ . '/lib/Curl.php';
require_once __DIR__ . '/lib/CaseInsensitiveArray.php';
require_once __DIR__ . '/lib/SolusVM.php';

use Illuminate\Database\Capsule\Manager as Capsule;
use SolusVM\SolusVM;

$userid 		= (int) $_POST["userid"];
$vserverid 		= (int) $_POST["vserverid"];

SolusVM::loadLang();

$params = SolusVM::getParamsFromVserviceID( $vserverid, $userid );
if ( ! $params ) {
    $result = [
        'status'        => 'error',
        'displaystatus' => $_LANG['solusvmpro_vserverNotFound'],
    ];
    echo json_encode( $result );
    exit();
}

if ($vserverid && $userid) {
    try {
		$solusvm = new SolusVM( $params );
		$callArray = array( "vserverid" => $vserverid );
		
        $solusvm->apiCall( 'vserver-rootpassword', $callArray );
		$r = $solusvm->result;
		
		if ( $r["status"] == "success" ) {
            $solusvm->setCustomfieldsValue( 'rootpassword', $r["rootpassword"] );
        }
        echo json_encode($r);
    } catch ( Exception $e ) {
        // Record the error in WHMCS's module log.
        logModuleCall(
            'rebuild',
            __FUNCTION__,
            $params,
            $e->getMessage(),
            $e->getTraceAsString()
        );

        echo $e->getMessage();
    }
}