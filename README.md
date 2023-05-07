## Introduction

The Demographic and Health Surveys (DHS) program is a valuable source of
information for researchers and policymakers working in the fields of
public health, demography, and social sciences. It provides nationally
representative and cross-sectional data for a wide range of indicators
related to population, health, and nutrition. The DHS data are collected
through household interviews conducted in numerous countries, usually
every five years.

Despite its importance and extensive use, working with DHS data can be
challenging due to its complex structure, large size, and the need to
link multiple datasets for comprehensive analysis. The dhs2db R package
aims to address these challenges by providing a streamlined process to
import and link DHS datasets into a PostgreSQL database. This allows
researchers to leverage the powerful querying and data manipulation
capabilities of PostgreSQL while working with DHS data.

### Justification for the Project

There are several reasons why the development of the dhs2db package may
be helpful for researchers working with DHS data:

1.  **Data management**: DHS datasets are typically large and can be
    difficult to manage in memory when using traditional data
    manipulation tools. Importing the data into a PostgreSQL database
    allows researchers to perform complex data manipulations and queries
    more efficiently.

2.  **Data linking**: The dhs2db package provides a systematic approach
    to link various DHS datasets (such as the Household, Individual, and
    Men’s datasets) through their unique identifiers. This makes it
    easier for researchers to perform multi-level analysis and gain
    deeper insights into the data.

3.  **Data integrity**: By importing the data into a PostgreSQL
    database, the dhs2db package ensures data integrity through the use
    of foreign key constraints and unique constraints. This helps
    prevent errors that may arise from improper data manipulation.

4.  **Reproducibility**: Using the dhs2db package ensures that the
    process of importing and linking DHS data is standardized and
    reproducible. This is particularly important for researchers who
    want to share their work and collaborate with others.

5.  **Ease of use**: The dhs2db package simplifies the process of
    importing and linking DHS data, making it accessible to researchers
    with varying levels of experience in data management and analysis.
    git remote add origin
    <https://github.com/jwilliamrozelle/dhs2db.git>

git push -u -f origin main

## Permission and requirements

This package and tutorial assume that you have an account at
dhsprogram.com and permission to access datasets.

First install the package using:

    devtools::install_github("https://github.com/jwilliamrozelle/dhs2db.git", build_vignettes = T)

## Set the environment

First, load the required packages into your R session.

    # library(dhs2db)
    library(rdhs)
    library(sf)

You may wish to keep your personal information outside of your codebase,
and `.Renviron` is a good way to accomplish this. Each line in the
`.Renviron` file will allow you to set an environment variable (for
example, mine has a single line `DHS_EMAIL = <your_email@example.com>`).
I use an environment email to store, for example, usernames and
passwords and include the `.Renviron` in my `.gitignore` file, so that
sensitive information remains on my local computer and is never uploaded
to the cloud.

You must restart your R session to load environment variables from the
`.Renviron` folder. To follow this tutorial without restarting R, you
can set environment variables within the R session by running the
following code


    Sys.setenv(DHS_EMAIL = "your_email@example.com")
    Sys.setenv(DHS_PROJECT = "YOUR DHS PROJECT NAME")

## Load the data into R

We will load information into R using the `rdhs` package. For detailed
information on retrieving data using `rdhs`, visit the
[vignette](https://cran.r-project.org/web/packages/rdhs/vignettes/introduction.html)
This package assumes you download data in STATA as zip files. When
prompted, type `1` That you would write files outside your R temporary
directory, then enter the password for your dhsprogram.com account.


    # Set up credentials
    set_rdhs_config(email = Sys.getenv("DHS_EMAIL"),
                    project = Sys.getenv("DHS_PROJECT"),
                    config_path = "rdhs.json",
                    cache_path = "C:\\Users\\JWROZE~1\\AppData\\Local\\jwrozelle\\rdhs\\Cache2",
                    # cache_path = "dhs_mlm_project",
                    global = F)


    # Get DHS surveys
    survs <- dhs_surveys(
      countryIds = "UG",
      surveyType = "DHS",
      surveyStatus = "Completed",
      surveyYear = c(2016)
    )

    # download the datasets
    datasets <- dhs_datasets(
      surveyIds = survs$SurveyId, 
      fileFormat = "stata",
      force = TRUE
      )
    downloads <- get_datasets(
      datasets$FileName, 
      clear_cache = TRUE)


    # make an empty list of dhs data
    dhsData.list <- list()

    # load each file into R
    for (svyTable in names(downloads)) {
      
      # load the downloaded data (sometimes there are weird permissions issues with rDHS. For the sake of this tutorial we will ignore them if they fail)
      try(mySvy <- readRDS(downloads[[svyTable]]))
      
      if (exists("mySvy")) {
        # assign the name of the download
        dhsData.list[[svyTable]] <- mySvy
      }
      
      # remove the generic survey variable from the environment
      rm(mySvy)
    }

    dhsData.list[["UGGE7AFL"]] <- st_read("C:/Users/jwrozelle/Downloads/UGGE7AFL/UGGE7AFL.shp")

## Send your dhs data to a PostgreSQL database!

The next step is relatively simple using the `dhs2pg` function, although
many helper functions in the background make this work.

-   First, the `dhs2pg` creates a schema,
-   Drops variables that are duplicated in other datasets (for example,
    information about place of birth is both in the Individual Recode
    table and the Birth Recode tables). Then,
-   For any tables that are still more than 1600 columns wide, a helper
    function splits the tables, but retains id columns within each.
-   Next, the `dhs2pg` function will upload tables to the PostgreSQL
    database. Each table is named by the data type (i.e. “ir”, “br”,
    etc.).
-   Finally, the unique ids and relationships are added as constraints
    to the tables.

<!-- -->


      # dhs_data_list <- dhsData.list
      # schema_name <- Sys.getenv("DB_SCHEMA")
      # db_host <- Sys.getenv("DB_HOST")
      # db_port <- Sys.getenv("DB_PORT")
      # db_name <- Sys.getenv("DB_NAME")
      # db_user <- Sys.getenv("DB_USER")
      # db_password <- Sys.getenv("DB_PW")

    dhs2pg(
      dhs_data_list = dhsData.list,
      schema_name = Sys.getenv("DB_SCHEMA"),
      db_host = Sys.getenv("DB_HOST"),
      db_port = Sys.getenv("DB_PORT"),
      db_name = Sys.getenv("DB_NAME"),
      db_user = Sys.getenv("DB_USER"),
      db_password = Sys.getenv("DB_PW")
      )

Output will be:

    Creating schema...
    Identifying relationships...
    Trimming duplicate variables in tables...
    Uploading dataframes...
    Uploading br...
    Uploading cr...
    Uploading hr...
    Uploading ir...
    Uploading kr...
    Uploading mr...
    Uploading pr...
    Uploading ge...
    Creating foreign keys...
    [1] "Data upload successful. Uploaded tables: br, cr, hr, ir, kr, mr, pr, ge"

## ERD

The resulting database organization is:

<figure>
<img src="vignettes/erd.png" style="width:100.0%" alt="ERD" />
<figcaption aria-hidden="true">ERD</figcaption>
</figure>
