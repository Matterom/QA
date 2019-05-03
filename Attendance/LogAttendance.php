<?php 
    #########################
    ### By Matthew Nelson ###
    #########################

    $result = "";
    #TODO Cleanup the error code 
    if($_SERVER["REQUEST_METHOD"] == "POST" && array_key_exists('markAttendance',$_POST)) {
        include_once './model/database.php';
        $MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);
        if($statement = $MYSQLi->prepare('INSERT IGNORE INTO AttendanceRecords(AttendeeID, RoomKey) Values (?, ?)')) {
            $attendeeID = filter_var($_POST['attendeeID'], FILTER_SANITIZE_NUMBER_INT);
            $roomKey = filter_var($_POST['roomKey'], FILTER_SANITIZE_STRING);
            $statement->bind_param('ds', $attendeeID, $roomKey);
            if(!$statement->execute()) {
                if(substr($statement->error,0,9)=='Duplicate') {
                    $result = "Successfully logged in";
                }
                else
                {
                    $result = '<font color="red">Incorrect RoomKey/Password<br>Please Try Again!</font>';
                }
            }
            else
            {
                $result = "Successfully logged in.";
            }
        }   
        else
        {
            $result = "Please Try Again";
        }
    }?>

    <form method="post" style="hidden" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
        RoomKey:<br><input type="text" name="roomKey"><br>
        ID Key:<br><input type="text" name="attendeeID"><br>
        <input type="submit" name = "markAttendance" class="raised" value="Enter Room"><br>
    </form><br>
    <?php echo $result;?>
