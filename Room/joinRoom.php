<?php
    if($_SERVER['REQUEST_METHOD']=='POST' && array_key_exists('joinRoom',$_POST))
    {
        $attendeeID = filter_input(INPUT_POST, 'joinroom_idKey', FILTER_SANITIZE_NUMBER_INT);
        $roomKey = filter_input(INPUT_POST, 'joinroom_roomKey', FILTER_SANITIZE_STRING);
        include '../model/database.php';
        $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);

        if($stmt = $MYSQLi->prepare('INSERT INTO quizattempts (roomKey, attendeeID, quizID)
            VALUES (?, ?, NULL)'))
        {
            $stmt->bind_param('ss', $roomKey, $attendeeID);
            $stmt->execute();
            $attemptID = $MYSQLi->insert_id;
        }
        if($stmt = $MYSQLi->prepare('SELECT quizID FROM quizattempts WHERE attemptID = ?'))
        {
            $stmt->bind_param('s', $attemptID);
            $stmt->execute();
            $quizID = $stmt->get_result()->fetch_assoc()['quizID'];
            $_SESSION['quizID'] = $quizID;
        }
        if($stmt = $MYSQL->prepare('SELECT roomID FROM rooms WHERE roomKey = ?'))
        {
            $stmt->bind_param('s', $roomKey);
            $stmt->execute();
            $roomID = $stmt->get_result->fetch_assoc()['roomID'];
            $_SESSION['roomID'] = $roomID;
        }
        $_SESSION['attemptID'] = $attemptID;
        $_SESSION['attendeeID'] = $attendeeID;
        $_SESSION['roomKey'] = $roomKey;
        header("Location: index.php");
    }
    else
    {
        ?>
        <form action="Room/joinRoom.php" method="POST">
        RoomKey: <input type="text" name="joinroom_roomKey" value=""><br>
        ID Key: <input type="text" name="joinroom_idKey" value=""><br>
        <input type="submit" name="joinRoom" class = "raised" value="Join Quiz">
        </form>
<?php }?>
