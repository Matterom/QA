<?php 
    include "../view/header.php";
    include "../model/database.php";
    include "newRosterOrAttendee.php";
    $_POST = array();?>

<!-- PHP for populating roster data -->
<?php 
    $user_id = $_SESSION['id'];
    $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);
    if ($MYSQLi->connect_errno) {
        printf("Unable to connect to SQL database. Error #%d", $MYSQLi->connect_error);
        die('Failed To Connect, Terminating Script');
    }
    
    $roster_array = array();
    $roster_list = array();
    /*QUERY for filled rosters*/
    if ($statement = $MYSQLi->prepare('SELECT rosters.rosterName, attendees.attendeeID FROM attendees join rosters 
                                        WHERE rosters.rosterHostID = ? 
                                        AND attendees.rosterID = rosters.rosterID
                                        ORDER BY rosterName'))
    {
        $statement->bind_param('s', $user_id);
        $statement->execute();
        if($statement->errno){
            printf($statement->error);
        }
        $result = $statement->get_result();
    
        while($r=$result->fetch_assoc()) {
            if (array_key_exists($r['rosterName'], $roster_array)) {
                $roster_array[$r['rosterName']] .= $r['attendeeID']."<br>";
            }
            else {
                $roster_array[$r['rosterName']] = $r['attendeeID']."<br>";
                $roster_list[] = $r['rosterName'];
            }
        }
        $statement->close(); 
        $result->free();
    }
    /*QUERY for empty rosters*/
    if ($statement = $MYSQLi->prepare('SELECT rosterName FROM rosters 
                                        WHERE attendee_count= 0
                                        AND rosterHostID = ?')) 
    {
        $statement->bind_param('s', $user_id);
        $statement->execute();
        $result = $statement->get_result();
        
        
        while($r=$result->fetch_assoc()) {
            if (!array_key_exists($r['rosterName'], $roster_array)) {
                $roster_list[] = $r['rosterName'];
                $roster_array[$r['rosterName']] = "";
            }
        } 
    }
    ?>
<!-- end of roster list population code -->


<!-- MAIN PAGE SECTION -->
<main>
<h2> Add or Modify Rosters</h2>
    <body class="center-wrapper">
    <div class="roster_col" >
        <span id="rcol">
            <h3><u>Rosters</u></h3>
            <p style="font-size: 15px"><b>To create a roster:</b>Enter the name of the roster and click 'addRoster'.
                <b>To see attendees in roster:</b> Click on roster name. Enrolled attendees will appear.</p>
            <?php foreach($roster_list as $roster) {
                echo('<span class="roster_text" id="rost_');
                echo($roster);
                echo('" onclick="displayRoster(this)">');
                echo($roster);
                echo('</span>');
            }
            ?>
        <form action="#" method="POST">
            <input type="text" placeholder="New Roster?" name="rosterName">
            <input type="submit" value="addRoster" name="addRoster">
        </form>
        </span>
    </div>
    <div class="attendee_col">
        <h3><u>Attendee List</h3></u>
        <p style="font-size: 15px"><b>To add an attendee to roster:</b>
            1)Click on roster name.
            2)Type in students ID and press 'addAttendee'.
            3)Repeat for every student.</p>
        <?php foreach($roster_array as $key => $value) {
            echo('<span style="display:none" class="attendee_text" id="att_');
            echo($key);
            echo('">');
            echo($value);
            echo('</span>'); 
        } ?>
        <form action="#" method="POST">
            <input type="hidden" name="selected_roster" id="hidden_selected_roster" value="">
            <input type="text" name="new_attendeeID">
            <input type="submit" value="addAttendee" name="addAttendee">
        </form> 
    </div>
    <body>
<main>

<!-- displayRoster() is used to populate the list of students who are members of the selected roster -->
<script>
    var $currently_displayed_roster;
    function displayRoster(element) {
        if($currently_displayed_roster) {
            $currently_displayed_roster.style.display="none";
        }
        var $selected_roster = element.innerHTML; // String of currently highlighted roster
        $currently_displayed_roster = document.getElementById("att_" + $selected_roster);
        $currently_displayed_roster.style.display="block";
        document.getElementById("hidden_selected_roster").value = $selected_roster;
    }
</script>


<?php include "../view/footer.php" ?>
