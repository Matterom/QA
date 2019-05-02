<?php include '../view/header.php';?>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<script>
    const mode = "Host";
</script>
<main>
    <div id="StartBox" onclick="startQuiz()" style="margin: 0 auto; width: 50%; height: 25%; background: green; display:flex;">Start Quiz?</div>
    <div id="QuestionBox" class="hidden">
        <table style="width:100%">
            <tr>
                <th style="width=25%">
                    <div id="popBox">
                        <p>Students Present</p>
                        <p id="popCurrent" class="pop">10</p>
                        <p class="pop">---</p>
                        <p id="popExpected" class="pop">15</p>
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
                        <p id="A1" class="RoomAnswer">Answer</p>
                        <p id="A2" class="RoomAnswer">Answer</p>
                        <p id="A3" class="RoomAnswer">Answer</p>
                        <p id="A4" class="RoomAnswer">Answer</p>
                        <p id="A5" class="RoomAnswer">Answer</p>
                    </div>
                </th>
                <th style="width:25%">
                </th>
        </table>
    </div>
</main>
<?php include '../view/footer.php';?>
