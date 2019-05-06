<!-- ********** newRosterorAttendee.php **********
     Purpose:   Processes the insertion of new roster
                or attendee data into the MySQL DB.
     Programmer: Sean Anderson
-->
<?php 
    if($_SERVER['REQUEST_METHOD'] == "POST"){
        
        /*** ADD A NEW ROSTER 
         *  insert into rosters (user_id, rosterID)
         */
        if(!empty($_POST['addRoster']))
            {   
            $user_id = $_SESSION['id'];
            $rosterName = filter_var($_POST['rosterName'], FILTER_SANITIZE_STRING);
            $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);
            if ($MYSQLi->connect_errno) {
                printf("Unable to connect to SQL database. Error #%d", $MYSQLi->connect_error);
                die('Failed To Connect, Terminating Script');
            }
            if ($statement = $MYSQLi->prepare('INSERT IGNORE INTO rosters(rosterHostID, rosterName)
                                                VALUES (?, ?)')) {
                $statement->bind_param("ss", $user_id, $rosterName);
                $statement->execute();
                $statement->close();
            }
        }
        /*** ADD A NEW ATTENDEE TO THE SELECTED ROSTER
         *  if selected roster is null, do nothing
         *  else, find rosterID using rosterName
         *  insert into attendees (attendeeID, rosterID)
         */
        elseif(!empty($_POST['addAttendee'] && $_POST['selected_roster']!== ""))
        {
            $user_id = $_SESSION['id'];
            $attendeeID = filter_var($_POST['new_attendeeID'], FILTER_SANITIZE_NUMBER_INT);
            $rosterName = filter_var($_POST['selected_roster'],FILTER_SANITIZE_STRING);
            $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);
            
            if ($MYSQLi->connect_errno) {
                printf("Unable to connect to SQL database. Error #%d", $MYSQLi->connect_error);
                die('Failed To Connect, Terminating Script');
            }
            
            if($statement = $MYSQLi->prepare('SELECT rosterID FROM rosters 
                                            WHERE rosterName=? 
                                            AND rosterHostID = ?'))
            {
                
                $statement->bind_param("ss", $rosterName, $user_id);
                $statement->execute();
                $roster_row = $statement->get_result()->fetch_assoc();
                $rosterID = $roster_row['rosterID'];
                
                if($statement = $MYSQLi->prepare('INSERT IGNORE INTO attendees(attendeeID, rosterID)
                                                    VALUES (?, ?)'))
                {
                    $statement->bind_param("ss", $attendeeID, $rosterID);
                    $statement->execute();
                }
            }
        }
    }
?>
