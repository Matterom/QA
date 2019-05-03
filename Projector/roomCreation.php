<!-- ******************** RoomCreation.php ********************
*   *
*  Purpose: Takes POST variables received from "Start Classroom"
*           form on the user dashboard and converts them to 
*           session variables for use by the room host. Then inserts
*           a new room row into rooms and adds the roomID to session.
*  Parameters:  id - PK of user (accounts.id)
*               rosterName - name of roster (may be anonymous)
*               qSetID - PK of questionset (questionsets.qSetID) 
*  Function: Saves the following variables into $_SESSION
        'roomID'        from $MYSQLi->insert_id
        'roomKey'       from SELECT WHERE roomID = $roomID  
        'rosterName'    from $_POST
        'rosterID'      from SELECT where rosterName = $rosterName
        'qSetName'      from $_POST
        'qSetID'        from SELECT WHERE qSetName = $qSetName
        'qSetIDList'    from getQuestionIDList($qSetID)
        'timer'         from $_POST

*/ -->

<?php 
    session_start();
    // Initialize database connection variables
    include_once '../model/database.php';
    include_once '../model/room_db.php';

    //Initializes connection to database
    $MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);
    if ($MYSQLi->connect_errno) {
        printf("Connection Failed: \n", $MYSQLi->connect_error);
        die('Failed To Connect, Terminating Script');
    }

    if($_SERVER['REQUEST_METHOD'] == 'POST') 
    {
        global $MYSQLi;

        // Sanitize all inputs
        $rosterName = filter_input(INPUT_POST, 'rosterName', FILTER_SANITIZE_STRING);
        $qSetName = filter_input(INPUT_POST, 'qSetName', FILTER_SANITIZE_STRING);
        $timer = filter_input(INPUT_POST, 'timer', FILTER_SANITIZE_NUMBER_INT);
        $userID = $_SESSION['id'];
        if($stmt = $MYSQLi->prepare('SELECT qSetID from questionsets WHERE qSetName = ?'))
        {
            $stmt->bind_param('s', $qSetName);
            $stmt->execute();
            $qSetID = $stmt->get_result()->fetch_assoc()['qSetID'];
        }

        // If rosterName is anonymous
        if ($rosterName == "Anonymous")
        {
            if($stmt = $MYSQLi->prepare('INSERT INTO rooms (ownerID, qSetID, timer, rosterID, roomKey)
                VALUES (?, ?, ?, NULL, NULL)'))
            {
                $stmt->bind_param('sss', $userID, $qSetID, $timer);
                $stmt->execute();
                $roomID = $MYSQLi->insert_id;
            }
        }
        else // If rosterName not anonymous
        {
            if($stmt = $MYSQLi->prepare('SELECT rosterID, attendee_count from rosters WHERE rosterName = ?'))
            {
                $stmt->bind_param('s', $rosterName);
                $stmt->execute();
                $result = $stmt->get_result()->fetch_assoc();
                $rosterID = $result['rosterID'];
                $_SESSION['attendeeCount'] = $result['attendee_count'];
            }
            if($stmt = $MYSQLi->prepare('INSERT INTO rooms (ownerID, qSetID, timer, rosterID, roomKey)
                VALUES (?, ?, ?, ?, NULL)'))
            {
                echo $userID." ".$qSetID." ".$timer." ".$rosterID;

                $stmt->bind_param('ssss', $userID, $qSetID, $timer, $rosterID);
                $stmt->execute();
                $roomID = $MYSQLi->insert_id;
                echo $roomID;
            }
            else {
                echo "Failure";
            }
        }
        if ($stmt = $MYSQLi->prepare('SELECT roomKey FROM rooms WHERE roomID = ?'))
        {
            $stmt->bind_param('s', $roomID);
            $stmt->execute();
            $roomKey = $stmt->get_result()->fetch_assoc()['roomKey'];
        }
        echo $roomKey;
        // Set session variables from post
        $_SESSION['roomID'] = $roomID;
        $_SESSION['roomKey'] = $roomKey;
        $_SESSION['qSetID'] = $qSetID;
        $_SESSION['qSetName'] = $qSetName;
        $_SESSION['qSetIDList'] = getQuestionIDList($qSetID);
        $_SESSION['rosterID'] = $rosterID;
        $_SESSION['rosterName'] = $rosterName;
        $_SESSION['timer'] = $timer;

    }
    header('Location: index.php');
?>
