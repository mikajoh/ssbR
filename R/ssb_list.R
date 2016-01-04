#' Download list of available data sets from Statistics Norway (SSB) API
#' 
#' Download an updated list of available data sets from the Statistics Norway (SSB)
#' API. Returns a data frame. 
#'
#' @param lang Language of available data sets to return. Can be "en" for english or "no" for norwegian.
#' @return Data frame listing all available data sets, with ID, title, tags and URLs.
#' @note The \code{ssbR} package ships with a local data frame with information on all
#'     data sets available on 03-01-2016. You can retrieve a new list of available data
#'     sets using \code{ssb_list()}, and give to to \code{ssb_search()} via the \code{list}
#'     argument.
#' @examples
#' ## View all data sets available from the Statistics Norway (SSB) API
#' View(ssb_list())
#' @export
ssb_list <- function(lang = "en") {
    out <- read.csv(paste0("https://data.ssb.no/api/v0/dataset/list.csv?lang=", lang), stringsAsFactors = FALSE, header = TRUE, encoding = "UTF-8", sep = ifelse(lang == "en", ",", ";"))
    return(out)
}
