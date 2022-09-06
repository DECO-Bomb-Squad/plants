CREATE TABLE `plant_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NOT NULL,
  `commonName` VARCHAR(255) NOT NULL,
  `fullName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));

  CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `email` VARCHAR(64) NOT NULL,
  `bio` VARCHAR(255) NULL,
  `startDate` DATETIME NOT NULL,
  `reputation` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);

  CREATE TABLE `plants` (
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

CREATE TABLE `activity_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `activities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `time` DATETIME NOT NULL,
  `activityTypeId` INT NOT NULL,
  `plantId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `activityType_idx` (`activityTypeId` ASC) VISIBLE,
  INDEX `plant_idx` (`plantId` ASC) VISIBLE,
  CONSTRAINT `activityType`
    FOREIGN KEY (`activityTypeId`)
    REFERENCES `plants`.`activity_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `plant`
    FOREIGN KEY (`plantId`)
    REFERENCES `plants`.`plants` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `plant_care_profile` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `soilType` VARCHAR(100) NOT NULL,
  `plantLocation` VARCHAR(100) NOT NULL,
  `plantId` INT NOT NULL,
  `daysBetweenWatering` INT NOT NULL,
  `daysBetweenRepotting` INT NULL,
  `daysBetweenFertilizer` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `plantId_idx` (`plantId` ASC) VISIBLE,
  CONSTRAINT `plant_care_profile_plantId`
    FOREIGN KEY (`plantId`)
    REFERENCES `plants`.`plants` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `plant_care_profile_default` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `plantTypeId` INT NOT NULL,
  `soilType` VARCHAR(100) NOT NULL,
  `plantLocation` VARCHAR(100) NOT NULL,
  `daysBetweenWatering` INT NOT NULL,
  `daysBetweenRepotting` INT NULL,
  `daysBetweenFertilizer` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `pcp_default_plantTypeId_idx` (`plantTypeId` ASC) VISIBLE,
  CONSTRAINT `pcp_default_plantTypeId`
    FOREIGN KEY (`plantTypeId`)
    REFERENCES `plants`.`plant_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
