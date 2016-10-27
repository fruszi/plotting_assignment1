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
# ....plot #4 - plot facet
par(mfrow = c(2, 2))

# first
with(data, plot(timestamp,Global_active_power, type="l", xlab = "", 
                ylab = "Global Active Power (kw)"))
# second
with(data, plot(timestamp,Voltage, type="l", xlab = "datetime", 
                ylab = "Voltage"))
# third
with(data, plot(timestamp,Sub_metering_1, type="n", xlab = "", 
                ylab = "Energy Sub Metering"))
with(data, points(timestamp,Sub_metering_1, col="black", type="l"))
with(data, points(timestamp,Sub_metering_2, col="red", type="l"))
with(data, points(timestamp,Sub_metering_3, col="blue", type="l"))
legend("topright", lty=1, col = c("black", "red", "blue"), 
       legend = c("Sub_Metering_1", "Sub_Metering_2", "Sub_Metering_3"))
# fourth
with(data, plot(timestamp,Global_reactive_power, type="l", xlab = "datetime", 
                ylab = "Global_reactive_power"))

# saving
dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()