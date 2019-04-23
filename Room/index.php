<?php include '../view/header.php';?>
<!--This handles the user page for rooms EG A drops them here -->
<main>
<div id="QuestionBox">
  <div id="QuestionHeader">
      <p>Question Text Display
      </p>
  </div>
  <div id="AnswerGrid">
    <button onclick="updateQuiz('User', 1)">Answer</button>
    <button onclick="updateQuiz('User', 2)">Answer</button>
    <button onclick="updateQuiz('User', 3)">Answer</button>
    <button onclick="updateQuiz('User', 4)">Answer</button>
    <button onclick="updateQuiz('User', 5)">Answer</button>
  </div>
</div>
</main>
<?php include '../view/footer.php';?>