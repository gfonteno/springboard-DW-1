library(dplyr)
library(tidyr)

# 0: Load the data
dat = read.csv("refine.csv", header = TRUE)


# 1: Clean up brand names

dat <- dat %>% mutate(company = tolower(company))

dat$company <- gsub("^[p|f].*", "philips", dat$company)
dat$company <- gsub("^a.*", "akzo", dat$company)
dat$company <- gsub("^v.*", "van houten", dat$company)
dat$company <- gsub("^un.*", "unilever", dat$company)

# 2: Separate product code and number
dat <- dat %>% separate(Product.code...number, into = c("product", "code"), sep = "-")

# 3: Add product categories
dat <- dat %>% mutate(product_category = 
                    ifelse(product == 'p', 'Smartphone', 
                    ifelse(product == 'v', 'TV',
                    ifelse(product == 'x', 'Laptop',
                    ifelse(product == 'q', 'Tablet',
                    product)))))

# 4: Add full address for geocoding
dat <- dat %>% unite(geo, address:country, sep = ",", remove = FALSE)

# 5: Create dummy variables for company and product category
# - company
dat <- dat %>% 
  mutate(company_philips = ifelse(company == 'phillips', TRUE, FALSE)) %>%
  mutate(company_akzo = ifelse(company == 'akzo', TRUE, FALSE)) %>%
  mutate(company_van_houten = ifelse(company == 'van houten', TRUE, FALSE)) %>%
  mutate(company_unilever = ifelse(company == 'unilever', TRUE, FALSE))

# - products
dat <- dat %>% 
  mutate(product_smartphone = ifelse(product_category == 'Smartphone', TRUE, FALSE)) %>%
  mutate(product_tv = ifelse(product_category == 'TV', TRUE, FALSE)) %>%
  mutate(product_laptop = ifelse(product_category == 'Laptop', TRUE, FALSE)) %>%
  mutate(product_tablet = ifelse(product_category == 'Tablet', TRUE, FALSE))

# 6: Submit the project on Github
write.csv(dat, file = "refine_clean.csv")

print(dat)