% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/snp_ld.R
\name{snp_ld}
\alias{snp_ld}
\title{GBS/RADseq short distance linkage disequilibrium pruning}
\usage{
snp_ld(data, snp.ld = "first")
}
\arguments{
\item{data}{A tidy data set with ID (LOCUS) and POS (SNP) information.
\emph{How to get a tidy data frame ?}
Look into \pkg{radiator} \code{\link{tidy_genomic_data}}.
Usually the LOCUS and POS info is taken from a VCF file.}

\item{snp.ld}{(character) 3 options:
\code{snp.ld = "random"} selection, \code{snp.ld = "first"} or
\code{snp.ld = "last"} for SNP on the same short read/haplotype.
Default: \code{snp.ld = "first"}.}
}
\description{
SNP short distance linkage disequilibrium pruning. With anonymous markers from
RADseq/GBS de novo discovery, you can minimize linkage disequilibrium (LD) by
choosing among these 3 options (see argument below).

For long distance linkage disequilibrium pruning, see details below.
Used internally in \href{https://github.com/thierrygosselin/radiator}{radiator}
and might be of interest for users.
}
