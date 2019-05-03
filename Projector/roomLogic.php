<?php
    include '../model/question_db.php';
    include '../model/room_db.php';
    include '../model/classes.php';

    if($func = filter_input(INPUT_POST, "Quiz")){
        if($type = filter_input(INPUT_POST, "update")) {

        }
        elseif ($type = filter_input(INPUT_POST, "Room")) {

        }
    }
    elseif ($func = filter_input(INPUT_POST, "Room")) {
        if($type = filter_input(INPUT_POST, "update")) {

        }
        elseif ($type = filter_input(INPUT_POST, "get")) {
            $roomID = filter_input(INPUT_POST, "roomID");
            $result = getRoom($roomID);
            echo $result;
        }
    }
    else {
        echo "Failure";
    }
?>