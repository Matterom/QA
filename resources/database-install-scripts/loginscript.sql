-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2019 at 11:19 PM
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

-- --------------------------------------------------------

--
-- Table structure for table `questionsetpairing`
--

CREATE TABLE `questionsetpairing` (
  `pairingID` int(11) NOT NULL,
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
  `folderID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  MODIFY `folderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

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
  MODIFY `questionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

GRANT USAGE ON *.* TO 'lnsys'@'localhost' IDENTIFIED BY PASSWORD '*571B02166B46C27003D2E30B815657658C800579';
GRANT SELECT, INSERT, UPDATE ON `qaproject`.* TO 'lnsys'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'quesys'@'localhost' IDENTIFIED BY PASSWORD '*D980CF29D2D015AFC048830684D401BF66FFE09D';