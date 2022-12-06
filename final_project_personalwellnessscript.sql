-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema new_schema1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema new_schema1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `new_schema1` ;
USE `new_schema1` ;

-- -----------------------------------------------------
-- Table `new_schema1`.`USER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`USER` (
  `user_name` VARCHAR(45) NOT NULL,
  `fname` VARCHAR(45) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  `dob` DATE NOT NULL COMMENT 'Check that someone is at least 16\n',
  `sex_at_birth` VARCHAR(1) NOT NULL COMMENT 'M/F/I options',
  `home_country` VARCHAR(45) NOT NULL,
  `home_stateprovince` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_name`))
ENGINE = InnoDB
PACK_KEYS = Default
ROW_FORMAT = Default;


-- -----------------------------------------------------
-- Table `new_schema1`.`FEMALE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`FEMALE_INSTANCE` (
  `start_date` DATE NOT NULL,
  `type` VARCHAR(1) NOT NULL COMMENT '{period, menopause, pregnancy, miscarry, gave_birth}',
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`start_date`, `USER_user_name`),
  INDEX `fk_FEMALE_INSTANCE_USER_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_FEMALE_INSTANCE_USER`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
PACK_KEYS = Default;


-- -----------------------------------------------------
-- Table `new_schema1`.`CONDITION_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`CONDITION_TYPE` (
  `condition_name` VARCHAR(45) NOT NULL,
  `chronicity` VARCHAR(45) NOT NULL COMMENT '{relapse-remitting, progressive, temporary, unknown}',
  PRIMARY KEY (`condition_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`CONDITION_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`CONDITION_INSTANCE` (
  `onset_date` DATE NOT NULL,
  `diagnosing_doctor` VARCHAR(45) NULL,
  `CONDITION_condition_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`onset_date`, `CONDITION_condition_name`, `USER_user_name`),
  INDEX `fk_CONDITION_INSTANCE_CONDITION1_idx` (`CONDITION_condition_name` ASC) VISIBLE,
  INDEX `fk_CONDITION_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_CONDITION_INSTANCE_CONDITION1`
    FOREIGN KEY (`CONDITION_condition_name`)
    REFERENCES `new_schema1`.`CONDITION_TYPE` (`condition_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CONDITION_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`SYMPTOM_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`SYMPTOM_TYPE` (
  `symptom_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`symptom_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`SYMPTOM_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`SYMPTOM_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `severity` INT(2) NOT NULL COMMENT '[0-10]',
  `duration_hours` INT(2) NULL,
  `SYMPTOM_TYPE_symptom_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `SYMPTOM_TYPE_symptom_name`, `USER_user_name`),
  INDEX `fk_SYMPTOM_INSTANCE_SYMPTOM_TYPE1_idx` (`SYMPTOM_TYPE_symptom_name` ASC) VISIBLE,
  INDEX `fk_SYMPTOM_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_SYMPTOM_INSTANCE_SYMPTOM_TYPE1`
    FOREIGN KEY (`SYMPTOM_TYPE_symptom_name`)
    REFERENCES `new_schema1`.`SYMPTOM_TYPE` (`symptom_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SYMPTOM_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`MEDICATION_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`MEDICATION_TYPE` (
  `medication_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`medication_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`MEDICATION_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`MEDICATION_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `dosage` VARCHAR(8) NOT NULL,
  `MEDICATION_TYPE_medication_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `MEDICATION_TYPE_medication_name`, `USER_user_name`),
  INDEX `fk_MEDICATION_INSTANCE_MEDICATION_TYPE1_idx` (`MEDICATION_TYPE_medication_name` ASC) VISIBLE,
  INDEX `fk_MEDICATION_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_MEDICATION_INSTANCE_MEDICATION_TYPE1`
    FOREIGN KEY (`MEDICATION_TYPE_medication_name`)
    REFERENCES `new_schema1`.`MEDICATION_TYPE` (`medication_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MEDICATION_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`CONDITION_SYMPTOM`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`CONDITION_SYMPTOM` (
  `CONDITION_INSTANCE_onset_date` DATE NOT NULL,
  `CONDITION_INSTANCE_CONDITION_condition_name` VARCHAR(45) NOT NULL,
  `CONDITION_INSTANCE_USER_user_name` VARCHAR(45) NOT NULL,
  `SYMPTOM_TYPE_symptom_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CONDITION_INSTANCE_onset_date`, `CONDITION_INSTANCE_CONDITION_condition_name`, `CONDITION_INSTANCE_USER_user_name`, `SYMPTOM_TYPE_symptom_name`),
  INDEX `fk_CONDITION_SYMPTOM_CONDITION_INSTANCE1_idx` (`CONDITION_INSTANCE_onset_date` ASC, `CONDITION_INSTANCE_CONDITION_condition_name` ASC, `CONDITION_INSTANCE_USER_user_name` ASC) VISIBLE,
  INDEX `fk_CONDITION_SYMPTOM_SYMPTOM_TYPE1_idx` (`SYMPTOM_TYPE_symptom_name` ASC) VISIBLE,
  CONSTRAINT `fk_CONDITION_SYMPTOM_CONDITION_INSTANCE1`
    FOREIGN KEY (`CONDITION_INSTANCE_onset_date` , `CONDITION_INSTANCE_CONDITION_condition_name` , `CONDITION_INSTANCE_USER_user_name`)
    REFERENCES `new_schema1`.`CONDITION_INSTANCE` (`onset_date` , `CONDITION_condition_name` , `USER_user_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CONDITION_SYMPTOM_SYMPTOM_TYPE1`
    FOREIGN KEY (`SYMPTOM_TYPE_symptom_name`)
    REFERENCES `new_schema1`.`SYMPTOM_TYPE` (`symptom_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`CONDITION MEDICATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`CONDITION MEDICATION` (
  `date_precribed` DATE NOT NULL,
  `CONDITION_INSTANCE_onset_date` DATE NOT NULL,
  `CONDITION_INSTANCE_CONDITION_condition_name` VARCHAR(45) NOT NULL,
  `CONDITION_INSTANCE_USER_user_name` VARCHAR(45) NOT NULL,
  `MEDICATION_TYPE_medication_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date_precribed`, `CONDITION_INSTANCE_onset_date`, `CONDITION_INSTANCE_CONDITION_condition_name`, `CONDITION_INSTANCE_USER_user_name`, `MEDICATION_TYPE_medication_name`),
  INDEX `fk_CONDITION MEDICATION_CONDITION_INSTANCE1_idx` (`CONDITION_INSTANCE_onset_date` ASC, `CONDITION_INSTANCE_CONDITION_condition_name` ASC, `CONDITION_INSTANCE_USER_user_name` ASC) VISIBLE,
  INDEX `fk_CONDITION MEDICATION_MEDICATION_TYPE1_idx` (`MEDICATION_TYPE_medication_name` ASC) VISIBLE,
  CONSTRAINT `fk_CONDITION MEDICATION_CONDITION_INSTANCE1`
    FOREIGN KEY (`CONDITION_INSTANCE_onset_date` , `CONDITION_INSTANCE_CONDITION_condition_name` , `CONDITION_INSTANCE_USER_user_name`)
    REFERENCES `new_schema1`.`CONDITION_INSTANCE` (`onset_date` , `CONDITION_condition_name` , `USER_user_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CONDITION MEDICATION_MEDICATION_TYPE1`
    FOREIGN KEY (`MEDICATION_TYPE_medication_name`)
    REFERENCES `new_schema1`.`MEDICATION_TYPE` (`medication_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`MOOD_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`MOOD_TYPE` (
  `name` INT NOT NULL,
  `is_negative_valence()` TINYINT NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`MOOD_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`MOOD_INSTANCE` (
  `MOOD_TYPE_name` INT NOT NULL,
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MOOD_TYPE_name`, `date`, `time`, `USER_user_name`),
  INDEX `fk_MOOD_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_MOOD_INSTANCE_MOOD_TYPE1`
    FOREIGN KEY (`MOOD_TYPE_name`)
    REFERENCES `new_schema1`.`MOOD_TYPE` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MOOD_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`VITALS_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`VITALS_TYPE` (
  `vital_name` INT NOT NULL,
  `upper_lim` INT NOT NULL,
  `lower_lim` INT NOT NULL,
  `unit` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`vital_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`VITAL_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`VITAL_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `position` VARCHAR(3) NOT NULL COMMENT 'Seated, standing, lying, eyes closed, eyes open\n',
  `fasting` TINYINT NOT NULL COMMENT 'Yes/no\n',
  `tool_method` VARCHAR(45) NULL,
  `VITALS_TYPE_vital_name` INT NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `VITALS_TYPE_vital_name`, `USER_user_name`),
  INDEX `fk_VITAL_INSTANCE_VITALS_TYPE1_idx` (`VITALS_TYPE_vital_name` ASC) VISIBLE,
  INDEX `fk_VITAL_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_VITAL_INSTANCE_VITALS_TYPE1`
    FOREIGN KEY (`VITALS_TYPE_vital_name`)
    REFERENCES `new_schema1`.`VITALS_TYPE` (`vital_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VITAL_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`BODY_MEASURE_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`BODY_MEASURE_TYPE` (
  `name` VARCHAR(45) NOT NULL,
  `units` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`BODY_MEASURE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`BODY_MEASURE_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `BODY_MEASURE_TYPE_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `BODY_MEASURE_TYPE_name`, `USER_user_name`),
  INDEX `fk_BODY_MEASURE_INSTANCE_BODY_MEASURE_TYPE1_idx` (`BODY_MEASURE_TYPE_name` ASC) VISIBLE,
  INDEX `fk_BODY_MEASURE_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_BODY_MEASURE_INSTANCE_BODY_MEASURE_TYPE1`
    FOREIGN KEY (`BODY_MEASURE_TYPE_name`)
    REFERENCES `new_schema1`.`BODY_MEASURE_TYPE` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BODY_MEASURE_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`EXERCISE_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`EXERCISE_TYPE` (
  `name` VARCHAR(45) NOT NULL COMMENT 'Aerobic, plyometric, calisthenic, weight-bearing',
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`EXERCISE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`EXERCISE_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `EXERCISE_TYPE_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `perceived_intensity` INT(2) NOT NULL COMMENT '0-10',
  `duration_mins` INT(3) NOT NULL,
  PRIMARY KEY (`date`, `time`, `EXERCISE_TYPE_name`, `USER_user_name`),
  INDEX `fk_EXERCISE_INSTANCE_EXERCISE_TYPE1_idx` (`EXERCISE_TYPE_name` ASC) VISIBLE,
  INDEX `fk_EXERCISE_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_EXERCISE_INSTANCE_EXERCISE_TYPE1`
    FOREIGN KEY (`EXERCISE_TYPE_name`)
    REFERENCES `new_schema1`.`EXERCISE_TYPE` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EXERCISE_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`LOCATIONS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`LOCATIONS` (
  `location_name` VARCHAR(45) NOT NULL,
  `street_address` INT NULL,
  `street` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `state_or_province` VARCHAR(45) NOT NULL DEFAULT 'USER.home_stateprovince',
  `country` VARCHAR(45) NOT NULL DEFAULT 'USER.home_country',
  PRIMARY KEY (`location_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`SLEEP_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`SLEEP_INSTANCE` (
  `date` DATE NOT NULL,
  `duration` VARCHAR(45) NOT NULL,
  `alone` TINYINT NOT NULL COMMENT 'Boolean type',
  `preceived_quality` INT(2) NULL,
  `deep` INT(2) NULL,
  `light` INT(2) NULL,
  `awake_mins` INT(3) NULL,
  `SLEEP_LOCATIONS_location_name` VARCHAR(45) NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `USER_user_name`),
  INDEX `fk_SLEEP_INSTANCE_SLEEP_LOCATIONS1_idx` (`SLEEP_LOCATIONS_location_name` ASC) VISIBLE,
  INDEX `fk_SLEEP_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_SLEEP_INSTANCE_SLEEP_LOCATIONS1`
    FOREIGN KEY (`SLEEP_LOCATIONS_location_name`)
    REFERENCES `new_schema1`.`LOCATIONS` (`location_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SLEEP_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`FOOD_BEV_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`FOOD_BEV_TYPE` (
  `name` VARCHAR(55) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`FOOD_BEV_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`FOOD_BEV_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `amount` FLOAT NULL,
  `units` VARCHAR(45) NULL,
  `FOOD_BEV_TYPE_name` VARCHAR(55) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `FOOD_BEV_TYPE_name`, `USER_user_name`),
  INDEX `fk_FOODBEV_INGESTION_FOOD_BEV_TYPE1_idx` (`FOOD_BEV_TYPE_name` ASC) VISIBLE,
  INDEX `fk_FOODBEV_INGESTION_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_FOODBEV_INGESTION_FOOD_BEV_TYPE1`
    FOREIGN KEY (`FOOD_BEV_TYPE_name`)
    REFERENCES `new_schema1`.`FOOD_BEV_TYPE` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FOODBEV_INGESTION_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`RECREATIONAL_INTOXICANT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`RECREATIONAL_INTOXICANT` (
  `name` VARCHAR(45) NOT NULL,
  `measurement_untis` VARCHAR(45) NOT NULL,
  `ingestion_method` VARCHAR(45) NOT NULL,
  `class_category` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`INTOXICANT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`INTOXICANT_INSTANCE` (
  `RECREATIONAL_INTOXICANT_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `amount` FLOAT NOT NULL,
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  PRIMARY KEY (`RECREATIONAL_INTOXICANT_name`, `USER_user_name`, `date`, `time`),
  INDEX `fk_INTOXICANT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_INTOXICANT_INSTANCE_RECREATIONAL_INTOXICANT1`
    FOREIGN KEY (`RECREATIONAL_INTOXICANT_name`)
    REFERENCES `new_schema1`.`RECREATIONAL_INTOXICANT` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_INTOXICANT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`TRANSPORT_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`TRANSPORT_TYPE` (
  `transport_type` INT NOT NULL,
  PRIMARY KEY (`transport_type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`TRANSPORT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`TRANSPORT_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `duration_hours` FLOAT NOT NULL,
  `for_pleasure` TINYINT NOT NULL,
  `depart_location` VARCHAR(45) NOT NULL,
  `arrival_location` VARCHAR(45) NOT NULL,
  `TRANSPORT_transport_type` INT NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `LOCATIONS_location_name` VARCHAR(45) NULL,
  PRIMARY KEY (`date`, `time`, `TRANSPORT_transport_type`, `USER_user_name`),
  INDEX `fk_TRANSPORT_INSTANCE_TRANSPORT1_idx` (`TRANSPORT_transport_type` ASC) VISIBLE,
  INDEX `fk_TRANSPORT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  INDEX `fk_TRANSPORT_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_name` ASC) VISIBLE,
  CONSTRAINT `fk_TRANSPORT_INSTANCE_TRANSPORT1`
    FOREIGN KEY (`TRANSPORT_transport_type`)
    REFERENCES `new_schema1`.`TRANSPORT_TYPE` (`transport_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRANSPORT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRANSPORT_INSTANCE_LOCATIONS1`
    FOREIGN KEY (`LOCATIONS_location_name`)
    REFERENCES `new_schema1`.`LOCATIONS` (`location_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`POSITIVE_EVENT_CATEGORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`POSITIVE_EVENT_CATEGORY` (
  `category_type` VARCHAR(45) NOT NULL COMMENT '{spiritual, emotional, achievement, interpersonal, recreation, entertainment}',
  PRIMARY KEY (`category_type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`POSITIVE_EVENT_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`POSITIVE_EVENT_TYPE` (
  `event_name` VARCHAR(45) NOT NULL,
  `POSITIVE_EVENT_CATEGORY_category_type` VARCHAR(45) NULL,
  PRIMARY KEY (`event_name`),
  INDEX `fk_POSITIVE_EVENT_TYPE_POSITIVE_EVENT_CATEGORY1_idx` (`POSITIVE_EVENT_CATEGORY_category_type` ASC) VISIBLE,
  CONSTRAINT `fk_POSITIVE_EVENT_TYPE_POSITIVE_EVENT_CATEGORY1`
    FOREIGN KEY (`POSITIVE_EVENT_CATEGORY_category_type`)
    REFERENCES `new_schema1`.`POSITIVE_EVENT_CATEGORY` (`category_type`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`POSITIVE_EVENT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`POSITIVE_EVENT_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `duration_hours` FLOAT NULL,
  `LOCATIONS_location_name` VARCHAR(45) NULL,
  `POSITIVE_EVENT_TYPE_event_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `end_time` TIME NULL,
  `end_date` DATE NULL,
  PRIMARY KEY (`date`, `time`, `POSITIVE_EVENT_TYPE_event_name`, `USER_user_name`),
  INDEX `fk_POSITIVE_EVENT_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_name` ASC) VISIBLE,
  INDEX `fk_POSITIVE_EVENT_INSTANCE_POSITIVE_EVENT_TYPE1_idx` (`POSITIVE_EVENT_TYPE_event_name` ASC) VISIBLE,
  INDEX `fk_POSITIVE_EVENT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_POSITIVE_EVENT_INSTANCE_LOCATIONS1`
    FOREIGN KEY (`LOCATIONS_location_name`)
    REFERENCES `new_schema1`.`LOCATIONS` (`location_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_POSITIVE_EVENT_INSTANCE_POSITIVE_EVENT_TYPE1`
    FOREIGN KEY (`POSITIVE_EVENT_TYPE_event_name`)
    REFERENCES `new_schema1`.`POSITIVE_EVENT_TYPE` (`event_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_POSITIVE_EVENT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`STRESSOR_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`STRESSOR_TYPE` (
  `name` VARCHAR(40) NOT NULL COMMENT '{pollution, chemical, injury, work, interpersonal, viral_bacterial}',
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`STRESSOR_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`STRESSOR_INSTANCE` (
  `start_date` DATE NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NULL COMMENT 'Each day the person has the experience',
  `end_date` DATE NULL,
  `duartion_hours` FLOAT NULL,
  `LOCATIONS_location_name` VARCHAR(45) NULL,
  `STRESSOR_TYPE_name` VARCHAR(40) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`start_date`, `start_time`, `STRESSOR_TYPE_name`, `USER_user_name`),
  INDEX `fk_STRESSOR_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_name` ASC) VISIBLE,
  INDEX `fk_STRESSOR_INSTANCE_STRESSOR_TYPE1_idx` (`STRESSOR_TYPE_name` ASC) VISIBLE,
  INDEX `fk_STRESSOR_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_STRESSOR_INSTANCE_LOCATIONS1`
    FOREIGN KEY (`LOCATIONS_location_name`)
    REFERENCES `new_schema1`.`LOCATIONS` (`location_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_STRESSOR_INSTANCE_STRESSOR_TYPE1`
    FOREIGN KEY (`STRESSOR_TYPE_name`)
    REFERENCES `new_schema1`.`STRESSOR_TYPE` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_STRESSOR_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`TREATMENT_CATEGORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`TREATMENT_CATEGORY` (
  `category_name` INT NOT NULL,
  PRIMARY KEY (`category_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`TREATMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`TREATMENT` (
  `treatment_name` VARCHAR(45) NOT NULL,
  `TREATMENT_CATEGORY_category_name` INT NULL,
  PRIMARY KEY (`treatment_name`),
  INDEX `fk_TREATMENT_TREATMENT_CATEGORY1_idx` (`TREATMENT_CATEGORY_category_name` ASC) VISIBLE,
  CONSTRAINT `fk_TREATMENT_TREATMENT_CATEGORY1`
    FOREIGN KEY (`TREATMENT_CATEGORY_category_name`)
    REFERENCES `new_schema1`.`TREATMENT_CATEGORY` (`category_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_schema1`.`TREATMENT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `new_schema1`.`TREATMENT_INSTANCE` (
  `date` DATE NOT NULL,
  `time` TIME NOT NULL,
  `duration_hours` FLOAT NULL,
  `TREATMENT_treatment_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `TREATMENT_treatment_name`, `USER_user_name`),
  INDEX `fk_TREATMENT_INSTANCE_TREATMENT1_idx` (`TREATMENT_treatment_name` ASC) VISIBLE,
  INDEX `fk_TREATMENT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_TREATMENT_INSTANCE_TREATMENT1`
    FOREIGN KEY (`TREATMENT_treatment_name`)
    REFERENCES `new_schema1`.`TREATMENT` (`treatment_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TREATMENT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `new_schema1`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
