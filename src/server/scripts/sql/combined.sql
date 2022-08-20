CREATE TABLE `plants`.`plant_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NOT NULL,
  `commonName` VARCHAR(255) NOT NULL,
  `fullName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));

  CREATE TABLE `plants`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `email` VARCHAR(64) NOT NULL,
  `bio` VARCHAR(255) NULL,
  `startDate` DATETIME NOT NULL,
  `reputation` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);

  CREATE TABLE `plants`.`plants` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `desc` VARCHAR(255) NOT NULL,
  `plantTypeId` INT NOT NULL,
  `userId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `plantTypeId_idx` (`plantTypeId` ASC) VISIBLE,
  INDEX `userId_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `plantTypeId`
    FOREIGN KEY (`plantTypeId`)
    REFERENCES `plants`.`plant_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `userId`
    FOREIGN KEY (`userId`)
    REFERENCES `plants`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
