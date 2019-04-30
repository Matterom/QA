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
        if ($statement = $MYSQLi->prepare('SELECT rosterName from rosters where rosterHostID = ? ORDER BY roster_name')){
            $statement->bind_param('s', $user_id);
            $statement->execute();
            $result = $statement->get_result();
        }
            
            $drop_options_string = "<option>Anonymous</option>";
            while ($row = $result->fetch_array(MYSQLI_NUM)) {
                foreach($row as $r){            
                    $drop_options_string .= '<option>';
                    $drop_options_string .= $r;
                    $drop_options_string .= '</option>';
                }
            }

            $result->free();
            $statement->close();
            $MYSQLi->close();
    ?>
        
        var roomsElement = document.getElementById("dash_rooms_button");
        roomsElement.className = "dash_form_text";
        roomsElement.innerHTML = 
            '<form action="../Room/" method="POST">' +
            'Roster: <select name="select_roster"><option value="choose one">Select a Roster: </option>' +
            '<?php echo($drop_options_string) ?>' +
            '</select><br><input type="submit" value="Start Room">' +
            '</form>';
        
        roomsElement.removeAttribute('onclick');
    }
    </script>

    <div class="dash_button">
        <span class="dash_button_text" id="dash_accounts_button" >Configure Account</span>
    </div>
    <div class="dash_button">
        <a href="../RosterConfig"><span class="dash_button_text">Configure Rosters</span></a>
    </div>
    <div class="dash_button">
        <span class="dash_button_text" id="dash_rooms_button" onclick="collectRoomInfo()">Start Classroom</span>
    </div>
    <div class="dash_button">
        <span class="dash_button_text">Quiz Reports</span>
    </div>
</main>
