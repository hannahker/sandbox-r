box::use(stringr)
box::use(arrow)
box::use(az = AzureStor)
box::use(glue)
box::use(rlang)
box::use(utils)
box::use(sf)
box::use(tools)
box::use(readr)
box::use(jsonlite)
box::use(dplyr)


azure_endpoint_url <- function(service = c("blob", "file"), stage = c("prod", "dev")) {
  service <- rlang$arg_match(service)
  stage <- rlang$arg_match(stage)
  # service and stage injected into endpoint string using `{glue}`
  glue$glue(Sys.getenv("DSCI_AZ_ENDPOINT"))
}

# gets the Dsci blob endpoints using the HDX Signals SAS
blob_endpoint_dev <- az$blob_endpoint(
  endpoint = azure_endpoint_url("blob", "dev"),
  sas = Sys.getenv("DSCI_AZ_SAS_DEV")
)

print(Sys.getenv("DSCI_AZ_ENDPOINT"))
print(azure_endpoint_url("blob", "dev"))
print(azure_endpoint_url("blob", "prod"))

blob_endpoint_prod <- az$blob_endpoint(
  endpoint = azure_endpoint_url("blob", "prod"),
  sas = Sys.getenv("DSCI_AZ_SAS_PROD")
)


# blob object for HDX Signals, used to read and write data
blob_dev <- az$blob_container(
  endpoint = blob_endpoint_dev,
  name = "hdx-signals"
)

# blob object for HDX Signals, used to read and write data
blob_prod <- az$blob_container(
  endpoint = blob_endpoint_prod,
  name = "hdx-signals-mc"
)

stage_to_blob <- function(stage = c("prod", "dev")) {
  stage <- rlang$arg_match(stage)
  if (stage == "prod") {
    blob_prod
  } else {
    blob_dev
  }
}


update_az_file <- function(df, name, stage = c("prod", "dev")) {
  blob <- stage_to_blob(stage)
  print(blob)
  fileext <- tools$file_ext(name)
  tf <- tempfile(fileext = paste0(".", fileext))

  switch(fileext,
    csv = readr$write_csv(x = df, file = tf),
    parquet = arrow$write_parquet(x = df, sink = tf),
    json = jsonlite$write_json(x = df, path = tf),
    geojson = sf$st_write(obj = df, dsn = tf, quiet = TRUE)
  )


  # wrapping to suppress printing of progress bar
  invisible(
    utils$capture.output(
      az$upload_blob(
        container = blob,
        src = tf,
        dest = name
      )
    )
  )
}