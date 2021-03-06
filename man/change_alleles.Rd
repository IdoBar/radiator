% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/change_alleles.R
\name{change_alleles}
\alias{change_alleles}
\title{Change REF and ALT alleles based on count}
\usage{
change_alleles(data, monomorphic.out = TRUE, biallelic = NULL,
  parallel.core = parallel::detectCores() - 1, verbose = FALSE)
}
\arguments{
\item{data}{A biallelic genomic data set in the working directory or
object in the global environment in wide or long (tidy) formats.
See details for more info.}

\item{monomorphic.out}{(optional) Should the monomorphic
markers present in the dataset be filtered out ?
Default: \code{monomorphic.out = TRUE}.}

\item{biallelic}{(optional) If \code{biallelic = TRUE/FALSE} will be use
during multiallelic REF/ALT decision. Used internally in
\href{https://github.com/thierrygosselin/radiator}{radiator}.
Default: \code{biallelic = NULL}.}

\item{parallel.core}{(optional) The number of core used for parallel
execution.
Default: \code{parallel::detectCores() - 1}.}

\item{verbose}{(optional, logical) \code{verbose = TRUE} to be chatty
during execution.
Default: \code{verbose = FALSE}.}
}
\value{
A tidy data frame with 6 columns:
\code{MARKERS, INDIVIDUALS, REF, ALT, GT_VCF, GT_BIN}.
\code{GT_VCF}: the genotype in VCF format
\code{GT_BIN}: coding used internally to easily convert to genlight,
the coding \code{0, 1, 2, NA} stands for the number of ALT allele in the
genotype and \code{NA} for missing genotype.
}
\description{
Change REF and ALT alleles based on count, for biallelic data
with REF or ALT info, the function will generate a REF and ALT columns.
Used internally in \href{https://github.com/thierrygosselin/radiator}{radiator}
and might be of interest for users.
}
\details{
\strong{Input data:}

To discriminate the long from the wide format,
the function \pkg{radiator} \code{\link[radiator]{tidy_wide}} searches
for \code{MARKERS or LOCUS} in column names (TRUE = long format).
The data frame is tab delimitted.
\strong{Wide format:}
The wide format cannot store metadata info.
The wide format starts with these 2 id columns:
\code{INDIVIDUALS}, \code{POP_ID} (that refers to any grouping of individuals),
the remaining columns are the markers in separate columns storing genotypes.

\strong{Long/Tidy format:}
The long format is considered to be a tidy data frame and can store metadata info.
(e.g. from a VCF see \pkg{radiator} \code{\link{tidy_genomic_data}}). A minimum of 4 columns
are required in the long format: \code{INDIVIDUALS}, \code{POP_ID},
\code{MARKERS or LOCUS} and \code{GENOTYPE or GT}. The rest are considered metata info.

\strong{2 genotypes formats are available:}
6 characters no separator: e.g. \code{001002 of 111333} (for heterozygote individual).
6 characters WITH separator: e.g. \code{001/002 of 111/333} (for heterozygote individual).
The separator can be any of these: \code{"/", ":", "_", "-", "."}.

\emph{How to get a tidy data frame ?}
\pkg{radiator} \code{\link{tidy_genomic_data}} can transform 6 genomic data formats
in a tidy data frame.
}
\author{
Thierry Gosselin \email{thierrygosselin@icloud.com}
}
