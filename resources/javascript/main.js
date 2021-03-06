//    main.js file by Matthew Nelson
//
//
//
//----------------------------------//
/////////////////////////
// Important Variables //
/////////////////////////

const modal = document.getElementById('id01');
let timeKeeper;
let logloop;
let time = 99999;
let timeStep = -1;
let activeFolder;
let activeSet;
let quizList;
let currentQuest;
let currentAnswer;
const EleArr = ["A1", "A2", "A3", "A4", "A5"];

//----------------------------------//

//////////////////////
// On Load function //
//////////////////////

window.addEventListener("load", function() {
    if (typeof mode === 'undefined') {} else if (mode == "User") {
        logicLoop("start");
    }
}, false);

//////////////////
// Update Clock //
//////////////////
function timer(arg) {
    switch (arg) {
        case "start":
            timeKeeper = setInterval(updateClock, 1000);
            break;
        case "clear":
            clearInterval(timeKeeper)
            time = 0
        case "pause":
            clearInterval(timeKeeper)
    }
}

function logicLoop(arg) {
    switch (arg) {
        case "start":
            logloop = setTimeout(update, 1000);
            break;
        case "clear":
            clearInterval(logloop)
            time = 99999
            break;
        case "pause":
            clearInterval(logloop)
            break;
    }
}

function updateClock() {
    var watch = document.getElementById("Time");
    watch.innerHTML = "Time: " + time;
    time += timeStep;
}

function update() {
    updateQuiz(mode);
    logloop = setTimeout(update, 1000);
}

async function updateQuiz(mode) {
    const room = await getRoomInfo()

    //Note, in the future, check against website or php variable to prevent errors
    if (mode == "Host") {
        // Check Quiz State, If Time Remaining < 0, Move to next Question
        if (time == 99999) {
            time = room.timer
            timer("start");
        } else if (time < 0) {
            nextQuestion(false);
            timer("clear")
            time = room.timer;
            timer("start")
        }
    } else if (mode == "Review") {
        //TODO review mode for looking back
    } else if (mode == "User") {
        console.log(room);
        console.log(room.current_questionID)
        if (typeof room.current_questionID === 'null') {
            //If room doesn't have a question, Idle
            console.log(true);
        } else if (currentQuest != room.current_questionID) {
            //If Question is not current question
            console.log("PartTwo")
            if (answerQuestion) {
                submitAnswer();
            }
            currentQuest = room.current_questionID
            let Q = await getQuestion(currentQuest);
            buildQuestion(Q);
        } else if (!currentQuest && room.current_questionID) {
            console.log("PartThree")
            currentQuest = room.current_questionID
            let Q = await getQuestion(currentQuest);
            buildQuestion(Q);
        } else {
            // Run down timer;
        }
    } else {
        //nothinh happens
    }
}

//Start Quiz
async function startQuiz() {
    // Get first question and update server
    currentQuest = QList[0];
    const data = new FormData();
    data.append("Quiz", true);
    data.append("setQuest", true);
    data.append("roomID", roomID);
    data.append("qID", currentQuest);
    const response = await fetch("roomLogic.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {} else {
        console.log(await response.text())
        const Q = await getQuestion(currentQuest);
        buildQuestion(Q);
        logicLoop("start");
        const ele = document.getElementById("StartBox");
        const quiz = document.getElementById("QuestionBox");
        ele.style = "display: none;";
        quiz.classList.remove("hidden");
    }
}

async function getRoomInfo() {
    if (roomID) {
        const data = new FormData()
        data.append("Room", true);
        data.append("getRoom", true);
        data.append("roomID", roomID);
        const response = await fetch("roomLogic.php", {
            method: 'POST',
            body: data
        });
        if (!response.ok) {
            console.log("Respone from server lost")
        } else {
            result = await response.json();
            return result;
        }
    }
}

//Answers Question
async function answerQuestion(aID) {
    console.log("answer Attempt");
    currentAnswer = aID;
    const data = new FormData();
    data.append("Quiz", true);
    data.append("Answer", true);
    data.append("qid", currentQuest)
    data.append("aid", aID);
    const response = await fetch("roomLogic.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("Respone from server lost")
    } else {
        let result = await response.text();
        console.log(result);
    }
}

//Submits Answer
async function submitAnswer() {
    const data = new FormData();
    data.append("Quiz", true);
    data.append("Answer", true);
    data.append("qid", currentQuest)
    data.append("aid", currentAnswer);
    const response = await fetch("roomLogic.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("Respone from server lost")
    } else {
        let result = await response.text();
        console.log(result);
    }
}

//User Side, Enables the Quiz when teach starts
function enableQuestion() {

}

//Push User's room to new question
async function nextQuestion(back) {
    let step = 1;
    if (back) {
        step = -1;
    }
    if (mode == "Host") {
        if ((back || !((QList.length - 1) == (QList.indexOf(currentQuest)))) && !(back && QList.indexOf(currentQuest) == 0)) {
            currentQuest = QList[QList.indexOf(currentQuest) + step];
            let Q = await getQuestion(currentQuest);
            buildQuestion(Q);
            const data = new FormData()
            data.append("Quiz", true);
            data.append("setQuest", true);
            data.append("roomID", roomID);
            data.append("qID", currentQuest);
            const response = await fetch("roomLogic.php", {
                method: 'POST',
                body: data
            });
            if (!response.ok) {
                console.log("Respone from server lost")
            }
        } else {
            // END OF QUIZ LOGIC

        }
    } else if (mode == "User") {
        let Q = await getQuestion(currentQuest);
        buildQuestion(Q)
    }

    //Pull Current Question data and push it to server, just in case.


}

async function getQuestion(QID) {
    console.log(QID);
    const data = new FormData()
    data.append("Room", true);
    data.append("getQuest", true);
    data.append("qID", QID);
    //Pull the question object and refresh the relevant DOM
    const response = await fetch("roomLogic.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("Respone from server lost")
    } else {
        let result = await response.json();
        return JSON.parse(result.question);
    }
}

//Build the Dom of a Question
function buildQuestion(Q) {
    console.log(Q);
    const QText = document.getElementById("QText");
    const A1 = document.getElementById("A1");
    const A2 = document.getElementById("A2");
    const A3 = document.getElementById("A3");
    const A4 = document.getElementById("A4");
    const A5 = document.getElementById("A5");

    QText.innerHTML = Q.text

    A1.innerHTML = Q.answer.one[1]
    if (Q.answer.one[2].includes("hidden")) {
        A1.classList.add("hidden")
    } else if (A1.classList.contains("hidden")) {
        A1.classList.remove("hidden");
    }
    A2.innerHTML = Q.answer.two[1]
    if (Q.answer.two[2].includes("hidden")) {
        A2.classList.add("hidden")
    } else if (A2.classList.contains("hidden")) {
        A2.classList.remove("hidden");
    }
    A3.innerHTML = Q.answer.three[1]
    if (Q.answer.three[2].includes("hidden")) {
        A3.classList.add("hidden")
    } else if (A3.classList.contains("hidden")) {
        A3.classList.remove("hidden");
    }
    A4.innerHTML = Q.answer.four[1]
    if (Q.answer.four[2].includes("hidden")) {
        A4.classList.add("hidden")
    } else if (A4.classList.contains("hidden")) {
        A4.classList.remove("hidden");
    }
    A5.innerHTML = Q.answer.five[1]
    console.log(Q.answer.five[2].includes("hidden"))
    if (Q.answer.five[2].includes("hidden")) {
        console.log("hidding");
        A5.classList.add("hidden")
    } else if (A5.classList.contains("hidden")) {
        A5.classList.remove("hidden");
    }

    // Just in case honestly
    //if (style == "Host") {
    //}
    //else if (style == "User") {
    //}
}
//----------------------------------//
////////////////////////////
// Object Definition Zone //
////////////////////////////
class questionObj {
    constructor() {
        this.text = "This is a sample Question, Double Click to Change",
            this.args = {
                TF: "False",
            },
            this.answer = {
                one: [true, "This is a sample Answer, Double click to change", ""],
                two: [false, "This is a sample Answer, Double click to change", ""],
                three: [false, "This is a sample Answer, Double click to change", "hidden"],
                four: [false, "This is a sample Answer, Double click to change", "hidden"],
                five: [false, "This is a sample Answer, Double click to change", "hidden"]
            };
    }
}
//Function to get a question Object out of an ID ///NOTE: Fragile and think of a better system later.
function getQObjFromQID(qid) {
    const eText = document.getElementById(qid + ":text").innerHTML;

    const argTF = document.getElementById(qid + ":args").innerHTML.split(", ")[0].split("::")[1];
    // Parse Answer Array Storage
    const ans1a = document.getElementById(qid + ":1");
    const ans2a = document.getElementById(qid + ":2");
    const ans3a = document.getElementById(qid + ":3");
    const ans4a = document.getElementById(qid + ":4");
    const ans5a = document.getElementById(qid + ":5");
    const ans1 = [ans1a.nextSibling.firstChild.checked, ans1a.innerHTML, ans1a.classList.contains("hidden") ? "hidden" : ""];
    const ans2 = [ans2a.nextSibling.firstChild.checked, ans2a.innerHTML, ans2a.classList.contains("hidden") ? "hidden" : ""];
    const ans3 = [ans3a.nextSibling.firstChild.checked, ans3a.innerHTML, ans3a.classList.contains("hidden") ? "hidden" : ""];
    const ans4 = [ans4a.nextSibling.firstChild.checked, ans4a.innerHTML, ans4a.classList.contains("hidden") ? "hidden" : ""];
    const ans5 = [ans5a.nextSibling.firstChild.checked, ans5a.innerHTML, ans5a.classList.contains("hidden") ? "hidden" : ""];
    const Q = new questionObj;
    Q.text = eText;
    Q.args.TF = argTF;
    Q.answer.one = ans1;
    Q.answer.two = ans2;
    Q.answer.three = ans3;
    Q.answer.four = ans4;
    Q.answer.five = ans5;
    return Q;
}
// Compresses an Element based on an ID
function compressQuestion(qid) {
    const reset = "This is a sample Answer, Double click to change";
    const eleBox = document.getElementById("AB:" + qid);
    const ansArr = [document.getElementById(qid + ":1"),
        document.getElementById(qid + ":2"),
        document.getElementById(qid + ":3"),
        document.getElementById(qid + ":4"),
        document.getElementById(qid + ":5")
    ]
    const chArr = [document.getElementById(qid + ":ch1"),
        document.getElementById(qid + ":ch2"),
        document.getElementById(qid + ":ch3"),
        document.getElementById(qid + ":ch4"),
        document.getElementById(qid + ":ch5")
    ]

    for (let i = 0; i < ansArr.length; i++) {
        if (ansArr[i].innerHTML == "") {
            if (!((i + 1) == ansArr.length) && !ansArr[i + 1].classList.contains("hidden")) {
                ansArr[i].innerHTML = ansArr[i + 1].innerHTML;
                ansArr[i + 1].innerHTML = "";
                chArr[i].firstChild.checked = chArr[i + 1].firstChild.checked
                ansArr[i + 1].nextSibling.firstChild.checked = false;
            } else {
                ansArr[i].innerHTML = reset;
                ansArr[i].classList.add("hidden");
                chArr[i].classList.add("hidden");
            }
        }
    }
}
//Adds question choices TODO breaks after some useage, works for display
async function addChoice(qid) {
    const eleBox = document.getElementById("AB:" + qid);
    const ansArr = [document.getElementById(qid + ":1"),
        document.getElementById(qid + ":2"),
        document.getElementById(qid + ":3"),
        document.getElementById(qid + ":4"),
        document.getElementById(qid + ":5")
    ]
    const chArr = [document.getElementById(qid + ":ch1"),
        document.getElementById(qid + ":ch2"),
        document.getElementById(qid + ":ch3"),
        document.getElementById(qid + ":ch4"),
        document.getElementById(qid + ":ch5")
    ]
    for (let i = 0; i < ansArr.length; ++i) {
        if (ansArr[i].classList.contains("hidden")) {
            ansArr[i].classList.remove("hidden");
            chArr[i].classList.remove("hidden");
            break;
        }
    }
}
//Refreshes questions assoicated with the set
async function revealSetAssoc(setID) {
    activeSet = setID;
    qBoxes = document.getElementsByClassName("question")
    const data = new FormData();
    data.append("set", true);
    data.append("get", true);
    data.append("setID", setID);
    const response = await fetch("pushRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("something went wrong");
    } else {
        let result = await response.text();
        for (let i = 0; i < qBoxes.length; ++i) {
            qid = qBoxes[i].id.split(':')[1];
            if (result.includes(qid)) {
                revealChildClass("BH:" + qid, "addToSet", false);
                revealChildClass("BH:" + qid, "subFromSet", true);
            } else {
                revealChildClass("BH:" + qid, "addToSet", true);
                revealChildClass("BH:" + qid, "subFromSet", false);
            }
        }
    }

}

//----------------------------------//

////////////////////
// Event Handlers //
////////////////////

//Closes window, TODO replace with new code, used as test
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}

function expandQ() {
    const box = document.getElementById("Q");
    const q = document.getElementById("Qimg");
    const hold = document.getElementById("RoomLoginHolder");
    box.style = "width:400px"
    q.style = "display:none";
    hold.style = "display:box";

}

function expandA() {
    const box = document.getElementById("A");
    const a = document.getElementById("Aimg");
    const hold = document.getElementById("LoginHolder");
    box.style = "width:400px"
    a.style = "display:none";
    hold.style = "display:box";

}

//DBLclick function to convert the folder name or description to a form
function convertFolderToForm(select, type, secondary, userID, folderID) {
    select.setAttribute("style", "display:none")
    let input;
    if (type == "folderN") {
        input = document.createElement("input");
        input.setAttribute("value", select.innerHTML);
    } else {
        input = document.createElement("textarea");
        input.innerHTML = select.innerHTML;
    }
    input.setAttribute("value", select.innerHTML);
    input.setAttribute("autofocus", true);
    input.setAttribute("onkeyup", "updateFolderFromForm(this, '" + type + "', '" + secondary + "', " + userID + ", " + folderID + ", false)")
    input.setAttribute("onfocusout", "updateFolderFromForm(this, '" + type + "', '" + secondary + "', " + userID + "," + folderID + ", true)")
    select.parentNode.insertBefore(input, select.nextSibling)
}
//DBLclick function to convert the Question Text to a form
function convertQuestionToForm(select, type, folderID, questionID) {
    select.setAttribute("style", "display:none");
    const input = document.createElement("textarea");
    input.innerHTML = select.innerHTML;
    input.setAttribute("autofocus", true);
    input.setAttribute("onkeyup", "updateQuestionFromForm(this, '" + type + "', " + folderID + ", " + questionID + ", false)");
    input.setAttribute("onfocusout", "updateQuestionFromForm(this, '" + type + "', " + folderID + ", " + questionID + ", true)");
    select.parentNode.insertBefore(input, select.nextSibling);

}
//DBLclick function to convert the set name or description to a form
function convertSetToForm(select, type, secondary, userID, folderID, setID) {
    select.setAttribute("style", "display:none");
    let input;
    if (type == "QSetN") {
        input = document.createElement("input");
        input.setAttribute("value", select.innerHTML);
        input.focus();
    } else {
        input = document.createElement("textarea");
        input.focus();
        input.innerHTML = select.innerHTML;
    }
    input.setAttribute("autofocus", true);
    input.setAttribute("onkeyup", "updateSetFromForm(this, '" + type + "', '" + secondary + "', " + userID + ", " + folderID + ", " + setID + ", false)");
    input.setAttribute("onfocusout", "updateSetFromForm(this, '" + type + "', '" + secondary + "', " + userID + ", " + folderID + ", " + setID + ", true)");
    select.parentNode.insertBefore(input, select.nextSibling);
}
//Updates parent elements from input data, updates the sql to reflect new form data. carries on.
async function updateFolderFromForm(origin, type, target, userID, folderID, clickoff) {
    if ((!event.shiftKey & event.keyCode == 13) || clickoff) {
        target = origin.previousSibling;
        //Replace content from input to dom
        if (!origin.innerHTML == 0 || !origin.value == 0) {
            origin.previousSibling.innerHTML = origin.value;
            //Send to server
            fname = document.getElementById("FN:" + folderID).innerHTML;
            fdesc = document.getElementById("FD:" + folderID).innerHTML;
            let data = new FormData();
            data.append("folder", true);
            data.append("update", true);
            data.append("name", fname);
            data.append("desc", fdesc);
            data.append("user", userID);
            data.append("folderID", folderID);
            // Fetch implementation
            const response = await fetch("pushRoomSetup.php", {
                method: 'POST',
                body: data
            });
            if (!response.ok) {
                console.log("something went wrong");
            } else {
                let result = await response.text();

                //remove form and reenable node if successful
                target.setAttribute("style", "display:block");
                origin.parentNode.removeChild(origin);
            }
        } else {
            target.setAttribute("style", "display:block");
            origin.parentNode.removeChild(origin);
        }
    } else if (event.keyCode == 27) {
        //Escape Pressed, Cancel everything
    }
}
//Updates the question Text
async function updateQuestionFromForm(origin, type, folderID, questionID, clickoff) {
    if ((!event.shiftKey & event.keyCode == 13) || clickoff) {
        target = origin.previousSibling;
        val = origin.value.replace(/(\r\n|\n|\r)/gm, "");
        origin.previousSibling.innerHTML = val
        if (type == "answer") {
            if (val.length == 0) {
                compressQuestion(questionID);
            }
        }

        let data = new FormData()
        let q = JSON.stringify(getQObjFromQID(questionID));
        data.append("question", true);
        data.append("update", true)
        data.append("target", questionID);
        data.append("data", q);
        data.append("folderID", folderID);



        const response = await fetch("pushRoomSetup.php", {
            method: 'POST',
            body: data
        })
        if (!response.ok) {
            console.log("something went wrong");
        } else {
            let result = await response.text();
            //remove form and reenable node if successful
            if (!target.classList.contains("hidden")) {
                target.setAttribute("style", "display:block");
            }
            origin.parentNode.removeChild(origin);
        }
    }

}
//Updates the DB with a new form name or descripter
async function updateSetFromForm(origin, type, secondary, userId, folderID, setID, clickoff) {
    if ((!event.shiftKey & event.keyCode == 13) || clickoff) {
        target = origin.previousSibling;
        val = origin.value.replace(/(\r\n|\n|\r)/gm, "");
        origin.previousSibling.innerHTML = val;
        let name = document.getElementById("QSN:" + setID).innerHTML;
        let desc = document.getElementById("QSD:" + setID).innerHTML;
        let data = new FormData();
        data.append("set", true);
        data.append("update", true);
        data.append("folderID", folderID);
        data.append("setID", setID);
        data.append("name", name);
        data.append("desc", desc);

        const response = await fetch("pushRoomSetup.php", {
            method: 'POST',
            body: data
        })
        if (!response.ok) {
            console.log("something went wrong");
        } else {
            let result = await response.text();

            //remove form and reenable node if successful
            if (!target.classList.contains("hidden")) {
                target.setAttribute("style", "display:block");
            }
            origin.parentNode.removeChild(origin);
        }
    }
}
//Utility for revealing children based on some variables
function revealChildClass(parent, target, mode) {
    child = document.getElementById(parent).childNodes;
    for (i = 0; i < child.length; ++i) {
        if (child[i].classList.contains(target)) {
            if (mode && child[i].classList.contains("hidden")) {
                child[i].classList.remove("hidden")
            } else if (!mode) {
                child[i].classList.add("hidden")
            }
        }
    }
}
// <i class=’fas fa-caret-down’></i>
//<i class='fas fa-caret-right'></i>
//Toggles answerbox
function toggleAnswers(qid) {
    const ele = document.getElementById("AB:" + qid)
    const arr = document.getElementById("QAr:" + qid)
    if (ele.classList.contains("hidden")) {
        ele.classList.remove("hidden");
        arr.innerHTML = "<i style='font-size: 30px' class='fas fa-caret-down'></i>"
        revealChildClass("BH:" + qid, "addChoice", true)
    } else {
        ele.classList.add("hidden");
        arr.innerHTML = "<i style='font-size: 30px' class='fas fa-caret-left'></i>"
        revealChildClass("BH:" + qid, "addChoice", false)
    }
}
//Deletes Folder, Remove element and ping server's php to remove from memory
async function deleteFolder(target, folderID, user) {
    const node = target.parentNode
    let data = new FormData();
    data.append("folder", true);
    data.append("delete", true);
    data.append("target", folderID)
    data.append("user", user);
    const response = await fetch("pushRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("something went wrong in delete folder");
    } else {
        //Finally delete the node
        let result = await response.text()
        console.log(result);
        node.parentNode.removeChild(node);
        document.getElementById("QuestionBox").innerHTML = "";
        document.getElementById("QuestionSetBox").innerHTML = "";
    }
}
//Delete Question
async function deleteQuestion(target, folderID) {
    const node = document.getElementById("Q:" + target);
    let data = new FormData();
    data.append("question", true);
    data.append("delete", true);
    data.append("setID", target);
    data.append("folderID", folderID);

    const response = await fetch("pushRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("something went wrong in delete folder");
    } else {
        //Finally delete the node
        let result = await response.text()

        node.parentNode.removeChild(node);
    }
}
//Delete Question Set, Remove Element and ping server's PHP to remove from memory
async function deleteQSet(element, setID, folderID) {
    const node = element.parentNode;
    let data = new FormData();
    data.append("set", true)
    data.append("delete", true);
    data.append("setID", setID);
    data.append("folderID", folderID);
    const response = await fetch("pushRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("Something went wrong attempting to delete Set, Not deleting set element")
    } else {
        //Delete the Node
        let result = await response.text()
        node.parentNode.removeChild(node);
    }
}
//Creates Folder, Pings PHP to create the default, initialaizes form, runs updateElementFromForm when values are entered and converts to normal
async function newFolder(user) {
    const folderbox = document.getElementById("FolderBox");
    const tempFolName = "Folder Name";
    const tempFolDesc = "Double Click to edit Folder Name or Folder Description";
    //Tell Server to make a new DB entry with user
    let data = new FormData();
    data.append("folder", "true");
    data.append("newFold", user);
    data.append("fname", tempFolName);
    data.append("fdesc", tempFolDesc);
    const response = await fetch("pushRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("something went wrong");
    } else {
        let result = await response.text();

        //the PHP returns the ID of the folder
        const folderID = result;
        //Make the Div using the ID
        const node = document.createElement("div");
        const h1 = document.createElement("h1");
        const p = document.createElement("p");
        const btn = document.createElement("button");

        //configure node
        node.setAttribute("class", "folderIter dragable")
        node.setAttribute("onclick", "queryQuestionList(" + folderID + ", " + user + ")")
            //configure h1
        h1.setAttribute("id", "FN:" + folderID);
        h1.setAttribute("ondblclick", "convertFolderToForm(this, 'folderN', 'FD:" + folderID + "', " + user + ", " + folderID + ")");
        h1.setAttribute("class", "renamable")
        h1.innerText = tempFolName;
        //configure p
        p.setAttribute("id", "FD:" + folderID);
        p.setAttribute("ondblclick", "convertFolderToForm(this, 'folderD', 'FN:" + folderID + "', " + user + ", " + folderID + ")");
        p.setAttribute("class", "renamable")
        p.innerText = tempFolDesc;

        //configure btn
        btn.setAttribute("type", "button");
        btn.classList.add("trashbtn")
        btn.classList.add("btnqa")
        btn.setAttribute("onclick", "deleteFolder(this, " + folderID + ", " + user + ")")
        btn.innerHTML = "<i class='fas fa-trash-alt'></i> Delete";
        //assemble node
        folderbox.appendChild(node);
        node.appendChild(h1);
        node.appendChild(p);
        node.appendChild(btn);
    }
}
//Makes a new set
async function newSet(folder, user) {
    const QSBox = document.getElementById('QuestionSetBox');
    const QSHead = document.getElementById('QuestionSetHeader');
    const defName = "Name of Set";
    const defDesc = "Description of Set";
    let data = new FormData();
    data.append('set', true);
    data.append('new', true);
    data.append('name', defName);
    data.append('desc', defDesc);
    data.append('folderID', folder);
    const response = await fetch("pushRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("something went wrong");
    } else {
        let result = await response.text();

        const setID = result;
        generateSEle(setID, folder, defName, defDesc, user)

        const node = document.createElement("div");
    }
}
//Queries the server for a list of questions in a set
async function queryQuestionList(folder, user) {
    if (activeFolder != folder) {
        activeFolder = folder
        const QBox = document.getElementById("QuestionBox");
        //Clear Box and Regenerate
        QBox.innerHTML = "";
        let data = new FormData();
        data.append("question", folder)
        data.append("query", "true")
        data.append("user", user)
        const response = await fetch("pushRoomSetup.php", {
            method: 'POST',
            body: data
        });
        if (!response.ok) {
            console.log("something went wrong");
        } else {
            let qList = await response.json();
            //Itterate through the list
            for (let i = 0; i < qList.length; i++) {
                let Q = JSON.parse(qList[i].question);
                let qid = qList[i].questionID;
                //Build Element
                Qbtn = generateQEle(QBox, folder, user, qid, Q);
            }
            //Create New question button


            const newQbtn = document.createElement("div");
            newQbtn.setAttribute("onclick", "newQuestion(" + folder + ", " + user + ")");
            newQbtn.setAttribute("id", "newQbtn");
            newQbtn.innerText = "Create New Question";
            QBox.appendChild(newQbtn);

            //Followup and query question Quiz sets
            queryQuizSet(folder, user);
        }
    }
}
//Queries the server for a list of sets in the folder
async function queryQuizSet(folder, user) {
    const QSBox = document.getElementById('QuestionSetBox');
    //Clear box and Regenerate
    QSBox.innerHTML = "<div id='QuestionSetHeader' class='lheader'><div id='NewSet'><button type='button' class='btnqa' onclick='newSet(" + folder + ")'><i class='fas fa-file-alt'></i> New Quiz Set</button></div></div>";
    let data = new FormData();
    data.append("set", true);
    data.append("query", true);
    data.append("location", folder)
    data.append("user", user);
    const response = await fetch("pushRoomsetup.php", {
        method: "POST",
        body: data
    });
    if (!response.ok) {
        console.log("Something went wrong")
    } else {
        let sList = await response.json();

        for (let i = 0; i < sList.length; i++) {
            let qsName = sList[i].qSetName;
            let qsDesc = sList[i].qSetDesc;
            let qSID = sList[i].qSetId;
            //Build Element
            generateSEle(qSID, folder, qsName, qsDesc, user)
        }
    }
}
//Function to add a question to a set
async function addToSet(qid, insert) {
    let target;
    if (insert) {
        target = "add";
    } else {
        target = "sub";
    }
    let data = new FormData();
    data.append("set", true);
    data.append(target, true);
    data.append("qID", qid);
    data.append("setID", activeSet);
    const response = await fetch("pushRoomsetup.php", {
        method: "POST",
        body: data
    });
    if (!response.ok) {
        console.log("Something went wrong")
    } else {
        result = await response.text();
        revealSetAssoc(activeSet)
    }

}
//Genereates the Element for a new or existing Question Config box
function generateQEle(QBox, folder, user, qid, Q) {
    const Qbtn = document.createElement("div");
    Qbtn.classList = "question";
    Qbtn.setAttribute("id", "Q:" + qid);
    // <i class=’fas fa-caret-down’></i>
    //<i class='fas fa-caret-right'></i>
    let qString = "<div class='QHead'><div id='" + qid + ":text' class='text'>" + Q.text + "</div><div id='QAr:" + qid + "' onclick='toggleAnswers(" + qid + ")' class='arrow'><i style='font-size: 30px' class='fas fa-caret-left'></i></i></div></div>"
    qString += "<div id='AB:" + qid + "' class='answerBox hidden'>"
    qString += "<div id='" + qid + ":1" + "' class='ans1 " + Q.answer.one[2] + "'>" + Q.answer.one[1] + "</div><div id='" + qid + ":ch1' class='ch1 " + Q.answer.one[2] + "'><input type='checkbox' name='answerOne' value='true' " + (Q.answer.one[0] ? "checked='true'" : "") + "/></div>"
    qString += "<div id='" + qid + ":2" + "' class='ans2 " + Q.answer.two[2] + "'>" + Q.answer.two[1] + "</div><div id='" + qid + ":ch2' class='ch2 " + Q.answer.two[2] + "'><input type='checkbox' name='answerTwo' value='true' " + (Q.answer.two[0] ? "checked='true'" : "") + "/></div>"
    qString += "<div id='" + qid + ":3" + "' class='ans3 " + Q.answer.three[2] + "'>" + Q.answer.three[1] + "</div><div id='" + qid + ":ch3' class='ch3 " + Q.answer.three[2] + "'><input type='checkbox' name='answerThree' value='true' " + (Q.answer.three[0] ? "checked='true'" : "") + "/></div>"
    qString += "<div id='" + qid + ":4" + "' class='ans4 " + Q.answer.four[2] + "'>" + Q.answer.four[1] + "</div><div id='" + qid + ":ch4' class='ch4 " + Q.answer.four[2] + "'><input type='checkbox' name='answerFour' value='true' " + (Q.answer.four[0] ? "checked='true'" : "") + "/></div>"
    qString += "<div id='" + qid + ":5" + "' class='ans5 " + Q.answer.five[2] + "'>" + Q.answer.five[1] + "</div><div id='" + qid + ":ch5' class='ch5 " + Q.answer.five[2] + "'><input type='checkbox' name='answerFive' value='true' " + (Q.answer.five[0] ? "checked='true'" : "") + "/></div>"
    qString += "</div>"
    qString += "<div id='" + qid + ":args' class='hidden'>" + "TF::" + Q.args.TF + "</div>"
    qString += "<div id='BH:" + qid + "' class='btnholder'>"
    qString += "<button onclick='addChoice(" + qid + ")' class='hidden addChoice btnqa'><i class='fas fa-plus'></i> Add Answer Choice</button>"
    qString += "<button class='hidden addToSet btnqa' onclick='addToSet(" + qid + ", true)'><i class='fas fa-file-alt'></i> Add to Quiz</button>"
    qString += "<button class='hidden subFromSet btnqa' onclick='addToSet(" + qid + ", false)'><i class='fas fa-file-alt'></i> Remove from Quiz</button>"
    qString += "<button onclick='deleteQuestion(" + qid + ", " + folder + ")' class='trashbtn btnqa'><i class='fas fa-trash-alt'></i> Delete</button></div>"
    Qbtn.innerHTML = qString
    QBox.appendChild(Qbtn);
    document.getElementById(qid + ":text").setAttribute("ondblclick", "convertQuestionToForm(this, 'title'," + folder + ", " + qid + ")");
    document.getElementById(qid + ":1").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
    document.getElementById(qid + ":2").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
    document.getElementById(qid + ":3").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
    document.getElementById(qid + ":4").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
    document.getElementById(qid + ":5").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");

    return Qbtn;
}
//Generates the element for a new or existing Set
function generateSEle(setID, folder, name, desc, user) {
    const QSBox = document.getElementById('QuestionSetBox');

    const node = document.createElement("div");
    const h1 = document.createElement("h1");
    const p = document.createElement("p");
    const btn = document.createElement("button");

    //configure node
    node.setAttribute("id", "QS:" + setID)
    node.setAttribute("class", "Set")
    node.classList.add("folderIter")
    node.setAttribute("onclick", "revealSetAssoc(" + setID + ", " + folder + ")")
        //configure h1 select, type, secondary, userID, folderID, setID
    h1.setAttribute("id", "QSN:" + setID)
    h1.setAttribute("ondblclick", "convertSetToForm(this, 'QSetN', '" + "QSD: +" + setID + "', " + user + ", " + folder + ", " + setID + ")");
    h1.setAttribute("class", "renamable")
    h1.innerText = name;
    //configure p
    p.setAttribute("id", "QSD:" + setID)
    p.setAttribute("ondblclick", "convertSetToForm(this, 'QSetD', '" + "QSN:" + setID + "', " + user + ", " + folder + ", " + setID + ")");
    p.setAttribute("class", "renamable")
    p.innerText = desc;

    //configure btn
    btn.setAttribute("type", "button");
    btn.classList.add("trashbtn")
    btn.classList.add("btnqa");
    btn.setAttribute("onclick", "deleteQSet(this, " + setID + ", " + folder + ")")
    btn.innerHTML = "<i class='fas fa-trash-alt'></i> Delete";
    //assemble node
    QSBox.appendChild(node);
    node.appendChild(h1);
    node.appendChild(p);
    node.appendChild(btn);
}
//Builds a new Question
async function newQuestion(folder, user) {
    //Define Element Components
    const QBox = document.getElementById("QuestionBox");
    const newQbtn = document.getElementById("newQbtn");

    const Q = new questionObj();
    //Make Entry into database
    const data = new FormData();
    data.append("question", true);
    data.append("new", true)
    data.append("location", folder);
    data.append("user", user);
    data.append("data", JSON.stringify(Q));
    const response = await fetch("pushRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("something went wrong");
    } else {
        const result = await response.text();
        let qid = result;

        //Build Element
        Qbtn = generateQEle(QBox, folder, user, qid, Q)

        QBox.insertBefore(Qbtn, newQbtn);
    }
}

//Swaps the login form to enable Registration
function adjustFormToRegister() {

    logele = document.getElementsByClassName("login");
    regele = document.getElementsByClassName("register");

    Array.prototype.forEach.call(logele, function(ele) {
        ele.setAttribute("style", "display:none");
    });
    Array.prototype.forEach.call(regele, function(ele) {
        ele.setAttribute("style", "display:block");
    });


    document.getElementById("regemail").required = true;
    document.getElementById("regpswconf").required = true;
    document.getElementById("regswitch").value = "true";
}

//Swaps the Registration form to enable login
function adjustFormToLogin() {

    logele = document.getElementsByClassName("login");
    regele = document.getElementsByClassName("register");

    Array.prototype.forEach.call(logele, function(ele) {
        ele.setAttribute("style", "display:block");
    });
    Array.prototype.forEach.call(regele, function(ele) {
        ele.setAttribute("style", "display:none");
    });


    document.getElementById("regemail").required = false;
    document.getElementById("regpswconf").required = false;
    document.getElementById("regswitch").value = "false";
}

//----------------------------------//