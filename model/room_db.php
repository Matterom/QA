<?php
include_once 'database.php';
#functions to pull the crap

//Initializes connection to database
$MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);
if ($MYSQLi->connect_errno) {
    printf("Connection Failed: \n", $MYSQLi->connect_error);
    die('Failed To Connect, Terminating Script');
}

/*** Get QuestionID List ***
 *  Purpose: Used to create a list of all IDs for a given quiz.
 *  Parameters: $qSetID - ID of the Question Set
 *  Returns: $questionList - An array of all question IDs for a given questionSet.
 */
function getQuestionIDList($qSetID) {
    global $MYSQLi;
    $qsetID = filter_var($qSetID, FILTER_SANITIZE_NUMBER_INT);
    if($stmt = $MYSQLi->prepare('SELECT qID FROM questionsetpairings 
        WHERE questionsetpairings.qSetID = ?'))
    {
        $stmt->bind_param('s', $qSetID);
        $stmt->execute();
        $result = $stmt->get_result();
        $questionIDList = [];
        while ($row = $result->fetch_row())
        {
            $questionIDList[] = $row[0];
        }
        return $questionIDList;
    }
    else
    {
        return "Error";
    }

}
/*** Get User Counts ***
 *  Purpose: Gets the count of connections to a room.
 *  Parameters: $roomID - The Primary Key associated with the room.
 *  Returns:    $userCount - The count of students in the room.
 */
function getCurrentUserCount($roomID) {
    global $MYSQLi;
    if ($statement = $MYSQLi->prepare('SELECT active_connections FROM rooms
                                    WHERE roomID = ?;'))
    {
        $statement->bind_param('s', $roomID);
        $success = $statement->execute();
        $result = $statement->get_result()->fetch_assoc();
        $userCount = $result['active_connections'];
        
        # UNCOMMENT THE FOLLOWING FOR PRODUCTION
        #return $userCount;

        #TODO
        #THE FOLLOWING USED FOR TESTING. COMMENT OR DELETE WHEN PUT INTO PRODUCTION
        $resultsArray = array();
        $resultsArray['success'] = $success;
        $resultsArray['userCount'] = $userCount;
        return json_encode($resultsArray);
    }
    else
    {
        return -1;
    }
}

function getTotalUserCount($roomID) {
    global $MYSQLi;
    if ($statement = $MYSQLi->prepare('SELECT attendee_count FROM rosters JOIN rooms
        WHERE rooms.roomID = ? AND rosters.rosterID = rooms.rosterID;'))
    {
        $statement->bind_param('s', $roomID);
        $statement->execute();
        $attendeeCount = $statement->get_result()->fetch_assoc()['attendeeCount'];
        return $attendeeCount;
    }
    else
    {
        return -1;
    }
}

/*** NewConnection ***
 *      Purpose: Used to create a new attendee connection to a room.
 *      Parameters: $roomKey - The key used to access the Room
 *                  $attendeeID - The unique identifier of the room attendee
 *      Returns:    $attemptID - The newly created ID for the attempt.
 *                  OR -1 upon error.
 */ 
//QuestionSetID is automatically inserted by SQL trigger
function newConnection($roomKey, $attendeeID) {
    global $MYSQLi;
    $roomKey = filter_var($roomKey, FILTER_SANITIZE_STRING);
    $attendeeID = filter_var($attendeeID, FILTER_SANITIZE_NUMBER_INT);
    if($stmt = $MYSQLi->prepare('INSERT INTO quizattempts (roomKey, attendeeID, quizID)
                                    VALUES (?, ?, NULL)'))
    {
        $stmt->bind_param('ss', $roomKey, $attendeeID);
        $stmt->execute();
        $attemptID = $MYSQLi->insert_id;
        return $attemptID;
    }
    else
    {
        return -1;
    }

}

/* Used for Question Timer Feature, if we have time to include it
function getTimeRemaining ($roomID) {

}

function setTimeRemaining($roomID) {

}*/

/*** Answer Question ***
 *  Purpose: Function to allow attendee to submit an answer to a question
 *  Parameters: $attemptID - PK for the QuizAttempt. Generated by newConnection().
 *              $questionID - ID for the answered question
 *              $answerID - JSON file with the selected answers.
 */
function answerQuestion($attemptID, $questionID, $answerID) {
    global $MYSQLi;
    $attemptID = filter_var($attemptID, FILTER_SANITIZE_NUMBER_INT);
    $questionID = filter_var($questionID, FILTER_SANITIZE_NUMBER_INT);
    if($stmt = $MYSQLi->prepare('INSERT INTO answersubmissions (quizAttemptID, questionID, answer_choice) VALUES (?, ?, ?) 
                                    ON DUPLICATE KEY UPDATE quizAttemptID = ?, questionID = ?, answer_choice = ?'))
    {
        $stmt->bind_param('sss', $attemptID, $questionID, $answerID);
        $result = $stmt->execute();
        return $result;
    }
    else {
        return 0;
    }
}

function getRoom($roomID) {
    global $MYSQLi;
    if ($statement = $MYSQLi->prepare("SELECT * FROM rooms WHERE roomID = ?")) {
        $statement->bind_param('s', $roomID);
        $statement->execute();
        $return = $statement->get_result();
        $statement->close();
        return json_encode($return->fetch_assoc());
    }
}

function setNextQuestion($roomID, $questionID) {
    global $MYSQLi;
    if($stmt = $MYSQLi->prepare('UPDATE rooms SET current_QuestionID = ? WHERE roomID = ?'))
    {
        $stmt->bind_param('ss', $questionID, $roomID);
        $stmt->execute();
        if($MYSQLi->affected_rows >0) {
            return 1;
        }
    }
    return 0;
}



?>
