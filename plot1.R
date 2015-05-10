# plot1 makes a histogram of Global active power over two days: February 1st and 2nd, 2007
# This function uses the base plotting system to make a basic histogram

plot1 <- function() {
    
    # The name of the file that contains all the power consumption data.
    filename <- "household_power_consumption.txt"
    
    # The directory where the power consumption data file is located.
    filedir <- "/Users/nick/Documents/Data Science/JHU-data-sci/"
    
    # The library sqldf provides an easy way to perform SQL selects on R data frames.
    library(sqldf)
    
    # Since we only want two days worth of data, for 1/2/2007 and 2/2/2007
    # we write a SQL select to read only rows where Date is one of these two.
    
    sql_cmd <- "SELECT * FROM file WHERE Date IN ('1/2/2007','2/2/2007')"
    
    # using read.csv.sql allows us to use a SQL select for only the desired dates.
    # columns in the data file are separated by semicolons
    powerdata <- read.csv.sql(file = paste(filedir,filename,sep = ""), sql = sql_cmd, header = TRUE, sep = ";")
    
    # we need to coerce the variable Time to the Time class using strptime
    powerdata$Time <- strptime(paste(powerdata$Date, powerdata$Time, sep = "-"), format = "%d/%m/%Y-%H:%M:%S")
    
    # we need to coerce the variable Date to the Date class using as.Date
    powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y")
    
    # We will use a png file as the graphics device
    png(filename = "plot1.png",
        width = 480, height = 480, units = "px", pointsize = 12,
        bg = "white",  res = NA)
    
    # Make a histogram of Global Active Power
    hist(powerdata$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)",
         ylab = "Frequency", main = "Global Active Power")
    
    # Need to call dev.off() so that we can look at the png
    dev.off()

}
    