-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 30, 2019 at 03:57 AM
-- Server version: 10.1.35-MariaDB
-- PHP Version: 7.2.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `qaproject`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `username` varchar(62) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(62) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` char(32) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `username`, `email`, `password`) VALUES
(1, 'test_user', 'example@example.com', '5f4dcc3b5aa765d61d8327deb882cf99');

--
-- Triggers `accounts`
--
DELIMITER $$
CREATE TRIGGER `hash_passwords` BEFORE INSERT ON `accounts` FOR EACH ROW BEGIN
    set new.password = md5(new.password);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attendancerecords`
--

CREATE TABLE `attendancerecords` (
  `attendeeID` int(11) NOT NULL,
  `roomKey` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `attendance_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `attendancerecords`
--
DELIMITER $$
CREATE TRIGGER `tr_attendance_record_bi` BEFORE INSERT ON `attendancerecords` FOR EACH ROW BEGIN
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
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attendees`
--

CREATE TABLE `attendees` (
  `attendeeID` int(11) NOT NULL,
  `rosterID` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `attendees`
--
DELIMITER $$
CREATE TRIGGER `tr_attendees_update_roster_ai` BEFORE INSERT ON `attendees` FOR EACH ROW BEGIN   
    UPDATE rosters SET attendee_count = attendee_count + 1
      WHERE rosters.rosterID = new.rosterID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `publishedquestions`
--

CREATE TABLE `publishedquestions` (
  `quizID` int(11) NOT NULL,
  `questionID` int(11) NOT NULL,
  `questionObject` varchar(124) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `publishedquizzes`
--

CREATE TABLE `publishedquizzes` (
  `quizID` int(11) NOT NULL,
  `roomKey` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `room_start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questionfolders`
--

CREATE TABLE `questionfolders` (
  `folderID` int(11) NOT NULL,
  `ownerID` int(11) NOT NULL,
  `folderName` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `folderDescription` varchar(64) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `questionfolders`
--

INSERT INTO `questionfolders` (`folderID`, `ownerID`, `folderName`, `folderDescription`) VALUES
(4, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description'),
(5, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description'),
(6, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description'),
(7, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description');

-- --------------------------------------------------------

--
-- Table structure for table `questionsetpairing`
--

CREATE TABLE `questionsetpairing` (
  `qID` int(11) NOT NULL,
  `qsetID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questionsets`
--

CREATE TABLE `questionsets` (
  `qSetID` int(11) NOT NULL,
  `qSetName` varchar(31) COLLATE utf8_unicode_ci NOT NULL,
  `qSetDesc` text COLLATE utf8_unicode_ci NOT NULL,
  `folderID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `questionsets`
--

INSERT INTO `questionsets` (`qSetID`, `qSetName`, `qSetDesc`, `folderID`) VALUES
(1, 'Name of Set', 'Description of Set', 4);

-- --------------------------------------------------------

--
-- Table structure for table `questiontable`
--

CREATE TABLE `questiontable` (
  `questionID` int(11) NOT NULL,
  `folderID` int(11) NOT NULL,
  `question` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `questiontable`
--

INSERT INTO `questiontable` (`questionID`, `folderID`, `question`) VALUES
(1, 4, '{\"text\":\"This is a sample Question, Double Click to Change\",\"args\":{\"TF\":\"False\"},\"answer\":{\"one\":[true,\"This is a sample Answer, Double click to change\",\"\"],\"two\":[false,\"This is a sample Answer, Double click to change\",\"\"],\"three\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"four\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"five\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"]}}');

-- --------------------------------------------------------

--
-- Table structure for table `quizattempts`
--

CREATE TABLE `quizattempts` (
  `attemptID` int(11) NOT NULL,
  `roomKey` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `quizID` int(11) NOT NULL,
  `attendeeID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `quizattempts`
--
DELIMITER $$
CREATE TRIGGER `tr_quiz_attempts_bi` BEFORE INSERT ON `quizattempts` FOR EACH ROW BEGIN
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
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `ownerID` int(11) NOT NULL,
  `roomKey` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `rosterID` int(8) DEFAULT NULL,
  `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `active_connections` int(11) DEFAULT '0',
  `current_questionID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `rooms`
--
DELIMITER $$
CREATE TRIGGER `rooms_config_BI` BEFORE INSERT ON `rooms` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rosters`
--

CREATE TABLE `rosters` (
  `rosterID` int(8) NOT NULL,
  `rosterHostID` int(11) NOT NULL,
  `rosterName` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `attendee_count` int(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_account_usernames` (`username`);

--
-- Indexes for table `attendancerecords`
--
ALTER TABLE `attendancerecords`
  ADD PRIMARY KEY (`attendeeID`,`roomKey`,`attendance_date`),
  ADD KEY `attendance_record_roomKey_fk` (`roomKey`);

--
-- Indexes for table `attendees`
--
ALTER TABLE `attendees`
  ADD PRIMARY KEY (`attendeeID`,`rosterID`),
  ADD KEY `attendee_rosterID_fk` (`rosterID`);

--
-- Indexes for table `publishedquestions`
--
ALTER TABLE `publishedquestions`
  ADD PRIMARY KEY (`questionID`,`quizID`),
  ADD KEY `pubQuest_pubQuiz_fk` (`quizID`);

--
-- Indexes for table `publishedquizzes`
--
ALTER TABLE `publishedquizzes`
  ADD PRIMARY KEY (`quizID`,`roomKey`),
  ADD KEY `pubQuiz_roomKey_fk` (`roomKey`);

--
-- Indexes for table `questionfolders`
--
ALTER TABLE `questionfolders`
  ADD PRIMARY KEY (`folderID`),
  ADD KEY `question_folder_owner_account_fk` (`ownerID`);

--
-- Indexes for table `questionsets`
--
ALTER TABLE `questionsets`
  ADD PRIMARY KEY (`qSetID`),
  ADD KEY `questionSet_folder_fk` (`folderID`);

--
-- Indexes for table `questiontable`
--
ALTER TABLE `questiontable`
  ADD PRIMARY KEY (`questionID`);

--
-- Indexes for table `quizattempts`
--
ALTER TABLE `quizattempts`
  ADD PRIMARY KEY (`attemptID`),
  ADD UNIQUE KEY `unique_quiz` (`quizID`,`attendeeID`),
  ADD KEY `published_quiz_room_quizID_fk` (`quizID`,`roomKey`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`),
  ADD UNIQUE KEY `unique_roomKey` (`roomKey`),
  ADD KEY `rooms_roster_fk` (`rosterID`),
  ADD KEY `room_owner_fk` (`ownerID`),
  ADD KEY `idx_roomKeys` (`roomKey`);

--
-- Indexes for table `rosters`
--
ALTER TABLE `rosters`
  ADD PRIMARY KEY (`rosterID`),
  ADD UNIQUE KEY `unique_rosterName_host_pair` (`rosterName`,`rosterHostID`),
  ADD KEY `rosterHostID_fk` (`rosterHostID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `publishedquestions`
--
ALTER TABLE `publishedquestions`
  MODIFY `questionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `publishedquizzes`
--
ALTER TABLE `publishedquizzes`
  MODIFY `quizID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `questionfolders`
--
ALTER TABLE `questionfolders`
  MODIFY `folderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `questionsets`
--
ALTER TABLE `questionsets`
  MODIFY `qSetID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `questiontable`
--
ALTER TABLE `questiontable`
  MODIFY `questionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `quizattempts`
--
ALTER TABLE `quizattempts`
  MODIFY `attemptID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rosters`
--
ALTER TABLE `rosters`
  MODIFY `rosterID` int(8) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendancerecords`
--
ALTER TABLE `attendancerecords`
  ADD CONSTRAINT `attendance_record_attendeeID_fk` FOREIGN KEY (`attendeeID`) REFERENCES `attendees` (`attendeeID`),
  ADD CONSTRAINT `attendance_record_roomKey_fk` FOREIGN KEY (`roomKey`) REFERENCES `rooms` (`roomKey`);

--
-- Constraints for table `attendees`
--
ALTER TABLE `attendees`
  ADD CONSTRAINT `attendee_rosterID_fk` FOREIGN KEY (`rosterID`) REFERENCES `rosters` (`rosterID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `publishedquestions`
--
ALTER TABLE `publishedquestions`
  ADD CONSTRAINT `pubQuest_pubQuiz_fk` FOREIGN KEY (`quizID`) REFERENCES `publishedquizzes` (`quizID`) ON DELETE CASCADE;

--
-- Constraints for table `publishedquizzes`
--
ALTER TABLE `publishedquizzes`
  ADD CONSTRAINT `pubQuiz_roomKey_fk` FOREIGN KEY (`roomKey`) REFERENCES `rooms` (`roomKey`);

--
-- Constraints for table `questionfolders`
--
ALTER TABLE `questionfolders`
  ADD CONSTRAINT `question_folder_owner_account_fk` FOREIGN KEY (`ownerID`) REFERENCES `accounts` (`id`);

--
-- Constraints for table `questionsets`
--
ALTER TABLE `questionsets`
  ADD CONSTRAINT `questionSet_folder_fk` FOREIGN KEY (`folderID`) REFERENCES `questionfolders` (`folderID`);

--
-- Constraints for table `quizattempts`
--
ALTER TABLE `quizattempts`
  ADD CONSTRAINT `published_quiz_room_quizID_fk` FOREIGN KEY (`quizID`,`roomKey`) REFERENCES `publishedquizzes` (`quizID`, `roomKey`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `room_owner_fk` FOREIGN KEY (`ownerID`) REFERENCES `accounts` (`id`),
  ADD CONSTRAINT `rooms_roster_fk` FOREIGN KEY (`rosterID`) REFERENCES `rosters` (`rosterID`);

--
-- Constraints for table `rosters`
--
ALTER TABLE `rosters`
  ADD CONSTRAINT `rosterHostID_fk` FOREIGN KEY (`rosterHostID`) REFERENCES `accounts` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
