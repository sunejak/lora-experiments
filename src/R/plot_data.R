#
# file for plotting data with R
#
# do some commandline magic
#
myArgs <- strsplit(commandArgs(), " ");
myLenght <- length(myArgs) + 1;
xCnt <- 6;
Txt <- "";
while ( xCnt < myLenght ) {
	Txt <- paste(Txt, myArgs[[xCnt]]);
	xCnt <- xCnt + 1;
}
#
# read the file
#
indata <- scan(file=myArgs[[4]], what=list("","","","","","","","","","","",""), flush=TRUE)
#
# pick out the fields
#
timestamp <- as.POSIXct(as.double(indata[[1]]), origin = "1970-01-01", tz = "UTC-1")
#
temperature <- as.numeric(indata[[2]])
#
humidity <- as.numeric(indata[[3]])
#
co2 <- as.numeric(indata[[4]])
#
tvos <- as.numeric(indata[[5]])
#
stat <- as.numeric(indata[[6]])
#
# remove entries with status != 0
#
timestamp <- timestamp[which(stat == 0)]
temperature <- temperature[which(stat == 0)]
humidity <- humidity[which(stat == 0)]
co2 <- co2[which(stat == 0)]
tvos <- tvos[which(stat == 0)]

# Open a file for the graph, use PNG format instead of JPEG, gets a much better result
png("temperature_humidity.png", width=1268, height=951);
plot.new();
# create extra margin room on the right for an axis
maxval <- 50.0;
par(mar=c(6, 6, 6, 6) + 0.1)
plot (timestamp, temperature, xaxt="n",yaxt="n", type="l", col="green", ylab="", xlab="", ylim=c(0,maxval[1]), las=1);
par(new=TRUE);
plot (timestamp, humidity, xaxt="n",yaxt="n", type="l", col="black", ylab="", xlab="", ylim=c(0,maxval[1]), las=1);
axis(2, ylim=c(0,maxval[1]), col="black",las=1);
par(new=TRUE);
maxval <- 2000.0;
plot(timestamp, co2, yaxt="n", type="l", lty=2, col="cyan", ylab="", xlab="", pch=".", ylim=c(0,maxval[1]), las=1)
par(new=TRUE)
plot(timestamp, tvos, yaxt="n", type="l", col="red", ylab="", xlab="", ylim=c(0,maxval[1]), las=1)
axis(4, ylim=c(0,maxval[1]), col="black", las=1);
axis.Date(1, at = timestamp, col.axis="red", las=1)
mtext(side=1,line=2.5,"Day");
mtext(side=2,line=2.5,"Temperature Humidity");
mtext(side=3,line=2.5, Txt);
mtext(side=4,line=2.5, "CO2 TVOS");
## Add Legend
legend("topright",legend=c("Temperature", "Humidity", "CO2", "TVOS"),col=c("green", "black", "cyan", "red"), lwd=c(2.5,2.5));
dev.off();

