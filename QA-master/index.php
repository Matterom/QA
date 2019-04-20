<?php include 'view/header.php';?>
<main>
	<link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet">
	<div class="sections" style="display:block;">
		<div class="Quiz">
			<button id="Q" onclick="window.location.href = 'RoomSetup'">Q</button>
		</div>
		<div class="Answer">
			<button id="A">Mark Yourself Present!<?php include 'Attendance/LogAttendance.php' ?></button>
		</div>
	</div>

	<div id="aboutmenu" class="container2">
		<span onclick="document.getElementById('aboutmenu').style.display='none'" class="close Mspan" title="Close Modal"></span>
		<div class="box1">
			<div class="picture">
			<img src="resources/graphics/attendance.png" width="100" height="100">
			</div>
			<h4><u>Class Attendance</u></h4>
			<ul>
				<li>Generate Daily Attendance Code</li>
				<li>Record dayily attendance</li>
				<li>Reduce wasted time</li>
			</ul>
		</div>

		<div class="box2">
			<div class= "picture">
			<img src="resources/graphics/quiz.png" width="100" height="100" >
			</div>
			<h4><u>Class Quizzes</u></h4>
			<ul>
				<li>Generate Daily Quiz Code</li>
				<li>Record quiz grades</li>
				<li>Encourage class participation</li>
			</ul>
		</div>

		<div class="box3">
			<div class="picture">
			<img src="resources/graphics/report.png" width="100" height="100">
			</div>
			<h4><u>Class Reports</u></h4>
			<ul>
				<li>Generate Attendance Reports</li>
				<li>Generate Quiz Reports</li>
				<li>Track both individual and class progress</li>
			</ul>
		</div>

	</div>
</main>
<?php include 'view/footer.php';?>
