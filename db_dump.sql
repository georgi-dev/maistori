-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';



DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `cities` (`id`, `name`, `last_modified`) VALUES
(1,	'Sliven',	'2018-08-30 16:36:57'),
(2,	'Novo Selo',	'2018-08-30 16:37:14');




DROP TABLE IF EXISTS `leads`;
CREATE TABLE `leads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` int(10) unsigned NOT NULL,
  `trade` int(11) NOT NULL,
  `description` text NOT NULL,
  `budget` decimal(10,2) NOT NULL,
  `city` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `coordinates` varchar(255) NOT NULL,
  `approved` enum('no','yes') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creator` (`creator`),
  KEY `trade` (`trade`),
  KEY `city` (`city`),
  CONSTRAINT `leads_ibfk_4` FOREIGN KEY (`creator`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leads_ibfk_6` FOREIGN KEY (`trade`) REFERENCES `trades` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leads_ibfk_7` FOREIGN KEY (`city`) REFERENCES `cities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `notes` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_key` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `permissions` (`id`, `name`, `slug`, `notes`, `last_modified`) VALUES
(1,	'View dashboard',	'dashborad.view',	'View dashboard. Used to distinguish users from guests',	'2017-01-16 11:23:14'),
(2,	'Manage users',	'users.edit',	'Used to create and modify users',	'2017-01-16 11:54:05'),
(3,	'View users',	'users.view',	'Used to have readonly access to users',	'2017-01-16 11:54:37'),
(25,	'View profiles',	'profiles.view',	'View profiles. Used by organization admins',	'2017-01-18 12:08:34'),
(28,	'View organizations',	'organizations.view',	'View organizations. Used by organization admins',	'2017-01-18 12:10:31'),
(29,	'Manage organizations',	'organizations.edit',	'Used by organization managers',	'2017-01-24 11:38:59'),
(30,	'View projects',	'projects.view',	'Used to view list of projects',	'2017-01-24 11:40:28'),
(31,	'Manage projects',	'projects.edit',	'Used by Organization admins and project managers',	'2017-01-24 11:41:19');

DROP TABLE IF EXISTS `proposals`;
CREATE TABLE `proposals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lead` int(11) NOT NULL,
  `user` int(10) unsigned NOT NULL,
  `description` text NOT NULL,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lead` (`lead`),
  KEY `user` (`user`),
  CONSTRAINT `proposals_ibfk_1` FOREIGN KEY (`lead`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `proposals_ibfk_2` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `roleperms`;
CREATE TABLE `roleperms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role` int(10) unsigned NOT NULL,
  `permission` int(10) unsigned NOT NULL,
  `last_modified` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `roleperm_role` (`role`),
  KEY `roleperm_perm` (`permission`),
  CONSTRAINT `roleperms_ibfk_1` FOREIGN KEY (`role`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `roleperms_ibfk_2` FOREIGN KEY (`permission`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

INSERT INTO `roleperms` (`id`, `role`, `permission`, `last_modified`) VALUES
(4,	1,	28,	'2017-01-19 14:56:56'),
(5,	7,	3,	'2017-02-04 23:06:32'),
(6,	7,	2,	'2017-02-04 23:06:42'),
(7,	1,	1,	'2017-02-04 23:07:09'),
(8,	2,	1,	'2017-02-04 23:07:44'),
(9,	2,	25,	'2017-02-04 23:07:54'),
(10,	2,	28,	'2017-02-04 23:08:01'),
(11,	2,	30,	'2017-02-04 23:08:07'),
(12,	12,	30,	'2017-02-10 00:18:29'),
(13,	13,	30,	'2017-02-10 00:19:09'),
(14,	12,	28,	'2017-02-10 00:52:07'),
(15,	14,	30,	'2017-02-10 00:54:23'),
(16,	11,	28,	'2017-02-10 00:56:07'),
(17,	10,	28,	'2017-02-10 00:58:47'),
(18,	16,	30,	'2017-02-10 01:00:58'),
(19,	2,	29,	'2017-02-10 12:50:48'),
(20,	9,	31,	'2017-02-13 15:41:40'),
(21,	17,	30,	'2017-02-14 15:05:15');

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `parent` int(11) DEFAULT NULL,
  `parents` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `notes` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `role_parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `roles` (`id`, `name`, `slug`, `parent`, `parents`, `notes`, `last_modified`) VALUES
(1,	'Guest',	'guest',	NULL,	'1',	NULL,	'2017-01-18 14:34:56'),
(2,	'User',	'user',	1,	'1,2',	NULL,	'2017-01-18 13:40:21'),
(7,	'Administartor',	'admin',	2,	'1,2,7',	'The administrator of the application. Has access to everything',	'2017-01-24 11:43:02'),
(8,	'Organization Manager',	'organization-manager',	13,	'1,2,13,8',	'The manager of an organization. Has full privileges to edit anything in it.',	'2017-01-24 11:44:16'),
(9,	'Project Manager',	'project-manager',	17,	'1,2,17,9',	'The project manager within an organization. Has privileges to manage their own projects.',	'2017-01-24 11:46:49'),
(10,	'Vendor contact',	'vendor-contact',	2,	'1,2,10',	'Vendor contact in an organization. Context of assignment is the organization ID. Used to view organizations where he/she is an vendor. Different from Project vendor',	'2017-01-24 11:47:20'),
(11,	'Client contact',	'client-contact',	2,	'1,2,11',	'Client contact in an organization. Context of assignment is the organization ID. Used to view organizations where he/she is an client. Different from Project client',	'2017-01-24 11:47:40'),
(12,	'Investor Contact',	'investor-contact',	2,	'1,2,12',	'Investor contact in an organization. Context of assignment is the organization ID. Used to view organizations where he/she is an investor. Different from Project investor',	'2017-01-24 11:48:02'),
(13,	'Organization member',	'organization-member',	2,	'1,2,13',	'Member in an organization',	'2017-02-08 18:42:39'),
(14,	'Project Investor',	'project-investor',	2,	'1,2,14',	'Contact of a project investor. Used to see details of project. Context of assignment is project ID',	'2017-02-09 22:54:03'),
(15,	'Project client',	'project-client',	2,	'1,2,15',	'Contact of a project client. Used to see details of project. Context of assignment is project ID',	'2017-02-09 22:59:51'),
(16,	'Project vendor',	'project-vendor',	2,	'1,2,16',	'Contact of a project vendor. Used to see details of project. Context of assignment is project ID',	'2017-02-09 23:00:47'),
(17,	'Project member',	'project-member',	2,	'1,2,17',	'Member of a project. Context of assignment is project ID',	'2017-02-14 13:05:01');

DROP TABLE IF EXISTS `trades`;
CREATE TABLE `trades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `descriptoin` text NOT NULL,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `userroles`;
CREATE TABLE `userroles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `role` int(10) unsigned NOT NULL,
  `context` int(10) unsigned NOT NULL DEFAULT 0,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `userrole_role` (`role`),
  KEY `context` (`context`),
  KEY `user` (`user`),
  CONSTRAINT `userroles_ibfk_2` FOREIGN KEY (`role`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userroles_ibfk_4` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` int(11) DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postcode` int(11) DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `introduction` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `about` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `verified` enum('no','yes') COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` enum('yes','no') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `city` (`city`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`city`) REFERENCES `cities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `users` (`id`, `username`, `password`, `email`, `first_name`, `last_name`, `display_name`, `avatar`, `city`, `address`, `postcode`, `phone`, `company`, `website`, `introduction`, `about`, `remember_token`, `verified`, `active`, `created_at`, `last_modified`) VALUES
(7,	'admin',	'1234',	'admin@digitalvoivode.com',	'Admin',	'Adminov',	'Admino',	NULL,	2,	'Hristo Botev 34',	8802,	'+359 899 829 949',	'DV',	NULL,	'Blah',	'Blah-blah',	NULL,	NULL,	'yes',	'2018-08-30 13:00:08',	'2018-08-30 16:02:10'),
(8,	'georgi',	'987654',	'georgi-dev@digitalvoivode.com',	'Georgi',	'Ivanov',	'GoergiIvanov',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'yes',	'2018-08-30 13:02:18',	'2018-08-30 16:02:18');

DROP TABLE IF EXISTS `usertrades`;
CREATE TABLE `usertrades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `trade` int(11) NOT NULL,
  `verified` enum('no','yes') NOT NULL,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `trade` (`trade`),
  CONSTRAINT `usertrades_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usertrades_ibfk_2` FOREIGN KEY (`trade`) REFERENCES `trades` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2018-08-30 14:37:39
DROP TABLE IF EXISTS `areasworked`;
CREATE TABLE `areasworked` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `city` int(11) NOT NULL,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `city` (`city`),
  CONSTRAINT `areasworked_ibfk_3` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `areasworked_ibfk_4` FOREIGN KEY (`city`) REFERENCES `cities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `insurances`;
CREATE TABLE `insurances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `issuer` varchar(255) NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `expiry` timestamp NULL DEFAULT current_timestamp(),
  `scan` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `verified` enum('no','yes') NOT NULL,
  `last_modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `insurances_ibfk_2` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `insurances` (`id`, `user`, `issuer`, `amount`, `expiry`, `scan`, `description`, `verified`, `last_modified`) VALUES
(2, 7,  'Дженерали България', 12345.68, '2018-12-30 22:00:00',  NULL, 'My insurance', 'no', '0000-00-00 00:00:00');
