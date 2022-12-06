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
-- Table `final_project`.`SEX_AT_BIRTH_LOOKUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`SEX_AT_BIRTH_LOOKUP` (
  `sex_abbreviation` VARCHAR(1) NOT NULL COMMENT 'M: Male, F: Female, I: Intersex',
  PRIMARY KEY (`sex_abbreviation`))
ENGINE = InnoDB;


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
-- DataType `final_project`.`severity`
-- -----------------------------------------------------
CREATE TABLE `final_project` `SEVERITY` (
  `rating` enum(1,2,3,4,5,6,7,8,9,10) NOT NULL,
  PRIMARY KEY (`final_project`)
)

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
-- Table `final_project`.`FEMALE_LOOKUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`FEMALE_LOOKUP` (
  `type_name` VARCHAR(40) NOT NULL COMMENT 'Pregnancy, Menopause, Period, Birth, Miscarriage, Perimenopause',
  PRIMARY KEY (`type_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`FEMALE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`FEMALE_INSTANCE` (
  `start_date` DATE NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `FEMALE_LOOKUP_type_name` VARCHAR(40) NOT NULL COMMENT '{menstruation, perimenopause, menopause, pregnancy, miscarry, gave_birth}',
  PRIMARY KEY (`start_date`, `USER_user_name`),
  INDEX `fk_FEMALE_INSTANCE_USER_idx` (`USER_user_name` ASC) VISIBLE,
  INDEX `fk_FEMALE_INSTANCE_FEMALE_CYCLES1_idx` (`FEMALE_LOOKUP_type_name` ASC) VISIBLE,
  CONSTRAINT `fk_FEMALE_INSTANCE_USER`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_FEMALE_INSTANCE_FEMALE_CYCLES1`
    FOREIGN KEY (`FEMALE_LOOKUP_type_name`)
    REFERENCES `final_project`.`FEMALE_LOOKUP` (`type_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
PACK_KEYS = Default;


-- -----------------------------------------------------
-- Table `final_project`.`CHRONICITY_LOOKUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`CHRONICITY_LOOKUP` (
  `type` VARCHAR(40) NOT NULL COMMENT '{acute, chronic-progressive, chronic relapse-remitting}',
  PRIMARY KEY (`type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`CONDITION_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`CONDITION_TYPE` (
  `condition_name` VARCHAR(45) NOT NULL,
  `CHRONICITY_LOOKUP_type` VARCHAR(40) NOT NULL,
  `condition_id` INT NOT NULL AUTO_INCREMENT COMMENT 'Auto-generated ID associated with the condition',
  INDEX `fk_CONDITION_TYPE_CHRONICITY_LOOKUP1_idx` (`CHRONICITY_LOOKUP_type` ASC) VISIBLE,
  PRIMARY KEY (`condition_id`),
  CONSTRAINT `fk_CONDITION_TYPE_CHRONICITY_LOOKUP1`
    FOREIGN KEY (`CHRONICITY_LOOKUP_type`)
    REFERENCES `final_project`.`CHRONICITY_LOOKUP` (`type`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
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
  `severity` INT(2) NOT NULL COMMENT '[0-10]',
  `duration` TIME NULL COMMENT 'Duration of symptom at severity (optional)',
  `SYMPTOM_TYPE_symptom_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `SYMPTOM_TYPE_symptom_name`, `USER_user_name`),
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
  `dosage` VARCHAR(10) NOT NULL COMMENT 'Can include units but for analysis best to keep input consistent',
  `MEDICATION_TYPE_medication_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `MEDICATION_TYPE_medication_name`, `USER_user_name`),
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
  `is_negative_valence()` TINYINT NOT NULL DEFAULT 0 COMMENT 'F if positive or neutral, T if negative',
  `name` VARCHAR(45) NULL COMMENT 'Name of mood',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`MOOD_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`MOOD_INSTANCE` (
  `date_time` TIMESTAMP NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `severity` INT(2) NOT NULL COMMENT 'Perceived intensity of mood [0:10]',
  `MOOD_TYPE_id` INT NOT NULL,
  PRIMARY KEY (`date`, `USER_user_name`, `MOOD_TYPE_id`),
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
-- Table `final_project`.`POSITIONS_LOOKUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`POSITIONS_LOOKUP` (
  `position_latin_name` VARCHAR(45) NOT NULL,
  `english_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`position_latin_name`))
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
  `POSITIONS_LOOKUP_positions_latin_name` VARCHAR(45) NOT NULL,
  `TOOL_LOOKUP_toolname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`vital_code`),
  INDEX `fk_VITALS_TYPE_POSITIONS_LOOKUP1_idx` (`POSITIONS_LOOKUP_positions_latin_name` ASC) VISIBLE,
  INDEX `fk_VITALS_TYPE_TOOL_LOOKUP1_idx` (`TOOL_LOOKUP_toolname` ASC) VISIBLE,
  CONSTRAINT `fk_VITALS_TYPE_POSITIONS_LOOKUP1`
    FOREIGN KEY (`POSITIONS_LOOKUP_positions_latin_name`)
    REFERENCES `final_project`.`POSITIONS_LOOKUP` (`positions_latin_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_VITALS_TYPE_TOOL_LOOKUP1`
    FOREIGN KEY (`TOOL_LOOKUP_toolname`)
    REFERENCES `final_project`.`TOOL_LOOKUP` (`toolname`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`VITAL_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`VITAL_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `fasting` TINYINT NOT NULL COMMENT 'Yes/no',
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
  `units` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`measure_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`BODY_MEASURE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`BODY_MEASURE_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `BODY_MEASURE_TYPE_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `BODY_MEASURE_TYPE_name`, `USER_user_name`),
  INDEX `fk_BODY_MEASURE_INSTANCE_BODY_MEASURE_TYPE1_idx` (`BODY_MEASURE_TYPE_measure_id` ASC) VISIBLE,
  INDEX `fk_BODY_MEASURE_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_BODY_MEASURE_INSTANCE_BODY_MEASURE_TYPE1`
    FOREIGN KEY (`BODY_MEASURE_TYPE_measure_id`)
    REFERENCES `final_project`.`BODY_MEASURE_TYPE` (`name`)
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
  `name` VARCHAR(45) NOT NULL COMMENT 'Aerobic, plyometric, calisthenic, weight-bearing',
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`EXERCISE_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`EXERCISE_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `EXERCISE_TYPE_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `perceived_intensity` INT(2) NOT NULL COMMENT '0-10',
  `duration_mins` INT(3) NOT NULL,
  PRIMARY KEY (`date`, `EXERCISE_TYPE_name`, `USER_user_name`),
  INDEX `fk_EXERCISE_INSTANCE_EXERCISE_TYPE1_idx` (`EXERCISE_TYPE_name` ASC) VISIBLE,
  INDEX `fk_EXERCISE_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_EXERCISE_INSTANCE_EXERCISE_TYPE1`
    FOREIGN KEY (`EXERCISE_TYPE_name`)
    REFERENCES `final_project`.`EXERCISE_TYPE` (`name`)
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
  `alone` TINYINT NOT NULL COMMENT 'Boolean type',
  `preceived_quality` INT(2) NULL,
  `deep_mins` INT(3) NULL COMMENT 'Deep Sleep Time',
  `light_mins` INT(3) NULL COMMENT 'Light Sleep Time',
  `awake_mins` INT(3) NULL,
  `SLEEP_LOCATIONS_location_id` INT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `USER_user_name`),
  INDEX `fk_SLEEP_INSTANCE_SLEEP_LOCATIONS1_idx` (`SLEEP_LOCATIONS_location_name` ASC) VISIBLE,
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
  `amount` FLOAT NULL COMMENT 'Use same relative or absolute units over time to increase accuracy\n',
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
  `measurement_untis` VARCHAR(45) NOT NULL,
  `ingestion_method` VARCHAR(45) NOT NULL,
  `class_category` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`intoxicant_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`INTOXICANT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`INTOXICANT_INSTANCE` (
  `RECREATIONAL_INTOXICANT_name` VARCHAR(45) NOT NULL,
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
-- Table `final_project`.`TRANSPORT_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TRANSPORT_TYPE` (
  `transport_type` INT NOT NULL,
  PRIMARY KEY (`transport_type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TRANSPORT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TRANSPORT_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `duration` TIME NOT NULL,
  `for_pleasure` TINYINT NULL,
  `depart_location` INT NOT NULL,
  `arrival_location` INT NOT NULL,
  `TRANSPORT_transport_type` INT NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `TRANSPORT_transport_type`, `USER_user_name`),
  INDEX `fk_TRANSPORT_INSTANCE_TRANSPORT1_idx` (`TRANSPORT_transport_type` ASC) VISIBLE,
  INDEX `fk_TRANSPORT_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  INDEX `fk_TRANSPORT_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_id` ASC) VISIBLE,
  INDEX `fk_TRANSPORT_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_id` ASC) VISIBLE,
  CONSTRAINT `fk_TRANSPORT_INSTANCE_TRANSPORT1`
    FOREIGN KEY (`TRANSPORT_transport_type`)
    REFERENCES `final_project`.`TRANSPORT_TYPE` (`transport_type`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
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
CONSTRAINT `fk_TRANSPORT_INSTANCE_DEPART_LOCATIONS`
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
  `positive_experience_rating` INT(2) NOT NULL COMMENT 'Percieved rating positivity of experience [0:10]',
  PRIMARY KEY (`date`, `time`, `POSITIVE_EVENT_TYPE_event_name`, `USER_user_name`),
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
-- Table `final_project`.`STRESSOR_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`STRESSOR_TYPE` (
  `name` VARCHAR(40) NOT NULL COMMENT '{pollution, chemical, injury, work, interpersonal, viral_bacterial}',
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`STRESSOR_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`STRESSOR_INSTANCE` (
  `start_date` TIMESTAMP NOT NULL,
  `duartion` TIME NOT NULL,
  `LOCATIONS_location_id` VARCHAR(45) NULL,
  `STRESSOR_TYPE_name` VARCHAR(40) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  `stress_intesity` INT(2) NOT NULL COMMENT 'Percieved intensity [0:10]',
  PRIMARY KEY (`start_date`, `STRESSOR_TYPE_name`, `USER_user_name`),
  INDEX `fk_STRESSOR_INSTANCE_LOCATIONS1_idx` (`LOCATIONS_location_id` ASC) VISIBLE,
  INDEX `fk_STRESSOR_INSTANCE_STRESSOR_TYPE1_idx` (`STRESSOR_TYPE_name` ASC) VISIBLE,
  INDEX `fk_STRESSOR_INSTANCE_USER1_idx` (`USER_user_name` ASC) VISIBLE,
  CONSTRAINT `fk_STRESSOR_INSTANCE_LOCATIONS1`
    FOREIGN KEY (`LOCATIONS_location_id`)
    REFERENCES `final_project`.`LOCATIONS` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_STRESSOR_INSTANCE_STRESSOR_TYPE1`
    FOREIGN KEY (`STRESSOR_TYPE_name`)
    REFERENCES `final_project`.`STRESSOR_TYPE` (`name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_STRESSOR_INSTANCE_USER1`
    FOREIGN KEY (`USER_user_name`)
    REFERENCES `final_project`.`USER` (`user_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TREATMENT_CATEGORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TREATMENT_CATEGORY` (
  `category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`category_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TREATMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TREATMENT` (
  `treatment_name` VARCHAR(45) NOT NULL,
  `TREATMENT_CATEGORY_category_name` VARCHAR(45) NULL,
  PRIMARY KEY (`treatment_name`),
  INDEX `fk_TREATMENT_TREATMENT_CATEGORY1_idx` (`TREATMENT_CATEGORY_category_name` ASC) VISIBLE,
  CONSTRAINT `fk_TREATMENT_TREATMENT_CATEGORY1`
    FOREIGN KEY (`TREATMENT_CATEGORY_category_name`)
    REFERENCES `final_project`.`TREATMENT_CATEGORY` (`category_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final_project`.`TREATMENT_INSTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project`.`TREATMENT_INSTANCE` (
  `date` TIMESTAMP NOT NULL,
  `duration` TIME NULL,
  `TREATMENT_treatment_name` VARCHAR(45) NOT NULL,
  `USER_user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date`, `time`, `TREATMENT_treatment_name`, `USER_user_name`),
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
