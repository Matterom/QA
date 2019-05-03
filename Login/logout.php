<?php
    #########################
    ### By Matthew Nelson ###
    #########################
session_start();
session_destroy();
$_SESSION = [];
header('location: ../index.php');
?>