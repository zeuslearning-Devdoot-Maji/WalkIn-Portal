-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema walkin
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema walkin
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `walkin` DEFAULT CHARACTER SET utf8mb3 ;
USE `walkin` ;

-- -----------------------------------------------------
-- Table `walkin`.`college`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`college` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `CollegeName` VARCHAR(100) NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `college_name_UNIQUE` (`CollegeName` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`location` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Location` VARCHAR(30) NULL DEFAULT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`qualification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`qualification` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `QualificationDegree` VARCHAR(100) NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `qualification_degree_UNIQUE` (`QualificationDegree` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`stream`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`stream` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `StreamName` VARCHAR(30) NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `stream_name_UNIQUE` (`StreamName` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`phonecode`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`phonecode` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Code` VARCHAR(10) NULL DEFAULT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`user` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `DisplayPicture` VARCHAR(256) NULL DEFAULT NULL,
  `FirstName` VARCHAR(15) CHARACTER SET 'utf8mb3' NOT NULL,
  `LastName` VARCHAR(15) CHARACTER SET 'utf8mb3' NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(100) CHARACTER SET 'utf8mb3' NOT NULL,
  `PhoneNumber` VARCHAR(10) NOT NULL,
  `Resume` VARCHAR(256) NULL DEFAULT NULL,
  `PortfolioUrl` VARCHAR(45) NULL DEFAULT NULL,
  `ReferalEmployeeName` VARCHAR(30) CHARACTER SET 'utf8mb3' NULL DEFAULT NULL,
  `OtherFamiliarTechnologies` VARCHAR(45) NULL DEFAULT NULL,
  `MailSubscription` BIT(1) NOT NULL DEFAULT b'1',
  `ApplicantIsExperienced` BIT(1) NOT NULL DEFAULT b'0',
  `AppliedForZeusPreviously` BIT(1) NOT NULL DEFAULT b'0',
  `AppliedRole` VARCHAR(30) NULL DEFAULT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  `PhoneCodesId` INT NOT NULL,
  PRIMARY KEY (`Id`, `PhoneCodesId`),
  UNIQUE INDEX `email_UNIQUE` (`Email` ASC) VISIBLE,
  INDEX `fk_users_phone_codes1_idx` (`PhoneCodesId` ASC) VISIBLE,
  CONSTRAINT `fk_users_phone_codes1`
    FOREIGN KEY (`PhoneCodesId`)
    REFERENCES `walkin`.`phonecode` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`educationqualification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`educationqualification` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `AggregatePercentage` FLOAT NOT NULL,
  `YearOfPassing` INT NOT NULL,
  `QualificationId` INT NOT NULL,
  `StreamId` INT NOT NULL,
  `CollegeId` INT NOT NULL,
  `UserId` INT NOT NULL,
  `OtherCollegeName` VARCHAR(50) NULL DEFAULT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  `LocationId` INT NOT NULL,
  PRIMARY KEY (`Id`, `QualificationId`, `StreamId`, `CollegeId`, `UserId`, `LocationId`),
  INDEX `fk_education_qualifications_qualification1_idx` (`QualificationId` ASC) VISIBLE,
  INDEX `fk_education_qualifications_stream1_idx` (`StreamId` ASC) VISIBLE,
  INDEX `fk_education_qualifications_college1_idx` (`CollegeId` ASC) VISIBLE,
  INDEX `fk_education_qualifications_users1_idx` (`UserId` ASC) VISIBLE,
  INDEX `fk_education_qualifications_locations1_idx` (`LocationId` ASC) VISIBLE,
  CONSTRAINT `fk_education_qualifications_college1`
    FOREIGN KEY (`CollegeId`)
    REFERENCES `walkin`.`college` (`Id`),
  CONSTRAINT `fk_education_qualifications_locations1`
    FOREIGN KEY (`LocationId`)
    REFERENCES `walkin`.`location` (`Id`),
  CONSTRAINT `fk_education_qualifications_qualification1`
    FOREIGN KEY (`QualificationId`)
    REFERENCES `walkin`.`qualification` (`Id`),
  CONSTRAINT `fk_education_qualifications_stream1`
    FOREIGN KEY (`StreamId`)
    REFERENCES `walkin`.`stream` (`Id`),
  CONSTRAINT `fk_education_qualifications_users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `walkin`.`user` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`professionalqualifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`professionalqualifications` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `YearOfExperience` INT NOT NULL,
  `CurrentCTC` INT NOT NULL,
  `ExpextedCTC` INT NOT NULL,
  `OnNoticePeriod` BIT(1) NOT NULL DEFAULT b'1',
  `NoticeEndDate` DATE NOT NULL,
  `NoticePeriodDuration` INT NOT NULL,
  `UserId` INT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  `OtherExpertiseTechnology` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Id`, `UserId`),
  INDEX `fk_professional_qualifications_users1_idx` (`UserId` ASC) VISIBLE,
  CONSTRAINT `fk_professional_qualifications_users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `walkin`.`user` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`technology`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`technology` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `TechnologyName` VARCHAR(20) NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `technology_name_UNIQUE` (`TechnologyName` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`expertisetechnology`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`expertisetechnology` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `ProfessionalQualificationId` INT NOT NULL,
  `ProfessionalQualificationUserId` INT NOT NULL,
  `TechnologyId` INT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`, `ProfessionalQualificationId`, `ProfessionalQualificationUserId`, `TechnologyId`),
  INDEX `fk_professional_qualifications_has_technologies_technologie_idx` (`TechnologyId` ASC) VISIBLE,
  INDEX `fk_professional_qualifications_has_technologies_professiona_idx` (`ProfessionalQualificationId` ASC, `ProfessionalQualificationUserId` ASC) VISIBLE,
  CONSTRAINT `fk_professional_qualifications_has_technologies_professional_1`
    FOREIGN KEY (`ProfessionalQualificationId` , `ProfessionalQualificationUserId`)
    REFERENCES `walkin`.`professionalqualifications` (`Id` , `UserId`),
  CONSTRAINT `fk_professional_qualifications_has_technologies_technologies1`
    FOREIGN KEY (`TechnologyId`)
    REFERENCES `walkin`.`technology` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`familiartechnology`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`familiartechnology` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `UserId` INT NOT NULL,
  `TechnologyId` INT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`, `UserId`, `TechnologyId`),
  INDEX `fk_users_has_technologies_technologies1_idx` (`TechnologyId` ASC) VISIBLE,
  INDEX `fk_users_has_technologies_users1_idx` (`UserId` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_technologies_technologies1`
    FOREIGN KEY (`TechnologyId`)
    REFERENCES `walkin`.`technology` (`Id`),
  CONSTRAINT `fk_users_has_technologies_users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `walkin`.`user` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`prerequisiteapplicationprocess`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`prerequisiteapplicationprocess` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `GeneralInstructions` TEXT NOT NULL,
  `ExamInstructions` TEXT NOT NULL,
  `SystemRequirements` TEXT NOT NULL,
  `Process` TEXT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`job`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`job` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `JobTitle` VARCHAR(45) NOT NULL,
  `StartDate` DATE NULL DEFAULT NULL,
  `EndDate` DATE NULL DEFAULT NULL,
  `SpecialOppourtunity` VARCHAR(45) NULL DEFAULT NULL,
  `PrerequisiteApplicationProcessId` INT NOT NULL,
  `LocationId` INT NULL DEFAULT NULL,
  `DateCreated` DATETIME NULL DEFAULT NULL,
  `DateModified` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Id`, `PrerequisiteApplicationProcessId`),
  INDEX `fk_jobs_prerequisite_application_process1_idx` (`PrerequisiteApplicationProcessId` ASC) VISIBLE,
  INDEX `location_id` (`LocationId` ASC) VISIBLE,
  CONSTRAINT `fk_jobs_prerequisite_application_process1`
    FOREIGN KEY (`PrerequisiteApplicationProcessId`)
    REFERENCES `walkin`.`prerequisiteapplicationprocess` (`Id`),
  CONSTRAINT `jobs_ibfk_1`
    FOREIGN KEY (`LocationId`)
    REFERENCES `walkin`.`location` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`jobrole`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`jobrole` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `RoleName` VARCHAR(45) NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `role_UNIQUE` (`RoleName` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`jobroleassociation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`jobroleassociation` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `JobId` INT NOT NULL,
  `JobRoleId` INT NOT NULL,
  `JobPackage` INT NOT NULL,
  `RoleDescription` TEXT NOT NULL,
  `Requirements` TEXT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_jobs_has_job_roles_job_roles1_idx` (`JobRoleId` ASC) VISIBLE,
  INDEX `fk_jobs_has_job_roles_jobs1_idx` (`JobId` ASC) VISIBLE,
  CONSTRAINT `fk_jobs_has_job_roles_job_roles1`
    FOREIGN KEY (`JobRoleId`)
    REFERENCES `walkin`.`jobrole` (`Id`),
  CONSTRAINT `fk_jobs_has_job_roles_jobs1`
    FOREIGN KEY (`JobId`)
    REFERENCES `walkin`.`job` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`timeslot`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`timeslot` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `SlotStartTime` TIME NOT NULL,
  `SlotEndTime` TIME NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`jobtimeslot`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`jobtimeslot` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `JobId` INT NOT NULL,
  `TimeSlotId` INT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`, `JobId`, `TimeSlotId`),
  INDEX `fk_jobs_has_time_slots_time_slots1_idx` (`TimeSlotId` ASC) VISIBLE,
  INDEX `fk_jobs_has_time_slots_jobs1_idx` (`JobId` ASC) VISIBLE,
  CONSTRAINT `fk_jobs_has_time_slots_jobs1`
    FOREIGN KEY (`JobId`)
    REFERENCES `walkin`.`job` (`Id`),
  CONSTRAINT `fk_jobs_has_time_slots_time_slots1`
    FOREIGN KEY (`TimeSlotId`)
    REFERENCES `walkin`.`timeslot` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`userjobapplication`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`userjobapplication` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `UserId` INT NOT NULL,
  `JobId` INT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  `jobs_has_job_roles_id` INT NOT NULL,
  `jobs_has_time_slots_id` INT NOT NULL,
  PRIMARY KEY (`Id`, `UserId`, `JobId`),
  INDEX `fk_users_has_jobs_jobs1_idx` (`JobId` ASC) VISIBLE,
  INDEX `fk_users_has_jobs_users1_idx` (`UserId` ASC) VISIBLE,
  INDEX `jobs_has_job_roles_id` (`jobs_has_job_roles_id` ASC) VISIBLE,
  INDEX `jobs_has_time_slots_id` (`jobs_has_time_slots_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_jobs_jobs1`
    FOREIGN KEY (`JobId`)
    REFERENCES `walkin`.`job` (`Id`),
  CONSTRAINT `fk_users_has_jobs_users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `walkin`.`user` (`Id`),
  CONSTRAINT `users_applies_for_jobs_ibfk_1`
    FOREIGN KEY (`jobs_has_job_roles_id`)
    REFERENCES `walkin`.`jobroleassociation` (`Id`),
  CONSTRAINT `users_applies_for_jobs_ibfk_2`
    FOREIGN KEY (`jobs_has_time_slots_id`)
    REFERENCES `walkin`.`jobtimeslot` (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `walkin`.`userrole`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `walkin`.`userrole` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `JobRoleId` INT NOT NULL,
  `UserId` INT NOT NULL,
  `DateCreated` DATETIME NOT NULL,
  `DateModified` DATETIME NOT NULL,
  PRIMARY KEY (`Id`, `JobRoleId`, `UserId`),
  INDEX `fk_job_roles_has_users_users1_idx` (`UserId` ASC) VISIBLE,
  INDEX `fk_job_roles_has_users_job_roles1_idx` (`JobRoleId` ASC) VISIBLE,
  CONSTRAINT `fk_job_roles_has_users_job_roles1`
    FOREIGN KEY (`JobRoleId`)
    REFERENCES `walkin`.`jobrole` (`Id`),
  CONSTRAINT `fk_job_roles_has_users_users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `walkin`.`user` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;

USE `walkin` ;

-- -----------------------------------------------------
-- procedure create_user
-- -----------------------------------------------------

DELIMITER $$
USE `walkin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`(
	in_display_picture varchar(256),
    in_first_name varchar(15),
    in_last_name varchar(15),
    in_email varchar(45),
    in_password varchar(100),
    in_phone_number varchar(10),
    in_resume varchar(256),
    in_portfolio_url varchar(45),
    in_referral_employee_name varchar(15),
    in_mail_subscription bit(1),
    in_applicant_is_experienced bit(1),
    in_applied_for_zeus_previously bit(1),
    in_applied_role varchar(30),
    in_phone_codes_id int,
    
    in_aggregate_percentage float,
	in_year_of_passing int,
	in_qualification_id int,
	in_stream_id int,
	in_college_id int, 
    in_other_college_name varchar(50),
    in_location_id int,
    in_other_familiar_technologies varchar(45),
    
    job_role_id_array varchar(10),
    
    familiar_technologies_id_array varchar(10),
    
    
    in_year_of_experience int,
	in_current_ctc int, 
	in_expexted_ctc int, 
	in_on_notice_period bit(1), 
	in_notice_end_date date, 
	in_notice_period_duration int,
    in_other_expertise_technologies varchar(45),
    
    expertise_technologies_id_array varchar(10)
)
BEGIN

	DECLARE id_array_local VARCHAR(20);
    DECLARE start_pos SMALLINT;
    DECLARE comma_pos SMALLINT;
    DECLARE current_id VARCHAR(20);
    DECLARE end_loop TINYINT;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
		ROLLBACK;
	END;
    
    START TRANSACTION;
    
-- Insert User Information    
		INSERT INTO users (
			display_picture,
			first_name,
			last_name,
			email,
			password,
			phone_number,
			resume,
			portfolio_url,
			referral_employee_name,
            other_familiar_technologies,
			mail_subscription,
			applicant_is_experienced,
			applied_for_zeus_previously,
			applied_role,
            date_created,
            date_modified,
            phone_codes_id
        )
        VALUES (
			in_display_picture,
			in_first_name,
			in_last_name,
			in_email,
			in_password,
			in_phone_number,
			in_resume,
			in_portfolio_url,
			in_referral_employee_name,
            in_other_familiar_technologies,
			in_mail_subscription,
			in_applicant_is_experienced,
			in_applied_for_zeus_previously,
			in_applied_role,
            now(),
            now(),
            in_phone_codes_id
        );
        
        SELECT * FROM users;
        
-- Storing the recently created user's ID
        SET @user_id := (SELECT LAST_INSERT_ID());

-- Insert User Education Qualifications
        INSERT INTO education_qualifications (
			aggregate_percentage, 
			year_of_passing,
			qualification_id,
			stream_id, 
			college_id, 
			users_id,
            other_college_name,
            date_created,
            date_modified,
            locations_id
        )
        VALUES (
			in_aggregate_percentage,
			in_year_of_passing,
			in_qualification_id,
			in_stream_id,
			in_college_id, 
			@user_id,
            in_other_college_name,
            now(),
            now(),
            in_location_id
        );
        
        SELECT * FROM education_qualifications;

-- Insert Job Roles

		SET id_array_local = job_role_id_array;
		SET start_pos = 1;
		SET comma_pos = LOCATE(',', id_array_local);
    
		REPEAT
        IF comma_pos > 0 THEN
            SET current_id = SUBSTRING(id_array_local, start_pos, comma_pos - start_pos);
            SET end_loop = 0;
        ELSE
            SET current_id = SUBSTRING(id_array_local, start_pos);
            SET end_loop = 1;
        END IF;

        # Inserting the user's roles
        INSERT INTO user_roles (
			job_roles_id,
            users_id,
            date_created,
            date_modified
        )
        VALUES (
			current_id,
            @user_id,
            now(),
            now()
        );
       
        IF end_loop = 0 THEN
            SET id_array_local = SUBSTRING(id_array_local, comma_pos + 1);
            SET comma_pos = LOCATE(',', id_array_local);
        END IF;
		UNTIL end_loop = 1

		END REPEAT;
        
        SELECT * FROM user_roles;
    
-- Inserting user's familiar technologies
		SET id_array_local = familiar_technologies_id_array;
		SET start_pos = 1;
		SET comma_pos = LOCATE(',', id_array_local);
        
        REPEAT
        IF comma_pos > 0 THEN
            SET current_id = SUBSTRING(id_array_local, start_pos, comma_pos - start_pos);
            SET end_loop = 0;
        ELSE
            SET current_id = SUBSTRING(id_array_local, start_pos);
            SET end_loop = 1;
        END IF;

        # Inserting the technologies
        INSERT INTO familiar_technologies (
			technologies_id,
            users_id,
            date_created,
            date_modified
        )
        VALUES (
			current_id,
            @user_id,
            now(),
            now()
        );
       
        IF end_loop = 0 THEN
            SET id_array_local = SUBSTRING(id_array_local, comma_pos + 1);
            SET comma_pos = LOCATE(',', id_array_local);
        END IF;
		UNTIL end_loop = 1

		END REPEAT;
        
        SELECT * FROM familiar_technologies;
        
-- Inserting Data if user is expertise
		IF 
			in_applicant_is_experienced = 1
		THEN
			INSERT INTO professional_qualifications (
				year_of_experience,
				current_ctc,
				expexted_ctc,
				on_notice_period,
				notice_end_date, 
				notice_period_duration,
				users_id,
                other_expertise_technologies,
                date_created,
                date_modified
            )
            VALUES (
				in_year_of_experience,
				in_current_ctc, 
				in_expexted_ctc, 
				in_on_notice_period, 
				in_notice_end_date, 
				in_notice_period_duration,
                @user_id,
                in_other_expertise_technologies,
                now(),
                now()
            );
            
            SELECT * FROM professional_qualifications;
            
            -- Storing the recently created user's ID
			SET @professional_id := (SELECT LAST_INSERT_ID());
            
            -- Inserting user's expertise technologies
            SET id_array_local = expertise_technologies_id_array;
			SET start_pos = 1;
			SET comma_pos = LOCATE(',', id_array_local);
        
			REPEAT
			IF comma_pos > 0 THEN
				SET current_id = SUBSTRING(id_array_local, start_pos, comma_pos - start_pos);
				SET end_loop = 0;
			ELSE
				SET current_id = SUBSTRING(id_array_local, start_pos);
				SET end_loop = 1;
			END IF;

			# Inserting the technologies
			INSERT INTO expertise_technologies (
				technologies_id,
				professional_qualifications_users_id,
                professional_qualifications_id,
                date_created,
                date_modified
			)
			VALUES (
				current_id,
				@user_id,
                @professional_id,
                now(),
                now()
			);
       
			IF end_loop = 0 THEN
				SET id_array_local = SUBSTRING(id_array_local, comma_pos + 1);
				SET comma_pos = LOCATE(',', id_array_local);
			END IF;
			UNTIL end_loop = 1

			END REPEAT;
            
            SELECT * FROM expertise_technologies;
            
		END IF;
	SELECT "User created successfully";
	COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure display_created_users
-- -----------------------------------------------------

DELIMITER $$
USE `walkin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `display_created_users`(in_id int)
BEGIN
	SELECT * FROM users
    WHERE users.id = in_id;
    
    
    SELECT 
		education_qualifications.id,
		users_id,
		aggregate_percentage, 
		year_of_passing,
		qualification_id,
        qualification.qualification_degree,
		stream_id,
        stream.stream_name,
		college_id,
        college.college_name,
        locations_id,
        location
	FROM education_qualifications
    JOIN qualification
    ON education_qualifications.qualification_id = qualification.id
    JOIN stream
    ON education_qualifications.stream_id = stream.id
    JOIN college
    ON education_qualifications.college_id = college.id
    JOIN locations
    ON education_qualifications.locations_id = locations.id
    WHERE education_qualifications.users_id = in_id;
    
    
    SELECT 
		users_id,
        job_roles_id,
        role_name
	FROM user_roles
	JOIN job_roles
    ON user_roles.job_roles_id = job_roles.id
    WHERE user_roles.users_id = in_id;
    
    
    SELECT
		users_id,
        technologies_id,
        technology_name
    FROM familiar_technologies
    JOIN technologies
    ON familiar_technologies.technologies_id = technologies.id
    WHERE familiar_technologies.users_id = in_id;
    
    
    SELECT * FROM professional_qualifications
    WHERE professional_qualifications.users_id = in_id;
    
    
    SELECT 
		professional_qualifications_users_id AS user_id,
        technologies_id,
        technology_name
    FROM expertise_technologies
    JOIN technologies
    ON expertise_technologies.technologies_id = technologies.id
    WHERE expertise_technologies.professional_qualifications_users_id = in_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_all_jobs
-- -----------------------------------------------------

DELIMITER $$
USE `walkin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_jobs`()
BEGIN
	SELECT
		jobs.id AS walkin_id,
		job_title,
        start_date,
        end_date,
        expires_in,
        special_oppourtunity
    FROM jobs;
    
    SELECT
		jobs.id AS walkin_id,
        location_id,
        location
    FROM jobs
    JOIN locations
    ON jobs.location_id = locations.id
    ORDER BY jobs.id; 
    
    SELECT
		jobs_id AS walkin_id,
        job_roles_id AS role_id,
        role_name
    FROM jobs_has_job_roles
    JOIN job_roles
    ON jobs_has_job_roles.job_roles_id = job_roles.id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_particular_job
-- -----------------------------------------------------

DELIMITER $$
USE `walkin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_particular_job`(inid int)
BEGIN
	-- Get Job
	SELECT
		jobs.id AS walkin_id,
		job_title,
        start_date,
        end_date,
        expires_in
    FROM jobs
    WHERE jobs.id = inid;
    
    -- Get Location
    SELECT
		jobs.id AS walkin_id,
        location_id,
        location
    FROM jobs
    JOIN locations
    ON jobs.location_id = locations.id
    WHERE jobs.id = inid
    ORDER BY jobs.id; 
    
    -- Get Roles
    SELECT
		jobs_id AS walkin_id,
        job_roles_id AS role_id,
        role_name,
        job_package,
        role_description,
        requirements
    FROM jobs_has_job_roles
    JOIN job_roles
    ON jobs_has_job_roles.job_roles_id = job_roles.id
    WHERE jobs_id = inid;
    
    -- Get Time Slots
    SELECT 
		*
	FROM time_slots;
    
    -- Get Pre-requisite
    SELECT 
		*
	FROM prerequisite_application_process;
    
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
