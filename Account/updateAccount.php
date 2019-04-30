<?php 
    if ($_SERVER["REQUEST_METHOD"] == "POST")
    {
        $user_id = $_SESSION['id'];
        $MYSQLi = new mysqli(HOST, USER, PASSWORD, DATABASE);
        if ($MYSQLi->connect_errno) {
            printf("Unable to connect to SQL database. Error #%d", $MYSQLi->connect_error);
            die('Failed To Connect, Terminating Script');
        }
        if("" !== $_POST['username'])
        {
            #update password section
            if (!empty($_POST['curr_pw']) && !empty($_POST['new_pw_1']) && !empty($_POST['new_pw_2']) 
                    && ($_POST['new_pw_1'] == $_POST['new_pw_2'])) 
            {
                if($statement = $MYSQLi->prepare('UPDATE accounts set password = ? 
                                                    WHERE id = ? AND password = ?')) 
                {
                    $new_password = filter_var(md5($_POST['new_pw_1']), FILTER_SANITIZE_STRIPPED);
                    $old_password = md5($_POST['curr_pw']);
                    $statement->bind_param('sss', $new_password, $user_id, $old_password);
                    $statement->execute();
                }
            }
            else # update username/email only
            {   
                if($statement = $MYSQLi->prepare('UPDATE accounts SET username= ?, email = ?
                                                    WHERE id = ?')) {
                    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
                    $username = filter_var($_POST['username'], FILTER_SANITIZE_STRING);
                    $statement->bind_param('sss', $username, $email, $user_id);
                    $statement->execute();
                }
                else
                {
                    printf("Username field can not be left blank. Please try again.");
                }
            }
        }
    }
?>
