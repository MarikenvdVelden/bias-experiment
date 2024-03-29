d_us <- d_us %>% 
  filter(consent == 1,
         screener == 2) %>% 
  unite("PT1b", matches("PT1b"),na.rm = TRUE) %>% 
  select(id = PID,
         gender = D1, #gender (3 categories)
         age = D2,  #age - continues
         state = D3,#state, 
         income = D5, #income: no income (1), <500 (2), 501-1000 (3), 1001-1500 (4); 1501-2000 (5); 2001-2500 (6); 2501-3000 (7); 3001-3500 (8); 3501-4000 (9); 4001-4500 (10); 4501-7500 (11); >7501 (12)
         job = D6, #job
         education = D7, #education
         PT1 = PT1a, #pid
         PT1b, #pid strength
         PT2, #issue position: migration: 1 = neg, 5 = pos
         PT3, #issue position: climate: 1 = neg, 5 = pos
         PT4, #issue position: tax: 1 = neg, 5 = pos
         PT5, #issue position: foreign policy: 1 = neg, 5 = pos
         PT6, #libcon -self: 0 = lib, 14 = cons
         PT7_1, #senator years (polknow)
         PT7_2, #majority in house (polknow)
         PT7_3, #majority in senate (polknow)
         PT7_4_1, PT7_4_2,  PT7_4_3, PT7_4_4, #bullshit receptivity
         actor1:actor4,
         issue1:issue4,
         specified1:specified4,
         S1:S4,
         Attention1_1:Attention1_9) %>% 
  mutate_at(vars(Attention1_1:Attention1_9), 
            funs(recode(., .missing = 0, .default = 1))) %>% 
  rowwise() %>%
  mutate(tmp = sum(c_across(starts_with("Attention1_")), na.rm = T)) %>% 
  ungroup() %>% 
  select(id,
         D1 = age,
         D2 = gender,
         D3 = education,
         D4 = state,
         D5 = income,
         D6 = job,
         PT1:Attention1_9, tmp) %>% 
  mutate(D2 = recode(D2,
                     `1` = "Male",
                     `2` = "Female",
                     .missing = "NA", .default = "NA"),
         D3 = recode(D3,
                     `1` = "Low-level of education",
                     `9` = "Low-level of education",
                     `10` = "Low-level of education",
                     `11` = "Low-level of education",
                     `12` = "Low-level of education",
                     `13` = "Low-level of education",
                     `14` = "Low-level of education",
                     `15` = "Low-level of education",
                     `16` = "Mid-level of education",
                     `17` = "Mid-level of education",
                     `18` = "Mid-level of education",
                     `19` = "Mid-level of education",
                     `20` = "High-level of education",
                     `21` = "High-level of education",
                     `22` = "High-level of education",
                     `23` = "High-level of education",
                     .missing = "NA", .default = "NA"),
         D4 = recode(D4,
                     `1` = "Southeast",
                     `2` = "West",
                     `3` = "Southwest",
                     `4` = "Southeast",
                     `5` = "West",
                     `6` = "West",
                     `7` = "Northeast",
                     `8` = "Northeast",
                     `9` = "Northeast",
                     `10` = "Southeast",
                     `11` = "Southeast",
                     `12` = "West",
                     `13` = "West",
                     `14` = "Midwest",
                     `15` = "Midwest",
                     `16` = "Midwest",
                     `17` = "Midwest",
                     `18` = "Southeast",
                     `19` = "Southeast",
                     `20` = "Northeast",
                     `21` = "Northeast",
                     `22` = "Northeast",
                     `23` = "Midwest",
                     `24` = "Midwest",
                     `25` = "Southeast",
                     `26` = "Midwest",
                     `27` = "West",
                     `28` = "Midwest",
                     `29` = "West",
                     `30` = "Northeast",
                     `31` = "Northeast",
                     `32` = "Southwest",
                     `33` = "Northeast",
                     `34` = "Southeast",
                     `35` = "Midwest",
                     `36` = "Midwest",
                     `37` = "Southwest",
                     `38` = "West",
                     `39` = "Northeast",
                     `40` = "Southeast",
                     `41` = "Northeast",
                     `42` = "Southeast",
                     `43` = "Midwest",
                     `44` = "Southeast",
                     `45` = "Southwest",
                     `46` = "West",
                     `47` = "Northeast",
                     `48` = "Southwest",
                     `49` = "West",
                     `50` = "Southwest",
                     `51` = "Midwest",
                     `52` = "West",
                     .missing = "NA"),
         D5 = na_if(D5, 15),
         D5 = na_if(D5, 16),
         D6 = recode(D6,
                     `1` = "Working now",                            
                     `11` = "Temporarily laid off",                              
                     `12` = "Unemployed",           
                     `13` = "Retired",                        
                     `14` = "Permanently disable",
                     `15` = "Homemaker",                    
                     `17` = "Student",
                     .missing = "NA", .default = "NA"),
         PT1 = recode(PT1,
                      `1` = "Democrat",
                      `2` = "Republican",                        
                      `3` = "Independent",
                      `4` = "Something else",    
                      .missing = "NA", .default = "NA"),
         PT1b = recode(PT1b,
                       `1` = "Strong",
                       `2` = "Not very strong",     
                       .missing = "NA", .default = "NA"),
         PT6 = na_if(PT6, 15),
         PT6 = recode(PT6,
                        `0` = 0,
                        `1`= 1,
                        `2` = 2,
                        `11` = 3,
                        `12` = 4,
                        `13` = 5,
                        `14` = 6),
         PT7_1 = ifelse(PT7_1==6, 1,0),
         PT7_2 = ifelse(PT7_2 == 1, 1, 0),
         PT7_3 = ifelse(PT7_3 == 2, 1, 0),
         PT7 = (PT7_1 + PT7_2 + PT7_3),
         PT7b = ((PT7_4_1 + PT7_4_2 + PT7_4_3 + PT7_4_4)/4),
         attention = ifelse(Attention1_3==1 & Attention1_6==1 & tmp ==2, 1, 0),
         issue1 = "Immigration",
         issue2 = "Environment",
         issue3 = "Tax",
         issue4 = "Foreign Policy",
         specified1 = recode(specified1,
                             `say immigration should be made more difficult.` = "Specified",
                             `say many immigrants are crossing our borders.` = "Underspecified"),
         specified2 = recode(specified2,
                             `say we need to put a tax on carbon emissions` = "Specified",
                             `say carbon emissions policy should be implemented differently.` = "Underspecified"),
         specified3 = recode(specified3,
                             `say the tax system should be implemented differently.` = "Underspecified",
                             `say we should implement a wealth tax for the richest Americans.` = "Specified"),
         specified4 = recode(specified4,
                             `say there should be a different military presence in the Pacific Ocean.` = "Underspecified",
                             `say the U.S. needs to consider military build-up in the Pacific Ocean` = "Specified"),
         stance1_nlp = ifelse(specified1 == "Specified" & S1 == 2, 
                              "correct", "not correct"),
         stance1_nlp = ifelse(specified1 == "Underspecified" & S1 == 3, 
                              "correct", stance1_nlp),
         stance1_ss = ifelse(specified1 == "Specified" & S1 == 2, 
                             "correct", "not correct"),
         stance1_ss = ifelse(specified1 == "Underspecified" & S1 == 3, 
                             "correct", stance1_ss),
         stance2_nlp = ifelse(specified2 == "Specified" & S2 == 1, 
                              "correct", "not correct"),
         stance2_nlp = ifelse(specified2 == "Underspecified" & S2 == 3, 
                              "correct", stance2_nlp),
         stance2_ss = ifelse(specified2 == "Specified" & S2 == 1, 
                             "correct", "not correct"),
         stance2_ss = ifelse(specified2 == "Underspecified" & S2 == 2, 
                             "correct", stance2_ss),
         stance2_ss= ifelse(specified2 == "Underspecified" & S2 == 3,
                            "correct", stance2_ss),
         stance3_nlp = ifelse(specified3 == "Specified" & S3 == 1,
                              "correct", "not correct"),
         stance3_nlp = ifelse(specified3 == "Underspecified" & S3 == 3, 
                              "correct", stance3_nlp),
         stance3_ss = ifelse(specified3 == "Specified" & S3 == 1,
                             "correct", "not correct"),
         stance3_ss = ifelse(specified3 == "Underspecified" & S3 == 2, 
                             "correct", stance3_ss),
         stance3_ss = ifelse(specified3 == "Underspecified" & S3 == 3, 
                             "correct", stance3_ss),
         stance4_nlp = ifelse(specified4 == "Specified" & S4 == 2, 
                              "correct", "not correct"),
         stance4_nlp = ifelse(specified4 == "Underspecified" & S4 == 3,
                              "correct", stance4_nlp),
         stance4_ss = ifelse(specified4 == "Specified" & S4 == 2, 
                             "correct", "not correct"),
         stance4_ss = ifelse(specified4 == "Underspecified" & S4 == 2,
                             "correct", stance4_ss),
         stance4_ss = ifelse(specified4 == "Underspecified" & S4 == 3,
                             "correct", stance4_ss),
         interpret1 = ifelse(specified1 == "Underspecified" & S1 == 1, 
                             "Stance", "No Stance"),
         interpret1 = ifelse(specified1 == "Underspecified" & S1 == 2, 
                             "Stance", interpret1),
         interpret2 = ifelse(specified2 == "Underspecified" & S2 == 1, 
                             "Stance", "No Stance"),
         interpret2 = ifelse(specified2 == "Underspecified" & S2 == 2, 
                             "Stance", interpret2),
         interpret3 = ifelse(specified3 == "Underspecified" & S3 == 1, 
                             "Stance", "No Stance"),
         interpret3 = ifelse(specified3 == "Underspecified" & S3 == 2, 
                             "Stance", interpret3),
         interpret4 = ifelse(specified4 == "Underspecified" & S4 == 1, 
                             "Stance", "No Stance"),
         interpret4 = ifelse(specified4 == "Underspecified" & S4 == 2, 
                             "Stance", interpret4)) %>% 
  select(id, D1:D6, PT1:PT6, PT7, PT7b, attention,
         actor1:actor4,
         issue1:issue4,
         specified1:specified4, 
         stance1_nlp:stance4_nlp,
         stance1_ss:stance4_ss,
         interpret1:interpret4) %>% 
  mutate(round1 = paste(actor1, issue1, specified1, stance1_nlp, stance1_ss, interpret1, sep = "-"),
         round2 = paste(actor2, issue2, specified2, stance2_nlp, stance2_ss, interpret2, sep = "-"),
         round3 = paste(actor3, issue3, specified3, stance3_nlp, stance3_ss, interpret3, sep = "-"),
         round4 = paste(actor4, issue4, specified4, stance4_nlp, stance4_ss, interpret4, sep = "-")) %>% 
  pivot_longer(cols = round1:round4,
               values_to = "condition",
               names_to = "round") %>% 
  separate(condition, c("actor", "issue", "specification", "stance_nlp", "stance_ss", "interpretation"), "-") %>% 
  select(id, D1:PT7b, attention,
         round, actor, issue, specification, stance_nlp, stance_ss, interpretation) %>% 
  mutate(masking = ifelse(actor == "X", "Masked", "Party"),
         stance_nlp = ifelse(stance_nlp =="correct", 1 ,0),
         stance_ss = ifelse(stance_ss =="correct", 1 ,0),
         interpretation_nlp = ifelse(interpretation=="No Stance", 0 ,1),
         interpretation_ss = ifelse(interpretation=="No Stance" & issue =="Immigration" , 0 ,1),
         interpretation_ss = ifelse(interpretation=="Stance" & issue !="Immigration" , 0 ,interpretation_ss),
         distance = 0,
         distance = ifelse(round == "round1", abs(PT6-1.5), distance),
         distance = ifelse(round == "round2", abs(PT6-3), distance),
         distance = ifelse(round == "round3", abs(PT6-3.5), distance),
         distance = ifelse(round == "round4", abs(PT6-7), distance)) %>% 
  select(-round, -actor) %>% 
  filter(attention==1)

# Recode missing
d_us <- d_us %>% 
  mutate(D2 = replace_na(D2, "Male"),
         D3 = replace_na(D3, "High-levels of education"),
         missing_D5 = ifelse(is.na(D5),1,0),
         D5 = replace_na(D5, round(mean(D5, na.rm=T),0)),
         missing_D6 = ifelse(is.na(D6),1,0),
         PT6 = replace_na(PT6,round(mean(PT6, na.rm=T),0)),
         distance = replace_na(distance,round(mean(distance, na.rm=T),0)))

