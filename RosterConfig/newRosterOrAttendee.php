<?php 
    if($_SERVER['REQUEST_METHOD'] == "POST"){
        
        /*** ADD A NEW ROSTER 
         *  insert into rosters (user_id, roster_id)
         */
        if(!empty($_POST['addRoster']))
            {    
            $user_id = $_SESSION['id'];
            $roster_name = filter_var($_POST['roster_name'], FILTER_SANITIZE_STRING);
            $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);
            if ($MYSQLi->connect_errno) {
                printf("Unable to connect to SQL database. Error #%d", $MYSQLi->connect_error);
                die('Failed To Connect, Terminating Script');
            }
            if ($statement = $MYSQLi->prepare('INSERT IGNORE INTO rosters(roster_host_id, roster_name)
                                                VALUES (?, ?)')) {
                $statement->bind_param("ss", $user_id, $roster_name);
                $statement->execute();
                $statement->close();
            }
        }
        /*** ADD A NEW ATTENDEE TO THE SELECTED ROSTER
         *  if selected roster is null, do nothing
         *  else, find roster_id using roster_name
         *  insert into attendees (attendee_id, roster_id)
         */
        elseif(!empty($_POST['addAttendee'] && $_POST['selected_roster']!== ""))
        {
            $user_id = $_SESSION['id'];
            $attendee_id = filter_var($_POST['new_attendee_id'], FILTER_SANITIZE_NUMBER_INT);
            $roster_name = filter_var($_POST['selected_roster'],FILTER_SANITIZE_STRING);
            $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);
            
            if ($MYSQLi->connect_errno) {
                printf("Unable to connect to SQL database. Error #%d", $MYSQLi->connect_error);
                die('Failed To Connect, Terminating Script');
            }
            
            if($statement = $MYSQLi->prepare('SELECT roster_id FROM rosters 
                                            WHERE roster_name=? 
                                            AND roster_host_id = ?'))
            {
                
                $statement->bind_param("ss", $roster_name, $user_id);
                $statement->execute();
                $roster_row = $statement->get_result()->fetch_assoc();
                $roster_id = $roster_row['roster_id'];
                
                if($statement = $MYSQLi->prepare('INSERT IGNORE INTO attendees(attendee_id, roster_id)
                                                    VALUES (?, ?)'))
                {
                    $statement->bind_param("ss", $attendee_id, $roster_id);
                    $statement->execute();
                }
            }
        }
    }
?>
