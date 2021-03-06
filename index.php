<?php include 'view/header.php';?>
<main>
	<div class="sections" >
		<div class="Quiz">
			<button id="Q" class="grid" onclick="expandQ()"><img class=LeftBracket src="resources/graphics/qbtn.png" id="Qimg">
				<div id="RoomLoginHolder" class="LeftBracket" style="display: none;"><?php include 'Room/joinRoom.php' ?></div>
			</button>
		</div>
		<div class="Answer">
			<button id="A" class="grid" onclick="expandA()"><img class="CentralContent" src="resources/graphics/abtn.png" id="Aimg">
				<div id="LoginHolder" class="CentralContent" style="display: none;"><?php include 'Attendance/LogAttendance.php' ?></div></button>
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
				<li>Record daily attendance</li>
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
			<img src="resources/graphics/participation.png" width="100" height="100">
			</div>
			<h4><u>Increase Participation</u></h4>
			<ul>
				<li>Students become more involved</li>
				<li>Encourages dialog among students</li>
				<li>Receive instant lesson feedback </li>
			</ul>
		</div>

	</div>
</main>
<?php include 'view/footer.php';?>
