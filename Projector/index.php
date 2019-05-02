<?php include '../view/header.php';?>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<main>
    <div id="QuestionBox">
    <table style="width:100%">
        <tr>
            <th style="width=25%">
                <div id="popBox">
                    <p>Students Present</p>
                    <p id="popCurrent" class="pop"></p>
                    <p id="popExpected" class="pop"></p>
                </div>
            </th>
            <th style="width:50%">
                <div id="QuestionHeader">
                    <p id="QText" class="Question">Question</p>
                    <p id="Time" class="Timer"></p>
                </div>
            </th>
            <th style="width=25%">
                <div id="dirQBox">
                    <button id="btnQPrev" class="QBtn">Previous Question</button>
                    <button id="btnNext" class="QBtn">Next Question</button>
                </div>
            </th>
        </tr>
        <tr>
            <th style="width:25%">
            </th>
            <th style="width:50%">
                <div id="AnswerGrid">
                    <button onclick="updateQuiz('User', 1)" id="A1" class="RoomAnswer">Answer</button>
                    <button onclick="updateQuiz('User', 2)" id="A2" class="RoomAnswer">Answer</button>
                    <button onclick="updateQuiz('User', 3)" id="A3" class="RoomAnswer">Answer</button>
                    <button onclick="updateQuiz('User', 4)" id="A4" class="RoomAnswer">Answer</button>
                    <button onclick="updateQuiz('User', 5)" id="A5" class="RoomAnswer">Answer</button>
                  </div>
            </th>
            <th style="width:25%">
            </th>
    </table>
    </div>
</main>
<?php include '../view/footer.php';?>