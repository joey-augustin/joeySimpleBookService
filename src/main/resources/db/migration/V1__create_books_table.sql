CREATE TABLE `books` (
                         `id` bigint NOT NULL AUTO_INCREMENT,
                         `author` varchar(150) NOT NULL,
                         `genre` varchar(255) DEFAULT NULL,
                         `price` decimal(10,2) NOT NULL,
                         `title` varchar(200) NOT NULL,
                         PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
