-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema final_project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema final_project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `final_project` ;
USE `final_project` ;

-- -----------------------------------------------------
-- Table `final_project`.`COUNTRY_LOOKUP_TABLE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`COUNTRY_LOOKUP_TABLE` (
  `country_abbreviation` VARCHAR(3) NOT NULL,
  `country_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`country_abbreviation`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`STATE_LOOKUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`STATE_LOOKUP` (
  `COUNTRY_LOOKUP_TABLE_country_abbreviation` VARCHAR(3) NOT NULL,
  `state_name` VARCHAR(45) NOT NULL,
  `state_abbreviation` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`COUNTRY_LOOKUP_TABLE_country_abbreviation`, `state_abbreviation`),
  CONSTRAINT `fk_STATE_IN_COUNTRY_COUNTRY_LOOKUP_TABLE1`
    FOREIGN KEY (`COUNTRY_LOOKUP_TABLE_country_abbreviation`)
    REFERENCES `final_project`.`COUNTRY_LOOKUP_TABLE` (`country_abbreviation`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`USER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`USER` (
  `user_name` VARCHAR(45) NOT NULL,
  `fname` VARCHAR(45) NOT NULL COMMENT 'First name',
  `lname` VARCHAR(45) NOT NULL COMMENT 'Last name',
  `dob` DATE NOT NULL COMMENT 'Date of birth yyy-mm-dd format',
  `sex_at_birth` enum('Female', 'Intersex', 'Male') NOT NULL COMMENT 'Sex at birth',
  `STATE_LOOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation` VARCHAR(3) NOT NULL COMMENT 'Country of residence',
  `STATE_LOOKUP_state_abbreviation` VARCHAR(3) NOT NULL COMMENT 'State of residence',
  PRIMARY KEY (`user_name`),
  INDEX `fk_USER_STATE_IN_COUNTRY1_idx` (`STATE_LOOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation` ASC, `STATE_LOOKUP_state_abbreviation` ASC) VISIBLE,
  CONSTRAINT `fk_USER_STATE_IN_COUNTRY1`
    FOREIGN KEY (`STATE_LOOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation` , `STATE_LOOKUP_state_abbreviation`)
    REFERENCES `final_project`.`STATE_LOOKUP` (`COUNTRY_LOOKUP_TABLE_country_abbreviation` , `state_abbreviation`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
PACK_KEYS = Default
ROW_FORMAT = Default;


-- -----------------------------------------------------
-- Table `final_project`.`FEMALE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`FEMALE_INSTANCE` (
  `start_date` DATE NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `event_type` enum('Pregnancy', 'Menopause', 'Menstruation', 'Gave Birth', 'Miscarriage', 'Perimenopause') NOT NULL,
  PRIMARY KEY (`start_date`, `USER_user_name`),
  INDEX `fk_FEMALE_INSTANCE_USER_idx` (`USER_user_name` ASC VISIBLE),
  CONSTRAINT `fk_FEMALE_INSTANCE_USER`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
PACK_KEYS = Default;




-- -----------------------------------------------------
-- Table `final_project`.`CONDITION_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`CONDITION_TYPE` (
  `condition_name` VARCHAR(45) NOT NULL,
  `chronicity` enum('acute', 'chronic-progressive', 'chronic', 'relapse-remitting') NOT NULL,
  `condition_id` INT NOT NULL AUTO_INCREMENT COMMENT 'Auto-generated ID associated with the condition',
  PRIMARY KEY (`condition_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`CONDITION_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`CONDITION_INSTANCE` (
  `onset_date` DATE NOT NULL,
  `diagnosing_doctor` VARCHAR(45) NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `condition_instance_id` INT NOT NULL AUTO_INCREMENT,
  `CONDITION_TYPE_condition_id` INT NOT NULL,
  INDEX `fk_CONDITION_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  PRIMARY KEY (`condition_instance_id`),
  INDEX `fk_CONDITION_INSTANCE_CONDITION_TYPE1_idx` (`CONDITION_TYPE_condition_id` ASC) VISIBLE,
  CONSTRAINT `fk_CONDITION_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_CONDITION_INSTANCE_CONDITION_TYPE1`
    FOREIGN KEY (`CONDITION_TYPE_condition_id`)
    REFERENCES `final_project`.`CONDITION_TYPE` (`condition_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`SYMPTOM_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`SYMPTOM_TYPE` (
  `symptom_name` VARCHAR(45) NOT NULL COMMENT 'Assumption that symptom is negative event',
  PRIMARY KEY (`symptom_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`SYMPTOM_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`SYMPTOM_INSTANCE` (
  `date_time` TIMESTAMP NOT NULL COMMENT 'Time of symptom onset',
  `severity` enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NOT NULL COMMENT '[0-10]',
  `duration` TIME NULL COMMENT 'Duration of symptom at specified severity (optional)',
  `SYMPTOM_TYPE_symptom_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date_time`, `SYMPTOM_TYPE_symptom_name`, `USER_user_name`),
  INDEX `fk_SYMPTOM_INSTANCE_SYMPTOM_TYPE1_idx` (`SYMPTOM_TYPE_symptom_name` ASC) VISIBLE,
  INDEX `fk_SYMPTOM_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_SYMPTOM_INSTANCE_SYMPTOM_TYPE1`
    FOREIGN KEY (`SYMPTOM_TYPE_symptom_name`)
    REFERENCES `final_project`.`SYMPTOM_TYPE` (`symptom_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_SYMPTOM_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`MEDICATION_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`MEDICATION_TYPE` (
  `medication_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`medication_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`MEDICATION_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`MEDICATION_INSTANCE` (
  `date_time` TIMESTAMP NOT NULL COMMENT 'Time medication is taken',
  `dosage` enum('g', 'mg', 'mL', 'l', 'fl oz', 'tsp', 'tbs', 'IU', 'drops', 'tablets', 'sprays') NOT NULL,
  `MEDICATION_TYPE_medication_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date_time`, `MEDICATION_TYPE_medication_name`, `USER_user_name`),
  INDEX `fk_MEDICATION_INSTANCE_MEDICATION_TYPE1_idx` (`MEDICATION_TYPE_medication_name` ASC) VISIBLE,
  INDEX `fk_MEDICATION_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_MEDICATION_INSTANCE_MEDICATION_TYPE1`
    FOREIGN KEY (`MEDICATION_TYPE_medication_name`)
    REFERENCES `final_project`.`MEDICATION_TYPE` (`medication_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_MEDICATION_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`CONDITION_SYMPTOM`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`CONDITION_SYMPTOM` (
  `SYMPTOM_TYPE_symptom_name` VARCHAR(45) NOT NULL COMMENT 'Symptom associated with condtion',
  `CONDITION_INSTANCE_condition_instance_id` INT NOT NULL COMMENT 'Condition associated with symptom',
  PRIMARY KEY (`SYMPTOM_TYPE_symptom_name`, `CONDITION_INSTANCE_condition_instance_id`),
  INDEX `fk_CONDITION_SYMPTOM_SYMPTOM_TYPE1_idx` (`SYMPTOM_TYPE_symptom_name` ASC) VISIBLE,
  INDEX `fk_CONDITION_SYMPTOM_CONDITION_INSTANCE1_idx` (`CONDITION_INSTANCE_condition_instance_id` ASC) VISIBLE,
  CONSTRAINT `fk_CONDITION_SYMPTOM_SYMPTOM_TYPE1`
    FOREIGN KEY (`SYMPTOM_TYPE_symptom_name`)
    REFERENCES `final_project`.`SYMPTOM_TYPE` (`symptom_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_CONDITION_SYMPTOM_CONDITION_INSTANCE1`
    FOREIGN KEY (`CONDITION_INSTANCE_condition_instance_id`)
    REFERENCES `final_project`.`CONDITION_INSTANCE` (`condition_instance_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`CONDITION MEDICATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`CONDITION MEDICATION` (
  `date` DATE NOT NULL COMMENT 'Date started taking for condition',
  `MEDICATION_TYPE_medication_name` VARCHAR(45) NOT NULL,
  `CONDITION_INSTANCE_condition_instance_id` INT NOT NULL,
  PRIMARY KEY (`MEDICATION_TYPE_medication_name`, `CONDITION_INSTANCE_condition_instance_id`),
  INDEX `fk_CONDITION MEDICATION_MEDICATION_TYPE1_idx` (`MEDICATION_TYPE_medication_name` ASC) VISIBLE,
  INDEX `fk_CONDITION MEDICATION_CONDITION_INSTANCE1_idx` (`CONDITION_INSTANCE_condition_instance_id` ASC) VISIBLE,
  CONSTRAINT `fk_CONDITION MEDICATION_MEDICATION_TYPE1`
    FOREIGN KEY (`MEDICATION_TYPE_medication_name`)
    REFERENCES `final_project`.`MEDICATION_TYPE` (`medication_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_CONDITION MEDICATION_CONDITION_INSTANCE1`
    FOREIGN KEY (`CONDITION_INSTANCE_condition_instance_id`)
    REFERENCES `final_project`.`CONDITION_INSTANCE` (`condition_instance_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`MOOD_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`MOOD_TYPE` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `is_negative_valence()` enum('Yes', 'No') NOT NULL DEFAULT 'No' COMMENT '\'No\' if positive or neutral, \'Yes\' if negative',
  `name` VARCHAR(45) NULL COMMENT 'Name of mood',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`MOOD_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`MOOD_INSTANCE` (
  `date_time` TIMESTAMP NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `severity` enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NOT NULL COMMENT 'Perceived intensity of mood [0:10]',
  `MOOD_TYPE_id` INT NOT NULL,
  PRIMARY KEY (`date_time`, `USER_user_name`, `MOOD_TYPE_id`),
  INDEX `fk_MOOD_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  INDEX `fk_MOOD_INSTANCE_MOOD_TYPE1_idx` (`MOOD_TYPE_id` ASC) VISIBLE,
  CONSTRAINT `fk_MOOD_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_MOOD_INSTANCE_MOOD_TYPE1`
    FOREIGN KEY (`MOOD_TYPE_id`)
    REFERENCES `final_project`.`MOOD_TYPE` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TOOL_LOOKUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TOOL_LOOKUP` (
  `toolname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`toolname`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`VITALS_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`VITALS_TYPE` (
  `vital_code` INT NOT NULL AUTO_INCREMENT,
  `upper_lim` INT NOT NULL,
  `lower_lim` INT NOT NULL,
  `unit` VARCHAR(6) NOT NULL,
  `vital_name` VARCHAR(45) NULL,
  `POSITIONS_LOOKUP_positions_latin_name` enum('Fowlers (seated)', 'Prone (lying face down)', 'Supine(lying face up)', 'Right Lateral Recumbent', 'Left Lateral Recumbent', 'Trendelenburg') NOT NULL,
  `TOOL_LOOKUP_toolname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`vital_code`),
  INDEX `fk_VITALS_TYPE_TOOL_LOOKUP1_idx` (`TOOL_LOOKUP_toolname` ASC) VISIBLE,
  CONSTRAINT `fk_VITALS_TYPE_TOOL_LOOKUP1`
    FOREIGN KEY (`TOOL_LOOKUP_toolname`)
    REFERENCES `final_project`.`TOOL_LOOKUP` (`toolname`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT valid_limits CHECK (upper_lim>lower_lim))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`VITAL_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`VITAL_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `fasting` enum('Yes', 'No') NOT NULL COMMENT 'Yes/no',
  `VITALS_TYPE_vital_code` INT NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `VITALS_TYPE_vital_code`, `USER_user_name`),
  INDEX `fk_VITAL_INSTANCE_VITALS_TYPE1_idx` (`VITALS_TYPE_vital_code` ASC) VISIBLE,
  INDEX `fk_VITAL_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_VITAL_INSTANCE_VITALS_TYPE1`
    FOREIGN KEY (`VITALS_TYPE_vital_code`)
    REFERENCES `final_project`.`VITALS_TYPE` (`vital_code`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_VITAL_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`BODY_MEASURE_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`BODY_MEASURE_TYPE` (
  `measure_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `units` enum('lbs', 'kg', 'cm', 'inches', 'meters', '%', 'feet') NOT NULL,
  PRIMARY KEY (`measure_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`BODY_MEASURE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`BODY_MEASURE_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `BODY_MEASURE_TYPE_measure_id` INT NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `BODY_MEASURE_TYPE_measure_id`, `USER_user_name`),
  INDEX `fk_BODY_MEASURE_INSTANCE_BODY_MEASURE_TYPE1_idx` (`BODY_MEASURE_TYPE_measure_id` ASC) VISIBLE,
  INDEX `fk_BODY_MEASURE_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_BODY_MEASURE_INSTANCE_BODY_MEASURE_TYPE1`
    FOREIGN KEY (`BODY_MEASURE_TYPE_measure_id`)
    REFERENCES `final_project`.`BODY_MEASURE_TYPE` (`measure_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_BODY_MEASURE_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`EXERCISE_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`EXERCISE_TYPE` (
  `exercise_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `category` enum('Aerobic', 'Anarobic', 'Plyometric', 'HIIT', 'Calisthenic', 'Weight-bearing') NOT NULL,
  PRIMARY KEY (`exercise_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`EXERCISE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`EXERCISE_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `EXERCISE_TYPE_exercise_id` INT NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `perceived_intensity` enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '10')  NOT NULL COMMENT '0-10',
  `duration` TIME NOT NULL,
  PRIMARY KEY (`date`, `EXERCISE_TYPE_exercise_id`, `USER_user_name`),
  INDEX `fk_EXERCISE_INSTANCE_EXERCISE_TYPE1_idx` (`EXERCISE_TYPE_exercise_id` ASC) VISIBLE,
  INDEX `fk_EXERCISE_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_EXERCISE_INSTANCE_EXERCISE_TYPE1`
    FOREIGN KEY (`EXERCISE_TYPE_exercise_id`)
    REFERENCES `final_project`.`EXERCISE_TYPE` (`exercise_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_EXERCISE_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`LOCATIONS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`LOCATIONS` (
  `location_id` INT NOT NULL AUTO_INCREMENT,
  `location_name` VARCHAR(45) NOT NULL,
  `street_address` INT NULL,
  `street` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `STATE_LOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation` VARCHAR(3) NULL,
  `STATE_LOOKUP_state_abbreviation` VARCHAR(3) NULL,
  PRIMARY KEY (`location_id`),
  INDEX `fk_LOCATIONS_STATE_LOOKUP1_idx` (`STATE_LOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation` ASC, `STATE_LOOKUP_state_abbreviation` ASC) VISIBLE,
  CONSTRAINT `fk_LOCATIONS_STATE_LOOKUP1`
    FOREIGN KEY (`STATE_LOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation` , `STATE_LOOKUP_state_abbreviation`)
    REFERENCES `final_project`.`STATE_LOOKUP` (`COUNTRY_LOOKUP_TABLE_country_abbreviation` , `state_abbreviation`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`SLEEP_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`SLEEP_INSTANCE` (
  `date` DATE NOT NULL,
  `duration` TIME NOT NULL,
  `alone` enum('Yes', 'No') NOT NULL,
  `preceived_quality` enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '10')  NULL,
  `deep` TIME NULL COMMENT 'Deep Sleep Time',
  `light` TIME NULL COMMENT 'Light Sleep Time',
  `awake` TIME NULL,
  `SLEEP_LOCATIONS_location_id` INT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `USER_user_name`),
  INDEX `fk_SLEEP_INSTANCE_SLEEP_LOCATIONS1_idx` (`SLEEP_LOCATIONS_location_id` ASC) VISIBLE,
  INDEX `fk_SLEEP_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_SLEEP_INSTANCE_SLEEP_LOCATIONS1`
    FOREIGN KEY (`SLEEP_LOCATIONS_location_id`)
    REFERENCES `final_project`.`LOCATIONS` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_SLEEP_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`FOOD_BEV_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`FOOD_BEV_TYPE` (
  `name` VARCHAR(55) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`FOOD_BEV_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`FOOD_BEV_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `amount` FLOAT NULL,
  `units` enum('g', 'ml', 'oz', 'lb', 'cups', 'tbs', 'tsp', 'dash', 'serving', 'fl oz') NULL,
  `FOOD_BEV_TYPE_name` VARCHAR(55) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `FOOD_BEV_TYPE_name`, `USER_user_name`),
  INDEX `fk_FOODBEV_INGESTION_FOOD_BEV_TYPE1_idx` (`FOOD_BEV_TYPE_name` ASC) VISIBLE,
  INDEX `fk_FOODBEV_INGESTION_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_FOODBEV_INGESTION_FOOD_BEV_TYPE1`
    FOREIGN KEY (`FOOD_BEV_TYPE_name`)
    REFERENCES `final_project`.`FOOD_BEV_TYPE` (`name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_FOODBEV_INGESTION_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`RECREATIONAL_INTOXICANT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`RECREATIONAL_INTOXICANT` (
  `intoxicant_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `measurement_units` enum('ml', 'fl oz', 'g', 'oz', 'doses') NOT NULL,
  `ingestion_method` enum('drink', 'eat', 'inhale', 'inject') NOT NULL,
  `class_category` enum('alcohol', 'tobacco', 'elicit drug', 'pharmaceutical', 'plant compound', 'opiate', 'barbituate', 'hallucinogen', 'antheogen', 'amphetamine') NOT NULL,
  PRIMARY KEY (`intoxicant_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`INTOXICANT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`INTOXICANT_INSTANCE` (
  `RECREATIONAL_INTOXICANT_intoxicant_id` INT NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `amount` FLOAT NOT NULL,
  `date` TIMESTAMP NOT NULL,
  PRIMARY KEY (`RECREATIONAL_INTOXICANT_intoxicant_id`, `USER_user_name`, `date`),
  INDEX `fk_INTOXICANT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_INTOXICANT_INSTANCE_RECREATIONAL_INTOXICANT1`
    FOREIGN KEY (`RECREATIONAL_INTOXICANT_intoxicant_id`)
    REFERENCES `final_project`.`RECREATIONAL_INTOXICANT` (`intoxicant_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_INTOXICANT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TRANSPORT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TRANSPORT_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `duration` TIME NOT NULL,
  `for_pleasure` enum('Yes', 'No') NULL,
  `depart_location` INT NOT NULL,
  `arrival_location` INT NOT NULL,
  `transport_type` enum('car', 'bus', 'train', 'plane', 'walk', 'bike', 'boat') NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `USER_user_name`),
  INDEX `fk_TRANSPORT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  INDEX `fk_TRANSPORT_INSTANCE_LOCATIONS1_idx` (`depart_location` ASC) VISIBLE,
  INDEX `fk_TRANSPORT_INSTANCE_LOCATIONS2_idx` (`arrival_location` ASC) VISIBLE,
  CONSTRAINT `fk_TRANSPORT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TRANSPORT_INSTANCE_DEPART_LOCATIONS`
    FOREIGN KEY (`depart_location`)
    REFERENCES `final_project`.`LOCATIONS` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
CONSTRAINT `fk_TRANSPORT_INSTANCE_ARRIVE_LOCATIONS`
    FOREIGN KEY (`arrival_location`)
    REFERENCES `final_project`.`LOCATIONS` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`POSITIVE_EVENT_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`POSITIVE_EVENT_TYPE` (
  `event_name` VARCHAR(45) NOT NULL,
  `event_category` enum('social', 'achievement', 'spiritual/internal', 'leisure/hobby') NOT NULL,
  PRIMARY KEY (`event_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`POSITIVE_EVENT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`POSITIVE_EVENT_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `duration` TIME NULL,
  `LOCATIONS_location_id` INT NULL,
  `POSITIVE_EVENT_TYPE_event_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `positive_experience_rating` enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NOT NULL COMMENT 'Percieved rating positivity of experience [0:10]',
  PRIMARY KEY (`date`, `POSITIVE_EVENT_TYPE_event_name`, `USER_user_name`),
  INDEX `fk_POSITIVE_EVENT_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_id` ASC) VISIBLE,
  INDEX `fk_POSITIVE_EVENT_INSTANCE_POSITIVE_EVENT_TYPE1_idx` (`POSITIVE_EVENT_TYPE_event_name` ASC) VISIBLE,
  INDEX `fk_POSITIVE_EVENT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_POSITIVE_EVENT_INSTANCE_LOCATIONS1`
    FOREIGN KEY (`LOCATIONS_location_id`)
    REFERENCES `final_project`.`LOCATIONS` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_POSITIVE_EVENT_INSTANCE_POSITIVE_EVENT_TYPE1`
    FOREIGN KEY (`POSITIVE_EVENT_TYPE_event_name`)
    REFERENCES `final_project`.`POSITIVE_EVENT_TYPE` (`event_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_POSITIVE_EVENT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `final_project`.`STRESSOR_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`STRESSOR_INSTANCE` (
  `start_date` TIMESTAMP NOT NULL,
  `duration` TIME NOT NULL,
  `LOCATIONS_location_id` INT NULL,
  `stress type` enum('pollution', 'chemical', 'injury', 'work', 'interpersonal', 'viral_bacterial') NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `stress_intesity` enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NOT NULL COMMENT 'Percieved intensity [0:10]',
  PRIMARY KEY (`start_date`, `stress type`, `USER_user_name`),
  INDEX `fk_STRESSOR_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_id` ASC) VISIBLE,
  INDEX `fk_STRESSOR_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_STRESSOR_INSTANCE_LOCATIONS1`
    FOREIGN KEY (`LOCATIONS_location_id`)
    REFERENCES `final_project`.`LOCATIONS` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_STRESSOR_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TREATMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TREATMENT` (
  `treatment_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`treatment_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TREATMENT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TREATMENT_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `duration` TIME NULL,
  `TREATMENT_treatment_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `TREATMENT_treatment_name`, `USER_user_name`),
  INDEX `fk_TREATMENT_INSTANCE_TREATMENT1_idx` (`TREATMENT_treatment_name` ASC) VISIBLE,
  INDEX `fk_TREATMENT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_TREATMENT_INSTANCE_TREATMENT1`
    FOREIGN KEY (`TREATMENT_treatment_name`)
    REFERENCES `final_project`.`TREATMENT` (`treatment_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TREATMENT_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
