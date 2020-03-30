#' Add bed movement data to an extracted table
#' 
#' Takes a table created by \code{\link{extract}} and adds bed movement data.
#' Please be aware, this may duplicate rows, if for example a patient moves
#' several beds in the same hour.
#'
#' @param connection a EMAP database connection
#' @param ltb a time series table produced from \code{\link{extract}}
#' 
#' @importFrom dplyr filter select collect rename left_join mutate full_join
#'   arrange
#'
#' @return a time series table with location data appended
#' @export
attach_locations <- function(connection, ltb) {
  
  tbls <- retrieve_tables(connection, "ops_dev")
  vo_ids <- unique(ltb$visit_occurrence_id)
  
  vo <- tbls[["visit_occurrence"]] %>%
    filter(visit_occurrence_id %in% vo_ids) %>%
    select(person_id, visit_occurrence_id, visit_start_datetime) %>%
    collect() %>%
    rename(vo_start = visit_start_datetime)
  
  ltb <- left_join(ltb, vo %>% select(person_id, visit_occurrence_id),
                   by = "visit_occurrence_id")
  
  vd <- tbls[["visit_detail"]] %>%
    filter(visit_occurrence_id %in% vo_ids) %>%
    left_join(tbls[["care_site"]] %>% select(care_site_id, care_site_name),
              by = "care_site_id") %>%
    select(visit_occurrence_id, person_id,
           visit_detail_id, visit_start_datetime,
           care_site_id, care_site_name) %>%
    collect() %>%
    rename(vd_start = visit_start_datetime)
  
  left_join(vo, vd, by = c("visit_occurrence_id", "person_id")) %>%
    mutate(time = round(
      as.numeric(
        difftime(vd_start, vo_start, units = "hours")), digits = 1)) %>%
    select(person_id, time, visit_occurrence_id, care_site_name) %>%
    full_join(ltb, by = c("person_id", "time", "visit_occurrence_id")) %>%
    arrange(person_id, visit_occurrence_id, time)
}