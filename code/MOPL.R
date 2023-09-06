# -*- coding: utf-8 -*-
# @Author  : Xiang Yu
# @Time    : 2023/9/6 15:18
# @File    : MOPL.R

library(zipfextR)
library(ggplot2)

# set the work path
current_wd <- getwd()

if (!grepl("/MOPL$", current_wd)) {
  moplfit_path <- regmatches(current_wd, regexpr(".*(?=/MOPL)", current_wd, perl=TRUE))
  if (length(moplfit_path) > 0) {
    new_wd <- paste0(moplfit_path, "/MOPL")
    if (dir.exists(new_wd)) {
      setwd(new_wd)
    } else {
      message("the path doesn't exist")
    }
  } else {
    message("can't locate 'MOPL'")
  }
}
print(getwd())

# different types
path = "./data/different_types"
path_to_write = "../../result/MOPL_types.csv"
path_to_save_data = '../../result/different_types/'

# # different languages
# path = "./data/different_languages"
# path_to_write = "../../result/MOPL_languages.csv"
# path_to_save_data = '../../result/different_languages/'



setwd(path)
files = list.files(path = getwd(), full.names = TRUE, recursive = FALSE)
count = 0

name_list = c()
alphaHat_list = c()
betaHat_list = c()
alphaSD_list = c()
betaSD_list = c()
alphaCI1_list = c()
alphaCI2_list = c()
betaCI1_list = c()
betaCI2_list = c()

for (file in files){
  file_name_temp = strsplit(file, '/')[[1]]
  file_name = file_name_temp[length(file_name_temp)]
  print(file_name)

  raw_data <- read.table(file, header = TRUE);

  data_1 <- as.numeric(as.character(raw_data[,1]))  # Length list
  data_2 <- as.numeric(as.character(raw_data[,3]))  # Count list

  # truncate
  i = 1
  for (i in 1 : length(data_2)){
    # print(i)
    # print(data_2[i])
    if(data_2[i] == 1){
      break
    }
  }
  data_1 = data_1[0:i];
  data_2 = data_2[0:i];

  data <- as.data.frame(cbind(data_1, data_2))

  initValues <- getInitialValues(data, model='moezipf')
  obj <- moezipfFit(data, init_alpha = initValues$init_alpha, init_beta = initValues$init_beta)
  y <- fitted(obj)

  fit_data <- data.frame(Length = data_1[0:i], Frequency = data_2[0:i], Predict = y)
  # raw_data <- data.frame(Length = data_1, Frequency = data_2)

  # write alpha, beta
  name_list = append(name_list, file_name)
  alphaHat_list = append(alphaHat_list, obj$alphaHat)
  betaHat_list = append(betaHat_list, obj$betaHat)
  alphaSD_list = append(alphaSD_list, obj$alphaSD)
  betaSD_list = append(betaSD_list, obj$betaSD)
  alphaCI1_list = append(alphaCI1_list, obj$alphaCI[1])
  alphaCI2_list = append(alphaCI2_list, obj$alphaCI[2])
  betaCI1_list = append(betaCI1_list, obj$betaCI[1])
  betaCI2_list = append(betaCI2_list, obj$betaCI[2])
  name = paste0(path_to_save_data, strsplit(file_name, '.txt'), '_truncated_moeFit.txt')
  write.table(fit_data, name , sep = "\t", row.names = F)

  # # draw pics
  # png(file = paste0(file_name, '.png'))
  # plot(data_1, y, lwd = 1, type = 'l', col = 'blue', log = 'xy', main = file_name, xlab = 'Length of words', ylab = 'Frequency')
  # points(data_1, data_2, pch = 4, cex = 1.5, lwd = 1.5)
  # legend("topright", legend= c(file_name,"MOEZipf Distribution"),
  #         col=c("black","blue"),
  #        pch = 15:18,)
  # dev.off()
}

# write the data
data_to_write = data.frame(name = name_list, alphaHat = alphaHat_list, betaHat = betaHat_list, alphaSD = alphaSD_list,
                           betaSD = betaSD_list, alphaCI1 = alphaCI1_list, alphaCI2 = alphaCI2_list, betaCI1 = betaCI1_list, betaCI2 = betaCI2_list)
write.csv(data_to_write, path_to_write)
