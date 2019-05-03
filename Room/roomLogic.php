<?php
    #########################
    ### By Matthew Nelson ###
    #########################
    include '../model/question_db.php';
    include '../model/room_db.php';
    include '../model/classes.php';

    if($func = filter_input(INPUT_POST, "Quiz")){
        if($type = filter_input(INPUT_POST, "Update")) {
            //Unused
        }
        elseif ($type = filter_input(INPUT_POST, "setQuest")) {
            $roomID = filter_input(INPUT_POST, "roomID");
            $questionID = filter_input(INPUT_POST, "qid");
            setNextQuestion($roomID, $questionID);
        }
        elseif ($type = filter_input(INPUT_POST, "Answer")) {
            $attemptID = 
            $questionID = filter_input(INPUT_POST, "qid");
            $answer = filter_input(INPUT_POST, "aid");
            $result = answerQuestion($attemptID, $questionID, $answer);
            echo $result;
        }
    }
    elseif ($func = filter_input(INPUT_POST, "Room")) {
        if($type = filter_input(INPUT_POST, "update")) {
            //Unused
        }
        //Returns Room from given ID
        elseif ($type = filter_input(INPUT_POST, "getRoom")) {
            $roomID = filter_input(INPUT_POST, "roomID");
            $result = getRoom($roomID);
            echo $result;
        }
        //Returns Question from given ID
        elseif ($type = filter_input(INPUT_POST, "getQuest")) {
            $qid = filter_input(INPUT_POST, "qID");
            $result = getQuestion($qid);
            echo $result;
        }
    }
    else {
        echo "Failure";
    }
?>