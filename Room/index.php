<?php include '../view/header.php';?>
<!--This handles the user page for rooms EG A drops them here -->
<main>
<div id="QuestionBox" class="hidden">
  <div id="QuestionHeader">
      <p id="QText" class="Question">Placeholder
      </p>
      <p id="Time" class="Timer"><p>
  </div>
  <div id="AnswerGrid">
    <button onclick="updateQuiz('User', 1)" id="A5" class="Answer">Placeholder</button>
    <button onclick="updateQuiz('User', 2)" id="A5" class="Answer">Placeholder</button>
    <button onclick="updateQuiz('User', 3)" id="A5" class="Answer">Placeholder</button>
    <button onclick="updateQuiz('User', 4)" id="A4" class="Answer">Placeholder</button>
    <button onclick="updateQuiz('User', 5)" id="A5" class="Answer">Placeholder</button>
  </div>
</div>
</main>
<?php include '../view/footer.php';?>