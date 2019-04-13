<?php
    include '../model/question_db.php';

    if($func = filter_input(INPUT_POST, "folder")){
        if ($type = filter_input(INPUT_POST, "folderN")) {
            $userID = filter_input(INPUT_POST, "user");
            $folderID = filter_input(INPUT_POST, "folderID");
            $folderName = $type;
            $folderDesc = filter_input(INPUT_POST, "alternative");
            $result = updateFolder($userID, $folderID, $folderName, $folderDesc);
            echo $userID." ".$folderID." ".$folderName." ".$folderDesc." Result: ".$result;
        }
        elseif ($type = filter_input(INPUT_POST, "folderD")) {
            $userID = filter_input(INPUT_POST, "user");
            $folderID = filter_input(INPUT_POST, "folderID");
            $folderName = filter_input(INPUT_POST, "alternative");
            $folderDesc = $type;
            $result = updateFolder($userID, $folderID, $folderName, $folderDesc);
            echo $userID." ".$folderID." ".$folderName." ".$folderDesc." Result: ".$result;
        }
        elseif ($user = filter_input(INPUT_POST, "newFold")) {
            $userID = $user;
            $folderName = filter_input(INPUT_POST, "fname");
            $folderDesc = filter_input(INPUT_POST, "fdesc");
            $result = makeFolder($userID, $folderName, $folderDesc);
            echo $result;        
        }
        elseif ($target = filter_input(INPUT_POST, "delFold")) {
            $userID = filter_input(INPUT_POST, "user");
            $folderID = $target;
            $result = deleteFolder($userID, $folderID);
        }
        else {
            //Throw Error, this shoudn't happen
            echo "This Shoudn't Happen";
        }
    }
    elseif ($func = filter_input(INPUT_POST, "question")) {

    }
    else {
        //Throw Error, This shoudn't run if that variable didn't fill
    }

?>