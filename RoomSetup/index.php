<?php include '../view/header.php';?>
<?php include '../model/question_db.php'?>
<!--This is where successful login attempts are sent, This is the configuration hub for new "Questions" and rooms owned by the user-->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
<main>
<div class="row">
    <div id="FolderColumn" class="column left">
        <div id="FolderBox" class="box" style="overflow-y: scroll">
            <div id="HeaderBox" class="lheader">
                <!--TODO check user for login status-->
                <div id="NewFolder">
                    <button type="button" class ="newfoldbtn btnqa" onclick="newFolder(<?php echo $_SESSION['id'] ?>)"><i class="fas fa-folder-plus"> Classroom Quiz Folder</i></button>
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
                            <button type="button" class="trashbtn btnqa" onclick="deleteFolder(this, <?php echo $index['folderID']; ?>, <?php echo $_SESSION['id']?>)"><i class="fas fa-trash-alt"></i> Delete</button>
                        </div>
            <?php endforeach; endif;?>
        </div>
    </div>
    <div id="QuestionColumn" class="column center">
        <div id="QuestionBox" style="overflow-y: scroll" class="box">
        </div>
    </div>
    <div id="QuestionSetColumn" class="column right">
        <div id="QuestionSetBox" class="box">

        </div>
    </div>
</div>
</main>
<?php include '../view/footer.php';?>