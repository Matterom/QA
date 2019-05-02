<?php include '../view/header.php';?>
<?php include "../model/database.php" ?>
<!--This is where successful login attempts are sent, This is the configuration hub for  rooms owned by the user and the account-->
<main>
<?php include "updateAccount.php" ?>
<?php 
    $user_id = $_SESSION['id'];
    $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);
    if ($MYSQLi->connect_errno) {
        printf("Unable to connect to SQL database. Error #%d", $MYSQLi->connect_error);
        die('Failed To Connect, Terminating Script');
    }
    if($statement = $MYSQLi->prepare('SELECT * from accounts where id = ?')) {
        $statement->bind_param('s', $user_id);
        $statement->execute();
        $result = $statement->get_result();
        $account = $result->fetch_assoc();
    }
?>
    <div class="updateContainer">
    <form action="#" method="POST">
        <div class="change_un_email">
        <h4>Change Username / Email</h4><br>
        Username:<input type="text" name = "username" value="<?php echo($account['username']); ?>" maxlength = "62"><br>
        Email: <input type="text" name = "email" value= "<?php echo($account['email']);?>" maxlength="62"><br>
        </div>
        <div class="change_pw">
        <h4>Change Password</h4><br>
        Current Password: <input type="text" name="curr_pw"><br>
        New Password:   <input type="text" name="new_pw_1"><br>
        Reenter Password: <input type="text" name="new_pw_2"><br>
        </div>
        <br>
        <br>
        <div class="submit_container">
        <input type="submit">
        </div>
          
    </form>
    </div>
</main>
<?php include '../view/footer.php';?>
