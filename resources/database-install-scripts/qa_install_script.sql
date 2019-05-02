/*************** qa_install_script.sql ***************
* Class:    CS/CINF Senior Project
* Group:    Q and A
* Purpose:  Consolidated SQL install script
****************************************************/

/*
-----------------------------------------
-- DATABASE DROP AND CREATE -------------
-----------------------------------------
*/
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
CREATE TABLE IF NOT EXISTS accounts (
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(62) NOT NULL,
  email varchar(62) UNIQUE,
  password char(32) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;
-- Index on accounts.username
CREATE INDEX idx_account_usernames on accounts(username);

DROP TRIGGER IF EXISTS hash_passwords;
DELIMITER $$
CREATE TRIGGER hash_passwords
BEFORE INSERT ON accounts
FOR EACH ROW
BEGIN
    set NEW.password = md5(NEW.password);
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
Notes:  Current_questionID can be is a link to the question currently posted
        in a room. When a question ceases to be available it points to the next
        question. If it is NULL, no questions will be accessible. 
        ******** THIS LOGIC MUST BE IMPLEMENTED IN PHP ********
        To do so, the attendees' page will need to select the current_questionID
        and then select that value from publishedquestions.questionID.
*/
Create TABLE IF NOT EXISTS rooms (
    roomID int(11) NOT NULL AUTO_INCREMENT,
    ownerID int(11) NOT NULL,
    roomKey varchar(6) NOT NULL,
    rosterID int(8) DEFAULT NULL, -- CAN BE NULL FOR ANONYMOUS QUIZ
    qSetID int(11),
    start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active_connections int DEFAULT 0,
    current_questionID int(11) DEFAULT NULL,
    PRIMARY KEY (roomID),
    CONSTRAINT rooms_roster_fk FOREIGN KEY (rosterID)
        REFERENCES rosters(rosterID),
    CONSTRAINT room_owner_fk FOREIGN KEY (ownerID)
        REFERENCES accounts(id),
    CONSTRAINT unique_roomKey UNIQUE INDEX (roomKey)
) ;

CREATE INDEX idx_roomKeys on rooms(roomKey);

DROP TRIGGER IF EXISTS rooms_config_bi;
DELIMITER $$
CREATE TRIGGER rooms_config_bi
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
    set NEW.start_time = NOW();
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

DROP TRIGGER IF EXISTS tr_attendees_update_roster_ai
DELIMITER $$
CREATE TRIGGER tr_attendees_update_roster_ai
BEFORE INSERT ON attendees
FOR EACH ROW
BEGIN   
    UPDATE rosters SET attendee_count = attendee_count + 1
      WHERE rosters.rosterID = NEW.rosterID;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS tr_attendees_update_roster_bd;
DELIMITER $$
CREATE TRIGGER tr_attendees_update_roster_bd
BEFORE DELETE ON attendees
FOR EACH ROW
BEGIN
    UPDATE rosters set attendee_count = attendee_count - 1
        WHERE rosters.rosterID = OLD.rosterID;
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

DROP TRIGGER IF EXISTS tr_attendance_record_bi;
DELIMITER $$
CREATE TRIGGER tr_attendance_record_bi
BEFORE INSERT ON attendancerecords
FOR EACH ROW
BEGIN
    if (SELECT isnull(rosterID) FROM rooms WHERE roomKey = NEW.roomKey) = 0 THEN
        set NEW.attendance_date = current_date();
    elseif (SELECT COUNT(*) FROM rooms join attendees 
        WHERE rooms.roomKey = NEW.roomKey
        AND NEW.attendeeID = attendees.attendeeID
        AND rooms.rosterID = attendees.rosterID) > 0 THEN
            set NEW.attendance_date = current_date();
    else
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Attendee does not have access to this room.';
    end if;
end $$
DELIMITER ;

-- Create question folder
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
CREATE TABLE IF NOT EXISTS questiontable (
    questionID int(11) NOT NULL AUTO_INCREMENT,
    folderID int(11) NOT NULL,
    question text NOT NULL,
    PRIMARY KEY (questionID),
    Constraint question_Qfolder_fk FOREIGN KEY (folderID)
        REFERENCES questionfolders(folderID) ON DELETE CASCADE ON UPDATE CASCADE
) ;


/********** QuestionSet **********
Syntax: INSERT INTO questionsets (col1 ,col2, col3)
        SELECT col1, col2, col3 FROM Questions where 
*/
CREATE TABLE IF NOT EXISTS questionsets (  
    qSetID int(11) NOT NULL AUTO_INCREMENT,
    qSetName varchar(31) NOT NULL,
    qSetDesc text NOT NULL,
    folderID int(11) NOT NULL,
    PRIMARY KEY (qSetID),
    CONSTRAINT questionSet_folder_fk FOREIGN KEY (folderID)
        REFERENCES questionfolders(folderID),
    CONSTRAINT un_qSet_folderID UNIQUE (qSetName, folderID)
);

/********** QuestionSetPairings **********
*/
CREATE TABLE questionsetpairings (
    qID int(11) NOT NULL,
    qsetID int(11) NOT NULL,
    PRIMARY KEY (qID, qsetID)
);

/********** Quiz Attempts **********
Syntax:         INSERT INTO quizattempts (roomKey, attendeeID, quizID) 
                    VALUES (@key, @attendee, NULL)
Constraints:    FK on quizID and roomKey from published_quizzes
Triggers:       Auto-fill quizID. Create an attendance record if non exists. Check
                    if attendee has access to given quiz.
*/
CREATE TABLE quizattempts (
    attemptID int(11) NOT NULL AUTO_INCREMENT,
    roomKey varchar(6) NOT NULL,
    quizID int(11) NOT NULL,
    attendeeID int(11) NOT NULL,
    PRIMARY KEY (attemptID),
    CONSTRAINT unique_quiz UNIQUE(quizID, attendeeID),
    CONSTRAINT quizattempt_quizID_fk FOREIGN KEY (quizID)
        REFERENCES questionsetpairings (qID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT quizattempt_roomkey_fk FOREIGN KEY (roomKey) 
        REFERENCES rooms (roomKey)
) ;

DROP TRIGGER IF EXISTS trg_create_quiz_from_roomkey_bi;
DELIMITER $$
CREATE TRIGGER trg_create_quiz_from_roomkey_bi 
BEFORE INSERT ON quizattempts
FOR EACH ROW
BEGIN
    if (isnull(NEW.quizID)) THEN
        SET NEW.quizID =(SELECT qSetID FROM rooms WHERE rooms.roomKey = NEW.roomKey);
    end if;
END $$
DELIMITER ;

/* Doesn't work - connected to prior table called PublishedQuizzes
DROP TRIGGER IF EXISTS tr_quiz_attempts_bi;
DELIMITER $$
CREATE TRIGGER tr_quiz_attempts_bi
BEFORE INSERT ON quizattempts
FOR EACH ROW
BEGIN
    -- Set the quizID value
    SET NEW.quizID = (SELECT quizID FROM PublishedQuizzes 
        WHERE roomKey = NEW.roomKey);

    -- INSERT NEW AttendanceRecord if one doesn't already exist
    if (SELECT COUNT(*) FROM attendancerecords 
            WHERE roomKey = NEW.roomKey AND 
                attendeeID = NEW.attendeeID) = 0 THEN
        INSERT INTO attendancerecords (roomKey, attendeeID) 
            VALUES (NEW.roomKey, NEW.attendeeID);
    end if;

    -- Check if the room is associated with a roster. If it is, check if the attendee has access.
    if (SELECT isnull (rosterID) FROM rooms WHERE roomKey = NEW.roomKey) = 0 THEN
        if (SELECT COUNT(*) FROM rooms join attendees 
            WHERE roomKey = NEW.roomKey
            AND attendeeID = NEW.attendeeID
            AND rooms.rosterID = attendees.rosterID) = 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Attendee does not have access to this room.';
        end if;
    end if;

    UPDATE rooms SET active_connections = active_connections +1 
        WHERE roomKey = NEW.roomKey;
end $$
DELIMITER ;
*/

-- Create AnswerSubmission (a answer the the attendee provides, linked to a quiz attempt)
CREATE TABLE IF NOT EXISTS answersubmissions (
    answerSubmitID int(11) AUTO_INCREMENT,
    quizAttemptID int(11) NOT NULL,
    questionID int(11) NOT NULL,
    answer_choice ENUM('a', 'b', 'c', 'd','e'),
    PRIMARY KEY (answerSubmitID),
    CONSTRAINT ans_sub_quiz_attempt_fk FOREIGN KEY (quizAttemptID)
        REFERENCES quizattempts (attemptID) ON DELETE CASCADE ON UPDATE CASCADE
) ;


ALTER TABLE rooms 
ADD CONSTRAINT room_qSet_fk FOREIGN KEY(qSetID)
        REFERENCES questionsets(qSetID);
/*
-------------------------------
-- STORED PROCEDURES SECTION --
-------------------------------
*/

-- Add access permissions
GRANT USAGE ON *.* TO 'lnsys'@'localhost' IDENTIFIED BY PASSWORD '*571B02166B46C27003D2E30B815657658C800579';
GRANT SELECT, INSERT, UPDATE ON qaproject.* TO 'lnsys'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'quesys'@'localhost' IDENTIFIED BY PASSWORD '*D980CF29D2D015AFC048830684D401BF66FFE09D';
