library(dplyr)
library(tidyr)
library(readr)


# National Education Longitudinal Study: Base Year Through Fourth Follow-Up, 1988-2000 
# https://www.icpsr.umich.edu/web/ICPSR/studies/3955

##########################################################################
# set up data
#
# NELS data is stored in fixed width format
#   no comma separators so we need setup file to tell us which characters
#      correspond to which columns
#   There are 15 side-by-side "pages" in this fixed width format
#      we will read in each page and the rbind pages together
##########################################################################
a <- scan(file="data/NELS/DS0001/03955-0001-Setup.sas", what="", sep="\n")
iStart <- 2+grep("INFILE 'file-specification' LRECL=1021 n=15 missover pad;",a)
iEnd   <- grep("F4ENRL00 38-39;",a)
a <- paste(a[iStart:iEnd], collapse=" ") |>
     gsub("^ *|; *$", "", x=_) |>        # remove leading/trailing spaces
     gsub("\\.[0-9]* |\\$", "", x=_) |>  # remove format characters
     gsub("  *", " ", x=_) |>            # remove extra spaces
     strsplit(" / ") |>                  
     unlist()

strsplit(a[15]," ")[[1]] |> 
  matrix(ncol=2, byrow=TRUE) |>
  data.frame() |>
  rename(var="X1",cols="X2")

a <- lapply(a, function(x)
  {
    strsplit(x," ")[[1]] |> 
      matrix(ncol=2, byrow=TRUE) |>
      data.frame() |>
      rename(var="X1",cols="X2")
  })

strsplit(a[[15]]$cols, "-") |>
  do.call(rbind, args=_)

a <- lapply(a, function(x)
  {
    b <- strsplit(x$cols, "-") |>
         do.call(rbind, args=_)
    x$start <- as.numeric(b[,1])
    x$end   <- as.numeric(b[,2])
    return(x)
})

# read all rows of data
nels88txt <- scan("data/NELS/DS0001/03955-0001-Data.txt", what="", sep="\n")
nels <- vector("list", 15)

# loop through the 15 pages of FWF data
for(i in 1:15)
{
  j <- seq(i, length(nels88txt), by=15)
  writeLines(nels88txt[j], 
             con=paste0("data/NELS/",i,".txt"))
  
  nels[[i]] <- read_fwf(paste0("data/NELS/",i,".txt"),
                        fwf_positions(a[[i]]$start,
                                      a[[i]]$end,
                                      a[[i]]$var),
                        col_type=paste0(rep("c", nrow(a[[i]])), collapse=""))
}

# all have same number of rows?
sapply(nels, nrow)

# attach them all side-by-side
nels <- do.call(cbind, nels)

##########################################################################
# Some of the variables we will explore
##########################################################################
# BYS - base year (8th grade) student 
# BYP - base year (8th grade) parent

# F4UNI2D Ever dropped-out by 12th grade = 3
# F4UNI2E Third followup... should have graduated, dropout=4
# F4HHDG='Highest PSE degree attained as of 2000' 
#     1='Some PSE, no degree attained' 
#     2='Certificate/license'                             
#     3='Associate^s degree'                              
#     4='Bachelor^s degree'                               
#     5='Master^s degree/equivalent'                      
#     6='Ph.D or a professional degree'                   
#    -3='{Legitimate skip}'                              
#    -9='{Missing}';  
# F4QWT    Weight

# G8CTRL  - school type
# G8URBAN - Urbanicity
# G8REGON - Region of country
# G8MINOR - Pct minority in 8th grade school
# G8LUNCH - Pct free lunch in 8th grade school
# SEX  - Male=1, Female=2
# RACE    - Race

# BYSES    - SES
# BYPARED  - Parents highest educational level
# BYFAMSIZ - Family size
# BYFCOMP  - Family structure
# BYPARMAR - Parents' marital status
# BYFAMINC - Family income
# BYSHMLANG    - Language spoken at home

# BYS14 - HS sector student plans to attend
# BYS36A, BYS36B, BYS36C - Discuss things with parents
# BYS38A, BYS38B, BYS38C, BYS38D - Parents involvement at home
# BYS41 - Time spent after school alone
# BYS42A - Time spent watching TV dummy variable
# BYS43 - Cigarettes smoked each day
# BYS45 - Educational aspirations
# BYS48A/B=7 - Kid does not know parents educational aspiration for child
# BYS48A, BYS48B - Kid's perceived parental educational expectations for child
# BYS49 - HS Program respondents plans to enroll in
# BYS50A, BYS50B - Talk to parents about HS program
# BYS55A - Kid is a discipline problem at school
# BYS56A - Student is seen as popular
# BYS56B - Student is seen as athletic
# BYS56C - Student is seen as good student
# BYS56D - Student is seen as important
# BYS56E - Student is seen as trouble maker
# BYS57C - Student was threatened at school
# BYS58A-K - 8th grade school has problems
# BYS59A,BYS59B,BYS59D,BYS59F,BYS59G,BYS59H,BYS59J - Student likes school
# BYS59L - Kids at school are disruptive
# BYS59C - Rules at school are strict
# BYS69A - Student likes math
# BYS70A - Student likes English
# BYS71A - Student likes social studies
# BYS72A - Student likes science
# BYS73 - Student is bored in school

# BYS74A - Student held back in kindergarten
# BYS74B - Student held back in 1st grade
# BYS74C - Student held back in 2nd grade
# BYS74D - Student held back in 3rd grade  
# BYS74E - Student held back in 4th grade
# BYS74F - Student held back in 6th grade
# BYS74G - Student held back in 6th grade
# BYS74H - Student held back in 7th grade
# BYS74I - Student held back in 8th grade

# BYS75 - Days absent past 4 weeks
# BYS76 - Frequency of classes cut
# BYS77 - Times late to school past 4 weeks
# BYS78A, BYS78B, BYS78C - Student comes to class unprepared
# BYLOCUS1 - Locus of control measure - Standardized measure
# BYCNCPT1 - Self-esteem measure - Standardized measure
# BYS79A, BYS79B, BYS79C, BYS79D, BYS79E - Hours of homework each week
# BYGRADS - Grade composite
# BYP6 - Older sibling dropped-out dummy (not 0 -> drop out)
# BYP40 - Number of times respondent changed schools
# BYP49A - Child in bilingual program dummy
# BYP49B - Child in ESL program dummy
# BYP49D - Child in special ed program dummy
# BYP50 - Child has behavior problem at school dummy
# BYP51 - Child in gifted/talented program dummy
# BYP53 - Child in algebra
# BYP55 - Child in foreign language dummy
# BYP59A-D - Parent involvement in school
# BYP62 - Parent knows child's friends
# BYP62B1 - Parent knows child's friends' parents
# BYP62A1 - Friends attend same school as respondent
# BYP63A-I - Extra-curricular composite
# BYP64A-D, BYP65A-C - Family rules composite
# BYP66 - Parent discusses things with respondent
# BYP69 - Parent helps respondent with homework
# BYP70 - Computer in home for school dummy
# BYP72A-B - Parent home when child returns from school
# BYP75 - Parent satisfied with child's schooling
# BYP76 - Parents educational aspirations for child
# BYP84 - Parents have saved for child's education
# BYP85C - Parents not willing to go into debt for education

nels0 <- nels |>
  filter(F4UNI2E!=6 &      # dropout status unknown
         RACE != 9) |>     # not in wave (RACE arbitrary)
  mutate(F4QWT = as.numeric(F4QWT),
         F4QWT = F4QWT/max(F4QWT),
         wave4dropout=as.numeric(F4UNI2E==4),
         typeSchool=factor(G8CTRL,c(1,2,3,4),
                           c("public","Catholic","private, religious",
                             "private, non-religious")),
         urbanicity=factor(G8URBAN,c(1,2,3),
                           c("urban","suburban","rural")),
         region=factor(G8REGON,c(1,2,3,4),
                       c("northeast","north central","south","west")),
         pctMinor=ordered(G8MINOR, 0:7,
                          c("none","1-5","6-10","11-20","21-30","31-50","51-75",
                            "76-100")),
         pctFreeLunch=ordered(G8LUNCH, 0:7,
                              c("none","1-5","6-10","11-20","21-30","31-50","51-75",
                                "76-100")),
         female=case_match(SEX,
                           "1"~"male",
                           "2"~"female",
                           .default=NA) |> factor(),
         race=case_match(RACE,
                         "1"~"Asian/PI",
                         "2"~"Hispanic",
                         "3"~"black",
                         "4"~"white",
                         "5"~"AI/AN",
                         .default=NA) |> factor(),
         ses=as.numeric(BYSES),
         ses=ifelse(ses==99999, NA, ses/1000),
         parentEd=ordered(BYPARED, 1:6,
                          labels=c("no HS","HS",">HS, <College","College grad",
                                   "MA/MS","PhD/MD/JD")),
         famSize=case_match(BYFAMSIZ,
                            "98"~NA,
                            "99"~NA,
                            "10"~"10+",
                            .default=BYFAMSIZ) |> 
           ordered(levels = c("2","3","4","5","6","7","8","9","10+")),
         famStruct=case_match(BYFCOMP,
                              "1"~"Mom & Dad",
                              "2"~"Mom & Male Guard",
                              "3"~"Dad & Fem Guard",
                              "4"~"Mom",
                              "5"~"Dad",
                              "6"~"Other",
                              .default=NA) |> factor(),
         parMarital=case_match(BYPARMAR,
                               "1"~"Divorced",
                               "2"~"Widowed",
                               "3"~"Separated",
                               "4"~"Never married",
                               "5"~"Married-like",
                               "6"~"Married",
                               .default=NA) |> factor(),
         famIncome=ordered(BYFAMINC, 1:15,
                           labels=c("None","<$1k","$1k-$3k","$3k-$5k",
                                    "$5k-$7.5k","$7.5k-$10k","$10k-$15k",
                                    "$15k-$20k","$20k-$25k","$25k-$35k",
                                    "$35k-$50k","$50k-$75k","$75k-$100k",
                                    "$100k-$200k","$200k+")),
         langHome=ordered(BYHMLANG,
                          levels=1:4,
                          labels=c("Non-English","Non-English dominant",
                                   "English dominant","English only"))) |>
  select(F4QWT,wave4dropout,typeSchool,urbanicity,region,pctMinor,
         pctFreeLunch,
         female,race,
         ses,parentEd,famSize,famStruct,parMarital,famIncome,langHome)

save(nels, nels0, file="nels.RData", compress=TRUE)
