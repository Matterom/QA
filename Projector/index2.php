<?php 
    session_start();
    print_r($_SESSION);
    print("<br>QuestionSetID: ");
    print_r($_SESSION['qSetIDList']);
    /*
    printf("UserID: %d<br>", $_SESSION['id']);
    printf("RoomID: %d<br>", $_SESSION['roomID']);
    printf("RoomKey: %d<br>", $_SESSION['roomKey']);
    printf("RosterID: %d<br>", $_SESSION['rosterID']);
    printf("Question Set ID: %d<br>", $_SESSION['qSetID']);
    */
?>
