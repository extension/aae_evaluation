# load some needed libraries
library(ggplot2)
library(plyr)
library(mapproj)

# Load the question and evaluation data
aae_evaluation <- read.csv("~/dev/eXtension/aae_evaluation/aae_evaluation_2013-40.csv")
aae_questions <- read.csv("~/dev/eXtension/aae_evaluation/aae_questions_2013-40.csv")
question_readability <- read.csv("~/dev/eXtension/aae_evaluation/question_readability.csv")

# focus on the public only
aae_questions_public = subset(aae_questions,aae_questions$submitter_is_extension == 'false')
aae_evaluation_public = subset(aae_evaluation,aae_evaluation$submitter_is_extension == 'false')

# create a subset of the evaluation eligible questions
aae_questions_public_evaluation_eligible = subset(aae_questions_public,aae_questions_public$evaluation_eligible == 'true')

# create a joined evaluation eligible dataframe with the evaluation results
aae_questions_public_plus_evaluation = join(aae_questions_public_evaluation_eligible,aae_evaluation_public, by=c('question_id'), type='left')

# create a joined evaluation eligible dataframe with the readability results
aae_questions_public_evaluation_readability = join(aae_questions_public_plus_evaluation,question_readability, by=c('question_id'), type='left')

# histogram of kincaid values between 0 and 25
kincaid_subset = subset(aae_questions_public_evaluation_readability, (aae_questions_public_evaluation_readability$kincaid <= 25 & aae_questions_public_evaluation_readability$kincaid >= 0))
hist(kincaid_subset$kincaid, breaks=25, main = 'Flesch-Kincaid Grade Level of Ask an Expert Responses', xlab='Grade Level')
