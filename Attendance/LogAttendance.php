<?php 

    $result = "";
    #TODO Cleanup the error code 
    if($_SERVER["REQUEST_METHOD"] == "POST") {
        include_once '../model/database.php';
        $MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);
        if($statement = $MYSQLi->prepare('INSERT IGNORE INTO AttendanceRecords Values (?, ?)')) {
            $attendeeID = filter_var($_POST['attendeeID'], FILTER_SANITIZE_NUMBER_INT);
            $roomKey = filter_var($_POST['roomKey'], FILTER_SANITIZE_STRING);
            $statement->bind_param('ds', $attendeeID, $roomKey);
            if(!$statement->execute()) {
                if(substr($statement->error,0,9)=='Duplicate') {
                    $result = "Successfully logged in";
                }
                else if ($statement->affected_rows >0) {
                    $result = "Successfully logged in.";
                }
            }
            else {
                printf("<h2>Login Error: Please re-enter your information.</h2>");
            }
            $statement->close();
        }

        
    }
    else {
        ?>
        <form method="post" style="hidden" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
            RoomKey: <br><input type="text" name="roomKey"><br>
            ID Key: <input type="text" name="attendeeID"><br>
            <input type="submit"><br>
        </form>
        <?php if (isset($result) && $result!== "") echo $result ?>
        <?php
    }
    

    function test_input($data) {
        $data = trim($data);
        $data = stripslashes($data);
        $data = htmlspecialchars($data);
        return $data;
    }


?>
