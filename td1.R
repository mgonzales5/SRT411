#Lesson 1 Manipulating Data with dplyr
?read.csv
mydf <- read.csv(path2csv, stringsAsFactors = FALSE)
dim(mydf)
head(mydf)
library(dplyr)
packageVersion("dplyr")
cran <- tbl_df(mydf)
rm("mydf")
cran
?select
select(cran,ip_id, package, country)
5:20
select(cran,r_arch:country)
select(cran,country:r_arch)
cran
select(cran, -time)
select(cran, -(X:size))
filter(cran, package == "swirl")
filter(cran, r_version == "3.1.1", country == "US")
?Comparison
filter(cran, r_version <= "3.0.2", country == "IN")
filter(cran, country == "US" | country == "IN")
filter(cran, size > 100500, r_os == "linux-gnu")
is.na(c(3,5,NA,10))
!is.na(c(3,5,NA,10))
filter(cran, !is.na(r_version))
cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
arrange(cran2,package, ip_id)
arrange(cran2, country, desc(r_version), ip_id)
cran3 <- select(cran, ip_id,package, size)
cran3
mutate(cran3, size_mb = size / 2^20)
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)
mutate(cran3, correct_size = size + 1000)
summarize(cran, avg_bytes = mean(size))

#Lesson 2 Grouping and Chaining with dplyr
library(dplyr)
cran <- tbl_df(mydf)
rm("mydf")
cran
?group_by
by_package <- group_by(cran, package)
by_package
summarize(by_package, mean(size))
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))
pack_sum
quantile(pack_sum$count, probs = 0.99)
top_counts <- filter(pack_sum, count > 679)
top_counts
View(top_counts)
top_counts_sorted <- arrange(top_counts, desc(count))
View(top_counts_sorted)
quantile(pack_sum$unique, probs = 0.99)
top_unique <- filter(pack_sum, unique > 465)
View(top_unique)
top_unique_sorted <-  arrange(top_unique, desc(unique))
View(top_unique_sorted)

#lesson 3 Using Tidyr
library(tidyr)
students
?gather
gather(students,sex,count,-grade)
res <- gather(students2, sex_class,count,-grade)
?separate
separate(data = res, col = sex_class, into = c("sex", "class"))
students2 %>%
  gather(sex_class ,count ,-grade ) %>%
  separate( sex_class, c("sex", "class")) %>%
  print
students3 %>%
  gather(class,grade, class1:class5 ,na.rm = TRUE) %>%
  print
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread( test, grade ) %>%
  print
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  mutate(class = extract_numeric(class)) %>%
  print
student_info <- students4 %>%
  select(id, name, sex) %>%
  unique %>%
  print
gradebook <- students4 %>%
  select(id,class,midterm,final) %>%
  print
passed <- passed %>% mutate(status = "passed")
failed <- failed %>% mutate( status = "failed")
sat %>%
  select(-contains("total")) %>%
  gather(key = part_sex, value = count, -score_range) %>%
  separate(part_sex, c("part","sex"))%>%
  print
sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part,sex) %>%
  mutate(total = sum(count),
         prop = count / total
  ) %>% print

#Lesson 4 Using Lubridate
Sys.getlocale("LC_TIME")
library(lubridate)
help(package=lubridate)
this_day <- today()
this_day
year(this_day)
wday(this_day)
wday(this_day, label = TRUE)
this_moment <- now()
this_moment
hour(this_moment)
my_date <- ymd("1989-05-17")
my_date
class(my_date)
ymd("1989 May 17")
mdy("March 12, 1975")
dmy(25081985)
ymd("192012")
ymd("1920-1-2")
dt1
ymd_hms(dt1)
hms("03:22:14")
this_moment <- update(this_moment, hours = 10, minutes = 16, seconds = 0)
this_moment
nyc <- now("America/New_York")
depart<- nyc +days(2)
depart
depart <- update(depart, hours = 17, minutes = 34)
depart
?with_tz
arrive <- with_tz(arrive, "Asia/Hong_Kong")
arrive
last_time <- mdy("June 17, 2008", tz = "Singapore")
last_time
?new_interval
how_long <- new_interval(last_time, arrive)
as.period(how_long)
stopwatch()
