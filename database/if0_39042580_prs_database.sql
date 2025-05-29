-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql204.infinityfree.com
-- Generation Time: May 29, 2025 at 03:46 PM
-- Server version: 10.6.19-MariaDB
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_39042580_prs_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(50) DEFAULT 'Pending',
  `doctor_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `user_id`, `appointment_date`, `appointment_time`, `created_at`, `status`, `doctor_id`) VALUES
(17, 39, '2025-05-30', '12:00:00', '2025-05-29 08:56:53', 'Completed', 5),
(36, 74, '2025-05-30', '16:30:00', '2025-05-29 19:42:10', 'Pending', 22),
(16, 39, '2025-06-01', '14:00:00', '2025-05-29 08:53:24', 'Pending', 22),
(24, 39, '2025-05-30', '15:30:00', '2025-05-29 15:23:04', 'Completed', 5),
(10, 39, '2025-05-29', '14:22:00', '2025-05-28 10:21:29', 'Pending', 5),
(11, 39, '2025-05-28', '15:58:00', '2025-05-28 12:58:06', 'Pending', 5),
(12, 39, '2025-05-30', '11:35:00', '2025-05-29 06:35:08', 'Pending', 5),
(23, 39, '2025-05-30', '15:30:00', '2025-05-29 15:18:53', 'Pending', 22),
(19, 39, '2025-05-30', '13:00:00', '2025-05-29 09:03:04', 'Pending', 5),
(29, 39, '2025-05-29', '14:00:00', '2025-05-29 17:44:46', 'Pending', 28),
(33, 70, '2025-05-30', '16:00:00', '2025-05-29 18:58:22', 'Pending', 28),
(35, 39, '2025-06-02', '10:00:00', '2025-05-29 19:36:09', 'Pending', 5);

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `entity_affected` varchar(100) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`log_id`, `user_id`, `action`, `entity_affected`, `record_id`, `timestamp`) VALUES
(1, 4, 'Uploaded vaccination record', 'documents', 1, '2025-05-06 15:21:22'),
(2, 4, 'Updated vaccination data', 'vaccination_records', 2, '2025-05-06 15:21:22'),
(3, 39, 'Changed password', 'users', 39, '2025-05-26 12:50:34'),
(4, 39, 'Changed password', 'users', 39, '2025-05-26 12:50:45'),
(5, 39, 'Uploaded file', 'documents', 42, '2025-05-26 13:20:25'),
(6, 39, 'Uploaded file', 'documents', 43, '2025-05-26 13:20:36'),
(7, 39, 'Uploaded file', 'documents', 44, '2025-05-26 13:20:38'),
(8, 39, 'Uploaded file', 'documents', 45, '2025-05-26 13:20:43'),
(9, 39, 'Uploaded file', 'documents', 46, '2025-05-26 13:20:47'),
(10, 4, 'Deleted file', 'documents', 0, '2025-05-26 18:28:22'),
(11, 4, 'Deleted file', 'documents', 0, '2025-05-26 18:28:25'),
(12, 4, 'Deleted file', 'documents', 0, '2025-05-26 18:28:27'),
(13, 4, 'Deleted file', 'documents', 0, '2025-05-26 18:28:29'),
(14, 39, 'Uploaded file', 'documents', 47, '2025-05-26 19:08:51'),
(15, 39, 'Uploaded file', 'documents', 48, '2025-05-26 19:31:54'),
(16, 4, 'Updated user role', 'users', 6, '2025-05-26 19:33:29'),
(17, 4, 'Updated user role', 'users', 6, '2025-05-26 19:33:33'),
(18, 4, 'Deleted file', 'documents', 0, '2025-05-26 19:33:51'),
(19, 4, 'Uploaded file', 'documents', 49, '2025-05-26 19:35:12'),
(20, 5, 'Uploaded file', 'documents', 50, '2025-05-26 19:35:54'),
(21, 5, 'Uploaded file', 'documents', 51, '2025-05-26 19:35:54'),
(22, 39, 'Uploaded file', 'documents', 52, '2025-05-26 19:41:28'),
(23, 4, 'Updated user role', 'users', 5, '2025-05-26 19:57:34'),
(24, 4, 'Updated user role', 'users', 5, '2025-05-26 19:57:38'),
(25, 39, 'Changed password', 'users', 39, '2025-05-26 20:38:17'),
(26, 39, 'Changed password', 'users', 39, '2025-05-26 20:38:23'),
(27, 39, 'Changed password', 'users', 39, '2025-05-27 07:23:20'),
(28, 4, 'Deleted file', 'documents', 0, '2025-05-27 07:24:01'),
(29, 4, 'Deleted file', 'documents', 0, '2025-05-27 07:24:06'),
(30, 4, 'Deleted file', 'documents', 0, '2025-05-27 07:24:08'),
(31, 39, 'Changed password', 'users', 39, '2025-05-27 07:55:22'),
(32, 39, 'Changed password', 'users', 39, '2025-05-27 09:24:23'),
(33, 5, 'Changed password', 'users', 5, '2025-05-27 13:21:37'),
(34, 39, 'Changed password', 'users', 39, '2025-05-27 13:22:52'),
(35, 39, 'Booked appointment', 'appointments', 1, '2025-05-27 13:39:45'),
(36, 39, 'Uploaded file', 'documents', 53, '2025-05-27 13:40:13'),
(37, 39, 'Booked appointment', 'appointments', NULL, '2025-05-27 13:43:42'),
(38, 39, 'Booked appointment', 'appointments', NULL, '2025-05-27 13:49:46'),
(39, 39, 'Booked appointment', 'appointments', 2025, '2025-05-27 13:53:33'),
(40, 39, 'Booked appointment', 'appointments', 2025, '2025-05-27 13:53:59'),
(41, 39, 'Booked an appointment for 2025-05-28 at 02:02', 'appointments', 2025, '2025-05-27 14:06:38'),
(42, 39, 'Booked appointment', 'appointments', 1, '2025-05-27 18:46:54'),
(43, 39, 'Booked appointment', 'appointments', 2025, '2025-05-27 18:48:01'),
(44, 39, 'Booked appointment', 'appointments', 2025, '2025-05-27 18:49:50'),
(45, 39, 'Booked an appointment for 2025-05-28 at 10:10', 'appointments', 2025, '2025-05-27 18:50:39'),
(46, 39, 'Changed password', 'users', 39, '2025-05-27 18:51:28'),
(47, 39, 'Uploaded file', 'documents', 54, '2025-05-27 18:51:50'),
(48, 39, 'Uploaded file', 'documents', 55, '2025-05-27 18:51:51'),
(49, 4, 'Deleted file', 'documents', 0, '2025-05-27 18:56:18'),
(50, 4, 'Updated user role', 'users', 5, '2025-05-27 18:57:25'),
(51, 4, 'Updated user role', 'users', 5, '2025-05-27 18:57:28'),
(52, 5, 'Changed password', 'users', 5, '2025-05-27 18:59:16'),
(53, 39, 'Booked an appointment for 2025-05-28 at 22:00', 'appointments', 2025, '2025-05-27 19:00:11'),
(54, 39, 'Booked an appointment for 2025-05-28 at 10:10', 'appointments', 2025, '2025-05-28 06:10:46'),
(55, 39, 'Booked an appointment for 2025-05-29 at 01:42', 'appointments', 2025, '2025-05-28 07:42:37'),
(56, 39, 'Booked an appointment for 2025-05-29 at 00:26', 'appointments', 2025, '2025-05-28 08:26:03'),
(57, 39, 'Booked an appointment for 2025-05-29 at 13:22', 'appointments', 2025, '2025-05-28 10:21:12'),
(58, 39, 'Booked an appointment for 2025-05-29 at 14:22', 'appointments', 2025, '2025-05-28 10:21:29'),
(59, 5, 'Uploaded file', 'documents', 56, '2025-05-28 10:23:28'),
(60, 4, 'Deleted file', 'documents', 0, '2025-05-28 12:57:15'),
(61, 39, 'Booked an appointment for 2025-05-28 at 15:58', 'appointments', 2025, '2025-05-28 12:58:06'),
(62, 39, 'Booked an appointment for 2025-05-30 at 11:35', 'appointments', 2025, '2025-05-29 06:35:08'),
(63, 39, 'Booked an appointment for 2025-05-30 at 03:05', 'appointments', 2025, '2025-05-29 07:26:12'),
(64, 39, 'Booked an appointment for 2025-05-30 at 12:30', 'appointments', 2025, '2025-05-29 08:51:44'),
(65, 39, 'Booked an appointment for 2025-05-30 at 14:30', 'appointments', 2025, '2025-05-29 08:51:59'),
(66, 39, 'Booked an appointment for 2025-05-29 at 14:00', 'appointments', 2025, '2025-05-29 08:53:24'),
(67, 39, 'Booked an appointment for 2025-05-30 at 12:00', 'appointments', 2025, '2025-05-29 08:56:53'),
(68, 39, 'Booked an appointment for 2025-05-30 at 14:00', 'appointments', 2025, '2025-05-29 09:01:17'),
(69, 39, 'Booked an appointment for 2025-05-30 at 13:00', 'appointments', 2025, '2025-05-29 09:03:04'),
(70, 39, 'Booked an appointment for 2025-05-30 at 11:30', 'appointments', 2025, '2025-05-29 09:22:45'),
(71, 39, 'Changed password', 'users', 39, '2025-05-29 09:23:19'),
(72, 39, 'Uploaded file', 'documents', 57, '2025-05-29 09:23:33'),
(73, 4, 'Deleted file', 'documents', 2147483647, '2025-05-29 09:23:45'),
(74, 4, 'Updated user role', 'users', 5, '2025-05-29 09:24:01'),
(75, 4, 'Updated user role', 'users', 5, '2025-05-29 09:24:06'),
(76, 4, 'Updated user role', 'users', 28, '2025-05-29 09:24:13'),
(77, 4, 'Updated user role', 'users', 29, '2025-05-29 09:24:17'),
(78, 4, 'Updated user role', 'users', 29, '2025-05-29 09:24:22'),
(79, 39, 'Booked an appointment for 2025-05-30 at 13:30', 'appointments', 2025, '2025-05-29 09:25:41'),
(80, 39, 'Booked an appointment for 2025-05-30 at 11:00', 'appointments', 2025, '2025-05-29 11:40:19'),
(81, 39, 'Changed password', 'users', 39, '2025-05-29 11:42:59'),
(82, 39, 'Booked an appointment for 2025-05-30 at 15:30', 'appointments', 2025, '2025-05-29 15:18:53'),
(83, 39, 'Booked an appointment for 2025-05-30 at 15:30', 'appointments', 2025, '2025-05-29 15:23:04'),
(84, 5, 'Updated appointment status to Completed', 'appointments', 17, '2025-05-29 15:23:25'),
(85, 4, 'Deleted user', 'users', 29, '2025-05-29 16:02:29'),
(86, 4, 'Deleted file', 'documents', 0, '2025-05-29 16:03:37'),
(87, 5, 'Updated appointment status to Cancelled', 'appointments', 14, '2025-05-29 16:08:44'),
(88, 5, 'Uploaded file', 'documents', 58, '2025-05-29 16:10:07'),
(89, 39, 'Booked an appointment for 2025-05-30 at 09:00', 'appointments', 2025, '2025-05-29 16:13:45'),
(90, 39, 'Uploaded file', 'documents', 59, '2025-05-29 16:14:12'),
(91, 39, 'Changed password', 'users', 39, '2025-05-29 16:14:28'),
(92, 39, 'Booked an appointment for 2025-05-30 at 10:00', 'appointments', 2025, '2025-05-29 16:55:11'),
(93, 39, 'Changed password', 'users', 39, '2025-05-29 16:55:41'),
(94, 39, 'Uploaded file', 'documents', 60, '2025-05-29 16:55:54'),
(95, 5, 'Updated appointment status to Completed', 'appointments', 26, '2025-05-29 16:56:30'),
(96, 5, 'Changed password', 'users', 5, '2025-05-29 16:56:46'),
(97, 4, 'Updated user role', 'users', 6, '2025-05-29 16:57:42'),
(98, 4, 'Updated user role', 'users', 6, '2025-05-29 16:57:48'),
(99, 4, 'Deleted user', 'users', 36, '2025-05-29 16:57:54'),
(100, 4, 'Deleted user', 'users', 38, '2025-05-29 16:58:03'),
(101, 4, 'Deleted file', 'documents', 0, '2025-05-29 16:58:27'),
(107, 39, 'Uploaded file', 'documents', 61, '2025-05-29 17:06:08'),
(108, 5, 'Updated appointment status to Completed', 'appointments', 27, '2025-05-29 17:06:30'),
(109, 5, 'Updated appointment status to Cancelled', 'appointments', 27, '2025-05-29 17:06:35'),
(110, 5, 'Uploaded file', 'documents', 62, '2025-05-29 17:06:58'),
(111, 5, 'Changed password', 'users', 5, '2025-05-29 17:07:17'),
(112, 4, 'Updated user role', 'users', 45, '2025-05-29 17:07:56'),
(113, 4, 'Updated user role', 'users', 45, '2025-05-29 17:08:04'),
(114, 4, 'Deleted user', 'users', 45, '2025-05-29 17:08:10'),
(115, 4, 'Deleted file', 'documents', 0, '2025-05-29 17:08:46'),
(117, 39, 'Booked an appointment for 2025-05-29 at 14:00', 'appointments', 2025, '2025-05-29 17:16:09'),
(118, 39, 'Uploaded file', 'documents', 63, '2025-05-29 17:16:33'),
(119, 39, 'Changed password', 'users', 39, '2025-05-29 17:16:43'),
(120, 5, 'Updated appointment status to Completed', 'appointments', 28, '2025-05-29 17:17:22'),
(121, 5, 'Updated appointment status to Cancelled', 'appointments', 28, '2025-05-29 17:17:29'),
(122, 5, 'Changed password', 'users', 5, '2025-05-29 17:17:44'),
(123, 4, 'Updated user role', 'users', 6, '2025-05-29 17:18:48'),
(124, 4, 'Updated user role', 'users', 6, '2025-05-29 17:18:52'),
(125, 4, 'Deleted user', 'users', 47, '2025-05-29 17:19:00'),
(126, 4, 'Deleted file', 'documents', 0, '2025-05-29 17:19:28'),
(135, 39, 'Booked an appointment for 2025-05-29 at 14:00', 'appointments', 2025, '2025-05-29 17:44:46'),
(136, 39, 'Booked an appointment for 2025-06-01 at 09:00', 'appointments', 2025, '2025-05-29 17:47:43'),
(146, 39, 'Booked an appointment for 2025-05-31 at 13:30', 'appointments', 2025, '2025-05-29 18:45:37'),
(147, NULL, 'Registered user', 'users', 68, '2025-05-29 18:54:06'),
(148, NULL, 'Registered user', 'users', 69, '2025-05-29 18:54:33'),
(149, 39, 'Booked an appointment for 2025-05-30 at 14:00', 'appointments', 2025, '2025-05-29 18:54:58'),
(150, 39, 'Changed password', 'users', 39, '2025-05-29 18:55:05'),
(151, 39, 'Uploaded file', 'documents', 64, '2025-05-29 18:55:14'),
(152, 5, 'Updated appointment status to Completed', 'appointments', 24, '2025-05-29 18:55:31'),
(153, 5, 'Uploaded file', 'documents', 65, '2025-05-29 18:55:46'),
(154, 5, 'Changed password', 'users', 5, '2025-05-29 18:56:01'),
(155, 4, 'Deleted file', 'documents', 100723789, '2025-05-29 18:56:14'),
(156, 4, 'Updated user role', 'users', 68, '2025-05-29 18:56:28'),
(157, 4, 'Deleted user', 'users', 68, '2025-05-29 18:56:33'),
(158, 4, 'Uploaded file', 'documents', 66, '2025-05-29 18:57:13'),
(159, 4, 'Deleted file', 'documents', 100723789, '2025-05-29 18:57:22'),
(160, NULL, 'Registered user', 'users', 70, '2025-05-29 18:58:06'),
(161, 70, 'Booked an appointment for 2025-05-30 at 16:00', 'appointments', 2025, '2025-05-29 18:58:22'),
(162, 70, 'Uploaded file', 'documents', 67, '2025-05-29 18:58:32'),
(163, 70, 'Changed password', 'users', 70, '2025-05-29 18:58:38'),
(164, NULL, 'Registered user', 'users', 71, '2025-05-29 19:25:18'),
(165, 39, 'Booked an appointment for 2025-05-29 at 16:00', 'appointments', 2025, '2025-05-29 19:26:01'),
(166, NULL, 'Registered user', 'users', 72, '2025-05-29 19:31:27'),
(167, NULL, 'Registered user', 'users', 73, '2025-05-29 19:35:40'),
(168, 39, 'Booked an appointment for 2025-06-02 at 10:00', 'appointments', 2025, '2025-05-29 19:36:09'),
(169, 4, 'Updated user role', 'users', 61, '2025-05-29 19:36:44'),
(170, 4, 'Deleted user', 'users', 61, '2025-05-29 19:36:58'),
(171, 4, 'Deleted file', 'documents', 100723789, '2025-05-29 19:37:35'),
(172, 5, 'Updated appointment status to Completed', 'appointments', 14, '2025-05-29 19:38:19'),
(173, NULL, 'Registered user', 'users', 74, '2025-05-29 19:41:37'),
(174, 74, 'Booked an appointment for 2025-05-30 at 16:30', 'appointments', 2025, '2025-05-29 19:42:10');

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `document_id` int(11) NOT NULL,
  `file_type` varchar(50) NOT NULL,
  `file_path` text NOT NULL,
  `uploaded_by` int(11) NOT NULL,
  `related_record_id` int(11) DEFAULT NULL,
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`document_id`, `file_type`, `file_path`, `uploaded_by`, `related_record_id`, `upload_date`) VALUES
(37, '', 'Vacc.txt', 5, NULL, '2025-05-26 10:56:00'),
(39, '', 'Vacc.txt', 5, NULL, '2025-05-26 10:57:33'),
(40, '', 'Vacc (1).txt', 5, NULL, '2025-05-26 10:57:57'),
(41, '', 'vacc.txt', 5, NULL, '2025-05-26 11:48:08'),
(58, '', 'vacc (3).txt', 5, NULL, '2025-05-29 16:10:07'),
(59, '', 'vacc (2).txt', 39, NULL, '2025-05-29 16:14:12'),
(61, '', 'vacc (4) (2).txt', 39, NULL, '2025-05-29 17:06:08');

-- --------------------------------------------------------

--
-- Table structure for table `encryption_keys`
--

CREATE TABLE `encryption_keys` (
  `key_id` int(11) NOT NULL,
  `key_type` varchar(50) NOT NULL,
  `key_value` text NOT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `encryption_keys`
--

INSERT INTO `encryption_keys` (`key_id`, `key_type`, `key_value`, `owner`, `created_date`) VALUES
(1, 'AES-256', 'a1b2c3d4e5f6g7h8', 'System', '2025-05-06 15:21:38'),
(2, 'RSA', 'publickey123456789', 'System', '2025-05-06 15:21:38');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'Admin', 'Can monitor vaccination and supply chain'),
(2, 'Doctor', 'Can manage pandemic-related supplies'),
(3, 'Public User', 'Can track vaccination records');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(20) DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password_hash`, `role_id`, `created_at`, `status`) VALUES
(4, 'admin', 'admin@example.com', '$2a$12$O5QJgWBBZ47qDrJsZfGPJOKjuyr3XEYKWTSMg/QkN1zhRxK3uQxFS', 1, '2025-03-28 15:12:38', 'active'),
(5, 'doctor_john', 'doctor@example.com', '$2y$10$MKc3oJLQbX5daESauKcnEeBDn4eCF7lmJQUe9HAm0GRWB8ZpC2eny', 2, '2025-03-28 15:12:38', 'active'),
(6, 'patient_sofia', 'patient_sofia@example.com', '89e01536ac207279409d4de1e5253e01f4a1769e696db0d6062ca9b8f56767c8', 3, '2025-03-28 15:12:38', 'active'),
(22, 'username_example', 'user@example.com', 'SFp1OTRna1oxVzAxTnduUmRqZlZnUT09Ojr4m2HjdYBY+MYOIjs9RdC9', 2, '2025-03-28 15:29:59', 'active'),
(28, 'aaa', 'aaa@hotmail.com', '$2y$10$Egquu6mIe/ITqwdT8HYb4uq3jEpt9D69QNXMiRB1ClVJmygqQjd0C', 2, '2025-05-06 15:41:12', 'active'),
(30, 'Aaa', 'aaa@hotmail.com', '$2y$10$0xVejqKG4QpJVLiVlNWRY.e9VhJWeMLk7rHitewEzcuQnJiqMCuPS', 3, '2025-05-06 15:44:18', 'active'),
(31, 'Aaa', 'aaa@hotmail.com', '$2y$10$UmdBwaoaQk9FD63BeEuTbOxPcmfCHClD3NdeAnrvZx9M4/Clc8k1m', 3, '2025-05-06 15:44:20', 'active'),
(32, 'aa', 'aaa@hotmail.com', '$2y$10$darS8SQZRS2nHlYYaNkxRO/uULPZzCLyQCpHxA4e0GmG5fVTlNSuS', 3, '2025-05-06 15:44:45', 'active'),
(33, 'aa', 'aaa@hotmail.com', '$2y$10$siiwhTp2PqADPLrjCsz0ZeK32MpuOE5XAhO29MP9AXNQ0wTdcbLt.', 3, '2025-05-06 15:46:21', 'active'),
(34, 'aa', 'aaa@hotmail.com', '$2y$10$MaxBK/43.RbdO136VxdLk.fTx17Y6CEBbAQwW9F2JYSvKUFmGETDi', 3, '2025-05-06 16:13:27', 'active'),
(35, 'aa', 'aa@hotmail.com', '$2y$10$aNgIFk6OIfjjMzqmUlwFkO749jq3JZb3k4ln0mZyaCxaWVfOC1dBW', 3, '2025-05-06 16:13:30', 'active'),
(39, 'user', 'user@gmail.com', '$2y$10$9ziy/4DoxIi4/FEzAQ.Zou3qIxhjMJMsVlb3pd29nraX8l470O/gu', 3, '2025-05-09 15:11:52', 'active'),
(40, 'user1', 'user1@gmail.com', '$2y$10$aGeKMBSRyeeUitB5O1UDb.oXm5xIezl/6a3lmVaoskzezdvAc9KZy', 3, '2025-05-11 10:42:21', 'active'),
(42, 'userH', 'user@hotmail.com', '$2y$10$Cc0iBHEzBsJN6WITmZNMYuI6vLQv7OA1kgG8pFFCaUbTfq1kUuthC', 3, '2025-05-11 13:09:07', 'active'),
(43, 'user', 'userr@gmail.com', '$2y$10$LyacxchIb.aYTwfm9zdUTeojA9t1XrQ4cdnqD4wxC/IOouJ16N122', 3, '2025-05-21 16:00:55', 'active'),
(44, 'user', 'user2@gmail.com', '$2y$10$UybCZq224dZTpFpRychSgOJZ4XG92z3L1CDQ1JTKvpwYHvJAHiZTa', 3, '2025-05-23 18:56:04', 'active'),
(46, 'alex', 'alex2@gmail.com', '$2y$10$zkq69b4L5soX3B8DMTRXiOXl6vIDSGLXhDl0b74a3d96eibcjySgu', 3, '2025-05-29 17:04:22', 'active'),
(48, 'alex', 'alex@gmail.com', '$2y$10$bUMo.BpMGhNhAc6yFeIGQOQES4ykaLusPzI6D4ksoG3vGf9nySAye', 3, '2025-05-29 17:15:34', 'active'),
(49, 'alex3', 'alex3@gmail.com', '$2y$10$XFrp7v9PdXgXQvUtQXeYfeHcD9rzFWldCyDHbZAWkNEQiaNf/pBaO', 3, '2025-05-29 17:22:20', 'active'),
(50, 'sof', 'sof@gmail.com', '$2y$10$OwtkzYthaZKYpZl/iKEVWOUyBK5z9Qkvze0ysw6SWU1kmeX4XeZl2', 3, '2025-05-29 17:25:10', 'active'),
(51, 'doctor', 'doctor12@example.com', '$2y$10$X/pxe.DMAFnRCYnO.oaBsO0BOsjNG3D4VhInDJczRRdx7jNODncfG', 3, '2025-05-29 17:25:32', 'active'),
(52, 'doctor12', '12@gmail.com', '$2y$10$lwo9QChKUna1YlvYTSLvdeUcjjXS78t2/pk1fl63PCsN0ojCHU5aO', 3, '2025-05-29 17:26:37', 'active'),
(53, '1', '1@gmail.com', '$2y$10$us.0YiUf7c3pXjO4vjs4eek7fPNT5qc/NGmKIggijFXW1MG3/l85e', 3, '2025-05-29 17:31:59', 'active'),
(54, 'aleeex', 'alex34@example.com', '$2y$10$ZucWHfPq5ikhsPrwwzQ1DubIFn4ihQxyZ1.UcZAM/lOb.j4Cs09HW', 3, '2025-05-29 17:33:09', 'active'),
(55, 'sof1', 'sofff@gmail.com', '$2y$10$bwSgXGKjVuE/auM8rfhYG.BywVh9STOoICZ52qGXSloGNtUn5Poua', 3, '2025-05-29 17:33:49', 'active'),
(56, 'doctor11', 'a@gmail.com', '$2y$10$3iJI3igOP8jinqn16Tqc7uAVJb.cv1o8POUmWnCGcVdF2RFH3Obvi', 3, '2025-05-29 17:34:42', 'active'),
(57, 'alex3', 'user11@gmail.com', '$2y$10$H5nmBDw//CO5zGbf8yyhxOUxGOmEoq2JVabYL7RQWOwX710B8PpTC', 3, '2025-05-29 17:43:42', 'active'),
(58, 'hi', 'hi@gmail.com', '$2y$10$NDzV9o7R7.6393JXLg2lluMphfnXYUCIr/4Nv0TxULBZ/UWiEvsA2', 3, '2025-05-29 17:48:36', 'active'),
(59, 'aa', 'a@hotmail.com', '$2y$10$B.SJzEuP.FumVzw1WiIJLOwhyIMrP4dUrmLsG7aknKycxzMBf3T7m', 3, '2025-05-29 17:49:56', 'active'),
(60, 'aa', 'user111@gmail.com', '$2y$10$bT4SbvBm.wQLFh1HcPwFRei9ELxGROguNEkGSSf2T2VEni1RApKq2', 3, '2025-05-29 18:23:41', 'active'),
(62, 'aa', 'user111111@gmail.com', '$2y$10$QWLNkJlnxSme1ZcqzSilFed6bIKuGWq.7uYcREzb0WCrLkUKa4A9a', 3, '2025-05-29 18:24:20', 'active'),
(63, 'user@gmail.com', 'uu@gmail.com', '$2y$10$Eqx0zA4xjQXoLMyXxJo0W.Lpea.xwYGmf0WoAsJ942/ml7xo5BM5C', 3, '2025-05-29 18:24:32', 'active'),
(64, 'aa', 'aaaaaaaa@gmail.com', '$2y$10$JDehh9HIiYKsroc3QZ2R8eO7DND85CxYyJ1djwUI78VQaFPL18Uiy', 3, '2025-05-29 18:25:22', 'active'),
(65, 'a', 'aaaaaaaaaaaaaaaa@gmail.com', '$2y$10$Rhx.dBeO/1Wx4pHuyf79n.7PPqT4LFSNSHTTQhGxB5jXQ4OrU8LkK', 3, '2025-05-29 18:29:15', 'active'),
(66, 'hi', 'h@gmail.com', '$2y$10$2B6LvF8ejWtOc/c5XEVMWOIxOeofuC2x0POHSApH.26hvMkAFySb2', 3, '2025-05-29 18:44:09', 'active'),
(67, 'h@hm.com', 'h@hm.com', '$2y$10$cOUF7d7f/WDaP12VSwsy/.FTrvYNzDrM17i6WsAz9Yg.kTTvncx.C', 3, '2025-05-29 18:50:35', 'active'),
(69, 's', 's@gmail.com', '$2y$10$N8yIA/N3pj6OLKviMQb51.yPmVH5TdPQZHfQ6Y0QEOZpKFhnrxeJC', 3, '2025-05-29 18:54:33', 'active'),
(70, 's', 'sss@gmail.com', '$2y$10$oh97MdcJ1zKn2Yc742dl5e9mhDozLls19eZytULVoFSUkzDMd5AjG', 3, '2025-05-29 18:58:06', 'active'),
(71, 'a', 'aa@outlook.com', '$2y$10$V8pV34hC17M0bSKaYCiriemT.v7vR9HEdeE30XR37.Ocqd/Rra9Dm', 3, '2025-05-29 19:25:18', 'active'),
(72, 'a', 'w@gmail.com', '$2y$10$QjnPnh7Y2iICc4JE6zxMSu/DcRWpYtxoo0imMPbUvHOrh2NjQeDyq', 3, '2025-05-29 19:31:27', 'active'),
(73, 'a', 'we@gmail.com', '$2y$10$OaMLRUbfdLcppdF0AaTzPOsInpDkrjfuseX1iA7CPpFDs0dSYXs0C', 3, '2025-05-29 19:35:40', 'active'),
(74, 'hi', 'hhh@gmail.com', '$2y$10$O.WZYupuHuW0zQmOzBlF9Oq54dgvZuASuI0zMqeaf4dG50TvL3XHS', 3, '2025-05-29 19:41:37', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `vaccination_records`
--

CREATE TABLE `vaccination_records` (
  `record_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `vaccine_name` varchar(255) NOT NULL,
  `date_administered` date NOT NULL,
  `dose_number` int(11) NOT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `lot_number` varchar(50) DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `location` varchar(100) DEFAULT NULL,
  `administered_by` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vaccination_records`
--

INSERT INTO `vaccination_records` (`record_id`, `user_id`, `vaccine_name`, `date_administered`, `dose_number`, `provider`, `lot_number`, `expiration_date`, `created_at`, `location`, `administered_by`) VALUES
(1, 4, 'COVID-19 Vaccine AstraZeneca', '2023-01-10', 1, 'City Health Clinic', 'AZ-12345', '2023-12-31', '2025-05-06 15:20:29', NULL, NULL),
(2, 4, 'COVID-19 Vaccine AstraZeneca', '2023-04-15', 2, 'City Health Clinic', 'AZ-67890', '2024-04-14', '2025-05-06 15:20:29', NULL, NULL),
(3, 4, 'COVID-19 Vaccine AstraZeneca', '2023-01-10', 1, 'City Health Clinic', 'AZ-12345', '2023-12-31', '2025-05-06 15:20:55', NULL, NULL),
(4, 4, 'COVID-19 Vaccine AstraZeneca', '2023-04-15', 2, 'City Health Clinic', 'AZ-67890', '2024-04-14', '2025-05-06 15:20:55', NULL, NULL),
(15, 39, 'Pfizer', '2024-03-05', 1, 'Health Center B', 'PF-202', '2025-03-05', '2025-05-09 19:27:32', 'Clinic B', 'Dr. Smith'),
(18, 39, 'Pfizer', '2024-03-05', 1, 'Health Center B', 'PF-201', '2025-03-05', '2025-05-09 19:28:29', 'Clinic B', 'Dr. Smith'),
(19, 39, 'Pfizer', '2024-04-05', 2, 'Health Center B', 'PF-202', '2025-04-05', '2025-05-09 19:28:29', 'Clinic B', 'Dr. Smith'),
(20, 39, 'Pfizer', '2024-05-05', 3, 'Health Center B', 'PF-203', '2025-05-05', '2025-05-09 19:28:29', 'Clinic B', 'Dr. Smith'),
(21, 5, 'Pfizer', '2023-05-01', 1, 'Health Center A', NULL, NULL, '2025-05-11 12:54:24', NULL, NULL),
(22, 5, 'Pfizer', '2023-06-01', 2, 'Health Center A', NULL, NULL, '2025-05-11 12:54:24', NULL, NULL),
(23, 6, 'Moderna', '2023-04-15', 1, 'Clinic B', NULL, NULL, '2025-05-11 12:54:24', NULL, NULL),
(24, 6, 'Moderna', '2023-05-15', 2, 'Clinic B', NULL, NULL, '2025-05-11 12:54:24', NULL, NULL),
(25, 5, 'Pfizer', '2023-05-01', 1, 'Health Center A', NULL, NULL, '2025-05-11 12:56:15', NULL, NULL),
(26, 5, 'Pfizer', '2023-06-01', 2, 'Health Center A', NULL, NULL, '2025-05-11 12:56:15', NULL, NULL),
(27, 6, 'Moderna', '2023-04-15', 1, 'Clinic B', NULL, NULL, '2025-05-11 12:56:15', NULL, NULL),
(28, 6, 'Moderna', '2023-05-15', 2, 'Clinic B', NULL, NULL, '2025-05-11 12:56:15', NULL, NULL),
(29, 40, 'Pfizer', '2024-04-01', 1, 'Clinic A', NULL, NULL, '2025-05-11 12:58:29', NULL, NULL),
(30, 40, 'Pfizer', '2024-05-01', 2, 'Clinic A', NULL, NULL, '2025-05-11 12:58:29', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_doctor_softlink` (`doctor_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`document_id`),
  ADD KEY `uploaded_by` (`uploaded_by`),
  ADD KEY `related_record_id` (`related_record_id`);

--
-- Indexes for table `encryption_keys`
--
ALTER TABLE `encryption_keys`
  ADD PRIMARY KEY (`key_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `vaccination_records`
--
ALTER TABLE `vaccination_records`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `document_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `encryption_keys`
--
ALTER TABLE `encryption_keys`
  MODIFY `key_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `vaccination_records`
--
ALTER TABLE `vaccination_records`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `documents_ibfk_2` FOREIGN KEY (`related_record_id`) REFERENCES `vaccination_records` (`record_id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE;

--
-- Constraints for table `vaccination_records`
--
ALTER TABLE `vaccination_records`
  ADD CONSTRAINT `vaccination_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
