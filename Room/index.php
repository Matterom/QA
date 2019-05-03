<?php include '../view/header.php';?>
<!--This handles the user page for rooms EG A drops them here -->
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<script>
  const mode = "User";
  const RKey = '<?php echo $_SESSION['roomKey'] ?>';
  const attemptID = <?php echo $_SESSION['attemptID'] ?>;
</script>
<main>
<div id="Hold">

</div>
<div id="QuestionBox">
  <div id="QuestionHeader">
      <p id="QText" class="Question">Question</p>
      <p id="Time" class="Timer"><p>
  </div>
  <div id="AnswerGrid" class="GridButtons">
    <button onclick="updateQuiz('User', 1)" id="A1" class="RoomAnswer">Answer</button>
    <button onclick="updateQuiz('User', 2)" id="A2" class="RoomAnswer">Answer</button>
    <button onclick="updateQuiz('User', 3)" id="A3" class="RoomAnswer">Answer</button>
    <button onclick="updateQuiz('User', 4)" id="A4" class="RoomAnswer">Answer</button>
    <button onclick="updateQuiz('User', 5)" id="A5" class="RoomAnswer">Answer</button>
  </div>
</div>
</main>
<?php include '../view/footer.php';?>