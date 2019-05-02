<main>
    <?php $user_id = $_SESSION['id']; ?>
    <script>
        function collectRoomInfo() {

        <?php 
        include_once '../model/database.php';
        $MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);

        if ($MYSQLi->connect_errno) {
            printf("Connection Failed: \n", $MYSQLi->connect_error);
            die('Failed To Connect, Terminating Script');
        }
        if ($statement = $MYSQLi->prepare('SELECT rosterName from rosters where rosterHostID = ? ORDER BY rosterName'))
        {
            $statement->bind_param('s', $user_id);
            $statement->execute();
            $result = $statement->get_result();
        }
            
            $drop_options_string = "<option>Select a Room</option><option>Anonymous</option>";
            while ($row = $result->fetch_array(MYSQLI_NUM)) {
                foreach($row as $r){            
                    $drop_options_string .= '<option>';
                    $drop_options_string .= $r;
                    $drop_options_string .= '</option>';
                }
            }

            $result->free();
            $statement->close();
            
            $drop_qSet_string = "<option>Select a Set</option>";
            if($qSetQuery = $MYSQLi->prepare('SELECT qSetID, qSetName FROM questionsets JOIN questionfolders
                                                WHERE questionsets.folderID = questionfolders.folderID
                                                AND ownerID = ? ORDER BY qSetName'))
            {
                $qSetQuery->bind_param('s', $user_id);
                $qSetQuery->execute();
                $qSetResults = $qSetQuery->get_result();
                /*$qSetRow = $qSetResults->fetch_assoc();
                $drop_qSet_string .= $qSetRow['qSetName'];
                $drop_qSet_string .= $qSetRow['qSetID'];
                */
                while($qSetRow = $qSetResults->fetch_assoc())
                {
                    $drop_qSet_string .= '<option id="';
                    $drop_qSet_string .= $qSetRow['qSetID'];
                    $drop_qSet_string .= '">'.$qSetRow['qSetName'];
                    $drop_qSet_string .= '</option>';
                }
            }

            
            $MYSQLi->close();
    ?>
        
        var roomsElement = document.getElementById("dash_rooms_button");
        roomsElement.className = "dash_form_text";
        roomsElement.innerHTML = 
            '<form action="../Projector/roomCreation.php" method="POST">' +
            'Roster: <select name="rosterName">' +
            '<?php echo($drop_options_string) ?>' +
            '</select><br>' +
            'Question Set: <select name="qSetName"><?php echo($drop_qSet_string) ?></select><br>' +
            'Time Per Question in Seconds: <input type="number" name="timer" value="60" min="0" max="999" maxlength="3"><br>' + 
            '<input type="submit" value="Start Room">' +
            '</form>';
        
        roomsElement.removeAttribute('onclick');
    }
    </script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <div class="dash_button">
        <a href="../Account"><span class="dash_button_text" id="dash_accounts_button" ><i class="fas fa-user-cog"></i> Configure Account</span></a>
    </div>
    <div class="dash_button">
        <a href="../RosterConfig"><span class="dash_button_text"><i class="fas fa-address-book"></i> Configure Rosters</span></a>
    </div>
    <div class="dash_button">
        <span class="dash_button_text" id="dash_rooms_button" onclick="collectRoomInfo()"><i class="fas fa-school"></i> Start Classroom</span>
    </div>
    <div class="dash_button">
        <a href="../RoomSetup"><span class="dash_button_text"><i class="fas fa-folder-plus"></i> Quiz Setup</span></a>
    </div>
</main>
