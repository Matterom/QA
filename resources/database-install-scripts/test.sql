-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 23, 2019 at 12:25 AM
-- Server version: 5.7.25
-- PHP Version: 7.1.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `qaproject`
--
CREATE DATABASE IF NOT EXISTS `qaproject` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `qaproject`;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `username` varchar(62) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(62) COLLATE utf8_unicode_ci NOT NULL,
  `password` char(126) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `username`, `email`, `password`) VALUES
(1, 'test_user', 'test@example.com', 'password'),
(2, 'Matterom', 'Matterom1@gmail.com', 'Testpassword');

-- --------------------------------------------------------

--
-- Table structure for table `AttendanceKeys`
--

DROP TABLE IF EXISTS `AttendanceKeys`;
CREATE TABLE `AttendanceKeys` (
  `course_id` int(11) NOT NULL,
  `session_date` date NOT NULL,
  `attendance_key` varchar(5) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `AttendanceKeys`
--
DROP TRIGGER IF EXISTS `date_key_generator_bi`;
DELIMITER $$
CREATE TRIGGER `date_key_generator_bi` BEFORE INSERT ON `AttendanceKeys` FOR EACH ROW BEGIN
	declare rnd_str varchar(5);
    declare rdy int;
    set rdy = 0;
/* The following section sets the course key to a random string of
*  8 characters, (A-Z, 1-9) if it has not */
if isnull(NEW.attendance_key) THEN
    while (not rdy) do
        set rnd_str := lpad(conv(floor(rand()*pow(36,5)), 10, 36), 5, 0);
            if not exists (select * from AttendanceKeys where attendance_key = rnd_str) then
                set NEW.attendance_key := rnd_str;
                set rdy = 1;
            end if;
    end while;
    
    /* Sets the class date to the current date when a key is created */
    set NEW.session_date = current_date(); 
end if;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `AttendanceRecords`
--

DROP TABLE IF EXISTS `AttendanceRecords`;
CREATE TABLE `AttendanceRecords` (
  `attendee_id` int(11) NOT NULL,
  `attendance_key` varchar(8) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendees`
--

DROP TABLE IF EXISTS `attendees`;
CREATE TABLE `attendees` (
  `attendee_id` int(7) NOT NULL,
  `course_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `attendees`
--

INSERT INTO `attendees` (`attendee_id`, `course_id`) VALUES
(1234567, 4321);

-- --------------------------------------------------------

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
CREATE TABLE `Courses` (
  `course_id` int(11) NOT NULL,
  `course_name` varchar(62) COLLATE utf8_unicode_ci NOT NULL,
  `course_subject` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `course_number` int(11) DEFAULT NULL,
  `course_instructor` varchar(62) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `Courses`
--

INSERT INTO `Courses` (`course_id`, `course_name`, `course_subject`, `course_number`, `course_instructor`) VALUES
(4321, 'Underwater Basket Weaving', 'CSCI', 1111, 'test_user');

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
CREATE TABLE `login_attempts` (
  `attemptID` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questionfolders`
--

DROP TABLE IF EXISTS `questionfolders`;
CREATE TABLE `questionfolders` (
  `folderID` int(11) NOT NULL,
  `ownerID` int(11) NOT NULL,
  `folderName` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `folderDescription` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `questionfolders`
--

INSERT INTO `questionfolders` (`folderID`, `ownerID`, `folderName`, `folderDescription`) VALUES
(1, 1, 'Soda Water', 'Questions about Soda Water'),
(4, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description'),
(5, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description'),
(6, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description');

-- --------------------------------------------------------

--
-- Table structure for table `questionsetpairing`
--

DROP TABLE IF EXISTS `questionsetpairing`;
CREATE TABLE `questionsetpairing` (
  `pairingID` int(11) NOT NULL,
  `qID` int(11) NOT NULL,
  `qsetID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questionsets`
--

DROP TABLE IF EXISTS `questionsets`;
CREATE TABLE `questionsets` (
  `qSetID` int(11) NOT NULL,
  `qSetName` varchar(31) COLLATE utf8_unicode_ci NOT NULL,
  `folderID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questiontable`
--

DROP TABLE IF EXISTS `questiontable`;
CREATE TABLE `questiontable` (
  `questionID` int(11) NOT NULL,
  `folderID` int(11) NOT NULL,
  `question` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `RoomConnections`
--

DROP TABLE IF EXISTS `RoomConnections`;
CREATE TABLE `RoomConnections` (
  `session _id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `room_key` int(11) NOT NULL,
  `connectTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `exitTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `RoomConnections`
--
DROP TRIGGER IF EXISTS `room_connect_bi`;
DELIMITER $$
CREATE TRIGGER `room_connect_bi` BEFORE INSERT ON `RoomConnections` FOR EACH ROW BEGIN

    set New.connectTime = NOW();
    -- Increment the active connections on room connection
    update Rooms 
        set active_connections = active_connections +1
        where room_key = new.room_key;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `room_connect_bu`;
DELIMITER $$
CREATE TRIGGER `room_connect_bu` BEFORE INSERT ON `RoomConnections` FOR EACH ROW BEGIN
    if (NEW.exitTime != NULL) THEN
        -- Increment the active connections on room connection
        update Rooms 
            set active_connections = active_connections - 1
            where room_key = new.room_key;
    end if;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Rooms`
--

DROP TABLE IF EXISTS `Rooms`;
CREATE TABLE `Rooms` (
  `room_key` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `LoginGroup` int(11) NOT NULL,
  `active_connection` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `Rooms`
--
DROP TRIGGER IF EXISTS `room_key_generator_bi`;
DELIMITER $$
CREATE TRIGGER `room_key_generator_bi` BEFORE INSERT ON `Rooms` FOR EACH ROW BEGIN
  declare ready int default 0;
  declare rnd_str varchar(5);

  while not ready DO set rnd_str := lpad(conv(floor(rand()*pow(36,6)),        10, 36), 6, 0);
     if not exists (select * from Rooms where room_key = rnd_str)
     then
       set new.room_key = rnd_str;
       set ready := 1;
     end if;
   end while;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `AttendanceKeys`
--
ALTER TABLE `AttendanceKeys`
  ADD PRIMARY KEY (`course_id`,`session_date`),
  ADD UNIQUE KEY `attendance_key` (`attendance_key`);

--
-- Indexes for table `AttendanceRecords`
--
ALTER TABLE `AttendanceRecords`
  ADD PRIMARY KEY (`attendee_id`,`attendance_key`),
  ADD KEY `fk_att_records_course_key` (`attendance_key`);

--
-- Indexes for table `attendees`
--
ALTER TABLE `attendees`
  ADD PRIMARY KEY (`attendee_id`),
  ADD KEY `fk_course_id_from_attendees` (`course_id`);

--
-- Indexes for table `Courses`
--
ALTER TABLE `Courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `fk_username` (`course_instructor`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`attemptID`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `questionfolders`
--
ALTER TABLE `questionfolders`
  ADD PRIMARY KEY (`folderID`),
  ADD KEY `ownerID` (`ownerID`),
  ADD KEY `ownerID_2` (`ownerID`);

--
-- Indexes for table `questionsetpairing`
--
ALTER TABLE `questionsetpairing`
  ADD PRIMARY KEY (`pairingID`),
  ADD KEY `qID` (`qID`,`qsetID`),
  ADD KEY `qsetID` (`qsetID`);

--
-- Indexes for table `questionsets`
--
ALTER TABLE `questionsets`
  ADD PRIMARY KEY (`qSetID`),
  ADD KEY `cascadefolderdelete` (`folderID`);

--
-- Indexes for table `questiontable`
--
ALTER TABLE `questiontable`
  ADD PRIMARY KEY (`questionID`),
  ADD KEY `folderID` (`folderID`);

--
-- Indexes for table `RoomConnections`
--
ALTER TABLE `RoomConnections`
  ADD PRIMARY KEY (`session _id`);

--
-- Indexes for table `Rooms`
--
ALTER TABLE `Rooms`
  ADD PRIMARY KEY (`room_key`) USING BTREE,
  ADD KEY `fk_Login_Group` (`LoginGroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `attemptID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `questionfolders`
--
ALTER TABLE `questionfolders`
  MODIFY `folderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `questionsetpairing`
--
ALTER TABLE `questionsetpairing`
  MODIFY `pairingID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `questionsets`
--
ALTER TABLE `questionsets`
  MODIFY `qSetID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `questiontable`
--
ALTER TABLE `questiontable`
  MODIFY `questionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `AttendanceKeys`
--
ALTER TABLE `AttendanceKeys`
  ADD CONSTRAINT `fk_course_id_from_keys` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`);

--
-- Constraints for table `AttendanceRecords`
--
ALTER TABLE `AttendanceRecords`
  ADD CONSTRAINT `fk_att_records_attendee` FOREIGN KEY (`attendee_id`) REFERENCES `attendees` (`attendee_id`),
  ADD CONSTRAINT `fk_att_records_course_key` FOREIGN KEY (`attendance_key`) REFERENCES `AttendanceKeys` (`attendance_key`);

--
-- Constraints for table `attendees`
--
ALTER TABLE `attendees`
  ADD CONSTRAINT `fk_course_id_from_attendees` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`);

--
-- Constraints for table `Courses`
--
ALTER TABLE `Courses`
  ADD CONSTRAINT `fk_username` FOREIGN KEY (`course_instructor`) REFERENCES `accounts` (`username`);

--
-- Constraints for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD CONSTRAINT `login_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`id`);

--
-- Constraints for table `questionfolders`
--
ALTER TABLE `questionfolders`
  ADD CONSTRAINT `questionfolders_ibfk_1` FOREIGN KEY (`ownerID`) REFERENCES `accounts` (`id`);

--
-- Constraints for table `questionsetpairing`
--
ALTER TABLE `questionsetpairing`
  ADD CONSTRAINT `questionsetpairing_ibfk_1` FOREIGN KEY (`qID`) REFERENCES `questiontable` (`questionID`),
  ADD CONSTRAINT `questionsetpairing_ibfk_2` FOREIGN KEY (`qsetID`) REFERENCES `questionsets` (`qSetID`);

--
-- Constraints for table `questionsets`
--
ALTER TABLE `questionsets`
  ADD CONSTRAINT `cascadefolderdelete` FOREIGN KEY (`folderID`) REFERENCES `questionfolders` (`folderID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `questiontable`
--
ALTER TABLE `questiontable`
  ADD CONSTRAINT `questiontable_ibfk_1` FOREIGN KEY (`folderID`) REFERENCES `questionfolders` (`folderID`) ON DELETE CASCADE;

--
-- Constraints for table `Rooms`
--
ALTER TABLE `Rooms`
  ADD CONSTRAINT `fk_Login_Group` FOREIGN KEY (`LoginGroup`) REFERENCES `Courses` (`course_id`);
COMMIT;

GRANT USAGE ON *.* TO 'lnsys'@'localhost' IDENTIFIED BY PASSWORD '*571B02166B46C27003D2E30B815657658C800579';
GRANT SELECT, INSERT, UPDATE ON `qaproject`.* TO 'lnsys'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'quesys'@'localhost' IDENTIFIED BY PASSWORD '*D980CF29D2D015AFC048830684D401BF66FFE09D';