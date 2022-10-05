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
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC));

CREATE TABLE `plant_care_profile` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `soilType` VARCHAR(100) NOT NULL,
  `plantLocation` VARCHAR(100) NOT NULL,
  `daysBetweenWatering` INT NOT NULL,
  `daysBetweenRepotting` INT NULL,
  `daysBetweenFertilizer` INT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `plant_care_profile_default` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `plantTypeId` INT NOT NULL,
  `soilType` VARCHAR(100) NOT NULL,
  `plantLocation` VARCHAR(100) NOT NULL,
  `daysBetweenWatering` INT NOT NULL,
  `daysBetweenRepotting` INT NULL,
  `daysBetweenFertilizer` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `pcp_default_plantTypeId_idx` (`plantTypeId` ASC),
  CONSTRAINT `pcp_default_plantTypeId`
    FOREIGN KEY (`plantTypeId`)
    REFERENCES `plant_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `plants` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `plantName` VARCHAR(255) NOT NULL,
  `plantDesc` VARCHAR(255) NOT NULL,
  `plantTypeId` INT NOT NULL,
  `userId` INT NOT NULL,
  `careProfileId` INT NOT NULL,
  PRIMARY KEY (`id`, `plantTypeId`, `userId`, `careProfileId`),
  INDEX `plant_to_type_idx` (`plantTypeId` ASC),
  INDEX `plant_to_user_idx` (`userId` ASC),
  INDEX `plant_to_profile_idx` (`careProfileId` ASC),
  CONSTRAINT `plant_to_type`
    FOREIGN KEY (`plantTypeId`)
    REFERENCES `plant_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `plant_to_user`
    FOREIGN KEY (`userId`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `plant_to_profile`
    FOREIGN KEY (`careProfileId`)
    REFERENCES `plant_care_profile` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


CREATE TABLE `activity_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `activityDesc` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `activities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `activityTime` DATETIME NOT NULL,
  `activityTypeId` INT NOT NULL,
  `plantId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `activityType_idx` (`activityTypeId` ASC),
  INDEX `plant_idx` (`plantId` ASC),
  CONSTRAINT `activityType`
    FOREIGN KEY (`activityTypeId`)
    REFERENCES `activity_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `plant`
    FOREIGN KEY (`plantId`)
    REFERENCES `plants` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

  CREATE TABLE `photos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uri` VARCHAR(255) NOT NULL,
  `photoTime` DATETIME NOT NULL,
  `plantId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `plant_idx` (`plantId` ASC),
  CONSTRAINT `photoPlant`
    FOREIGN KEY (`plantId`)
    REFERENCES `plants` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `plant_tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `plantTypeId` INT NOT NULL,
  `tagId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `plant_type_to_plant_tag_idx` (`plantTypeId` ASC),
  INDEX `tag_id_to_plant_tag_idx` (`tagId` ASC),
  CONSTRAINT `plant_type_to_plant_tag`
    FOREIGN KEY (`plantTypeId`)
    REFERENCES `plant_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `tag_id_to_plant_tag`
    FOREIGN KEY (`tagId`)
    REFERENCES `tags` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
