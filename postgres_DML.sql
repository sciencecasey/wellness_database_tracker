# DML

INSERT INTO final_project.COUNTRY_LOOKUP_TABLE 
    VALUES ('USA', 'United States'), ('MEX', 'Mexico'), ('CAN', 'Canada');

SELECT * FROM final_project.COUNTRY_LOOKUP_TABLE;

INSERT INTO final_project.STATE_LOOKUP 
    VALUES('USA','California','CA'),('USA', 'Alaska', 'AK'),('USA', 'Nevada', 'NV');

Select * from final_project.STATE_LOOKUP ;

insert into final_project.USER Values(
  'cjayne',
  'Casey',
  'Richards', 
  '1989-03-14',
  'Female',
  'USA',
  'CA');

select * from final_project.USER;

insert into final_project.FEMALE_INSTANCE 
    VALUES('2020-01-01','cjayne','Menstruation'), 
    ('2020-02-01','cjayne','Menstruation'),
    ('2020-03-01','cjayne','Menstruation');

select * from final_project.FEMALE_INSTANCE;


insert into final_project.CONDITION_TYPE 
    VALUES('chronic recurring idiopathic angioedema','relapse-remitting'),
    ('fibromyalgia', 'relapse-remitting'),
    ('restless legs syndrome', 'chronic-progressive'),
    ('depression', 'relapse-remitting'),
    ('migraine', 'relapse-remitting'),
    ('food allergy', 'chronic');

select * from final_project.CONDITION_TYPE;

insert into final_project.CONDITION_INSTANCE 
    values('2014-03-02','kaiser','cjayne', default, 1),
    ('2016-07-02','ucla','cjayne',default,2),
    ('2022-07-02','ole health','cjayne',default,3),
    ('2007-12-01','kaiser','cjayne',default,4),
    ('1996-12-20', 'ucla', 'cjayne',default, 5),
    ('2012-12-01', 'kaiser', 'cjayne',default, 6);

insert into final_project.SYMPTOM_TYPE 
    values('pain, generalized'), ('headache/migraine'),
    ('nausea'),('vomiting'),('diarrhea'), ('bloating'),
    ('cramping'),('indigestion'),('runny nose'),('stuffy nose'),
    ('congestion'), ('wheezing'), ('chest-pain'), ('skin-reaction'), 
    ('internal heat'), ('palpitations'), ('brain-fog'),
    ('fatigue'), ('insomnia'), ('panic'), ('dissociation'),
    ('panarnoia');

insert into final_project.CONDITION_TYPE 
    VALUES('PTSD','acute'), 
    ('IBS', 'chronic'), 
    ('PCOS', 'relapse-remitting'),
    ('PCOS', 'chronic'),
    ('endometriosis', 'chronic'),
    ('anxiety', 'acute'),
    ('anxiety', 'chronic'),
    ('obesity', 'acute'), 
    ('SIADH', 'chronic'),
    ('multiple chemical sensitivity', 'chronic');

insert into final_project.CONDITION_INSTANCE 
    values('2013-03-02','unknown','cjayne', default, 7),
    ('2019-07-04','ole health','cjayne', default, 7),
    ('2008-07-04','ole health','cjayne', default, 7),
    ('2017-01-01', 'ole health', 'cjayne', default, 15),
    ('2008-01-01', 'kaise', 'cjayne', default, 8);

-- made a mistake on insert --
UPDATE final_project.condition_instance SET
    condition_type_condition_id = '10'::integer, 
    diagnosing_doctor = 'kaiser'::character varying WHERE
    condition_instance_id = 9;

select * from final_project.CONDITION_INSTANCE;


-- view condition instance with condition names --
select * from final_project.condition_instance 
    join final_project.condition_type 
    on condition_type_condition_id = condition_id;

INSERT into final_project.SYMPTOM_TYPE
    values('anxiety'), ('dizziness'),('swell (eyelids)'),
    ('swell (lips)'), ('very depressed mood'), ('binge');

SHOW search_path;
SET search_ TO final_project;
SHOW search_path;

-- change to single decimal type--
ALTER TABLE final_project.SYMPTOM_INSTANCE 
alter column severity type decimal(2,1);

-- IMPORT DATA FROM CSV------------------------------------------------
CONTEXT:  COPY symptom_instance, line 1, column date_time: "﻿date_time"
COPY  final_project.symptom_instance 
    ( date_time, severity, duration, symptom_type_symptom_name, user_user_name ) 
    FROM STDIN  DELIMITER ',' CSV   
    ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

select * from symptom_instance;

insert into final_project.MEDICATION_TYPE 
    values('rizatriptan'), ('desoloratidine'),
    ('hydrocobalamin'), ('magnesium stearate'),
    ('coq10'), ('ubiquinol'), ('loratidine d'),
    ('cyclobenzaprine'), ('tramadol'), ('epinephrine'), 
    ('fexofenadine'), ('acetomenaphin');

select * from final_project.medication_type;


ALTER TABLE IF EXISTS final_project.medication_instance
    ADD COLUMN dose integer;

insert into final_project.medication_instance
    values('2022-04-07 21:00', 'mg', 'desoloratidine', 'cjayne', '10'),
    ('2022-04-03 21:00', 'mg', 'desoloratidine', 'cjayne', '10'),
    ('2022-04-04 21:00', 'mg', 'desoloratidine', 'cjayne', '10'),
    ('2022-04-05 21:00', 'mg', 'desoloratidine', 'cjayne', '10'),
    ('2022-04-06 21:00', 'mg', 'desoloratidine', 'cjayne', '10');

select * from final_project.medication_instance;

insert into final_project.CONDITION_SYMPTOM
    values('swell (lips)', 1), 
    ('swell (eyelids)', 1),
    ('pain, generalized', 2), 
    ('dizziness', 5), 
    ('dizziness', 10),
    ('brain-fog', 2), 
    ('fatigue', 2);

select * from final_project.CONDITION_SYMPTOM;

-- View condition-symptom interactions with type names rather than ids
select symptom_type_symptom_name, condition_name 
	from final_project.condition_symptom as cs, 
	final_project.condition_instance as ci,
	final_project.condition_type as ct
	where cs.condition_instance_condition_instance_id = ci.condition_instance_id and 
	ci.condition_type_condition_id = ct.condition_id;

insert into final_project.TOOL_LOOKUP 
    values('thermometer'),('wearable');

insert into final_project.VITALS_TYPE 
    values(default,115,50,'F','body temperature','Fowlers (seated)','thermometer'),
    (default,300,20,'bpm','lowest heart rate','Prone','wearable');


select * from final_project.vitals_type;

--- add the amount column

ALTER TABLE IF EXISTS final_project.vital_instance
    ADD COLUMN amount numeric(5, 2) NOT NULL;

-- insert into vitals instance with csv
COPY  final_project.vital_instance 
    (date, fasting, vitals_type_vital_code, user_user_name, amount) 
    FROM STDIN  DELIMITER ',' CSV   HEADER  ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

select tab.date, tab.amount, vt.vital_name from final_project.vital_instance as tab
	join final_project.vitals_type as vt on vitals_type_vital_code = vital_code;

-- insert moods manually
insert into final_project.mood_type values
	(default, true, 'depressed'),
	(default, true, 'anxious'), 
	(default, true, 'irritable'),
	(default, true, 'angry'), 
	(default, true, 'discontent'), 
	(default, true, 'forlorn'),
	(default, false, 'excited'),
	(default, false, 'happy'),
	(default, false, 'grateful'),
	(default, false, 'loved');
select * from final_project.mood_type;

insert into final_project.mood_instance values(
	'2022-02-01', 'cjayne', 10, 1),
	('2022-02-01', 'cjayne', 2, 5),
	('2022-02-02', 'cjayne', 6, 7),
	('2022-02-01', 'cjayne', 8, 9);


----------------------------------------------------------------------
-------- CREATE FUNC TO VIEW USERS PRIMARY SYMPTOMS --------------
----------------------------------------------------------------------
----- Takes, username.  Returns Table with the symptoms and their causing conditions
CREATE OR REPLACE FUNCTION getUsersSymptoms(user_name VARCHAR(45))
	RETURNS TABLE(Symptom VARCHAR(45), Causing_Condition VARCHAR(45))
AS $$
begin
	RETURN QUERY select cs.symptom_type_symptom_name, ct.condition_name 
	from final_project.condition_symptom as cs, 
	final_project.condition_instance as ci,
	final_project.condition_type as ct
	where cs.condition_instance_condition_instance_id = ci.condition_instance_id and 
	ci.condition_type_condition_id = ct.condition_id and ci.user_user_name = user_name;
END;
$$
LANGUAGE 'plpgsql';

select * from getUsersSymptoms('cjayne');

----------------------------------------------------------------------
-------- CREATE FUNC TO INSERT NEW CONDITION INSTANCE---
----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insertCondition(onset_date_ DATE, 
										   user_name_ VARCHAR(45), 
										   condition_name_ VARCHAR(45), 
										   chronicity_ CHRON_OPTS)
if exists(
	 -- if condition, get condition id from condition table
	select condition_id as cond_id
		from final_project.CONDITION_TYPE 
		where condition_name = condition_name_ 
			and chronicity = chronicity_)
else
	-- if no condition type, create condition & grab type id
	cond_id = createCondition(condition_name_, chronicity_)

----------------------------------------------------------------------
-------- CREATE FUNC TO INSERT NEW CONDITION SYMPTOM INTERACTION---
----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insertConditionSymptom()
 -- if no symptom, create symptom
 -- if no condition, throw error to create condition instance


----------------------------------------------------------------------
-------- CREATE FUNC TO INSERT NEW SYMPTOM ---------------------
----------------------------------------------------------------------
----- Takes, symptom name.  No returns
CREATE OR REPLACE FUNCTION insertSymptom(symptom_name varchar(45))
	RETURNS void AS 
$$
begin
	INSERT INTO final_project.SYMPTOM_TYPE values(symptom_name);
end;
$$
LANGUAGE 'plpgsql';

SELECT insertSymptom('night sweats');

select * from final_project.Symptom_Type;


----------------------------------------------------------------------
-------- CREATE FUNC TO CREATE NEW CONDITION TYPE---
----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION createCondition(condition_name_ VARCHAR(45), 
									   chronicity_ CHRON_OPTS)
RETURNS cond_id INT AS
$$
begin
insert into final_project.CONDITION_TYPE(condition_name_, chronicity_);
RETURN INT cond_id 
		select condition_id as cond_id 
			from final_project.CONDITION_TYPE 
			where condition_name = condition_name_ 
				and chronicity = chronicity_;
end;
$$
language 'plgsql;'
select createCondition('Type 1 Diabetes Mellitus', 'chronic');
select createCondition('chronic recurring idiopathic angioedema', '')


----------------------------------------------------------------------
-------- CREATE PROCEDURE THAT SETUP COMPLETE ---------------------
----------------------------------------------------------------------
------- It is recommended that after initial setup of your personal database is completed, you run this procedure which will help optimize the database
------- Anytime that major changes are done to the database (ie lots of new data is populated) you rerun this
------- Alternatively, if data is populated one at a time rerunning is recommended 
-- * to trigger all tables as a loop?
-- check how many rows in table (before or after dropping index?)
-- drop index
-- recreate index


----------------------------------------------------------------------
-------- CREATE VIEWS FOR AN INDIVIDUAL USER  ---------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
-------- My Conditions  ---------------------------------------------
----------------------------------------------------------------------
CREATE OR REPLACE VIEW final_project.my_conditions AS
	(select condition_instance_id as id_, condition_name, onset_date
	from final_project.condition_instance 
	join final_project.condition_type on condition_type_condition_id = condition_id);
	
select * from final_project.my_conditions;

---------------------------------------------------------------------
-------- My Conditions' Symptoms  ---------------------------------------------
----------------------------------------------------------------------

CREATE VIEW final_project.my_conditions_symptoms AS	
	select condition_name as causing_condition, symptom_type_symptom_name as symptom
	from final_project.my_conditions join final_project.condition_symptom
	on id_ = condition_instance_condition_instance_id;

select * from final_project.my_conditions_symptoms


---------------------------------------------------------------------
-------- My Syptom Scores  ---------------------------------------------
----------------------------------------------------------------------
CREATE VIEW final_project.my_symptoms AS
    select si.date_time::date as date_ , 
			si.symptom_type_symptom_name as symptom, 
            avg(si.severity) as days_average, 
            max(si.severity) as days_max, 
            min(si.severity) as days_min
        from final_project.symptom_instance as si
        group by si.date_time::date, si.symptom_type_symptom_name
		order by date_, symptom;

select * from final_project.my_symptoms;


---------------------------------------------------------------------
-------- My Mood Scores  ---------------------------------------------
----------------------------------------------------------------------
CREATE VIEW final_project.my_moods AS(
        select 
			mi.date_time::date as date_, 
			mt.name, 
            avg(case when mt.is_negative_valence then (mi.severity*-1) 
                else mi.severity 
                end) as overall_valence
        from final_project.mood_instance as mi 
			join final_project.mood_type as mt 
			on mt.id = mi.mood_type_id 
        group by mi.date_time::date, mt.name
);		

select * from final_project.my_moods;

---------------------------------------------------------------------
-------- My Valence Scores  ---------------------------------------------
----------------------------------------------------------------------
CREATE VIEW final_project.my_valence AS(
    with wv as ( -- set the weighting for valence of each mood
        select mi.date_time::date as date_, 
            mt.name, 
            avg(case when mt.is_negative_valence then (mi.severity*-1) --negate scores when negative mood
                else mi.severity 
                end) as overall_valence
        from final_project.mood_instance as mi join final_project.mood_type as mt on mt.id = mi.mood_type_id 
        group by mi.date_time::date, mt.name
    )
    select date_, avg(overall_valence) as overall_valence
        from wv
        group by date_
        order by date_
);
		
select * from final_project.my_valence;


---------------------------------------------------------------------
-------- My Wellness Scores  ---------------------------------------------
----------------------------------------------------------------------
-- add more symptom scores for testing
insert into final_project.symptom_instance 
	values('2022-02-02 01:00:00 PM', 8, Null,'fatigue', 'cjayne'),
	('2022-02-02 09:00:00 PM', 6, Null,'fatigue', 'cjayne');

select * from final_project.symptom_instance where date_time::date = '2022-02-02';
select * from final_project.my_valence natural join final_project.my_symptoms;

create view final_project.my_wellness as
	with inny as (select date_, avg(days_average) as flare_avg, overall_valence
				from final_project.my_symptoms 
				natural join final_project.my_valence 
				group by date_, overall_valence)
	select date_, flare_avg*1.5+overall_valence/2 as wellness_score
	from inny; 
	
select * from final_project.my_wellness

---------------------------------------------------------------------
-------- My Mood Condition Interaction Function -----------------------
----------------------------------------------------------------------

DROP FUNCTION final_project.get_condition_mood_interaction;
CREATE OR REPLACE FUNCTION final_project.get_condition_mood_interaction(
	condition_name character varying)
    RETURNS TABLE(date__ date, symptom_ character varying, symptom_average_ numeric, overall_valence_ numeric, causing_condition_ character varying)
    LANGUAGE 'plpgsql'
AS $BODY$
begin
	RETURN QUERY select date_, 
					symptom, 
					days_average as symptom_average, 
					overall_valence as daily_valence, 
					causing_condition as associated_condition 
					from final_project.my_symptoms 
					natural join final_project.my_valence 
					natural join final_project.my_conditions_symptoms
					where causing_condition = condition_name; 
END;
$BODY$;

select * from final_project.get_condition_mood_interaction('fibromyalgia');

CREATE OR REPLACE FUNCTION final_project.get_mood_symptom_interaction(mood_in varchar)
    RETURNS TABLE(date_symptom date, date_mood date, symptom character varying, symptom_avg numeric, directional_intensity numeric, mood_name varchar)
    LANGUAGE 'plpgsql'
AS $BODY$
begin
	RETURN QUERY select ms.date_ as symptom_date,
					mm.date_ as mood_date, 
					ms.symptom, 
					ms.days_average as symptom_average, 
					mm.overall_valence as intensity, 
					mm.name as mood_
					from final_project.my_symptoms as ms
					cross join final_project.my_moods as mm
					where mood_in = mm.name and 
						((mm.date_= ms.date_) or 
						 ((mm.date_ + interval '1 day') = ms.date_) or 
						 ((mm.date_+ interval '2 days') = ms.date_)); 
END;
$BODY$;

select * from final_project.get_mood_symptom_interaction('depressed');

select * 
	from
		(select date_symptom, 
		date_mood, 
		symptom, 
		symptom_avg,
		rank() over(partition by date_symptom order by symptom_avg desc) as r,
		directional_intensity, 
		mood_name
		from final_project.get_mood_symptom_interaction('depressed')) inny
	where r=1;

---------------------------------------------------------------------
-------- My Flare Score ---------------------------------------------
----------------------------------------------------------------------
CREATE OR REPLACE VIEW final_project.my_flares
 AS
 SELECT my_symptoms.date_,
    avg(my_symptoms.days_average) AS flare_score
   FROM final_project.my_symptoms
  GROUP BY my_symptoms.date_;

---------------------------------------------------------------------
-------- Worst Offenders  ---------------------------------------------
----------------------------------------------------------------------
CREATE OR REPLACE VIEW final_project.worst_culprits AS
	select date_, 
		array_agg(distinct symptom) as worst_rated_symptoms, 
		avg(days_average) symptom_intensity, 
		array_agg(distinct causing_condition) as potential_culprits
		from
		-- select the highest ranked symptom and where tied, average and aggregate which symptoms 
		-- are worst
		-- creates spurious tuples if multiple highest rank symptoms, resolved through array_ag()
			(select symptom, 
				days_average,
				rank() over(partition by date_ 
							order by days_average desc 
							rows between unbounded preceding and current row) as rank_,
				date_, 
				causing_condition
			 -- rank the highest to lowest averages so that most intense symptoms on a day have a rank 1
				from(
					select * 
					-- grab all the symptoms and conditions interactions, may create
					-- spurious tuples where symptom shared across conditions, 
					-- if more than one condition selected in where clause
					-- this is resolved through array_ag()
						from final_project.my_symptoms  
						natural join final_project.my_conditions_symptoms) as inner_
			) as second_inner
		where rank_ = 1
		group by date_;

select * 
	from final_project.worst_culprits;

---------------------------------------------------------------------
-------- ROLES  ---------------------------------------------
----------------------------------------------------------------------

CREATE ROLE avg_user;

-- create grant options to read, write, update and delete with row restrictions for all user owned instances
-- enable row level  securities across tables to enact policies on
alter table final_project.body_measure_instance enable row level security;
alter table final_project.condition_instance enable row level security;
alter table final_project.exercise_instance enable row level security;
alter table final_project.female_instance enable row level security;
alter table final_project.food_bev_instance enable row level security;
alter table final_project.intoxicant_instance enable row level security;
alter table final_project.locations enable row level security;
alter table final_project.medication_instance enable row level security;
alter table final_project.mood_instance enable row level security;
alter table final_project.positive_event_instance enable row level security;
alter table final_project.sleep_instance enable row level security;
alter table final_project.stressor_instance enable row level security;
alter table final_project.transport_instance enable row level security;
alter table final_project.user enable row level security;
alter table final_project.vital_instance enable row level security;


GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.body_measure_instance TO avg_user;

CREATE POLICY body_measure_instance_policy ON final_project.body_measure_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.condition_instance TO avg_user;

CREATE POLICY condition_instance_policy ON final_project.condition_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.exercise_instance TO avg_user;

CREATE POLICY exercise_instance_policy ON final_project.exercise_instance 
    TO avg_user USING (user_user_name = current_user);

CREATE POLICY female_instance_policy ON final_project.female_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.food_bev_instance TO avg_user;

CREATE POLICY food_instance_policy ON final_project.food_bev_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.intoxicant_instance TO avg_user;

CREATE POLICY intox_instance_policy ON final_project.intoxicant_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.locations TO avg_user;

CREATE POLICY locations_policy ON final_project.locations 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.medication_instance TO avg_user;

CREATE POLICY medications_instance_policy ON final_project.medication_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.mood_instance TO avg_user;

CREATE POLICY mood_instance_policy ON final_project.mood_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.positive_event_instance TO avg_user;

CREATE POLICY pevent_instance_policy ON final_project.positive_event_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.sleep_instance TO avg_user;

CREATE POLICY sleep_instance_policy ON final_project.sleep_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.stressor_instance TO avg_user;

CREATE POLICY stressor_instance_policy ON final_project.stressor_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.symptom_instance TO avg_user;

CREATE POLICY symptom_instance_policy ON final_project.symptom_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.transport_instance TO avg_user;

CREATE POLICY transport_instance_policy ON final_project.transport_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.treatment_instance TO avg_user;

CREATE POLICY treatment_instance_policy ON final_project.treatment_instance 
    TO avg_user USING (user_user_name = current_user);

GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.vital_instance TO avg_user;

CREATE POLICY vital_instance_policy ON final_project.vital_instance 
    TO avg_user USING (user_user_name = current_user);


-- create grant options to select, write, and reference all lookups except state and country

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.body_measure_type TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.condition_type TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.exercise_type TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.food_bev_type TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.medication_instance TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.mood_type TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.positive_event_type TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.recreational_intoxicant TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.symptom_type TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.tool_lookup TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.treatment TO avg_user;

GRANT SELECT, INSERT, REFERENCES ON TABLE final_project.vitals_type TO avg_user;


-- create grant options to select and reference user, state and country tables with row restrictions on user
-- these tables need to be inserted into by DBA

GRANT SELECT, REFERENCES ON TABLE final_project.country_lookup_table TO avg_user;

GRANT SELECT, REFERENCES ON TABLE final_project.state_lookup TO avg_user;

GRANT SELECT, REFERENCES ON TABLE final_project."user" TO avg_user;

CREATE POLICY user_policy ON final_project."user" TO avg_user USING (user_name = current_user);

-- create grant options to reference domain and types in avg_user

GRANT USAGE ON TYPE chron_opts TO avg_user;
GRANT USAGE ON TYPE dose_opts TO avg_user;
GRANT USAGE ON TYPE ex_opts TO avg_user;
GRANT USAGE ON TYPE f_opts TO avg_user;
GRANT USAGE ON TYPE funits_opts TO avg_user;
GRANT USAGE ON TYPE intox_cat  TO avg_user;
GRANT USAGE ON TYPE intox_method TO avg_user;
GRANT USAGE ON TYPE intox_units TO avg_user;
GRANT USAGE ON TYPE pe_types TO avg_user;
GRANT USAGE ON TYPE pos_opts TO avg_user;
GRANT USAGE ON TYPE sex_opts TO avg_user;
GRANT USAGE ON TYPE stress_type TO avg_user;
GRANT USAGE ON TYPE t_types TO avg_user;
GRANT USAGE ON TYPE units_opts TO avg_user;
GRANT USAGE ON DOMAIN sev_opts TO avg_user;

CREATE ROLE avg_female;
GRANT INSERT, SELECT, UPDATE, REFERENCES ON TABLE final_project.female_instance TO avg_female;

-- create grant options to select and reference views with row restrictions
GRANT SELECT, REFERENCES ON final_project.my_symptoms to avg_user;
GRANT SELECT, REFERENCES ON final_project.my_conditions to avg_user;
GRANT SELECT, REFERENCES ON final_project.my_conditions_symptoms to avg_user;
GRANT SELECT, REFERENCES ON final_project.my_moods to avg_user;
GRANT SELECT, REFERENCES ON final_project.my_valence to avg_user;
GRANT SELECT, REFERENCES ON final_project.my_wellness to avg_user;
GRANT SELECT, REFERENCES ON final_project.my_flares to avg_user;
GRANT SELECT, REFERENCES ON final_project.worst_culprits to avg_user;
GRANT EXECUTE ON FUNCTION final_project.get_mood_symptom_interaction to avg_user;
GRANT EXECUTE ON FUNCTION final_project.get_condition_mood_interaction to avg_user;


---------------------------------------------------------------------
-------- ADD ADDITIONAL SECURITY AND CONSTRAINTS----------------------
---------------------------------------------------------------------
------- add a check that only certain symbols allowed in user_name and no spaces.  Thus minimize injections
ALTER TABLE final_project."user"
    add constraint valid_user CHECK (user_name ~ '[A-Za-z_$%@+(){}<;]');

------ add trigger so that female_instance is only accesible by female users
-- this is more efficient than operating on female_instance table as only DBAs can add users


---------------------------------------------------------------------
-------- NEW USER ACCESS ROLES NOT WORKING----------------------
---------------------------------------------------------------------

CREATE OR REPLACE FUNCTION final_project.user_access()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    SET check_function_bodies='true'
AS $BODY$
begin
    CREATE ROLE user_name IN ROLE avg_user;
end;
$BODY$;

CREATE TRIGGER new_user
    BEFORE INSERT OF user_name
    ON final_project."user"
    FOR EACH ROW
    EXECUTE FUNCTION final_project.user_access('user_name');

CREATE OR REPLACE FUNCTION final_project.female_access()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    SET check_function_bodies='true'
AS $BODY$
begin
    GRANT avg_female TO user_name;
end;
$BODY$;

CREATE TRIGGER femal_user
    AFTER INSERT OR UPDATE OF sex_at_birth
    ON final_project."user"
    FOR EACH ROW
    WHEN (new.sex_at_birth = 'female'::sex_opts)
    EXECUTE FUNCTION final_project.female_access('user_name');

COMMENT ON TRIGGER femal_user ON final_project."user"
    IS 'calls the female_access function';


CREATE OR REPLACE FUNCTION final_project.user_access(username varchar)
    RETURNS void
    LANGUAGE 'plpgsql'
AS $BODY$
begin
    CREATE ROLE username IN ROLE avg_user;
end;
$BODY$;


CREATE OR REPLACE FUNCTION final_project.to_lowercase(str varchar)
    RETURNS varchar
    LANGUAGE 'plpgsql'
AS $BODY$
begin
    RETURN LOWER(str);
end;
$BODY$;


insert into final_project."user" VALUES('radio', 'Fred', 'Macri', '1972-10-18', 'Male', 'USA', 'CA');
CREATE ROLE "radio" WITH PASSWORD 'b3stfri3nd' IN ROLE avg_user;
select * from final_project."user";

CREATE ROLE "cjayne" WITH PASSWORD 'itsm3' IN ROLE avg_user, avg_female;


insert into final_project.user values('mom', 'shannon', 'richards', '1961-06-16', 'USA', 'CA', 'female');

-- Add these
--- add "favorites"
--- add "flag for removal" with trigger to "alert DBA" when selected after insertion
