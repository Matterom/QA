<?php
    include '../model/question_db.php';
    include '../model/room_db.php';
    include '../model/classes.php';

    if($func = filter_input(INPUT_POST, "Quiz")){
        if($type = filter_input(INPUT_POST, "Update")) {

        }
        elseif ($type = filter_input(INPUT_POST, "Question")) {

        }
        elseif ($type = filter_input(INPUT_POST, "Answer")) {
            $attemptID = 
            $questionID = filter_input(INPUT_POST, "qid");
            $answer = filter_input(INPUT_POST, "aid");
            $result = answerQuestion($attemptID, $questionID, $answer);
        }
    }
    elseif ($func = filter_input(INPUT_POST, "Room")) {
        if($type = filter_input(INPUT_POST, "update")) {

        }
        elseif ($type = filter_input(INPUT_POST, "getRoom")) {
            $roomID = filter_input(INPUT_POST, "roomID");
            $result = getRoom($roomID);
            echo $result;
        }
        elseif ($type = filter_input(INPUT_POST, "getQuest")) {
            $qid = filter_input(INPUT_POST, "qID");
            $result = getQuestion($roomID);
            echo json_encode($result);
        }
    }
    else {
        echo "Failure";
    }
?>