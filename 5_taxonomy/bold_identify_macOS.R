## load packages
# devtools::install_github("ropensci/bold") # for the dev version
library("bold") # now at 0.5.0.  use ≥0.4.1.9300 If not avail from cran, use github version
library("plyr") # always load plyr before dplyr
library("seqinr") # used to read fasta file
library("dplyr")
library("readr")

## bold_identify multiple sequences from a fasta file ####

#### load a fasta file
testseqsall <- read.fasta(file = "CO1_1sequence_perBIN_040915_COIspiking.fas", seqtype = "DNA", set.attributes = FALSE, as.string = TRUE, forceDNAtolower = FALSE)  # read in fasta file using seqinr

#### bold_identify all sequences at once
# testseqsallbold <- bold_identify(testseqsall, db = "COX1")

#### bold_identify one sequence at a time (for large files that take a long time and might crash partway, this saves the output of each sequence)
testseqsallbold <- vector('list')
for (i in 1:length(testseqsall)) {
    print(i)
    boldoutput <- bold_identify(testseqsall[i], db = "COX1")
    testseqsallbold <- c(testseqsallbold, boldoutput)
}

#### to remove any null elements
#### WATCH IF list size gets smaller 
testseqsallbold <- testseqsallbold[!sapply(testseqsallbold, is.null)] 

#### add parent taxa to output, wide format (another call to BOLD, but faster)
testseqsallbold_parents <- bold_identify_parents(testseqsallbold, wide = TRUE)

#### convert list to dataframe
# testseqsallbold_parents.df <- do.call(rbind, testseqsallbold_parents) # i think this should replace ldply
testseqsallbold_parents.df <- ldply(testseqsallbold_parents, data.frame)

#### filter for similarity threshold (optional)
testseqsallbold_parents_96_to_100.df <- dplyr::filter(testseqsallbold_parents.df, similarity>=0.96)
testseqsallbold_parents_96_to_100.df <- dplyr::arrange(testseqsallbold_parents_96_to_100.df, .id, desc(similarity))

#### write dataframe to disk
write_tsv(testseqsallbold_parents_96_to_100.df, "CO1_1sequence_perBIN_040915_COIspiking_96_to_100.tsv")
write_tsv(testseqsallbold_parents.df, "CO1_1sequence_perBIN_040915_COIspiking.tsv")


