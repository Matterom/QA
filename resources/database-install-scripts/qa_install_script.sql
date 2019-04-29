/*************** qa_install_script.sql ***************
* Class:    CS/CINF Senior Project
* Group:    Q and A
* Purpose:  Consolidated SQL install script
****************************************************/

-- Create Database
DROP DATABASE IF EXISTS qaproject; 
CREATE DATABASE IF NOT EXISTS qaproject DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE qaproject;

-- Add access permissions
GRANT USAGE ON *.* TO 'lnsys'@'localhost' IDENTIFIED BY PASSWORD '*571B02166B46C27003D2E30B815657658C800579';
GRANT SELECT, INSERT, UPDATE ON qaproject.* TO 'lnsys'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'quesys'@'localhost' IDENTIFIED BY PASSWORD '*D980CF29D2D015AFC048830684D401BF66FFE09D';

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
  username varchar(62),
  email varchar(62) NOT NULL UNIQUE,
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
Syntax: INSERT INTO rosters (roster_host_id, roster_name) VALUES()
Constraints:    FK for roster_host_id from accounts(id)
*/
CREATE TABLE IF NOT EXISTS rosters (
    roster_id int(8) AUTO_INCREMENT,
    roster_host_id int(11) NOT NULL,
    roster_name varchar(40) NOT NULL,
    attendee_count int(4) DEFAULT 0,
    PRIMARY KEY (roster_id),
    CONSTRAINT roster_host_id_fk FOREIGN KEY (roster_host_id)
        REFERENCES accounts(id),
    CONSTRAINT unique_roster_name_host_pair UNIQUE(roster_name,roster_host_id)
) ;


/********** Rooms **********
Syntax: "INSERT IGNORE INTO rooms (room_host_id, roster_id, room_key) 
            VALUES (@id, @roster, NULL)"
Constraints: FK for roster_id (rosters)
Trigger Algorithm:  Auto-generate a 6-digit alphanumeric key for room_key and
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
    room_host_id int(11) NOT NULL,
    room_key varchar(6) NOT NULL,
    roster_id int(8), -- CAN BE NULL FOR ANONYMOUS QUIZ
    start_time TIMESTAMP NOT NULL,
    active_connections int DEFAULT 0,
    current_question_id int(11) DEFAULT NULL,
    PRIMARY KEY (room_id),
    CONSTRAINT rooms_roster_fk FOREIGN KEY (roster_id)
        REFERENCES rosters(roster_id),
    CONSTRAINT unique_room_key UNIQUE INDEX (room_key)
) ;

CREATE INDEX idx_room_keys on rooms(room_key);

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS rooms_config_BI
BEFORE INSERT ON rooms
FOR EACH ROW
BEGIN
    declare rnd_str varchar(6);
    declare rdy int;
    set rdy = 0;
    if isnull(NEW.room_key) THEN
        while (not rdy) do
            set rnd_str := lpad(conv(floor(rand()*pow(36,6)), 10, 36), 6, 0);
            if not exists (select * from rooms where room_key = rnd_str) then
                set NEW.room_key := rnd_str;
                set rdy = 1;
            end if;
        end while;
    end if;
    set new.start_time = NOW();
END $$
DELIMITER ;


/********** ATTENDEES **********
Syntax: "INSERT INTO ATTENDEES (attendee_id, roster_id) VALUES ()"
Constraints: FK for roster_id (rosters)
Trigger Algorithm:  Increment the attendance_count of the row in rosters
                    which matches the given roster_id.
*/
CREATE TABLE IF NOT EXISTS attendees (
    attendee_id int(11) NOT NULL,
    roster_id int(8) NOT NULL,
    PRIMARY KEY (attendee_id,roster_id),
    CONSTRAINT attendee_roster_id_fk FOREIGN KEY (roster_id)
        REFERENCES rosters(roster_id) ON DELETE CASCADE
) ;

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS tr_attendees_update_roster_ai
BEFORE INSERT ON attendees
FOR EACH ROW
BEGIN   
    UPDATE rosters SET attendee_count = attendee_count + 1
      WHERE rosters.roster_id = new.roster_id;
END $$
DELIMITER ;


/********** Attendance_Records **********
Syntax: "INSERT IGNORE INTO attendancerecords (attendee_id, room_key) VALUES()"
Constraints: FK for room_key (rooms) and attendee_id (attendees)
Trigger Algorithm:  Check that attendee is a member of the roster associated with
                    the given room_key. If so, set the date to current_date and
                    insert. Otherwise, send signal 45000 error.
*/
CREATE TABLE IF NOT EXISTS attendancerecords (
    attendee_id int(11) NOT NULL,
    room_key varchar(6) NOT NULL,
    attendance_date DATE NOT NULL,
    PRIMARY KEY (attendee_id, room_key, attendance_date),
    CONSTRAINT attendance_record_room_key_fk FOREIGN KEY (room_key)
        REFERENCES rooms(room_key),
    CONSTRAINT attendance_record_attendee_id_fk FOREIGN KEY (attendee_id)
        REFERENCES attendees(attendee_id)
) ;

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS tr_attendance_record_bi
BEFORE INSERT ON attendancerecords
FOR EACH ROW
BEGIN
    if (SELECT isnull(roster_id) FROM rooms WHERE room_key = NEW.room_key) = 0 THEN
        set new.attendance_date = current_date();
    elseif (SELECT COUNT(*) FROM rooms join attendees 
        WHERE rooms.room_key = new.room_key
        AND new.attendee_id = attendees.attendee_id
        AND rooms.roster_id = attendees.roster_id) > 0 THEN
            set new.attendance_date = current_date();
    else
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Attendee does not have access to this room.';
    end if;
end $$
DELIMITER ;

-- Create User_Folder
CREATE TABLE IF NOT EXISTS questionfolders (
    folder_id int(11) NOT NULL AUTO_INCREMENT,
    owner_id int(11) NOT NULL,
    folder_name varchar(32) NOT NULL,
    folder_description varchar(64) NOT NULL,
    PRIMARY KEY (folder_id),
    CONSTRAINT question_folder_owner_account_fk FOREIGN KEY (owner_id)
        REFERENCES accounts(id)
) ;

-- Create Question
CREATE TABLE IF NOT EXISTS questions (
    question_id int(11) NOT NULL AUTO_INCREMENT,
    folder_id int(11) NOT NULL,
    question_text varchar(250) NOT NULL,
    answer_a varchar(100) NOT NULL,
    answer_b varchar(100) NOT NULL,
    answer_c varchar(100),
    answer_d varchar(100),
    answer_e varchar(100),
    correct_answer enum('a','b','c','d','e') NOT NULL,
    PRIMARY KEY (question_id),
    Constraint question_Qfolder_fk FOREIGN KEY (folder_id)
        REFERENCES questionfolders(folder_id) ON DELETE CASCADE
) ;


/********** QuestionSet **********
Syntax: INSERT INTO questionset (col1 ,col2, col3)
        SELECT col1, col2, col3 FROM Questions where 

CREATE TABLE IF NOT EXISTS questionset ( -- ON THE FENCE AS TO WHETHER WE NEED THIS OR NOT
    
);
    -- FK QUESTION ON DELETE CASCADE
*/


/********** PublishedQuizzes **********
Syntax:         PublishedQuizzes are created *EXCLUSIVELY* through the stored
                procedure "publish_quiz_folder"
Constraints:    FK for Room_ID (rooms)
*/
CREATE TABLE IF NOT EXISTS publishedquizzes (
    quiz_id int(11) NOT NULL AUTO_INCREMENT,
    room_key varchar(6) NOT NULL,
    room_start_time TIMESTAMP,
    PRIMARY KEY (quiz_id, room_key),
    CONSTRAINT pubQuiz_room_key_fk FOREIGN KEY (room_key)
        REFERENCES rooms(room_key)
) ;

/********** PublishedQuestions **********
Syntax:         Published Questions are created *EXCLUSIVELY* through the stored
                procedure "publish_quiz_folder"
Constraints:    FK for Quiz_id (PublishedQuizzes)
*/
CREATE TABLE IF NOT EXISTS publishedquestions (
    quiz_id int(11) NOT NULL,
    question_id int(11) NOT NULL AUTO_INCREMENT,
    question_text varchar(250) NOT NULL,
    answer_a varchar(100) NOT NULL,
    answer_b varchar(100) NOT NULL,
    answer_c varchar(100),
    answer_d varchar(100),
    answer_e varchar(100),
    correct_answer enum('a','b','c','d','e') NOT NULL,
    PRIMARY KEY (question_id, quiz_id),
    CONSTRAINT pubQuest_pubQuiz_fk FOREIGN KEY (quiz_id)
        REFERENCES publishedquizzes (quiz_id) ON DELETE CASCADE
) ;


/********** Quiz Attempts **********
Syntax:         INSERT INTO quizattempts (room_key, attendee_id, quiz_id) 
                    VALUES (@key, @attendee, NULL)
Constraints:    FK on quiz_id and room_key from published_quizzes
Triggers:       Auto-fill quiz_id. Create an attendance record if non exists. Check
                    if attendee has access to given quiz.
*/
CREATE TABLE quizattempts (
    attempt_id int(11) NOT NULL AUTO_INCREMENT,
    room_key varchar(6) NOT NULL,
    quiz_id int(11) NOT NULL,
    attendee_id int(11) NOT NULL,
    PRIMARY KEY (attempt_id),
    CONSTRAINT unique_quiz UNIQUE(quiz_id, attendee_id),
    CONSTRAINT published_quiz_room_quiz_id_fk FOREIGN KEY (quiz_id, room_key)
        REFERENCES publishedquizzes (quiz_id, room_key) ON DELETE CASCADE
) ;

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS tr_quiz_attempts_bi
BEFORE INSERT ON quizattempts
FOR EACH ROW
BEGIN
    -- Set the quiz_id value
    SET new.quiz_id = (SELECT quiz_id FROM PublishedQuizzes 
        WHERE room_key = new.room_key);

    -- INSERT NEW AttendanceRecord if one doesn't already exist
    if (SELECT COUNT(*) FROM attendancerecords 
            WHERE room_key = NEW.room_key AND 
                attendee_id = NEW.attendee_id) = 0 THEN
        INSERT INTO attendancerecords (room_key, attendee_id) 
            VALUES (new.room_key, new.attendee_id);
    end if;

    -- Check if the room is associated with a roster. If it is, check if the attendee has access.
    if (SELECT isnull (roster_id) FROM rooms WHERE room_key = NEW.room_key) = 0 THEN
        if (SELECT COUNT(*) FROM rooms join attendees 
            WHERE room_key = new.room_key
            AND attendee_id = new.attendee_id
            AND rooms.roster_id = attendees.roster_id) = 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Attendee does not have access to this room.';
        end if;
    end if;

    UPDATE rooms SET active_connections = active_connections +1 
        WHERE room_key = NEW.room_key;
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
        REFERENCES quizattempts (attempt_id) ON DELETE CASCADE,
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
              has the same folder_id as the parameter fold_id and
              set the quiz_id for each with the quiz_id which was
              generated for the row created in previous step. */


DELIMITER $$
CREATE PROCEDURE publish_quiz_folder
(IN fold_id int(11), IN r_key varchar(6))
BEGIN
    INSERT IGNORE INTO publishedquizzes (room_key) VALUES (r_key);
    SELECT @qid := quiz_id
      FROM publishedquizzes
      WHERE publishedquizzes.room_key = r_key;
    INSERT IGNORE INTO publishedquestions (quiz_id, question_id, question_text, answer_a, answer_b,
                                            answer_c, answer_d, answer_e, correct_answer)
        SELECT @qid, question_id, question_text, answer_a, answer_b, answer_c, answer_d, answer_e, correct_answer
        FROM questions WHERE questions.folder_id = fold_id;
end $$
DELIMITER ;
