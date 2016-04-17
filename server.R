library(shiny)
library(plyr)

shinyServer(function(input, output) {

	# You can access the value of the widget with input$select, e.g.
  	output$stratselect = renderPrint({ input$stratselect })
 
  	## get data
  	strategy_output = reactive({
  		if (is.null(input$stratselect))
  			return(NULL)                

  		inFile <- paste("./data/", input$stratselect, ".csv", sep = "")
  		data = read.csv(inFile, stringsAsFactors = FALSE)
    	data$Date = as.Date(data$Date, "%d-%b-%y")
    	data = data[order(data$Date, decreasing = TRUE),]

		dt = as.numeric(max(data$Date) - min(data$Date)) / 365
		annret = (data$Close[1] / data$Close[dim(data)[1]])^(1 / dt) - 1
		vol = sd(diff(log(data$Close))) * sqrt(252)
		sharpe = annret / vol

		annret = paste(round(annret*100,2),"%", sep = "")
		vol = paste(round(vol*100,2),"%", sep = "")
		sharpe = round(sharpe,2)

		currlevel = round(data$Close[1],2)
		YoY = paste(round((data$Close[1] / data$Close[252] - 1)*100,2),"%", sep = "")
		MoM = paste(round((data$Close[1] / data$Close[21] - 1)*100,2),"%", sep = "")
		WoW = paste(round((data$Close[1] / data$Close[5] - 1)*100,2),"%", sep = "")

		metrics = data.frame(AnnRetun = annret, Vol = vol, Sharpe = sharpe, cl = currlevel, yoy= YoY, mom = MoM, wow = WoW, row.names = "Metrics")
		names(metrics) = c("Ann. Return", "Volatility", "Sharpe", "Current Level", "YoY Return", "MoM Return", "WoW Return")
		metrics = t(metrics)
		list(undldata = data, metrics = metrics)
		})

  	output$contents = renderDataTable({
  		strategy_output()$undldata
  	})

	output$metrics = renderTable({
  		strategy_output()$metrics
  	})

  	output$plot = renderPlot({
  		if(!is.null(strategy_output))
  			plot(strategy_output()$undldata, type = "l")
  	})

  	 output$YoYplot = renderPlot({
  		if(!is.null(strategy_output)){
  			X = strategy_output()$undldata
  			X$year = format(X$Date, "%Y")
  			yoy = ddply(X, .(year), function(y){y$Close[1] / y$Close[dim(y)[1]] - 1})
  			barplot(yoy$V1 * 100, name = yoy$year)
  		}
  	})

  	output$downloadData = downloadHandler(
    	filename = function() {paste(input$stratselect, '.csv', sep='')},
    	content = function(file) {write.csv(strategy_output()$undldata, file)}
    )

})
