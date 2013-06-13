

aae_questions_public$dayhour_et = format(as.POSIXct(aae_questions_public$submitted_at, tz="UTC"),'%H',tz='America/New_York')
aae_questions_public$weekday_et = format(as.POSIXct(aae_questions_public$submitted_at, tz="UTC"),'%A',tz='America/New_York')

# answered
a_q_a_p = subset(aae_questions_public, aae_questions_public$initial_response_at != '')
a_q_a_p$dayhour_answered_et = format(as.POSIXct(a_q_a_p$initial_response_at, tz="UTC"),'%H',tz='America/New_York')
a_q_a_p$weekday_answered_et = format(as.POSIXct(a_q_a_p$initial_response_at, tz="UTC"),'%A',tz='America/New_York')

# 
ggplot(aae_questions_public, aes(factor(aae_questions_public$dayhour_et))) + geom_bar() + facet_grid("weekday_et ~ .")
ggplot(a_q_a_p, aes(factor(a_q_a_p$dayhour_answered_et))) + geom_bar() + facet_grid("weekday_answered_et ~ .")