
removeDup <- function(dhs_data_list) {

  if ("ir" %in% names(dhs_data_list)) {
    # get birth variables & remove them
    birthVars <- names(dhs_data_list$ir)
    birthVars <- birthVars[grepl("_", birthVars)]
    birthVars <- birthVars[startsWith(birthVars, "b")]

    dhs_data_list$ir <- dhs_data_list$ir[,!names(dhs_data_list$ir) %in% birthVars]

    # get delivery vars and remove them
    delVars <- names(dhs_data_list$ir)
    delVars <- delVars[grepl("_", delVars)]
    delVars <- delVars[startsWith(delVars, "m")]
    delVars <- delVars[!grepl("mm", delVars)]

    dhs_data_list$ir <- dhs_data_list$ir[,!names(dhs_data_list$ir) %in% delVars]

    # get delivery vars and remove them
    vaxVars <- names(dhs_data_list$ir)
    vaxVars <- vaxVars[grepl("_", vaxVars)]
    vaxVars <- vaxVars[startsWith(vaxVars, "h")]

    dhs_data_list$ir <- dhs_data_list$ir[,!names(dhs_data_list$ir) %in% vaxVars]
  }

  if ("hr" %in% names(dhs_data_list)) {

    # get household member vars and remove them
    hhmemVars <- names(dhs_data_list$hr)
    hhmemVars <- hhmemVars[grepl("_", hhmemVars)]
    hhmemVars <- hhmemVars[grepl("hv", hhmemVars)]

    dhs_data_list$hr <- dhs_data_list$hr[,!names(dhs_data_list$hr) %in% hhmemVars]

    hhmemVars_sh <- names(dhs_data_list$hr)
    hhmemVars_sh <- hhmemVars_sh[grepl("_", hhmemVars_sh)]
    hhmemVars_sh <- hhmemVars_sh[grepl("sh", hhmemVars_sh)]

    dhs_data_list$hr <- dhs_data_list$hr[,!names(dhs_data_list$hr) %in% hhmemVars_sh]

    hhmemVars_other <- names(dhs_data_list$hr)
    hhmemVars_other <- hhmemVars_other[grepl("_", hhmemVars_other)]
    hhmemVars_other <- hhmemVars_other[grepl("ha|hc|hb|hml", hhmemVars_other)]

    dhs_data_list$hr <- dhs_data_list$hr[,!names(dhs_data_list$hr) %in% hhmemVars_other]

  }

  if ("cr" %in% names(dhs_data_list)) {

    # get household member vars and remove them
    birthVars <- names(dhs_data_list$cr)
    birthVars <- birthVars[grepl("_", birthVars)]
    birthVars <- birthVars[startsWith(birthVars, "b")]

    dhs_data_list$cr <- dhs_data_list$cr[,!names(dhs_data_list$cr) %in% birthVars]

    delVars <- names(dhs_data_list$cr)
    delVars <- delVars[grepl("_", delVars)]
    delVars <- delVars[startsWith(delVars, "m")]

    dhs_data_list$cr <- dhs_data_list$cr[,!names(dhs_data_list$cr) %in% delVars]

    contraVars <- names(dhs_data_list$cr)
    contraVars <- contraVars[grepl("_", contraVars)]
    contraVars <- contraVars[startsWith(contraVars, "v")]

    dhs_data_list$cr <- dhs_data_list$cr[,!names(dhs_data_list$cr) %in% contraVars]

  }

  return(dhs_data_list)

}
