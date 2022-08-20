CREATE TABLE `plants`.`plant_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NOT NULL,
  `commonName` VARCHAR(255) NOT NULL,
  `fullName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));

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
