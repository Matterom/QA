-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 29, 2019 at 05:04 PM
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
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `attemptID` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questionfolders`
--

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
(42, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description'),
(43, 1, 'Folder Name', 'Double Click to edit Folder Name or Folder Description');

-- --------------------------------------------------------

--
-- Table structure for table `questionsetpairing`
--

CREATE TABLE `questionsetpairing` (
  `qID` int(11) NOT NULL,
  `qsetID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `questionsetpairing`
--

INSERT INTO `questionsetpairing` (`qID`, `qsetID`) VALUES
(34, 1),
(35, 1),
(36, 1),
(34, 2);

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
(3, 'Name of Set', 'Description of Set', 42);

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
(34, 42, '{\"text\":\"This is a sample Question, Double Click to Change\",\"args\":{\"TF\":\"False\"},\"answer\":{\"one\":[true,\"This is a sample Answer, Double click to change\",\"\"],\"two\":[false,\"This is a sample Answer, Double click to change\",\"\"],\"three\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"four\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"five\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"]}}'),
(35, 42, '{\"text\":\"This is a sample Question, Double Click to Change\",\"args\":{\"TF\":\"False\"},\"answer\":{\"one\":[true,\"This is a sample Answer, Double click to change\",\"\"],\"two\":[false,\"This is a sample Answer, Double click to change\",\"\"],\"three\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"four\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"five\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"]}}'),
(36, 42, '{\"text\":\"This is a sample Question, Double Click to Change\",\"args\":{\"TF\":\"False\"},\"answer\":{\"one\":[true,\"This is a sample Answer, Double click to change\",\"\"],\"two\":[false,\"This is a sample Answer, Double click to change\",\"\"],\"three\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"four\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"],\"five\":[false,\"This is a sample Answer, Double click to change\",\"hidden\"]}}');

-- --------------------------------------------------------

--
-- Table structure for table `roomconnections`
--

CREATE TABLE `roomconnections` (
  `session_id` text COLLATE utf8_unicode_ci NOT NULL,
  `room_key` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `connectTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `exitTime` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_key` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `ownerID` int(11) NOT NULL,
  `flags` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

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
  ADD PRIMARY KEY (`qsetID`,`qID`);

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
  MODIFY `folderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `questionsets`
--
ALTER TABLE `questionsets`
  MODIFY `qSetID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `questiontable`
--
ALTER TABLE `questiontable`
  MODIFY `questionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- Constraints for dumped tables
--

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
-- Constraints for table `questionsets`
--
ALTER TABLE `questionsets`
  ADD CONSTRAINT `cascadefolderdelete` FOREIGN KEY (`folderID`) REFERENCES `questionfolders` (`folderID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `questiontable`
--
ALTER TABLE `questiontable`
  ADD CONSTRAINT `questiontable_ibfk_1` FOREIGN KEY (`folderID`) REFERENCES `questionfolders` (`folderID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
