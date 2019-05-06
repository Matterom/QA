<!-- Project Index Page Created by David Fretz -->
<?php include '../view/header.php';?>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<script>
    const mode = "Host";
    const QList = <?php echo json_encode($_SESSION['qSetIDList']) ?>;
    const RKey = '<?php echo $_SESSION['roomKey'] ?>';
    const remainingTime = <?php echo $_SESSION['timer'];?>;
    const MaxPop = <?php echo $_SESSION['attendeeCount'];?>;
</script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
<main>
	<div id="StartBox" onclick="startQuiz()">Start Quiz?</div>
	<div id="QuestionBox" class="hidden">
    	<div class="grid-container">
    		<div id="popBox" class="popBox">
        		<p>Students Present</p>
            	<p id="popCurrent" class="pop">0</p>
            	<p class="pop">---</p>
            	<p id="popExpected" class="pop"><?php echo $_SESSION['attendeeCount'];?></p>
        	</div>
        	<div id="QuestionHeader" class="QuestionHeader">
            	<p id="QText" class="Question">Question</p>
            	<p id="Time" class="Timer"></p>
        	</div>
        	<div id="dirQBox" class="dirQBox">
				<button id="btnQPrev" class="QBtn" onclick="nextQuestion(true)"><i class="fas fa-angle-double-left"></i></button>
            	<button id="btnNext" class="QBtn" onclick="nextQuestion(false)"><i class="fas fa-angle-double-right"></i></button>
        	</div>
        	<div id="RoomKeyBox" class="RoomKeyBox">
			<p>Room Key</p>
			<?php echo $_SESSION['roomKey'] ?>
		</div>
        	<div id="AnswerGrid" class="AnswerGrid">
        		<p id="A1" class="RoomAnswer">Answer</p>
            	<p id="A2" class="RoomAnswer">Answer</p>
            	<p id="A3" class="RoomAnswer">Answer</p>
            	<p id="A4" class="RoomAnswer">Answer</p>
            	<p id="A5" class="RoomAnswer">Answer</p>
        	</div>
        </div>
    </div>
</main>
<?php include '../view/footer.php';?>
