<?php
    session_start();
    include_once 'psl-config.php';
    #Initialize login database connection from configuration
    $MYSQLi = new mysqli(HOST,USER,PASSWORD,DATABASE);

    if ($MYSQLi->connect_errno) {
        printf("Connection Failed: \n", $MYSQLi->connect_error);
        die('Failed To Connect, Terminating Script');
    }

    if ( !isset($_POST['uname'], $_POST['psw'])){
        # No Reason for this script to run
        die('No Username or Password'.$_POST['uname'].$_POST['psw']);
    }
    #if register flag enabled, attempt to parse registration form
    if($_POST['register'] == "true"){
        if($statement = $MYSQLi->prepare('SELECT email, username FROM accounts WHERE email = ? OR username = ?')) {
            $statement->bind_param('ss', $_POST['email'], $_POST['uname']);
            $statement->execute();
            $statement->store_result();
            #check row count, if gt than 0, match found and deny registration with result, Else continue
            if($statement-> num_rows > 0) {

            }
            else {
                #Ensure all variables are valid, scrub database entries.
                if ($_POST['uname'] !== NULL || $_POST['email'] !== NULL || $_POST['psw'] !== NULL ) {
                    #TODO Rework into password hash, proof of concept
                    if($statement = $MYSQLi->prepare('INSERT into accounts (username, email, password) VALUES (?, ?, ?)' )) {
                        #bind and filter username, email and password
                        $uName = filter_var($_POST['uname'], FILTER_SANITIZE_STRING);
                        $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
                        $psw = filter_var($_POST['psw'], FILTER_SANITIZE_STRING);
                        $statement->bind_param('sss', $uName, $email, $psw);
                        $statement->execute();
                        $statement->close();
                        #Redirect to success screen if everything good
                        header("Location: ../index.php");
                    }
                    else {
                        #TODO Query failed, Throw error
                    }
                }
                else {
                    #TODO Evaluate missing data, Throw error page
                }
            }
        }
    }
    else {
        #TODO session id against login attempts
        #If login attempts gt 5 or last attempt 15m ago, block attempt with a timer.
        if (true) {
            #TODO Purge login attempts for session
            if($statement = $MYSQLi->prepare('SELECT id, password FROM accounts WHERE username = ?')){
                $statement->bind_param('s', $_POST['uname']);
                $statement->execute();
                $statement->store_result();
                if ($statement->num_rows > 0) {
                    $statement->bind_result($id, $password);
                    $statement->fetch();

                    if(password_verify($_POST['psw'], $password)) {
                        
                        session_regenerate_id();
                        $_SESSION['loggedin'] = 'true';
                        $_SESSION['name'] = $_POST['uname'];
                        $_SESSION['id'] = $id;
                        echo 'Login Successful';
                        header("Location: ../index.php");
                    }
                    else if ($_POST['psw'] == $password) {
                        #Remove when encryption enabled
                        session_regenerate_id();
                        $_SESSION['loggedin'] = 'true';
                        $_SESSION['name'] = $_POST['uname'];
                        $_SESSION['id'] = $id;
                        echo 'Login Successful';
                        header("Location: ../index.php");
                    }
                    else{
                        echo 'Incorrect Login Information ID:PASSWORD(REMOVE ID BIT ON RELEASE)';
                        echo $_POST['uname']." ".$_POST['psw'];
                        #trigger login attempt strike
                    }
                }
                else {
                    echo 'Incorrect Login Information ID:USER(REMOVE ID BIT ON RELEASE)';
                    echo $_POST['uname']." ".$_POST['psw'];
                    echo "info output:".$MYSQLi->info;
                    #trigger login attempt strike
                }
            }
        }
    }


?>