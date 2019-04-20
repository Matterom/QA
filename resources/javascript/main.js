//    main.js file by Matthew Nelson
//
//
//
//----------------------------------//
/////////////////////////
// Important Variables //
/////////////////////////

const modal = document.getElementById('id01');
let activeFolder = "";

//----------------------------------//

//////////////////////
// On Load function //
//////////////////////

window.addEventListener("load", function() {

}, false);


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

function updateClock() {
    var watch = document.getElementById("Watch");
    watch.innerHTML = "Time: " + time;
    time += 1;
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
    console.log(Q);
    return Q;
}

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
            console.log(i);
            if (!((i + 1) == ansArr.length) && !ansArr[i + 1].classList.contains("hidden")) {
                ansArr[i].innerHTML = ansArr[i + 1].innerHTML;
                ansArr[i + 1].innerHTML = "";
                chArr[i].firstChild.checked = chArr[i + 1].firstChild.checked
                ansArr[i + 1].nextSibling.firstChild.checked = false;
            } else {
                console.log("Hiding");
                ansArr[i].innerHTML = reset;
                ansArr[i].classList.add("hidden");
                chArr[i].classList.add("hidden");
            }
        }
    }
}

async function addChoice(qid) {
    const eleBox = document.getElementById("AB:" + qid);
    const ansArr = [document.getElementById(qid + ":1"),
        document.getElementById(qid + ":2"),
        document.getElementById(qid + ":3"),
        document.getElementById(qid + ":4"),
        document.getElementById(qid + ":5")
    ]
    for (let i = 0; i < ansArr.length; ++i) {
        if (ansArr[i].classList.contains("hidden")) {
            ansArr[i].classList.remove("hidden");
            ansArr[i].nextSibling.classList.remove("hidden");
            break;
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

//Converts a Text line to a form
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

function convertQuestionToForm(select, type, folderID, questionID) {
    select.setAttribute("style", "display:none");
    const input = document.createElement("textarea");
    input.innerHTML = select.innerHTML;
    input.setAttribute("autofocus", true);
    input.setAttribute("onkeyup", "updateQuestionFromForm(this, '" + type + "', " + folderID + ", " + questionID + ", false)");
    input.setAttribute("onfocusout", "updateQuestionFromForm(this, '" + type + "', " + folderID + ", " + questionID + ", true)");
    select.parentNode.insertBefore(input, select.nextSibling);

}

function convertSetToForm(select, type, secondary, userID, folderID, setID) {
    select.setAttribute("style", "display:none");
    let input;
    if (type == "QSetN") {
        input = document.createElement("input");
        input.setAttribute("value", select.innerHTML);
    } else {
        input = document.createElement("textarea");
        input.innerHTML = select.innerHTML;
    }
    input.setAttribute("autofocus", true);
    input.setAttribute("onkeyup", "updateSetFromForm(this, '" + type + "', '" + secondary + "', " + userID + ", " + folderID + ", " + setID + ", true)");
    input.setAttribute("onfocusout", "updateSetFromForm(this, '" + type + "', '" + secondary + "', " + userID + ", " + folderID + ", " + setID + ", true)");
    select.parentNode.insertBefore(input, select.nextSibling);
}
//Updates parent elements from input data, updates the sql to reflect new form data. carries on.
async function updateFolderFromForm(origin, type, secondary, userID, folderID, clickoff) {
    if ((!event.shiftKey & event.keyCode == 13) || clickoff) {
        target = origin.previousSibling;
        //Replace content from input to dom
        if (!origin.innerHTML == 0) {
            origin.previousSibling.innerHTML = origin.value;
            //Send to server
            let data = new FormData();
            data.append("folder", "true");
            data.append(type, origin.value);
            data.append("alternative", secondary);
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
                console.log(result);

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
            console.log(result)

            //remove form and reenable node if successful
            if (!target.classList.contains("hidden")) {
                target.setAttribute("style", "display:block");
            }
            origin.parentNode.removeChild(origin);
        }
    }

}
async function updateSetFromForm(origin, type, secondary, userId, folderID, setID, clickoff) {
    if ((!event.shiftKey & event.keyCode == 13) || clickoff) {

    }
}

//Toggles answerbox
function toggleAnswers(qid) {
    const ele = document.getElementById("AB:" + qid)
    if (ele.classList.contains("hidden")) {
        ele.classList.remove("hidden");
    } else {
        ele.classList.add("hidden");
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
    data.append("target", target);
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
        console.log(result);
        node.parentNode.removeChild(node);
    }
}
//Delete Question Set, Remove Element and ping server's PHP to remove from memory
async function deleteQSet(element, setID, user) {
    const node = element.parentNode;
    let data = new FormData();
    data.append("set", true)
    data.append("delete", true);
    data.append("target", setID);
    data.append("user", user); // not used but may be used later for security
    const response = await fetch("psuhRoomSetup.php", {
        method: 'POST',
        body: data
    });
    if (!response.ok) {
        console.log("Something went wrong attempting to delete Set, Not deleting set element")
    } else {
        //Delete the Node
        let result = await response.text()
        console.log(result);
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
        console.log(result);

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
        h1.setAttribute("ondblclick", "convertFolderToForm(this, 'folderN', '" + tempFolDesc + "', " + user + ", " + folderID + ")");
        h1.setAttribute("class", "renamable")
        h1.innerText = tempFolName;
        //configure p
        p.setAttribute("ondblclick", "convertFolderToForm(this, 'folderD', '" + tempFolName + "', " + user + ", " + folderID + ")");
        p.setAttribute("class", "renamable")
        p.innerText = tempFolDesc;

        //configure btn
        btn.setAttribute("type", "button");
        btn.setAttribute("onclick", "deleteFolder(this, " + folderID + ", " + user + ")")
        btn.innerText = "TRASHICON";
        //assemble node
        folderbox.appendChild(node);
        node.appendChild(h1);
        node.appendChild(p);
        node.appendChild(btn);
    }
}

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
                const Qbtn = document.createElement("div");
                Qbtn.classList = "question";
                Qbtn.setAttribute("id", "Q:" + qid);

                let qString = "<div class='QHead'><div id='" + qid + ":text' class='text'>" + Q.text + "</div><div onclick='toggleAnswers(" + qid + ")' class='arrow'>Arrow</div></div>"
                qString += "<div id='AB:" + qid + "' class='answerBox hidden'>"
                qString += "<div id='" + qid + ":1" + "' class='ans1 " + Q.answer.one[2] + "'>" + Q.answer.one[1] + "</div><div id='" + qid + ":ch1' class='ch1 " + Q.answer.one[2] + "'><input type='checkbox' name='answerOne' value='true' " + (Q.answer.one[0] ? "checked='true'" : "") + "/></div>"
                qString += "<div id='" + qid + ":2" + "' class='ans2 " + Q.answer.two[2] + "'>" + Q.answer.two[1] + "</div><div id='" + qid + ":ch2' class='ch2 " + Q.answer.two[2] + "'><input type='checkbox' name='answerTwo' value='true' " + (Q.answer.two[0] ? "checked='true'" : "") + "/></div>"
                qString += "<div id='" + qid + ":3" + "' class='ans3 " + Q.answer.three[2] + "'>" + Q.answer.three[1] + "</div><div id='" + qid + ":ch3' class='ch3 " + Q.answer.three[2] + "'><input type='checkbox' name='answerThree' value='true' " + (Q.answer.three[0] ? "checked='true'" : "") + "/></div>"
                qString += "<div id='" + qid + ":4" + "' class='ans4 " + Q.answer.four[2] + "'>" + Q.answer.four[1] + "</div><div id='" + qid + ":ch4' class='ch4 " + Q.answer.four[2] + "'><input type='checkbox' name='answerFour' value='true' " + (Q.answer.four[0] ? "checked='true'" : "") + "/></div>"
                qString += "<div id='" + qid + ":5" + "' class='ans5 " + Q.answer.five[2] + "'>" + Q.answer.five[1] + "</div><div id='" + qid + ":ch5' class='ch5 " + Q.answer.five[2] + "'><input type='checkbox' name='answerFive' value='true' " + (Q.answer.five[0] ? "checked='true'" : "") + "/></div>"
                qString += "</div>"
                qString += "<div id='" + qid + ":args' class='hidden'>" + "TF::" + Q.args.TF + "</div>"
                qString += "<div class='btnHolder'>"
                qString += "<button onclick=addChoice(" + qid + ")>Add Answer Choice</button>"
                qString += "<button>TrueFalse</button>"
                qString += "<button class='QSetLinkBTN hidden'>Add To Current Set</button>"
                qString += "<button onclick='deleteQuestion(" + qid + ", " + folder + ")'>Trash</button></div>"
                Qbtn.innerHTML = qString
                QBox.appendChild(Qbtn);
                document.getElementById(qid + ":text").setAttribute("ondblclick", "convertQuestionToForm(this, 'title'," + folder + ", " + qid + ")");
                document.getElementById(qid + ":1").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
                document.getElementById(qid + ":2").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
                document.getElementById(qid + ":3").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
                document.getElementById(qid + ":4").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
                document.getElementById(qid + ":5").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
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
async function queryQuizSet(folder, user) {
    const QSBox = document.getElementById('QuestionSetBox');
    //Clear box and Regenerate
    QSBox.innerHTML = "<div id='NewSet'><button type='button' onclick='newSet()'>New Set Icon</button></div>";
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
            let qsName = sList[i].setName;
            let qSID = sList[i].setID;
            //Build Element
            const qSBtn = document.createElement("div");
            qSBtn.classList = "setClass";
            qSBtn.setAttribute("id", "S:" + qSID);
            qSBtn.innerHTML = "<div class='Details' onclick='querySetQuestions(this, " + folder + ", " + qSID + ", " + user + ")'>"
            qSBtn.innerHTML += "<h1>" + qsName + "</h1><p>" + qsDesc + "</p></div>"
            qSBtn.innerHTML += "<div class='qsetbtnbox'><button onclick='deleteQSet(this, " + folder + ", " + qSID + ", " + user + ")'>DELETE</button><button>PUBLISH</button></div>"
            qSBtn.innerHTML += "</div>"
            QSBox.appendChild(qSBtn);
        }
    }
}

async function newQuestion(folder, user) {
    //Define Element Components
    const QBox = document.getElementById("QuestionBox");
    const newQbtn = document.getElementById("newQbtn");
    const Qbtn = document.createElement("div");
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
        console.log(result);
        //Basic Structure of the Question Object
        Qbtn.classList = "question";
        Qbtn.setAttribute("id", "Q:" + qid);

        const onclickinsertT = "onclick='convertQuestionToForm(this,'title'," + folder + "," + qid + ")'"
        const onclickinsertA = "onclick='convertQuestionToForm(this,'answer'," + folder + "," + qid + ")'"

        let qString = "<div class='QHead'><div id='" + qid + ":text' class='text'>" + Q.text + "</div><div onclick='toggleAnswers(" + qid + ")' class='arrow'>Arrow</div></div>"
        qString += "<div id='AB:" + qid + "' class='answerBox hidden'>"
        qString += "<div id='" + qid + ":1" + "' class='ans1 " + Q.answer.one[2] + "'>" + Q.answer.one[1] + "</div><div id='" + qid + ":ch1' class='ch1 " + Q.answer.one[2] + "'><input type='checkbox' name='answerOne' value='true' " + (Q.answer.one[0] ? "checked='true'" : "") + "/></div>"
        qString += "<div id='" + qid + ":2" + "' class='ans2 " + Q.answer.two[2] + "'>" + Q.answer.two[1] + "</div><div id='" + qid + ":ch2' class='ch2 " + Q.answer.two[2] + "'><input type='checkbox' name='answerTwo' value='true' " + (Q.answer.two[0] ? "checked='true'" : "") + "/></div>"
        qString += "<div id='" + qid + ":3" + "' class='ans3 " + Q.answer.three[2] + "'>" + Q.answer.three[1] + "</div><div id='" + qid + ":ch3' class='ch3 " + Q.answer.three[2] + "'><input type='checkbox' name='answerThree' value='true' " + (Q.answer.three[0] ? "checked='true'" : "") + "/></div>"
        qString += "<div id='" + qid + ":4" + "' class='ans4 " + Q.answer.four[2] + "'>" + Q.answer.four[1] + "</div><div id='" + qid + ":ch4' class='ch4 " + Q.answer.four[2] + "'><input type='checkbox' name='answerFour' value='true' " + (Q.answer.four[0] ? "checked='true'" : "") + "/></div>"
        qString += "<div id='" + qid + ":5" + "' class='ans5 " + Q.answer.five[2] + "'>" + Q.answer.five[1] + "</div><div id='" + qid + ":ch5' class='ch5 " + Q.answer.five[2] + "'><input type='checkbox' name='answerFive' value='true' " + (Q.answer.five[0] ? "checked='true'" : "") + "/></div>"
        qString += "</div>"
        qString += "<div id='" + qid + ":args' class='hidden'>" + "TF::" + Q.args.TF + "</div>"
        qString += "<div class='btnHolder'>"
        qString += "<button onclick=addChoice(" + qid + ")>Add Answer Choice</button>"
        qString += "<button>TrueFalse</button>"
        qString += "<button class='QSetLinkBTN hidden'>Add To Current Set</button>"
        qString += "<button onclick='deleteQuestion(" + qid + ", " + folder + ")'>Trash</button></div>"
        Qbtn.innerHTML = qString
        QBox.appendChild(Qbtn);
        document.getElementById(qid + ":text").setAttribute("ondblclick", "convertQuestionToForm(this, 'title'," + folder + ", " + qid + ")");
        document.getElementById(qid + ":1").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
        document.getElementById(qid + ":2").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
        document.getElementById(qid + ":3").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
        document.getElementById(qid + ":4").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
        document.getElementById(qid + ":5").setAttribute("ondblclick", "convertQuestionToForm(this, 'answer'," + folder + ", " + qid + ")");
        //Build Element
        QBox.insertBefore(Qbtn, newQbtn);
    }
}



//Swaps the login form to enable Registration
function adjustFormToRegister() {

    logele = document.getElementsByClassName("login");
    regele = document.getElementsByClassName("register");

    Array.prototype.forEach.call(logele, function(ele) {
        ele.setAttribute("style", "display:none");
        console.log(ele);
        console.log("i tried first");
    });
    Array.prototype.forEach.call(regele, function(ele) {
        ele.setAttribute("style", "display:block");
        console.log("i tried");
    });


    document.getElementById("regemail").required = true;
    document.getElementById("regpswconf").required = true;
    document.getElementById("regswitch").value == "true";
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
    document.getElementById("regswitch").value == "false";
}

//----------------------------------//