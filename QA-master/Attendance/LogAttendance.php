<?php 

    $result = "";
    #TODO Cleanup the error code 
    if($_SERVER["REQUEST_METHOD"] == "POST") {
        include_once 'psl-config.php';
        $MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);
        if($statement = $MYSQLi->prepare('INSERT INTO AttendanceRecords Values (?, ?)')) {
            $attendee_id = filter_var($_POST['attendee_id'], FILTER_SANITIZE_NUMBER_INT);
            $course_key = filter_var($_POST['course_key'], FILTER_SANITIZE_STRING);
            $statement->bind_param('ds', $attendee_id, $course_key);
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
            Account ID: <input type="number" name="attendee_id"><br>
            Course ID: <input type="text" name="course_key"><br>
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
