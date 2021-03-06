% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ibdg_fh.R
\name{ibdg_fh}
\alias{ibdg_fh}
\title{FH measure of IBDg}
\usage{
ibdg_fh(data, strata = NULL, monomorphic.out = TRUE,
  common.markers = FALSE, pop.levels = NULL, pop.labels = NULL,
  pop.select = NULL, blacklist.id = NULL, blacklist.genotype = NULL,
  whitelist.markers = NULL, max.marker = NULL, snp.ld = NULL,
  filename = NULL, verbose = TRUE)
}
\arguments{
\item{data}{11 options: VCF (SNPs or Haplotypes,
to make the vcf population ready, see details below),
plink, stacks haplotype file, genind (library(adegenet)),
genlight (library(adegenet)), gtypes (library(strataG)), genepop,
and a data frame in long/tidy or wide format.
\emph{See details} of \code{\link{tidy_genomic_data}}.}

\item{strata}{(optional/required) Required for VCF and haplotypes files,
optional for the other formats supported.

The strata file is a tab delimited file with a minimum of 2 columns headers:
\code{INDIVIDUALS} and \code{STRATA}.
If a \code{strata} file is specified with all file formats that don't
require it, the strata argument will have precedence on the population
groupings used internally in those file formats.
The \code{STRATA} column can be any hierarchical grouping.
To create a strata file see \code{\link[radiator]{individuals2strata}}.
If you have already run
\href{http://catchenlab.life.illinois.edu/stacks/}{stacks} on your data,
the strata file is similar to a stacks \emph{population map file},
make sure you
have the required column names (\code{INDIVIDUALS} and \code{STRATA}).
Default: \code{strata = NULL}.}

\item{monomorphic.out}{(optional) Set by default to remove
monomorphic markers that might have avoided filters.
Default: \code{monomorphic.out = TRUE}.}

\item{common.markers}{(optional) Logical. The argument for common markers
between populations is set by default to maximize genome coverage of
individuals and populations.
Default: \code{common.markers = FALSE}}

\item{pop.levels}{(optional, string) This refers to the levels in a factor. In this
case, the id of the pop.
Use this argument to have the pop ordered your way instead of the default
alphabetical or numerical order. e.g. \code{pop.levels = c("QUE", "ONT", "ALB")}
instead of the default \code{pop.levels = c("ALB", "ONT", "QUE")}.
White spaces in population names are replaced by underscore.
Default: \code{pop.levels = NULL}.}

\item{pop.labels}{(optional, string) Use this argument to rename/relabel
your pop or combine your pop. e.g. To combine \code{"QUE"} and \code{"ONT"}
into a new pop called \code{"NEW"}:
(1) First, define the levels for your pop with \code{pop.levels} argument:
\code{pop.levels = c("QUE", "ONT", "ALB")}.
(2) then, use \code{pop.labels} argument:
\code{pop.levels = c("NEW", "NEW", "ALB")}.
To rename \code{"QUE"} to \code{"TAS"}:
\code{pop.labels = c("TAS", "ONT", "ALB")}.
Default: \code{pop.labels = NULL}. If you find this too complicated,
there is also the \code{strata} argument that can do the same thing,
see below.
White spaces in population names are replaced by underscore.}

\item{pop.select}{(string, optional) Selected list of populations for
the analysis. e.g. \code{pop.select = c("QUE", "ONT")} to select \code{QUE}
and \code{ONT} population samples (out of 20 pops).
Default: \code{pop.select = NULL}}

\item{blacklist.id}{(optional) A blacklist with individual ID and
a column header 'INDIVIDUALS'. The blacklist is an object in your
global environment or a file in the working directory
(e.g. "blacklist.txt").
Default: \code{blacklist.id = NULL}.}

\item{blacklist.genotype}{(optional) Useful to erase genotype with below
average quality, e.g. genotype with more than 2 alleles in diploid likely
sequencing errors or genotypes with poor genotype likelihood or coverage.
The blacklist has a minimum of 2 column headers (markers and individuals).
Markers can be 1 column (CHROM or LOCUS or POS),
a combination of 2 (e.g. CHROM and POS or CHROM and LOCUS or LOCUS and POS) or
all 3 (CHROM, LOCUS, POS). The markers columns must be designated: CHROM (character
or integer) and/or LOCUS (integer) and/or POS (integer). The id column designated
INDIVIDUALS (character) columns header. The blacklist must be in the working
directory (e.g. "blacklist.genotype.txt"). For de novo VCF, CHROM column
with 'un' need to be changed to 1.
Default: \code{blacklist.genotype = NULL} for no blacklist of
genotypes to erase.}

\item{whitelist.markers}{(optional) A whitelist containing CHROM (character
or integer) and/or LOCUS (integer) and/or
POS (integer) columns header. To filter by chromosome and/or locus and/or by snp.
The whitelist is in the working directory (e.g. "whitelist.txt").
de novo CHROM column with 'un' need to be changed to 1.
In the VCF, the column ID is the LOCUS identification.
Default \code{whitelist.markers = NULL} for no whitelist of markers.}

\item{max.marker}{(integer, optional) For large PLINK files,
useful to subsample marker number. e.g. if the data set
contains 200 000 markers and \code{max.marker = 10000}, 10000 markers are
subsampled randomly from the 200000 markers. If you need specific markers,
use \code{whitelist.markers} argument.
Default: \code{max.marker = NULL}.}

\item{snp.ld}{(optional) \strong{For VCF file only}.
SNP short distance linkage disequilibrium pruning. With anonymous markers from
RADseq/GBS de novo discovery, you can minimize linkage disequilibrium (LD) by
choosing among these 3 options: \code{"random"} selection, \code{"first"} or
\code{"last"} SNP on the same short read/haplotype. For long distance linkage
disequilibrium pruning, see details below.
Default: \code{snp.ld = NULL}.}

\item{filename}{(optional) Name of the tidy data set,
written to the working directory.}

\item{verbose}{(optional, logical) When \code{verbose = TRUE}
the function is a little more chatty during execution.
Default: \code{verbose = TRUE}.}
}
\value{
A list is created with 6 objects (function call, tables, manhattan,
boxplot and distribution plot).
FH measure is on average negative when the parents are less related than
expected by random mating. The distribution \code{fh.distribution.plot}
should be centered around 0 in samples of non-inbred individuals.
The first table, \code{$fh}, gives the individual's value
while the second table, \code{$fh.stats}, show the population and overall averaged.
}
\description{
FH is a proxy mesure of IBDg based on the excess in the observed
number of homozygous genotypes within an individual,
relative to the mean number of homozygous genotypes expected under random mating
(Keller et al., 2011; Kardos et al., 2015; Hedrick & Garcia-Dorado, 2016).

\strong{IBDg} is the realized proportion of the individual genome
that is identical by descent by reference to the current population
under hypothetical random mating
(Keller et al., 2011; Kardos et al., 2015; Hedrick & Garcia-Dorado, 2016).

This function is using a modified version of the FH measure
(constructed using \href{http://pngu.mgh.harvard.edu/~purcell/plink/}{PLINK}
\code{-het} option) described in (Keller et al., 2011; Kardos et al., 2015).

The novelties are:

\itemize{
\item \strong{population-wise:} the individual's observed homozygosity is
contrasted against the expected homozygosity.
Two estimates of the expected homozygosity are provided based
on the population and/or the overall expected homozygosity
averaged across markers.
\item \strong{tailored for RADseq:} instead of using the overall number
of markers, the population and the overall expected homozygosity
are averaged with the same markers the individual's are genotyped for.
This reduces the bias potentially introduced by comparing the individual's
observed homozygosity (computed from non-missing genotypes) with
an estimate computed with more markers found at the population or at the
overall level.
}

The FH measure is also computed in
[stackr](https://github.com/thierrygosselin/stackr) \emph{summary_haplotypes}
function and [grur](https://github.com/thierrygosselin/grur)
\emph{missing_visualization} functions.
See \strong{note} below for the equations.
}
\note{
\strong{Modified FH:}
\deqn{F_{h_i} = \frac{\overline{Het}_{obs_{ij}} - \overline{Het}_{exp_j}}{\sum_{i}snp_{ij} - \overline{Het}_{exp_j}}}

\strong{Individual Observed Heterozygosity averaged across markers:}
\deqn{\overline{Het}_{obs_i} = \frac{\sum_iHet_{obs_i}}{\sum_i{snp_i}}}

\strong{Population expected Heterozygosity (under Hardy-Weinberg) and
tailored by averaging for each individual using his genotyped markers:}
#\deqn{\overline{Het}_{exp_j} = \frac{\sum_jHet_{exp_j}}{\sum_j{snp_j}}}
}
\examples{
\dontrun{
# Using a  VCF file, the simplest for of the function:
fh <- ibdg_fh(
data = "batch_1.vcf",
strata = "strata.panda.tsv"
)
# To see what's inside the list
names(fh)
# To view the manhattan plot:
fh$fh.manhattan.plot
# To view the boxplot:
fh$fh.boxplot
# To view the distribution of FH values:
fh$fh.distribution.plot
}
}
\references{
Keller MC, Visscher PM, Goddard ME (2011)
Quantification of inbreeding due to distant ancestors and its detection
 using dense single nucleotide polymorphism data. Genetics, 189, 237–249.

Kardos M, Luikart G, Allendorf FW (2015)
Measuring individual inbreeding in the age of genomics: marker-based
measures are better than pedigrees. Heredity, 115, 63–72.

Hedrick PW, Garcia-Dorado A. (2016)
Understanding Inbreeding Depression, Purging, and Genetic Rescue.
Trends in Ecology and Evolution. 2016; 31: 940-952.
}
\author{
Thierry Gosselin \email{thierrygosselin@icloud.com}
}
