<!--This is where successful login attempts are sent, This is the configuration hub for new "Questions" and rooms owned by the user
	Created by Matthew Nelson
-->
<?php session_start();?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Quiz and Attendance</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/resources/Stylesheets/main.css" type="text/css">
	<link rel="stylesheet" href="<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/resources/Stylesheets/login.css" type="text/css">
	<link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet">
	<link rel="stylesheet" href="local.css" type="text/css">
	<link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet">
	<script src="<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/resources/javascript/main.js" type="text/javascript" async="true"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
	<!--script src="https://www.google.com/recaptcha/api.js" async defer></script-->
	<script>
	// php variables to JS "global" variables
	const sessionID = <?php echo "\"".session_id()."\""; ?>;
	const roomID = <?php if (isset($_SESSION['roomID'])){echo "\"".$_SESSION['roomID']."\"";} else echo "\""."\"" ?>;


	</script>
	<!-- link to fontawesome for icons -->
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
</head>
<body>
<header>
<div class="nav">
	<div class="topleft">
		<a href="<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/"><img src="<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/resources/graphics/5.png" alt="Logo"></a>
	</div>
	<!--Generate Login Bar based on login status, Check Viewport size and apply necisary adjustments-->

	<div class="topright"id="login">
		<?php if (array_key_exists('loggedin', $_SESSION) == false) : ?>

			<button id="loginbtn" onclick="document.getElementById('logform').style.display='block'" class="raised"><i class="fas fa-user"></i> Login</button>

		<!--If Logged in, Grant access to new menu options and replace login button with logut-->
		<?php elseif (array_key_exists('loggedin', $_SESSION) == true) : ?>

			<div class="userbtn1">
				<button id="accountbtn" class="raised" onclick="window.location.href = '<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/Dashboard'"><i class="fas fa-bars"></i></i> <?php echo $_SESSION['name']?></button>
			</div>

			<div class="userbtn2">
				<form action="<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/Login/Logout.php" method="POST">
					<input type="hidden" name="user" value="<?php echo $_SESSION['username'];?>"/>
					<input type="submit" class="raised" name="logout" value="Logout"/>
				</form>
			</div>
		<?php endif;?>
	
    </div>
    <!--The Login Box-->
    <div id="logform" class="modal">
		<span onclick="document.getElementById('logform').style.display='none'" class="close Mspan" title="Close Modal">&times;</span>
		<form class="modal-content Mform animate" action="<?php $ex = explode(DIRECTORY_SEPARATOR ,__DIR__); $rev = array_reverse($ex); if (!filter_var($rev[1], FILTER_VALIDATE_URL, FILTER_FLAG_SCHEME_REQUIRED)){echo "/".$rev[1];} ?>/Login/loginAttempt.php" method="POST">
			<div class="container">
				<input type="hidden" id="regswitch" name="register" value="false">
				<label for="email" class="register" style="display:none">Email</label>
				<input type="email" id="regemail" class="Minput register" style="display:none" placeholder="example@example.com" name="email">
				<label for="uname"><b>Username</b></label>
				<input type="text" class="Minput" placeholder="Enter Username" name="uname" required>
				<label for="psw"><b>Password</b></label>
				<input type="password" class="Minput" placeholder="Enter Password" name="psw" required>
				<label for="rpsw" class="register" id="regpswconf" style="display:none"><b>Confirm Password</b></label>
				<input type="password" id="retypepsw" class="Minput register" style="display:none" placeholder="Enter Password" name="rpsw">
				<button class="Mbutton login" type="submit">Login</button>
				<button class="Mbutton register" style="display:none" type="submit">Register</button>
                <button class="Mbutton login" onclick="adjustFormToRegister()" type="button">Register?</button>
				<button class="Mbutton register" onclick="adjustFormToLogin()" style="display:none" type="button">Login?</button>
				<!--div class="g-recaptcha" data-sitekey="your_site_key"></div-->
				<br>
				<br>
				<label>
					<input type="checkbox" checked="checked" name="remember"> Remember Me
				</label>
			</div>
			<div class="container " style="background-color:$f1f1f1">
				<button type="button" onclick="document.getElementById('logform').style.display='none'" class="cancelbtn">cancel</button>
				<span class="psw Mspan login">Forgot <a href="#">password?</a></span>
            </div>
            <!--Close Login Screen open Registrar Screen-->
		</form>
	</div>
</div>
    <!---->
</header>
