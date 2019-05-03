<?php
    ##############################
    ### Page By Matthew Nelson ###
    ##############################
    include '../model/question_db.php';
    include '../model/classes.php';

    //Directs inputs based on the initial Key
    if($func = filter_input(INPUT_POST, "folder")){
        if ($type = filter_input(INPUT_POST, "update")) {
            $userID = filter_input(INPUT_POST, "user");
            $folderID = filter_input(INPUT_POST, "folderID");
            $folderName = filter_input(INPUT_POST, "name");
            $folderDesc = filter_input(INPUT_POST, "desc");
            $result = updateFolder($userID, $folderID, $folderName, $folderDesc);
            echo $result;
        }
        elseif ($user = filter_input(INPUT_POST, "newFold")) {
            $userID = $user;
            $folderName = filter_input(INPUT_POST, "fname");
            $folderDesc = filter_input(INPUT_POST, "fdesc");
            $result = makeFolder($userID, $folderName, $folderDesc);
            echo $result;        
        }
        elseif ($target = filter_input(INPUT_POST, "delete")) {
            $userID = filter_input(INPUT_POST, "user");
            $folderID = filter_input(INPUT_POST, "target");
            $result = deleteFolder($userID, $folderID);
        }
        else {
            //Throw Error, this shoudn't happen
            echo "This Shoudn't Happen";
        }
    }
    elseif ($func = filter_input(INPUT_POST, "question")) {
        if ($type = filter_input(INPUT_POST, "new")) {
            $folderID = filter_input(INPUT_POST, "location");
            $question = filter_input(INPUT_POST, "data");
            $result = makeQuestion($folderID, $question);
            echo $result;
        }
        elseif ($type = filter_input(INPUT_POST, "query")) {
            $folderID = $func;
            $result = getQuestions($folderID);
            echo json_encode($result);
        }
        elseif ($type = filter_input(INPUT_POST, "update")) {
            $target = filter_input(INPUT_POST, "target");
            $data = filter_input(INPUT_POST, "data");
            $folderID = filter_input(INPUT_POST, "folderID");
            $result = updateQuestion($target, $data, $folderID);
            echo $result;

        }
        elseif ($type = filter_input(INPUT_POST, "delete")) {
            $question = filter_input(INPUT_POST, "target");
            $folder = filter_input(INPUT_POST, "folderID");
            $result = deleteQuestion($folder, $question);
            echo $result;
        }
        else {
            echo "this shoudn't happen";
        }
    }
    elseif ($func = filter_input(INPUT_POST, "set")) {
        if ($type = filter_input(INPUT_POST, "query")) {
            $folderID = filter_input(INPUT_POST, "location");
            $user = filter_input(INPUT_POST, "user");
            $result = getQSets($folderID);
            echo json_encode($result);
        }
        elseif ($type = filter_input(INPUT_POST, "update")) {
            $setName = filter_input(INPUT_POST, "name");
            $setDesc = filter_input(INPUT_POST, "desc");
            $setID = filter_input(INPUT_POST, "setID");
            $folder = filter_input(INPUT_POST, "folderID");
            $result = updateSet($folder, $setID, $setName, $setDesc);
            echo $result;
         }
        elseif ($type = filter_input(INPUT_POST, "new")) {
            $setName = filter_input(INPUT_POST, "name");
            $setDesc = filter_input(INPUT_POST, "desc");
            $folder = filter_input(INPUT_POST, "folderID");
            $result = makeSet($folder, $setName, $setDesc);
            echo $result;
        }
        elseif ($type = filter_input(INPUT_POST, "delete")) {
            $setID = filter_input(INPUT_POST, "setID");
            $folder = filter_input(INPUT_POST, "folderID");
            $result = deleteSet($setID, $folder);
            echo $result;
        }
        elseif ($type = filter_input(INPUT_POST, "add")) {
            $questionID = filter_input(INPUT_POST, "qID");
            $setID = filter_input(INPUT_POST, "setID");
            $result = addQToSet($questionID, $setID);
            echo $result;
        }
        elseif ($type = filter_input(INPUT_POST, "sub")) {
            $questionID = filter_input(INPUT_POST, "qID");
            $setID = filter_input(INPUT_POST, "setID");
            $result = subQFromSet($questionID, $setID);
            echo $result;
        }
        elseif ($type = filter_input(INPUT_POST, "get")) {
            $setID = filter_input(INPUT_POST, "setID");
            $result = getQuestionsInSet($setID);
            echo json_encode($result);
        }
    }
    else {
        //Throw Error, This shoudn't run if that variable didn't fill
    }

?>
