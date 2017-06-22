calculate = function(arglist) 
{
  mean_percent_error(arglist)
  common_object(arglist)
}

mean_percent_error = function(arglist) {
  mean_list = subset(arglist, stimulus %in% c("resized_box1", "resized_box2", "resized_box3", "resized_box4", "resized_box5"))
  current = 0
  for(i in 1:nrow(mean_list)) {
    row = mean_list[i,]
    reported_width = as.numeric(as.character(row$reported_width))
    switch(as.character(row$stimulus),
           'resized_box1' = {
             box1 = abs(2.5 - reported_width) / 2.5
             current = current + box1
           },
           'resized_box2' = {
             box2 = abs(2.75 - reported_width) / 2.75
             current = current + box2
           },
           'resized_box3' = {
             box3 = abs(3 - reported_width) / 3
             current = current + box3
           },
           'resized_box4' = {
             box4 = abs(3.25 - reported_width) / 3.25
             current = current + box4
           },
           'resized_box5' = {
             box5 = abs(3.5 - reported_width) / 3.5
             current = current + box5
           })
  }
  mean_error = current * 100 / nrow(mean_list)
  cat('The mean percent error is', mean_error, "%", "\n")
}

common_object = function(arglist) {
  list = subset(arglist, responses!='NULL')
  common_list = list[,(c(1,8))]
  credit = 0
  license = 0
  index = 0
  quarter = 0
  dime = 0
  nickel = 0
  penny = 0
  paper = 0
  disc = 0
  check = 0
  cards = 0
  AAbattery = 0
  AAAbattery = 0
  Vbattery = 0
  for(i in 1:nrow(common_list)) {
    row = common_list[i,]
    responses = as.character(row$responses)
    responses = gsub("Q0:", "", responses, fixed="TRUE")
    responses = gsub("\\{|\\}|\\[|\\]", "", responses)
    responses = unlist(strsplit(responses, ","))
    for(j in 1:length(responses)) {
      element = responses[j]
      switch(element, 
             "Credit/Debit card" = {credit = credit + 1},
             "Driver's License / Non-driver identification card" = {license = license + 1},
             "3x5\\ index card" = {index = index + 1},
             "U.S. Quarter" = {quarter = quarter + 1},
             "U.S. Dime" = {dime = dime + 1},
             "U.S. Nickel" = {nickel = nickel + 1},
             "U.S. Penny" = {penny = penny + 1},
             "A sheet of standard size paper (8.5\\ x 11\\)" = {paper = paper + 1},
             "CD/DVD" = {disc = disc + 1},
             "A check (for a bank account)" = {check = check + 1},
             "A playing card from a standard deck of cards" = {cards = cards + 1},
             "AA battery" = {AAbattery = AAbattery + 1},
             "AAA battery" = {AAAbattery = AAAbattery + 1},
             "9V battery" = {Vbattery = Vbattery + 1})
    }
  }
  number_responses = 100 / nrow(common_list)
  response_totals = c(credit, license, index, quarter, dime, nickel, penny, paper, disc, check, cards, AAbattery, AAAbattery, Vbattery,
                      credit * number_responses, license * number_responses, index * number_responses, quarter * number_responses, dime * number_responses, 
                      nickel * number_responses, penny * number_responses, paper * number_responses, disc * number_responses, check * number_responses, 
                      cards * number_responses, AAbattery * number_responses, AAAbattery * number_responses, Vbattery * number_responses)
  response_table = matrix(response_totals, ncol = 2)
  colnames(response_table) = c("Number of Responses", "% out of total responses")
  rownames(response_table) = c("Credit/Debit card", "Driver's License / Non-driver identification card", "3x5\\ index card", "U.S. Quarter", "U.S. Dime", "U.S. Nickel", "U.S. Penny", "A sheet of standard size paper (8.5\\ x 11\\)",  "CD/DVD", "A check (for a bank account)", "A playing card from a standard deck of cards", "AA battery", "AAA battery", "9V battery")
  response_table = as.table(response_table)
  print(response_table)
}
    
    
