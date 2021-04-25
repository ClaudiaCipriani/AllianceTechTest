-- ----------------------------
-- Create the database for the star schema model that will be loaded by Pentaho PDI
-- the database must be called "alliance_target", as that is how Pentaho PDI will connect
-- ----------------------------
Create database alliance_target;

use alliance_target;

-- ----------------------------
-- Table structure for DIM_global_units
-- ----------------------------
DROP TABLE IF EXISTS `DIM_global_units`;
CREATE TABLE `DIM_global_units` (
	`id`  bigint(20) NOT NULL,
	`global_unit_type_id`  bigint(20) NOT NULL ,
	`smo_code`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
	`name`  text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
	`acronym`  varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
	`institution_id`  bigint(20) NULL,
	`is_active`  tinyint(1) NOT NULL ,
	`created_by`  bigint(20) NULL,
	`modified_by`  bigint(20) NULL,
	`active_since`  timestamp NULL,
	`modification_justification`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
	`is_marlo`  tinyint(1) NOT NULL ,
	`login`  tinyint(1) NOT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
;

-- ----------------------------
-- Table structure for DIM_loc_elements
-- ----------------------------
DROP TABLE IF EXISTS `DIM_loc_elements`;
CREATE TABLE `DIM_loc_elements` (
	`id`  bigint(20) NOT NULL,
	`name`  text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
	`iso_alpha_2`  varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`iso_numeric`  bigint(5) NULL,
	`parent_id`  bigint(20) NULL,
	`element_type_id`  bigint(20) NULL, -- regions: element_type_id =1 and countries: element_type_id = 2
	`geoposition_id`  bigint(20) NULL,
	`is_site_integration`  tinyint(1) NULL,
	`is_active`  tinyint(1) NOT NULL ,
	`created_by`  bigint(20) NULL,
	`active_since`  timestamp NOT NULL,
	`modified_by`  bigint(20) NULL,
	`modification_justification`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
	`global_unit_id`  bigint(20) NULL,
	`rep_ind_regions_id`  bigint(20) NULL,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
;

-- ----------------------------
-- Table structure for DIM_geographic_scopes
-- ----------------------------
DROP TABLE IF EXISTS `DIM_geographic_scopes`;
CREATE TABLE `DIM_geographic_scopes` (
`id`  bigint(20) NOT NULL,
`name`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`iati_name`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`definition`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
;

-- ----------------------------
-- Table structure for DIM_srf_sub_idos
-- ----------------------------
DROP TABLE IF EXISTS `DIM_srf_sub_idos`;
CREATE TABLE `DIM_srf_sub_idos` (
`id`  bigint(20) NOT NULL,
`description`  text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`ido_id`  bigint(20) NOT NULL ,
`smo_code`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`is_active`  tinyint(1) NOT NULL ,
`created_by`  bigint(20) NULL,
`active_since`  timestamp NOT NULL,
`modified_by`  bigint(20) NULL,
`modification_justification`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
;

-- ----------------------------
-- Table structure for DIM_Years
-- ----------------------------
DROP TABLE IF EXISTS `DIM_Years`;
CREATE TABLE `DIM_Years` (
`year`  bigint(5) NOT NULL,
PRIMARY KEY (`year`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
;

-- ----------------------------
-- Table structure for FACT_Project_Policies
-- ----------------------------
DROP TABLE IF EXISTS `FACT_Project_Policies`;
CREATE TABLE `FACT_Project_Policies` (
`id`  bigint(20) NOT NULL AUTO_INCREMENT,
`project_policy_id`  bigint(20) NOT NULL,
`id_phase`  bigint(20) NULL DEFAULT NULL,
`year`  bigint(5) NOT NULL,
`id_global_unit` bigint(20) NOT NULL,
`id_loc_element` bigint(20) NULL,  -- There might be policies with no country nor region
`id_sub_idos` bigint(20) NULL,   -- There might be policies with no sub_idos
`id_geographic_scopes` bigint(20) NULL,
`title`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`description`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`year`) REFERENCES `DIM_Years` (`year`),
FOREIGN KEY (`id_global_unit`) REFERENCES `DIM_global_units` (`id`),
FOREIGN KEY (`id_loc_element`) REFERENCES `DIM_loc_elements` (`id`),
FOREIGN KEY (`id_sub_idos`) REFERENCES `DIM_srf_sub_idos` (`id`),
FOREIGN KEY (`id_geographic_scopes`) REFERENCES `DIM_geographic_scopes` (`id`),
INDEX `idx_id_global_unit` (`id_global_unit`) USING BTREE ,
INDEX `idx_id_loc_element` (`id_loc_element`) USING BTREE ,
INDEX `idx_id_sub_idos` (`id_sub_idos`) USING BTREE ,
INDEX `idx_id_geographic_scopes` (`id_geographic_scopes`) USING BTREE
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
;



-- ----------------------------
-- Table structure for FACT_Project_Policies STAGING
-- This table is a staging table with no constraints. The data of the Facts will first be loaded in this table
-- then if all the integrity checks are passed it will be loaded into the final Facts table	
-- ----------------------------
DROP TABLE IF EXISTS `FACT_Project_Policies_STG`;
CREATE TABLE `FACT_Project_Policies_STG` (
`project_policy_id`  bigint(20),
`id_phase`  bigint(20),
`year`  bigint(5),
`id_global_unit` bigint(20),
`id_loc_element` bigint(20),  
`id_sub_idos` bigint(20) NULL,   
`id_geographic_scopes` bigint(20) ,
`title`  text CHARACTER SET utf8 COLLATE utf8_general_ci  ,
`description`  text CHARACTER SET utf8 COLLATE utf8_general_ci 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
;


