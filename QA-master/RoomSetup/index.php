<?php include '../view/header.php';?>
<?php include '../model/question_db.php'?>
<!--This is where successful login attempts are sent, This is the configuration hub for new "Questions" and rooms owned by the user-->
<main>
<div class="row">
    <div id="FolderColumn" class="column left">
        <div id="FolderBox" class="box" style="overflow-y: scroll">
            <div id="HeaderBox" class="lheader">
                <!--TODO check user for login status-->
                <div id="NewFolder">
                    <button type="button" onclick="newFolder(<?php echo $_SESSION['id'] ?>)">NEW FOLDER ICON</button>
                </div>
            </div>
            <!--Pull Folders From User-->
            <?php 
                $folders = getFolders($_SESSION['id']);
                if (sizeof($folders) > 0) :
                    foreach($folders as $i=>$index) :?>
                        <div class="folderIter dragable" onclick="queryQuestionList(<?php echo $index['folderID']?>, <?php echo $_SESSION['id']?>)">
                            <h1 ondblclick="convertFolderToForm(this, 'folderN', '<?php echo $index['folderDescription']?>', '<?php echo $_SESSION['id']?>', '<?php echo $index['folderID']; ?>')" class="renameable"><?php echo $index['folderName'];?></h1>
                            <p ondblclick="convertFolderToForm(this, 'folderD', '<?php echo $index['folderName']?>', '<?php echo $_SESSION['id']?>', '<?php echo $index['folderID']; ?>')" class="renamable"><?php echo $index['folderDescription'];?></p>
                            <button type="button" onclick="deleteFolder(this, <?php echo $index['folderID']; ?>, <?php echo $_SESSION['id']?>)">TRASHICON</button>
                        </div>
            <?php endforeach; endif;?>
        </div>
    </div>
    <div id="QuestionColumn" class="column center">
        <div id="QuestionBox" style="overflow-y: scroll" class="box">
            <!--Question List Generator-->
            <!--Handled by pure JS-->
            <!--div id="TestQuestion" class="question">
                <div class="QHead">
                    <div class="text">Question Text</div>
                    <div class="arrow">Arrow</div>
                </div>
                <div class="answer">Answer 1</div>
                <div class="answer">Answer 2</div>
                <div class="answer">Answer 3</div>
                <div class="answer">Answer 4</div>
                <div class="answer">Answer 5</div>
                <div class="btnHolder">
                    <button>TrueFalse</button>
                    <button>Trash</button>
                </div>
            </div-->
        </div>
    </div>
    <div id="QuestionSetColumn" class="column right">
        <div id="QuestionSetBox" class="box">
            <div id="QuestionSetHeader" class="lheader">
                <div id="NewSet">
                    <button type="button" onclick="newSet()">New Set Icon</button>
                </div>
                <div id="TestSet" class="setIter">
                    
                </div>
            </div>
            <!--Pull Set List from database-->
            <?php  ?>
        </div>
    </div>
</div>
</main>
<?php include '../view/footer.php';?>