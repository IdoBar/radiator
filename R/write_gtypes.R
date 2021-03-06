# write a strataG gtypes object from a tidy data frame

#' @name write_gtypes
#' @title Write a \code{\link[strataG]{gtypes}} object from a tidy data frame

#' @description Write a \code{\link[strataG]{gtypes}} object from a tidy data frame.
#' Used internally in \href{https://github.com/thierrygosselin/radiator}{radiator}
#' and might be of interest for users.

#' @param data A tidy data frame object in the global environment or
#' a tidy data frame in wide or long format in the working directory.
#' \emph{How to get a tidy data frame ?}
#' Look into \pkg{radiator} \code{\link{tidy_genomic_data}}.

#' @return An object of the class \code{\link[strataG]{gtypes}} is returned.



#' @export
#' @rdname write_gtypes
# @import strataG

#' @importFrom tidyr gather
#' @importFrom methods new
#' @importFrom stringi stri_replace_all_fixed stri_sub
#' @importFrom dplyr select arrange rename mutate
#' @importFrom data.table dcast.data.table as.data.table
#' @importFrom purrr safely
#' @importFrom utils installed.packages


#' @seealso \code{strataG.devel} is available on github \url{https://github.com/EricArcher/}

#' @references Archer FI, Adams PE, Schneiders BB.
#' strataG: An r package for manipulating, summarizing and analysing population
#' genetic data.
#' Molecular Ecology Resources. 2017; 17: 5-11. doi:10.1111/1755-0998.12559

#' @author Thierry Gosselin \email{thierrygosselin@@icloud.com}

write_gtypes <- function(data) {
  # Check that strataG is installed --------------------------------------------
  if (!"strataG" %in% utils::installed.packages()[,"Package"]) {
    stop("Please install strataG for this output option:\n
devtools::install_github('ericarcher/strataG', build_vignettes = TRUE)")
  }
  # Checking for missing and/or default arguments ------------------------------
  if (missing(data)) stop("Input file missing")

  # Import data ---------------------------------------------------------------
  if (is.vector(data)) {
    input <- radiator::tidy_wide(data = data, import.metadata = TRUE)
  } else {
    input <- data
  }

  # check genotype column naming
  colnames(input) <- stringi::stri_replace_all_fixed(
    str = colnames(input),
    pattern = "GENOTYPE",
    replacement = "GT",
    vectorize_all = FALSE
  )

  # necessary steps to make sure we work with unique markers and not duplicated LOCUS
  if (tibble::has_name(input, "LOCUS") && !tibble::has_name(input, "MARKERS")) {
    input <- dplyr::rename(.data = input, MARKERS = LOCUS)
  }

  input <- dplyr::select(.data = input, POP_ID, INDIVIDUALS, MARKERS, GT) %>%
    dplyr::arrange(MARKERS, POP_ID, INDIVIDUALS) %>%
    dplyr::mutate(
      GT = replace(GT, which(GT == "000000"), NA),
      POP_ID = as.character(POP_ID),
      `1` = stringi::stri_sub(str = GT, from = 1, to = 3), # most of the time: faster than tidyr::separate
      `2` = stringi::stri_sub(str = GT, from = 4, to = 6)
    ) %>%
    dplyr::select(-GT) %>%
    tidyr::gather(
      data = .,
      key = ALLELES,
      value = GT,
      -c(MARKERS, INDIVIDUALS, POP_ID)
    ) %>%
    data.table::as.data.table(.) %>%
    data.table::dcast.data.table(
      data = .,
      formula = POP_ID + INDIVIDUALS ~ MARKERS + ALLELES,
      value.var = "GT",
      sep = "."
    ) %>%
    tibble::as_data_frame(.)

  # dcast is slightly faster using microbenchmark then unite and spread
  # tidyr::unite(data = ., MARKERS_ALLELES, MARKERS, ALLELES, sep = ".") %>%
  # tidyr::spread(data = ., key = MARKERS_ALLELES, value = GT)

  safe_gtypes <-  purrr::safely(.f = methods::new)

  res <- suppressWarnings(
    safe_gtypes(
      "gtypes",
      gen.data = input[, -(1:2)],
      ploidy = 2,
      ind.names = input$INDIVIDUALS,
      strata = input$POP_ID,
      schemes = NULL,
      sequences = NULL,
      description = NULL,
      other = NULL
    )
  )

  if (is.null(res$error)) {
    res <- res$result
  } else {
    stop("strataG package must be installed and loaded: library('strataG')")
  }

  return(res)
}# End write_gtypes
