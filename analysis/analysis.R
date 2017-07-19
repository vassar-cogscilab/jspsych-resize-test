library(dplyr)
library(ggplot2)

# load data ####

all.data <- read.csv('data/experiment_data.csv', stringsAsFactors = F)

# exclude subjects ####

manual.exclude <- c('56ed166d0260df000d2f011d')

# reasons for exlcusion:
# subject 56ed166d0260df000d2f011d emailed to report a technical problem with the experiment

# check for self-reported lack of ruler

self.exclude <- (filtered.data %>% filter(phase == 'validation', button_pressed == 1))$prolific_id

all.exclude <- c(manual.exclude, self.exclude)

filtered.data <- all.data %>% filter(!prolific_id %in% all.exclude)

# measurement data ####

measure.data <- filtered.data %>% filter(phase %in% c('pre-calibration', 'post-calibration')) %>% select(subject_id, stimulus, reported_width, target_width, phase)
measure.data$reported_width <- as.numeric(measure.data$reported_width)
measure.data$target_width <- as.numeric(measure.data$target_width)
measure.data <- measure.data %>% mutate(measured_error = reported_width - target_width, abs_measured_error = abs(measured_error))

measure.summary <- measure.data %>% group_by(subject_id, phase) %>% summarise(error = mean(measured_error))
ggplot(measure.summary, aes(x=phase, y=error))+geom_boxplot()+geom_jitter()

# stan model ####

# model: data is error, estimate mean and sd of error normal distribution.
# sd and mean are hierarchically estimated at the subject -> group level.
# parameter that describes change in SD and change in mean from pre-to-post calibration.

