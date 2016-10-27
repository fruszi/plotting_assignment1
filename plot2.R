# downloading file
if(!file.exists("exdata-data-household_power_consumption.zip")) {
    temp <- tempfile()
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
    file <- unzip(temp)
    unlink(temp)
}

# read data and subset
data <- read.table(file, header=T, sep=";")
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
data <- data[(data$Date=="2007-02-01") | (data$Date=="2007-02-02"),]

# transform relevant fields (from factors)
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))
data$Global_reactive_power <- as.numeric(as.character
                                         (data$Global_reactive_power))
data$Voltage <- as.numeric(as.character(data$Voltage))
data <- transform(data, timestamp=as.POSIXct(paste(Date, Time)), 
                  "%d/%m/%Y %H:%M:%S")
data$Sub_metering_1 <- as.numeric(as.character(data$Sub_metering_1))
data$Sub_metering_2 <- as.numeric(as.character(data$Sub_metering_2))
data$Sub_metering_3 <- as.numeric(as.character(data$Sub_metering_3))


# -----------------------------------------------------------------------------
#                  PLOT
# -----------------------------------------------------------------------------
# ....plot #2 - plot
with(data, plot(timestamp,Global_active_power, type="l", xlab = "", 
                ylab = "Global Active Power (kilowatts)"))
# saving
dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()