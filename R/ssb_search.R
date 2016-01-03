#' Search id, title and tags of available data sets from Statistics Norway (SSB) API
#' 
#' Data frame with id, title, tag and URLs for data sets matching the provided search
#' terms.
#'
#' @param ... Character string(s) to use as search terms.
#' @param lang Language of available data sets to use. Can be "en" for english or "no" for norwegian.
#' @param list List of available data sets retrieved with the \code{ssb_list()} function. If not provided,
#'     the function uses a local list for the search (unless \code{update_list} is set to \code{TRUE}).
#' @param update_list If \code{TRUE} the function downloads and use an updated list of available data
#'     sets for the search.
#' @param print_results If \code{TRUE} it will print the results in the terminal.
#' @param return_results If \code{TRUE} it returns the results as data frame, otherwise it returns \code{NULL}.
#' @return Data frame with id, title, tag and URLs of data sets matching the provided search
#' terms.
#' @examples
#' res <- ssb_search("population")
#' View(res)
#' @export
ssb_search <- function(..., lang = "en", list = NULL, update_list = FALSE, print_results = TRUE, return_results = TRUE) {
    if (!(lang %in% c("no", "en"))) {
        stop("'lang' can only be one of 'en' or 'no'")
    }
    if (is.null(list)) {
        if (update_list) {
            list <- ssb_list(lang)
        } else {
            list <- ssb_data[[lang]]
        }
    }
    search_param <- paste(list$id, list$title, list$tags)
    search_words <- names(sort(table(strsplit(tolower(paste(list$id, list$title, list$tags, collapse = " ")), "[^a-z]+"))))

    ## Use adist to also search for nearby results if provided term does not match anything directly
    ## See: http://www.sumsar.net/blog/2014/12/peter-norvigs-spell-checker-in-two-lines-of-r/
    terms <- tolower(as.character(...))
    for (term in terms) {
        if (!any(term %in% search_words)) {
            term <- c(search_words[adist(term, search_words) <= min(adist(term, search_words), 2)], term)[1:3]
            terms <- c(terms, term)
        }
    }
    place <- sort(unique(as.numeric(unlist(sapply(terms, grep, x = search_param)))))
    results <- list[place, ]
    if (print_results) print(results[, c(1, 2)])
    if (return_results) return(results)
}
