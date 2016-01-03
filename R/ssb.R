#' Data from Statics Norway (SSB) Statbank database
#' 
#' Downloads the requested data by using Statistics Norway's API, parses the
#' resulting JSON file, and returns it as a data frame. 
#' 
#' @param id Data set ID. See the ssb_search() function.
#' @param lang Language of data set to return. Can be "en" for english or "no" for norwegian.
#' @return Data frame with SSB data 
#' @author Mikael Poul Johannesson \email{mikael.johannesson@uib.no}
#' @examples
#' ## View data sets related to population
#' View(ssb_search("population"))
#' 
#' ## Download population by municipalities from 1986 to last year
#' data <- ssb(26975)
#' str(data)
#' View(data)
#' @export
ssb <- function(id, lang = "en") {
    if (!id %in% ssb_data$en$id) {
        temp_list <- ssb_list()
        if (!id %in% temp_list) {
            stop(paste0("Can't find data set with id '", id, "'"))
        }
    }
    raw <- rjstat::fromJSONstat(readLines(paste0("https://data.ssb.no/api/v0/dataset/", id, ".json?lang=", lang), warn = FALSE, encoding = "UTF-8"))
    out <- raw[[1]]
    names(out) <- gsub(" ", "_", names(out))
    if ("time" %in% names(out)) {
        out <- .ssb_time_extraction(out)
    }
    attr(out, "title") <- names(raw)[1]
    attr(out, "source") <- attr(raw[[1]], "source")
    attr(out, "updated") <- attr(raw[[1]], "updated")
    return(out)
}

.ssb_time_extraction <- function(out) {
    vars <- names(out)[!(names(out) %in% c("value"))]
    out$year <- as.numeric(substr(out$time, 1, 4))
    new_vars <- "year"
    if (any(grepl("M\\d\\d", out$time))) {
        out$month <- as.numeric(sub("^.*M(..$)", "\\1", out$time))
        new_vars <- c(new_vars, "month")
    } else  if (any(grepl("K\\d", out$time))) {
        out$quarter <- as.numeric(sub("^.*K(.$)", "\\1", out$time))
        new_vars <- c(new_vars, "quarter")
    }
    out <- out[, c(vars, new_vars, "value")]
    ## if (quarter) {
    ##     old <- c("K1", "K2", "K3", "K4")
    ##     new <- c("01", "04", "07", "10")
    ##     for (i in 1:length(old)) time_var <- gsub(old[i], new[i], time_var)
    ## }
    ##date_format <- paste0("%Y", ifelse(month, "M%m", ifelse(quarter, "%m", "")))
    ## new_time_var <- as.Date(time_var, date_format)
    return(out)    
}
