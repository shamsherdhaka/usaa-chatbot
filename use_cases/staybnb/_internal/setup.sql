--!jinja
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
CREATE OR REPLACE SCHEMA CORTEX_AGENTS_DEMO.STAYBNB;

CREATE OR REPLACE STAGE _DATA
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = ( TYPE = 'SNOWFLAKE_SSE' );

COPY FILES
  INTO @_DATA
  FROM @CORTEX_AGENTS_DEMO.PUBLIC.GITHUB_REPO_CORTEX_AGENTS_DEMO/branches/{{BRANCH}}/use_cases/staybnb/_internal/
  PATTERN='.*[.]parquet';;
ALTER STAGE _DATA REFRESH;

CREATE OR REPLACE TABLE "CORTEX_AGENTS_DEMO"."STAYBNB"."HOMES" ( RENTAL_HOME_ID VARCHAR , RENTAL_HOME_TITLE VARCHAR , RENTAL_HOME_DESCRIPTION VARCHAR , PROPERTY_TYPE VARCHAR , TOTAL_SQUARE_METERS NUMBER(38, 0) ); 

CREATE OR REPLACE TEMP FILE FORMAT "CORTEX_AGENTS_DEMO"."STAYBNB"."parquet_format"
	TYPE=PARQUET
    REPLACE_INVALID_CHARACTERS=TRUE
    BINARY_AS_TEXT=FALSE; 

COPY INTO "CORTEX_AGENTS_DEMO"."STAYBNB"."HOMES" 
FROM (SELECT $1:RENTAL_HOME_ID::VARCHAR, $1:RENTAL_HOME_TITLE::VARCHAR, $1:RENTAL_HOME_DESCRIPTION::VARCHAR, $1:PROPERTY_TYPE::VARCHAR, $1:TOTAL_SQUARE_METERS::NUMBER(38, 0)
	FROM '@_DATA') 
FILES = ('homes.parquet') 
FILE_FORMAT = '"CORTEX_AGENTS_DEMO"."STAYBNB"."parquet_format"' 
ON_ERROR=ABORT_STATEMENT;

CREATE OR REPLACE TABLE "CORTEX_AGENTS_DEMO"."STAYBNB"."BOOKINGS" ( RENTAL_HOME_ID VARCHAR , BOOKING_DATE_START DATE , BOOKING_DATE_END DATE , PRICE_PER_NIGHT FLOAT , CLEANING_FEE NUMBER(38, 0) ); 

COPY INTO "CORTEX_AGENTS_DEMO"."STAYBNB"."BOOKINGS" 
FROM (SELECT $1:RENTAL_HOME_ID::VARCHAR, $1:BOOKING_DATE_START::DATE, $1:BOOKING_DATE_END::DATE, $1:PRICE_PER_NIGHT::FLOAT, $1:CLEANING_FEE::NUMBER(38, 0)
	FROM '@_DATA') 
FILES = ('bookings.parquet') 
FILE_FORMAT = '"CORTEX_AGENTS_DEMO"."STAYBNB"."parquet_format"' 
ON_ERROR=ABORT_STATEMENT;

CREATE OR REPLACE STAGE IMAGES
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = ( TYPE = 'SNOWFLAKE_SSE' );
  
CREATE OR REPLACE STAGE SEMANTIC_MODELS
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = ( TYPE = 'SNOWFLAKE_SSE' );

COPY FILES
  INTO @IMAGES
  FROM @CORTEX_AGENTS_DEMO.PUBLIC.GITHUB_REPO_CORTEX_AGENTS_DEMO/branches/{{BRANCH}}/use_cases/staybnb/images/;
ALTER STAGE IMAGES REFRESH;

COPY FILES
  INTO @SEMANTIC_MODELS
  FROM @CORTEX_AGENTS_DEMO.PUBLIC.GITHUB_REPO_CORTEX_AGENTS_DEMO/branches/{{BRANCH}}/use_cases/staybnb/semantic_models/
  PATTERN='.*[.]yaml';
ALTER STAGE SEMANTIC_MODELS REFRESH;

CREATE OR REPLACE NOTEBOOK SETUP_AGENT_STAYBNB
    FROM '@CORTEX_AGENTS_DEMO.PUBLIC.GITHUB_REPO_CORTEX_AGENTS_DEMO/branches/{{BRANCH}}/use_cases/staybnb' 
        MAIN_FILE = 'SETUP_AGENT_STAYBNB.ipynb' 
        QUERY_WAREHOUSE = COMPUTE_WH;
ALTER NOTEBOOK SETUP_AGENT_STAYBNB ADD LIVE VERSION FROM LAST;

-- Whether to execute the notebook or not during initial demo setup
{% if EXECUTE_NOTEBOOKS %}
    EXECUTE NOTEBOOK SETUP_AGENT_STAYBNB();
{%- endif -%}