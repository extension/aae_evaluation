# this data file assumes that the csv downloads at http://data.extension.org/downloads
# have been loaded in to R as 'aae_evaluation', 'aae_questions', 'aae_demographics'
# 
# e.g.
aae_evaluation <- read.csv("~/dev/eXtension/aae_evaluation/aae_evaluation_2013-24.csv")
aae_questions <- read.csv("~/dev/eXtension/aae_evaluation/aae_questions_2013-24.csv")
aae_demographics <- read.csv("~/dev/eXtension/aae_evaluation/aae_demographics_2013-24.csv")

## set up some data that we'll need
# focus on public evaluations and demographics only
aae_questions_public = subset(aae_questions,aae_questions$submitter_is_extension == 'false')
aae_evaluation_public = subset(aae_evaluation,aae_evaluation$submitter_is_extension == 'false')
aae_demographics_public = subset(aae_demographics,aae_demographics$submitter_is_extension == 'false')

# create subsets of the evaluation and demographic eligible questions
aae_questions_public_evaluation_eligible = subset(aae_questions_public,aae_questions_public$evaluation_eligible == 'true')
aae_questions_public_demographic_eligible = subset(aae_questions_public,aae_questions_public$demographic_eligible == 'true')

# create a joined evaluation eligible dataframe with the evaluation results
aae_questions_public_plus_evaluation = join(aae_questions_public_evaluation_eligible,aae_evaluation_public, by=c('question_id'), type='left')

## response rates
# eligibility pool
eligible_evaluation_question_ids = aae_questions_public_evaluation_eligible['question_id']
eligible_demographic_submitter_ids = unique(aae_questions_public_demographic_eligible['submitter_id'])
# rates
evaluation_response_rate = nrow(aae_evaluation_public) / nrow(eligible_evaluation_question_ids)
demographic_response_rate = nrow(aae_demographics_public) / nrow(eligible_demographic_submitter_ids)

# histogram of 
# evaluation_histogram = hist(aae_evaluation$evaluation_count, breaks = 11, plot = FALSE)

# demographic makeup
demographic_summary = summary(aae_demographics_public)

# expectations of response time
expected_response_time_summary = summary(factor(aae_evaluation_public$evaluation_7_response,levels = c('Less than 1 day','1 to 2 days','2 to 3 days','3 to 4 days','4 to 5 days','no expectation')))

# actual response time - evaluation eligible questions only
aae_questions_public_plus_evaluation['factored_initial_response_time'] = cut(aae_questions_public_plus_evaluation$initial_response_time, breaks=c(0,24,48,72,96,120,Inf), labels = c('Less than 1 day','1 to 2 days','2 to 3 days','3 to 4 days','4 to 5 days','> 5 days'))
actual_response_time_summary = summary(subset(aae_questions_public_plus_evaluation,!is.na(evaluation_7_response))$factored_initial_response_time)

plot(subset(aae_questions_public_plus_evaluation,!is.na(evaluation_7_response))$factored_initial_response_time)
plot(factor(aae_evaluation_public$evaluation_7_response,levels = c('Less than 1 day','1 to 2 days','2 to 3 days','3 to 4 days','4 to 5 days','no expectation')))

# importance summary from 1 - "a personal curiosity that was not too important" to 5 "critically important to me"
importance_summary = summary(factor(aae_evaluation_public$evaluation_1_response))
# TODO heatmap?

# economic impact
boxplot(aae_evaluation_public$evaluation_5_value,outline=FALSE)


