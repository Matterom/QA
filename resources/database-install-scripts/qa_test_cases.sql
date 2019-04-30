/*************** qa_test_cases.sql ***************
* Class:    CS/CINF Senior Project
* Group:    Q and A
* Purpose:  Insert test data into database to test
*           core functionality of website.
****************************************************/
USE qaproject;

-- ACCOUNTS
INSERT INTO accounts (username, email, account_password) VALUES 
('david', 'david@quizandattendance.com', 'alpha'),
('matthew', 'matt@quizandattendance.com', 'beta'),
('nayeli', 'nayeli@quizandattendance.com', 'gamma'),
('sean', 'sean@quizandattendance.com', 'delta'),
('steve', 'steve@quizandattendance.com', 'epsilon');
/*Successful triggers will change all passwords to 32 character keys */ 

-- ROSTERS
INSERT INTO rosters (rosterHostID, rosterName) VALUES
(6, 'CSCI 4388'),
(6, 'CINF 4324'),
(7, 'CSCI 4391'),
(7, 'CENG 3351'),
(8, 'ENGL 1135'),
(9, 'MATH 2405');
-- rosterID should be auto-set. Attendee_count should default to 0.

-- Attendees
INSERT IGNORE INTO ATTENDEES (attendeeID, rosterID) VALUES 
(111111, 1),
(111111, 2),
(111111, 3),
(12345, 2),
(12345, 3),
(54321, 3);
/* When finished, the attendee_count of 1, 2, and 3 will be updated to 1, 2, and 3*/

-- ROOMS
INSERT IGNORE INTO ROOMS (ownerID, rosterID, roomKey) VALUES
(1, 1, NULL),
(2, 2, NULL),
(3, 6, NULL),
(3, 4, NULL),
(1, 3, NULL);
/* Successful triggers will auto-generate room keys for each room */

-- ATTENDANCE RECORDS
INSERT INTO attendancerecords (attendeeID, roomKey)
SELECT attendees.attendeeID, rooms.roomKey 
FROM attendees join rooms
WHERE attendees.rosterID = rooms.rosterID;
/*  Creates an attendancerecord for every attendee on every room where they both have
    the same rosterID. 
    Successful trigger will generate the current_date
*/

-- QUESTION FOLDERS
INSERT INTO questionfolders (ownerID, folderName, folderDescription) VALUES
(1, 'CSCI4388 Quiz#4', 'Quiz about ethics'),
(2, 'CINF 4324 Quiz #2', 'Quiz about DFDs'),
(3, 'CompArch Pipelines', 'Covers chapter 4'),
(1, 'CSCI4388 Quiz#1', 'Quiz about Charters'),
(1, 'CSCI4388 Quiz#6', 'Quiz about ER Diagrams');
/* PHP file which creates this must implement error checking for duplicates. */

-- QUESTIONS
INSERT INTO questions (folder_id, question_text, answer_a, answer_b, answer_c,
                        answer_d, answer_e, correct_answer) VALUES
(1, 'Is it good to be ethical?'),
(1, 'Ethics is exciting'),
(1, 'It is important to use visual aids when discussing Aristotle'),
(1, 'Is murder bad?'),
(2, 'What is a DFD?'),
(3, 'How many stages are there in MIPS pipelining?');
/* PHP file which creates this must implement error checking for duplicates. */

-- Publishing Quizzes
SELECT @roomkey := roomKey from rooms where room_id=1;
CALL publish_quiz_folder(1, @roomkey);

SELECT @roomkey := roomKey from rooms where room_id=2;
CALL publish_quiz_folder(2, @roomkey);
/* On first run through this test, it will publish quiz folder 1 to room 1 and quiz folder 2 to room 2 */

-- QUIZ ATTEMPT
SELECT @roomkey := roomKey from rooms where room_id=1;
INSERT INTO quizattempts (roomKey, attendeeID, quizID) VALUES 
(@roomkey, 111111, NULL);

SELECT @roomkey := roomKey from rooms where room_id=2;
INSERT INTO quizattempts (roomKey, attendeeID, quizID) VALUES 
(@roomkey, 111111, NULL),
(@roomkey, 12345, NULL);
/*  On first run through thiis test, it will create an attempt for user 111111 in room 1 and an
    attempt for 111111 and 12345 in room 2. */
