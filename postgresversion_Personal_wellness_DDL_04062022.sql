-- MySQL Workbench Forward Engineering

BEGIN;

CREATE DATABASE final_project
    WITH 
    OWNER = casey
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
-- -----------------------------------------------------
-- Schema final_project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema final_project
-- -----------------------------------------------------
CREATE SCHEMA final_project
    AUTHORIZATION casey;

-- -----------------------------------------------------
-- Table final_project.COUNTRY_LOOKUP_TABLE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.COUNTRY_LOOKUP_TABLE (
  country_abbreviation VARCHAR(3) NOT NULL,
  country_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (country_abbreviation));


-- -----------------------------------------------------
-- Table final_project.STATE_LOOKUP
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.STATE_LOOKUP (
  COUNTRY_LOOKUP_TABLE_country_abbreviation VARCHAR(3) NOT NULL,
  state_name VARCHAR(45) NOT NULL,
  state_abbreviation VARCHAR(3) NOT NULL,
  PRIMARY KEY (COUNTRY_LOOKUP_TABLE_country_abbreviation, state_abbreviation),
  CONSTRAINT fk_STATE_IN_COUNTRY_COUNTRY_LOOKUP_TABLE1
    FOREIGN KEY (COUNTRY_LOOKUP_TABLE_country_abbreviation)
    REFERENCES final_project.COUNTRY_LOOKUP_TABLE (country_abbreviation)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE sex_opts AS enum('female', 'intersex', 'male');

-- -----------------------------------------------------
-- Table final_project.USER
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.USER (
  user_name VARCHAR(45) NOT NULL,
  fname VARCHAR(45) NOT NULL,
  lname VARCHAR(45) NOT NULL, 
  dob DATE NOT NULL,
  sex_at_birth sex_opts NOT NULL,
  STATE_LOOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation VARCHR(3) NOT NULL,
  STATE_LOOKUP_state_abbrviation VARCHAR(3) NOT NULL,
  PRIMARY KEY (user_name),
  CONSTRAINT fk_USER_STATE_IN_COUNTRY1
    FOREIGN KEY (STATE_LOOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation , STATE_LOOKUP_state_abbreviation)
    REFERENCES final_project.STATE_LOOKUP (COUNTRY_LOOKUP_TABLE_country_abbreviation , state_abbrviation)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE f_opts AS ENUM('pregnancy', 'menopause', 'menstruation', 'gave birth', 'miscarriage', 'perimenopause');

-- -----------------------------------------------------
-- Table final_project.FEMALE_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.FEMALE_INSTANCE (
  start_date DATE NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  event_type f_opts NOT NULL,
  PRIMARY KEY (start_date, USER_user_name),
  CONSTRAINT fk_FEMALE_INSTANCE_USER
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE chron_opts AS ENUM('acute', 'chronic-progressive', 'chronic', 'relapse-remitting');

-- -----------------------------------------------------
-- Table final_project.CONDITION_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.CONDITION_TYPE (
  condition_name VARCHAR(45) NOT NULL,
  chronicity chron_opts NOT NULL,
  condition_id SERIAL NOT NULL,
  PRIMARY KEY (condition_id));


-- -----------------------------------------------------
-- Table final_project.CONDITION_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.CONDITION_INSTANCE (
  onset_date DATE NOT NULL,
  diagnosing_doctor VARCHAR(45) NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  condition_instance_id SERIAL NOT NULL,
  CONDITION_TYPE_condition_id INT NOT NULL,
  PRIMARY KEY (condition_instance_id),
  CONSTRAINT fk_CONDITION_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_CONDITION_INSTANCE_CONDITION_TYPE1
    FOREIGN KEY (CONDITION_TYPE_condition_id)
    REFERENCES final_project.CONDITION_TYPE (condition_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table final_project.SYMPTOM_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.SYMPTOM_TYPE (
  symptom_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (symptom_name));

-- -----------------------------------------------------
-- Create domain for severity/intensity
-- -----------------------------------------------------
CREATE DOMAIN sev_opts AS INTEGER
    CHECK(VALUE BETWEEN 0 and 10);


-- -----------------------------------------------------
-- Table final_project.SYMPTOM_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.SYMPTOM_INSTANCE (
  date_time TIMESTAMP NOT NULL,
  severity sev_opts NOT NULL,
  duration TIME NULL,
  SYMPTOM_TYPE_symptom_name VARCHAR(45) NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date_time, SYMPTOM_TYPE_symptom_name, USER_user_name),
  CONSTRAINT fk_SYMPTOM_INSTANCE_SYMPTOM_TYPE1
    FOREIGN KEY (SYMPTOM_TYPE_symptom_name)
    REFERENCES final_project.SYMPTOM_TYPE (symptom_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_SYMPTOM_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table final_project.MEDICATION_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.MEDICATION_TYPE (
  medication_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (medication_name));


-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE dose_opts AS ENUM('g', 'mg', 'mL', 'l', 'fl oz', 'tsp', 'tbs', 'IU', 'drops', 'tablets', 'sprays');

-- -----------------------------------------------------
-- Table final_project.MEDICATION_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.MEDICATION_INSTANCE (
  date_time TIMESTAMP NOT NULL,
  units dose_opts NOT NULL,
  dose numeric(5,2) NOT NULL,
  MEDICATION_TYPE_medication_name VARCHAR(45) NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date_time, MEDICATION_TYPE_medication_name, USER_user_name),
  CONSTRAINT fk_MEDICATION_INSTANCE_MEDICATION_TYPE1
    FOREIGN KEY (MEDICATION_TYPE_medication_name)
    REFERENCES final_project.MEDICATION_TYPE (medication_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_MEDICATION_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

ALTER TABLE final_project.MEDICATION_INSTANCE
    ADD COLUMN amount numeric(5,2)


-- -----------------------------------------------------
-- Table final_project.CONDITION_SYMPTOM
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.CONDITION_SYMPTOM (
  SYMPTOM_TYPE_symptom_name VARCHAR(45) NOT NULL,
  CONDITION_INSTANCE_condition_instance_id INT NOT NULL,
  PRIMARY KEY (SYMPTOM_TYPE_symptom_name, CONDITION_INSTANCE_condition_instance_id),
  CONSTRAINT fk_CONDITION_SYMPTOM_SYMPTOM_TYPE1
    FOREIGN KEY (SYMPTOM_TYPE_symptom_name)
    REFERENCES final_project.SYMPTOM_TYPE (symptom_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_CONDITION_SYMPTOM_CONDITION_INSTANCE1
    FOREIGN KEY (CONDITION_INSTANCE_condition_instance_id)
    REFERENCES final_project.CONDITION_INSTANCE (condition_instance_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table final_project.CONDITION MEDICATION
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.CONDITION_MEDICATION (
  date DATE NOT NULL,
  MEDICATION_TYPE_medication_name VARCHAR(45) NOT NULL,
  CONDITION_INSTANCE_condition_instance_id SERIAL NOT NULL,
  PRIMARY KEY (MEDICATION_TYPE_medication_name, CONDITION_INSTANCE_condition_instance_id),
  CONSTRAINT fk_CONDITION_MEDICATION_MEDICATION_TYPE1
    FOREIGN KEY (MEDICATION_TYPE_medication_name)
    REFERENCES final_project.MEDICATION_TYPE (medication_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_CONDITION_MEDICATION_CONDITION_INSTANCE1
    FOREIGN KEY (CONDITION_INSTANCE_condition_instance_id)
    REFERENCES final_project.CONDITION_INSTANCE (condition_instance_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE dose_opts AS ENUM(('g', 'mg', 'mL', 'l', 'fl oz', 'tsp', 'tbs', 'IU', 'drops', 'tablets', 'sprays');


-- -----------------------------------------------------
-- Table final_project.MOOD_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.MOOD_TYPE (
  id SERIAL NOT NULL,
  is_negative_valence BOOLEAN NOT NULL DEFAULT FALSE,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (id));

-- -----------------------------------------------------
-- Table final_project.MOOD_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.MOOD_INSTANCE (
  date_time TIMESTAMP NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  severity sev_opts NOT NULL,
  MOOD_TYPE_id SERIAL NOT NULL,
  PRIMARY KEY (date_time, USER_user_name, MOOD_TYPE_id),
  CONSTRAINT fk_MOOD_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_MOOD_INSTANCE_MOOD_TYPE1
    FOREIGN KEY (MOOD_TYPE_id)
    REFERENCES final_project.MOOD_TYPE (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table final_project.TOOL_LOOKUP
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.TOOL_LOOKUP (
  toolname VARCHAR(45) NOT NULL,
  PRIMARY KEY (toolname));

-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE pos_opts AS ENUM('fowlers (seated)', 'prone (lying face down)', 'supine(lying face up)', 'lateral recumbent (lying on side)', 'other');

-- -----------------------------------------------------
-- Table final_project.VITALS_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.VITALS_TYPE (
  vital_code SERIAL NOT NULL,
  upper_lim INT NOT NULL,
  lower_lim INT NOT NULL,
  unit VARCHAR(6) NOT NULL,
  vital_name VARCHAR(45) NULL,
  POSITIONS_LOOKUP_positions_latin_name pos_opts NOT NULL,
  TOOL_LOOKUP_toolname VARCHAR(45) NOT NULL,
  PRIMARY KEY (vital_code),
  CONSTRAINT fk_VITALS_TYPE_TOOL_LOOKUP1
    FOREIGN KEY (TOOL_LOOKUP_toolname)
    REFERENCES final_project.TOOL_LOOKUP (toolname)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT valid_limits CHECK (upper_lim>lower_lim));


-- -----------------------------------------------------
-- Table final_project.VITAL_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.VITAL_INSTANCE (
  date TIMESTAMP NOT NULL,
  fasting BOOLEAN NOT NULL,
  VITALS_TYPE_vital_code INT NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date, VITALS_TYPE_vital_code, USER_user_name),
  CONSTRAINT fk_VITAL_INSTANCE_VITALS_TYPE1
    FOREIGN KEY (VITALS_TYPE_vital_code)
    REFERENCES final_project.VITALS_TYPE (vital_code)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_VITAL_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

--- add the amount column

ALTER TABLE IF EXISTS final_project.vital_instance
    ADD COLUMN amount numeric(5, 2) NOT NULL;

-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE units_opts AS ENUM('lbs', 'kg', 'cm', 'inches', 'meters', '%', 'feet');

-- -----------------------------------------------------
-- Table final_project.BODY_MEASURE_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.BODY_MEASURE_TYPE (
  measure_id SERIAL NOT NULL,
  name VARCHAR(45) NOT NULL,
  units units_opts NOT NULL,
  PRIMARY KEY (measure_id));


-- -----------------------------------------------------
-- Table final_project.BODY_MEASURE_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.BODY_MEASURE_INSTANCE (
  date TIMESTAMP NOT NULL,
  BODY_MEASURE_TYPE_measure_id INT NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date, BODY_MEASURE_TYPE_measure_id, USER_user_name),
  CONSTRAINT fk_BODY_MEASURE_INSTANCE_BODY_MEASURE_TYPE1
    FOREIGN KEY (BODY_MEASURE_TYPE_measure_id)
    REFERENCES final_project.BODY_MEASURE_TYPE (measure_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_BODY_MEASURE_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

--- add the amount column

ALTER TABLE IF EXISTS final_project.vital_instance
    ADD COLUMN amount numeric(5, 2) NOT NULL;

-- --------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE ex_opts AS ENUM('aerobic', 'anarobic', 'plyometric', 'HIIT', 'calisthenic', 'weight-bearing');

-- -----------------------------------------------------
-- Table final_project.EXERCISE_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.EXERCISE_TYPE (
  exercise_id SERIAL NOT NULL,
  name VARCHAR(45) NOT NULL,
  category ex_opts NOT NULL,
  PRIMARY KEY (exercise_id));


-- -----------------------------------------------------
-- Table final_project.EXERCISE_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.EXERCISE_INSTANCE (
  date TIMESTAMP NOT NULL,
  EXERCISE_TYPE_exercise_id INT NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  perceived_intensity sev_opts  NOT NULL, 
  duration TIME NOT NULL,
  PRIMARY KEY (date, EXERCISE_TYPE_exercise_id, USER_user_name),
  CONSTRAINT fk_EXERCISE_INSTANCE_EXERCISE_TYPE1
    FOREIGN KEY (EXERCISE_TYPE_exercise_id)
    REFERENCES final_project.EXERCISE_TYPE (exercise_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_EXERCISE_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table final_project.LOCATIONS
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.LOCATIONS (
  location_id SERIAL NOT NULL,
  location_name VARCHAR(45) NOT NULL,
  street_address INT NULL,
  street VARCHAR(45) NULL,
  city VARCHAR(45) NULL,
  STATE_LOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation VARCHAR(3) NULL,
  STATE_LOOKUP_state_abbreviation VARCHAR(3) NULL,
  PRIMARY KEY (location_id),
  CONSTRAINT fk_LOCATIONS_STATE_LOOKUP1
    FOREIGN KEY (STATE_LOOKUP_COUNTRY_LOOKUP_TABLE_country_abbreviation , STATE_LOOKUP_state_abbreviation)
    REFERENCES final_project.STATE_LOOKUP (COUNTRY_LOOKUP_TABLE_country_abbreviation , state_abbreviation)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

ALTER TABLE final_project.locations
    ADD COLUMN user_user_name character varying(45) NOT NULL;
ALTER TABLE final_project.locations
    ADD CONSTRAINT fk_locations_user_name FOREIGN KEY (user_user_name)
    REFERENCES final_project."user" (user_name) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;
-- -----------------------------------------------------
-- Table final_project.SLEEP_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.SLEEP_INSTANCE (
  date DATE NOT NULL,
  duration TIME NOT NULL,
  alone BOOLEAN NOT NULL,
  preceived_quality sev_opts  NULL,
  deep TIME NULL,
  light TIME NULL,
  awake TIME NULL,
  SLEEP_LOCATIONS_location_id INT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date, USER_user_name),
  CONSTRAINT fk_SLEEP_INSTANCE_SLEEP_LOCATIONS1
    FOREIGN KEY (SLEEP_LOCATIONS_location_id)
    REFERENCES final_project.LOCATIONS (location_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_SLEEP_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table final_project.FOOD_BEV_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.FOOD_BEV_TYPE (
  name VARCHAR(55) NOT NULL,
  PRIMARY KEY (name));

-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE funits_opts AS enum('g', 'ml', 'oz', 'lb', 'cups', 'tbs', 'tsp', 'dash', 'serving', 'fl oz');


-- -----------------------------------------------------
-- Table final_project.FOOD_BEV_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.FOOD_BEV_INSTANCE (
  date TIMESTAMP NOT NULL,
  amount FLOAT NULL,
  units funits_opts NULL,
  FOOD_BEV_TYPE_name VARCHAR(55) NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date, FOOD_BEV_TYPE_name, USER_user_name),
  CONSTRAINT fk_FOODBEV_INGESTION_FOOD_BEV_TYPE1
    FOREIGN KEY (FOOD_BEV_TYPE_name)
    REFERENCES final_project.FOOD_BEV_TYPE (name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_FOODBEV_INGESTION_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE intox_units AS enum('ml', 'fl oz', 'g', 'oz', 'doses');
CREATE TYPE intox_method AS enum('drink', 'eat', 'inhale', 'inject');
CREATE TYPE intox_cat AS enum('alcohol', 'tobacco', 'elicit drug', 'pharmaceutical', 'plant compound', 'opiate', 'barbituate', 'hallucinogen', 'antheogen', 'amphetamine');

-- -----------------------------------------------------
-- Table final_project.RECREATIONAL_INTOXICANT
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.RECREATIONAL_INTOXICANT (
  intoxicant_id SERIAL NOT NULL,
  name VARCHAR(45) NOT NULL,
  measurement_units intox_units NOT NULL,
  ingestion_method intox_method NOT NULL,
  class_category intox_cat NOT NULL,
  PRIMARY KEY (intoxicant_id));


-- -----------------------------------------------------
-- Table final_project.INTOXICANT_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.INTOXICANT_INSTANCE (
  RECREATIONAL_INTOXICANT_intoxicant_id INT NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  amount FLOAT NOT NULL,
  date TIMESTAMP NOT NULL,
  PRIMARY KEY (RECREATIONAL_INTOXICANT_intoxicant_id, USER_user_name, date),
  CONSTRAINT fk_INTOXICANT_INSTANCE_RECREATIONAL_INTOXICANT1
    FOREIGN KEY (RECREATIONAL_INTOXICANT_intoxicant_id)
    REFERENCES final_project.RECREATIONAL_INTOXICANT (intoxicant_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_INTOXICANT_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE t_types AS enum('car', 'bus', 'train', 'plane', 'walk', 'bike', 'boat');

-- -----------------------------------------------------
-- Table final_project.TRANSPORT_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.TRANSPORT_INSTANCE (
  date TIMESTAMP NOT NULL,
  duration TIME NOT NULL,
  for_pleasure BOOLEAN NULL,
  depart_location INT NULL,
  arrival_location INT NULL,
  transport_type t_types NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date, USER_user_name),
  CONSTRAINT fk_TRANSPORT_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_TRANSPORT_INSTANCE_DEPART_LOCATIONS
    FOREIGN KEY (depart_location)
    REFERENCES final_project.LOCATIONS (location_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
CONSTRAINT fk_TRANSPORT_INSTANCE_ARRIVE_LOCATIONS
    FOREIGN KEY (arrival_location)
    REFERENCES final_project.LOCATIONS (location_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE pe_types AS enum('social', 'achievement', 'spiritual/internal', 'leisure/hobby');

-- -----------------------------------------------------
-- Table final_project.POSITIVE_EVENT_TYPE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.POSITIVE_EVENT_TYPE (
  event_name VARCHAR(45) NOT NULL,
  event_category pe_types NOT NULL,
  PRIMARY KEY (event_name));


-- -----------------------------------------------------
-- Table final_project.POSITIVE_EVENT_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.POSITIVE_EVENT_INSTANCE (
  date TIMESTAMP NOT NULL,
  duration TIME NULL,
  LOCATIONS_location_id INT NULL,
  POSITIVE_EVENT_TYPE_event_name VARCHAR(45) NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  positive_experience_rating sev_opts NOT NULL,
  PRIMARY KEY (date, POSITIVE_EVENT_TYPE_event_name, USER_user_name),
  CONSTRAINT fk_POSITIVE_EVENT_INSTANCE_LOCATIONS1
    FOREIGN KEY (LOCATIONS_location_id)
    REFERENCES final_project.LOCATIONS (location_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_POSITIVE_EVENT_INSTANCE_POSITIVE_EVENT_TYPE1
    FOREIGN KEY (POSITIVE_EVENT_TYPE_event_name)
    REFERENCES final_project.POSITIVE_EVENT_TYPE (event_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_POSITIVE_EVENT_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Enumeration Type to choose from
-- -----------------------------------------------------
CREATE TYPE stress_types AS enum('pollution', 'chemical', 'injury', 'work', 'interpersonal', 'viral_bacterial');

-- -----------------------------------------------------
-- Table final_project.STRESSOR_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.STRESSOR_INSTANCE (
  start_date TIMESTAMP NOT NULL,
  duration TIME NOT NULL,
  LOCATIONS_location_id INT NULL,
  stress_type stress_types NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  stress_intesity sev_opts NOT NULL,
  PRIMARY KEY (start_date, stress_type, USER_user_name),
  CONSTRAINT fk_STRESSOR_INSTANCE_LOCATIONS1
    FOREIGN KEY (LOCATIONS_location_id)
    REFERENCES final_project.LOCATIONS (location_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_STRESSOR_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table final_project.TREATMENT
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.TREATMENT (
  treatment_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (treatment_name));


-- -----------------------------------------------------
-- Table final_project.TREATMENT_INSTANCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS final_project.TREATMENT_INSTANCE (
  date TIMESTAMP NOT NULL,
  duration TIME NULL,
  TREATMENT_treatment_name VARCHAR(45) NOT NULL,
  USER_user_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (date, TREATMENT_treatment_name, USER_user_name),
  CONSTRAINT fk_TREATMENT_INSTANCE_TREATMENT1
    FOREIGN KEY (TREATMENT_treatment_name)
    REFERENCES final_project.TREATMENT (treatment_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_TREATMENT_INSTANCE_USER1
    FOREIGN KEY (USER_user_name)
    REFERENCES final_project.USER (user_name)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


