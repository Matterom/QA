<!-- ******************** RoomCreation.php ********************
*   *
*  Purpose: Takes POST variables received from "Start Classroom"
*           form on the user dashboard and converts them to 
*           session variables for use by the room host. Then inserts
*           a new room row into rooms and adds the roomID to session.
*  Parameters:  id - PK of user (accounts.id)
*               rosterName - name of roster (may be anonymous)
*               qSetID - PK of questionset (questionsets.qSetID) 
*/ -->

<?php 
    session_start();
    // Initialize database connection variables
    include_once '../model/database.php';
    include_once '../model/room_db.php';
    $_SESSION['thisSucks'] = False;

    //Initializes connection to database
    $MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);
    if ($MYSQLi->connect_errno) {
        printf("Connection Failed: \n", $MYSQLi->connect_error);
        die('Failed To Connect, Terminating Script');
    }

    if($_SERVER['REQUEST_METHOD'] == 'POST') 
    {
        global $MYSQLi;

        // Set local variables from filtered post variables
        $rosterName = filter_input(INPUT_POST, 'rosterName', FILTER_SANITIZE_STRING);
        $qSetName = filter_input(INPUT_POST, 'qSetName', FILTER_SANITIZE_STRING);
        $userID = $_SESSION['id'];
        // If rosterName is anonymous
        if($stmt = $MYSQLi->prepare('SELECT qSetID from questionsets WHERE qSetName = ?'))
        {
            $stmt->bind_param('s', $qSetName);
            $stmt->execute();
            $qSetID = $stmt->get_result()->fetch_assoc()['qSetID'];
            $_SESSION['qSetID'] = $qSetID;
        }
        if ($rosterName == "Anonymous")
        {
            if($stmt = $MYSQLi->prepare('INSERT INTO rooms (ownerID, qSetID, rosterID, roomKey)
                VALUES (?, ?, NULL, NULL)'))
            {
                $stmt->bind_param('ss', $userID, $qSetID);
                $stmt->execute();
                $roomID = $MYSQLi->insert_id;
            }
        }
        else // If rosterName not anonymous
        {
            if($stmt = $MYSQLi->prepare('SELECT rosterID from rosters WHERE rosterName = ?'))
            {
                $stmt->bind_param('s', $rosterName);
                $stmt->execute();
                $rosterID = $stmt->get_result()->fetch_assoc()['rosterName'];
                
            }

            if($stmt = $MYSQLi->prepare('INSERT INTO rooms (ownerID, qSetID, rosterID, roomKey)
                VALUES (?, ?, ?, NULL)'))
            {
                $stmt->bind_param('sss', $userID, $qSetID, $rosterID);
                $stmt->execute();
                $roomID = $MYSQLi->insert_id;
            }
        }
        if ($stmt->prepare('SELECT roomKey FROM rooms WHERE roomID = ?'))
        {
            $stmt->bind_param('s', $roomID);
            $stmt->execute();
            $roomKey = $stmt->get_result()->fetch_assoc()['roomKey'];
        }

        // Set session variables from post
        $_SESSION['roomID'] = $roomID;
        $_SESSION['roomKey'] = $roomKey;
        $_SESSION['qSetID'] = $qSetID;
        $_SESSION['qSetName'] = $qSetName;
        $_SESSION['qSetIDList'] = getQuestionIDList($qSetID);
        $_SESSION['rosterID'] = $rosterID;
    }
    header('Location: index.php');
?>
