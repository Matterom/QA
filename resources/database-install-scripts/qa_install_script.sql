/*************** qa_install_script.sql ***************
* Class:    CS/CINF Senior Project
* Group:    Q and A
* Purpose:  Consolidated SQL install script
****************************************************/

-- Create Database
DROP DATABASE IF EXISTS qaproject; 
CREATE DATABASE IF NOT EXISTS qaproject DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE qaproject;

/*
-----------------------------------------
-- TABLE CREATION AND TRIGGERS SECTION --
-----------------------------------------
*/

/********** Accounts **********
Triggers:   Convert password to MD5 hash before saving.
Notes:      Additional index on accounts.username
*/
DROP TABLE IF EXISTS accounts;
CREATE TABLE IF NOT EXISTS accounts (
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(62) NOT NULL,
  email varchar(62) UNIQUE,
  account_password char(32) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;
-- Index on accounts.username
CREATE INDEX idx_account_usernames on accounts(username);

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS hash_passwords
BEFORE INSERT ON accounts
FOR EACH ROW
BEGIN
    set new.account_password = md5(new.account_password);
END $$
DELIMITER ;

/********** Rosters **********
Syntax: INSERT INTO rosters (rosterHostID, rosterName) VALUES()
Constraints:    FK for rosterHostID from accounts(id)
*/
CREATE TABLE IF NOT EXISTS rosters (
    rosterID int(8) AUTO_INCREMENT,
    rosterHostID int(11) NOT NULL,
    rosterName varchar(40) NOT NULL,
    attendee_count int(4) DEFAULT 0,
    PRIMARY KEY (rosterID),
    CONSTRAINT rosterHostID_fk FOREIGN KEY (rosterHostID)
        REFERENCES accounts(id),
    CONSTRAINT unique_rosterName_host_pair UNIQUE(rosterName,rosterHostID)
) ;


/********** Rooms **********
Syntax: "INSERT IGNORE INTO rooms (ownerID, rosterID, roomKey) 
            VALUES (@id, @roster, NULL)"
Constraints: FK for rosterID (rosters)
Trigger Algorithm:  Auto-generate a 6-digit alphanumeric key for roomKey and
                    set start_time to NOW.
Notes:  Current_Question_ID can be is a link to the question currently posted
        in a room. When a question ceases to be available it points to the next
        question. If it is NULL, no questions will be accessible. 
        ******** THIS LOGIC MUST BE IMPLEMENTED IN PHP ********
        To do so, the attendees' page will need to select the current_question_id
        and then select that value from publishedquestions.questionID.
*/
Create TABLE IF NOT EXISTS rooms (
    room_id int(11) NOT NULL AUTO_INCREMENT,
    ownerID int(11) NOT NULL,
    roomKey varchar(6) NOT NULL,
    rosterID int(8), -- CAN BE NULL FOR ANONYMOUS QUIZ
    start_time TIMESTAMP NOT NULL,
    active_connections int DEFAULT 0,
    current_question_id int(11) DEFAULT NULL,
    PRIMARY KEY (room_id),
    CONSTRAINT rooms_roster_fk FOREIGN KEY (rosterID)
        REFERENCES rosters(rosterID),
    CONSTRAINT room_owner_fk FOREIGN KEY (ownerID)
        REFERENCES accounts(id),
    CONSTRAINT unique_roomKey UNIQUE INDEX (roomKey)
) ;

CREATE INDEX idx_roomKeys on rooms(roomKey);

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS rooms_config_BI
BEFORE INSERT ON rooms
FOR EACH ROW
BEGIN
    declare rnd_str varchar(6);
    declare rdy int;
    set rdy = 0;
    if isnull(NEW.roomKey) THEN
        while (not rdy) do
            set rnd_str := lpad(conv(floor(rand()*pow(36,6)), 10, 36), 6, 0);
            if not exists (select * from rooms where roomKey = rnd_str) then
                set NEW.roomKey := rnd_str;
                set rdy = 1;
            end if;
        end while;
    end if;
    set new.start_time = NOW();
END $$
DELIMITER ;


/********** ATTENDEES **********
Syntax: "INSERT INTO ATTENDEES (attendeeID, rosterID) VALUES ()"
Constraints: FK for rosterID (rosters)
Trigger Algorithm:  Increment the attendance_count of the row in rosters
                    which matches the given rosterID.
*/
CREATE TABLE IF NOT EXISTS attendees (
    attendeeID int(11) NOT NULL,
    rosterID int(8) NOT NULL,
    PRIMARY KEY (attendeeID,rosterID),
    CONSTRAINT attendee_rosterID_fk FOREIGN KEY (rosterID)
        REFERENCES rosters(rosterID) ON DELETE CASCADE ON UPDATE CASCADE
) ;

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS tr_attendees_update_roster_ai
BEFORE INSERT ON attendees
FOR EACH ROW
BEGIN   
    UPDATE rosters SET attendee_count = attendee_count + 1
      WHERE rosters.rosterID = new.rosterID;
END $$
DELIMITER ;


/********** Attendance_Records **********
Syntax: "INSERT IGNORE INTO attendancerecords (attendeeID, roomKey) VALUES()"
Constraints: FK for roomKey (rooms) and attendeeID (attendees)
Trigger Algorithm:  Check that attendee is a member of the roster associated with
                    the given roomKey. If so, set the date to current_date and
                    insert. Otherwise, send signal 45000 error.
*/
CREATE TABLE IF NOT EXISTS attendancerecords (
    attendeeID int(11) NOT NULL,
    roomKey varchar(6) NOT NULL,
    attendance_date DATE NOT NULL,
    PRIMARY KEY (attendeeID, roomKey, attendance_date),
    CONSTRAINT attendance_record_roomKey_fk FOREIGN KEY (roomKey)
        REFERENCES rooms(roomKey),
    CONSTRAINT attendance_record_attendeeID_fk FOREIGN KEY (attendeeID)
        REFERENCES attendees(attendeeID)
) ;

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS tr_attendance_record_bi
BEFORE INSERT ON attendancerecords
FOR EACH ROW
BEGIN
    if (SELECT isnull(rosterID) FROM rooms WHERE roomKey = NEW.roomKey) = 0 THEN
        set new.attendance_date = current_date();
    elseif (SELECT COUNT(*) FROM rooms join attendees 
        WHERE rooms.roomKey = new.roomKey
        AND new.attendeeID = attendees.attendeeID
        AND rooms.rosterID = attendees.rosterID) > 0 THEN
            set new.attendance_date = current_date();
    else
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Attendee does not have access to this room.';
    end if;
end $$
DELIMITER ;

-- Create User_Folder
CREATE TABLE IF NOT EXISTS questionfolders (
    folderID int(11) NOT NULL AUTO_INCREMENT,
    ownerID int(11) NOT NULL,
    folderName varchar(32) NOT NULL,
    folderDescription varchar(64) NOT NULL,
    PRIMARY KEY (folderID),
    CONSTRAINT question_folder_owner_account_fk FOREIGN KEY (ownerID)
        REFERENCES accounts(id)
) ;

-- Create Question
CREATE TABLE IF NOT EXISTS questions (
    questionID int(11) NOT NULL AUTO_INCREMENT,
    folderID int(11) NOT NULL,
    questionText varchar(124) NOT NULL,
    PRIMARY KEY (questionID),
    Constraint question_Qfolder_fk FOREIGN KEY (folderID)
        REFERENCES questionfolders(folderID) ON DELETE CASCADE ON UPDATE CASCADE
) ;


/********** QuestionSet **********
Syntax: INSERT INTO questionsets (col1 ,col2, col3)
        SELECT col1, col2, col3 FROM Questions where 
*/
CREATE TABLE IF NOT EXISTS questionsets (  
    questionSetID int(11) AUTO_INCREMENT,
    questionSetName varchar(31) NOT NULL,
    folderID int(11) NOT NULL,
    PRIMARY KEY (questionSetID),
    CONSTRAINT questionSet_folder_fk FOREIGN KEY (folderID)
        REFERENCES questionfolders(folderID)
);

/********** QuestionSetPairings **********
*/
CREATE TABLE questionsetpairings (
    pairingID int(11) AUTO_INCREMENT,
    questionID int(11) NOT NULL,
    questionSetID int(11) NOT NULL,
    PRIMARY KEY (pairingID),
    CONSTRAINT qsp_question FOREIGN KEY (questionID)
        REFERENCES questions(questionID),
    CONSTRAINT qsp_qSet_fk FOREIGN KEY (questionSetID)
        REFERENCES questionsets(questionSetID)
);

/********** PublishedQuizzes **********
Syntax:         PublishedQuizzes are created *EXCLUSIVELY* through the stored
                procedure "publish_quiz_folder"
Constraints:    FK for Room_ID (rooms)
*/
CREATE TABLE IF NOT EXISTS publishedquizzes (
    quizID int(11) NOT NULL AUTO_INCREMENT,
    roomKey varchar(6) NOT NULL,
    room_start_time TIMESTAMP,
    PRIMARY KEY (quizID, roomKey),
    CONSTRAINT pubQuiz_roomKey_fk FOREIGN KEY (roomKey)
        REFERENCES rooms(roomKey)
) ;


/********** PublishedQuestions **********
Syntax:         Published Questions are created *EXCLUSIVELY* through the stored
                procedure "publish_quiz_folder"
Constraints:    FK for quizID (PublishedQuizzes)
*/
CREATE TABLE IF NOT EXISTS publishedquestions (
    quizID int(11) NOT NULL,
    question_id int(11) NOT NULL AUTO_INCREMENT,
    question_text varchar(124) NOT NULL,
    PRIMARY KEY (question_id, quizID),
    CONSTRAINT pubQuest_pubQuiz_fk FOREIGN KEY (quizID)
        REFERENCES publishedquizzes (quizID) ON DELETE CASCADE
) ;


CREATE TABLE questionanswers (
    answerID int(11) AUTO_INCREMENT,
    answerPOS set('1', '2', '3','4','5'),
    questionID int(11),
    answer varchar(124),
    PRIMARY KEY (answerID),
    CONSTRAINT answer_question_fk FOREIGN KEY (questionID)
    	REFERENCES questions(questionID)
    );
    
/********** Quiz Attempts **********
Syntax:         INSERT INTO quizattempts (roomKey, attendeeID, quizID) 
                    VALUES (@key, @attendee, NULL)
Constraints:    FK on quizID and roomKey from published_quizzes
Triggers:       Auto-fill quizID. Create an attendance record if non exists. Check
                    if attendee has access to given quiz.
*/
CREATE TABLE quizattempts (
    attempt_id int(11) NOT NULL AUTO_INCREMENT,
    roomKey varchar(6) NOT NULL,
    quizID int(11) NOT NULL,
    attendeeID int(11) NOT NULL,
    PRIMARY KEY (attempt_id),
    CONSTRAINT unique_quiz UNIQUE(quizID, attendeeID),
    CONSTRAINT published_quiz_room_quizID_fk FOREIGN KEY (quizID, roomKey)
        REFERENCES publishedquizzes (quizID, roomKey) ON DELETE CASCADE ON UPDATE CASCADE
) ;

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS tr_quiz_attempts_bi
BEFORE INSERT ON quizattempts
FOR EACH ROW
BEGIN
    -- Set the quizID value
    SET new.quizID = (SELECT quizID FROM PublishedQuizzes 
        WHERE roomKey = new.roomKey);

    -- INSERT NEW AttendanceRecord if one doesn't already exist
    if (SELECT COUNT(*) FROM attendancerecords 
            WHERE roomKey = NEW.roomKey AND 
                attendeeID = NEW.attendeeID) = 0 THEN
        INSERT INTO attendancerecords (roomKey, attendeeID) 
            VALUES (new.roomKey, new.attendeeID);
    end if;

    -- Check if the room is associated with a roster. If it is, check if the attendee has access.
    if (SELECT isnull (rosterID) FROM rooms WHERE roomKey = NEW.roomKey) = 0 THEN
        if (SELECT COUNT(*) FROM rooms join attendees 
            WHERE roomKey = new.roomKey
            AND attendeeID = new.attendeeID
            AND rooms.rosterID = attendees.rosterID) = 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Attendee does not have access to this room.';
        end if;
    end if;

    UPDATE rooms SET active_connections = active_connections +1 
        WHERE roomKey = NEW.roomKey;
end $$
DELIMITER ;

-- Create AnswerSubmission (a answer the the attendee provides, linked to a quiz attempt)
CREATE TABLE IF NOT EXISTS answersubmissions (
    ans_submit_id int(11) AUTO_INCREMENT,
    quiz_attempt_id int(11) NOT NULL,
    question_id int(11) NOT NULL,
    answer_choice ENUM('a', 'b', 'c', 'd','e'),
    PRIMARY KEY (ans_submit_id),
    CONSTRAINT ans_sub_quiz_attempt_fk FOREIGN KEY (quiz_attempt_id)
        REFERENCES quizattempts (attempt_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ans_question_fk FOREIGN KEY (question_id)
        REFERENCES publishedquestions (question_id)
) ;

/*
-------------------------------
-- STORED PROCEDURES SECTION --
-------------------------------
*/

/********** Publish Quiz Folder **********
Parameters: fold_id - ID of the folder which houses the questions
            r_id - ID of the room where the quiz is being published.
Algorithm:  INSERT publishedquizzes row using paramater r_id
            INSERT publishedquestions row for each question which
              has the same folderID as the parameter fold_id and
              set the quizID for each with the quizID which was
              generated for the row created in previous step. */


DELIMITER $$
CREATE PROCEDURE publish_quiz_folder
(IN fold_id int(11), IN r_key varchar(6))
BEGIN
    INSERT IGNORE INTO publishedquizzes (roomKey) VALUES (r_key);
    SELECT @qid := quizID
      FROM publishedquizzes
      WHERE publishedquizzes.roomKey = r_key;
    INSERT IGNORE INTO publishedquestions (quizID, question_id, question_text, answer_a, answer_b,
                                            answer_c, answer_d, answer_e, correct_answer)
        SELECT @qid, question_id, question_text, answer_a, answer_b, answer_c, answer_d, answer_e, correct_answer
        FROM questions WHERE questions.folderID = fold_id;
end $$
DELIMITER ;

-- Add access permissions
GRANT USAGE ON *.* TO 'lnsys'@'localhost' IDENTIFIED BY PASSWORD '*571B02166B46C27003D2E30B815657658C800579';
GRANT SELECT, INSERT, UPDATE ON qaproject.* TO 'lnsys'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'quesys'@'localhost' IDENTIFIED BY PASSWORD '*D980CF29D2D015AFC048830684D401BF66FFE09D';
