# AllianceTechTest
Repository for the delivarables of the technical test for the Alliance of Bioversity and CIAT

# Installation Steps for PART 1

1. Download the folder "2. Pentaho ETL" with all its content into your local machine.

2. Execute the script "bi_test_create_schema.sql" in a local MySql 8.0 database 
   (**IMPORTANT**: This script contains the operational source tables that you have sent as part of the test, 
   therefore you might not need this step in case you have the tables installed and loaded).
   
3. Execute the script "Create_Star_Schema.sql" in a local MySql 8.0 database (I have assumed this would not be a problem since the scrip to create the operational tables in your test was to be run in a similar database).
   This script will create a new database called "alliance_target" and the structure of the star schema tables.
   (**IMPORTANT**: if you already have a schema called "alliance_target" this script will fail).

4. Open Pentaho PDI, open the file "Load_Star_Schema.kjb" and create two database connections to MySql database: the first connection should be called "alliance_source" and should point to the database created as per point 2.
   The second connection should be called "alliance_target" and should point to the database created as per point 3.
   
4. In Pentaho PDI, in the Load_Star_Schema tab, click on the Start icon in the diagram and then press the Run button. Give it few minutes to finish.
   If everything is fine you should see no errors in the logging.
5. Log into your mySql alliance_target database and check if the tables are loaded using the queries below. 

	----------------------------------------------------------------------------------------------------
	```sql
	select count(*) from alliance_target.DIM_global_units;
	-- Result should be: 37
	select count(*) from alliance_target.DIM_geographic_scopes;
	-- Result should be: 5
	select count(*) from alliance_target.DIM_srf_sub_idos;
	-- Result should be: 46
	select count(*) from alliance_target.DIM_loc_elements;
	-- Result should be: 743
	select count(*) from alliance_target.DIM_Years;
	-- Result should be: 458
	select count(*) from alliance_target.fact_project_policies;
	-- Result should be: 1288
	```
	----------------------------------------------------------------------------------------------------
	
5. Open Pentaho Schema Workbench to load the cube based on the star schema created in the steps above. Create a new connection to the "alliance_target" and then open the file "Policy_Cube_Test.xml".

6. In Pentaho Schema Workbench open a MDX query to test the cube and run the queries below.

	----------------------------------------------------------------------------------------------------
	```sql	
	-- [1] MDX: This should return the count distinct of the project policy IDs
	SELECT 
	FROM Policies_2018_2019
	-- Result : 390

	-- [1] SQL: same query as above from Mysql DB
	select count(distinct project_policy_id) from alliance_target.fact_project_policies;
	-- Result : 390	
		
	-- [2] MDX: This should return the count distinct of the project policy IDs per Year
	SELECT {([Year].[2018]), ([Year].[2019] )} on columns
	FROM Policies_2018_2019
	
	Axis #0:
	{}
	Axis #1:
	{[Policies per Year.Years].[2018]}
	{[Policies per Year.Years].[2019]}
	Row #0: 163
	Row #0: 206
	
	-- [2] SQL: same query as above from Mysql DB
	select Year, count(distinct project_policy_id) from alliance_target.fact_project_policies where year in (2018,2019) group by year;
	Year, 	count(distinct project_policy_id)
	'2018', '163'
	'2019', '206'	
	
	-- [3] MDX: This should return the count distinct of the project policy IDs per Year Only for the National geo scope
	SELECT  {([Year].[2018]), ([Year].[2019] )} on columns, 
	{[Measures].[Number of policies]} ON ROWS
	FROM Policies_2018_2019
	WHERE [Policies per Geo Scopes.Geo Scopes].[National]
	
	Axis #0:
	{[Policies per Geo Scopes.Geo Scopes].[National]}
	Axis #1:
	{[Policies per Year.Years].[2018]}
	{[Policies per Year.Years].[2019]}
	Axis #2:
	{[Measures].[Number of Policies]}
	Row #0: 85
	Row #0: 135
	
	-- [3] SQL: same query as above from Mysql DB
	select Year, count(distinct project_policy_id) 
	from alliance_target.fact_project_policies 
	where year in (2018,2019) and id_geographic_scopes = 4  
	group by year;	
	Year, count(distinct project_policy_id)
	'2018', '85'
	'2019', '135'
	```
	----------------------------------------------------------------------------------------------------
	
# Installation Steps for PART 2

1. Download the folder "3. Power BI files" with all its content into your local machine.

2. Open Power BI (either Desktop or Services) and open the report file "Result Dashboard innovation Report.pbix".