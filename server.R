library(shiny)
library(ggplot2)


simulate = function(lambda, n, sims){
    sample = NULL
    for (i in 1 : sims) sample = c(sample, mean(rexp(n, lambda)) )
    sample
}

set.seed(612*2)

shinyServer( 
    function(input, output) {
        output$meanVarTable <- renderTable({
                sample.means = simulate(input$lambda, input$nrruns, input$nrsims)
                sample.sd = sd(sample.means) # Means standard deviation over the 1000 simulations
                sample.var = var(sample.means) # Means variance over the 1000 simulations
                conf.int.95.low = round(mean(sample.means)+qnorm(0.025)*sample.sd, digit=3) # Lower confidence interval (95%)
                conf.int.95.high = round(mean(sample.means)+qnorm(0.975)*sample.sd, digit=3) # Higher confidence interval (95%)
                means.density = density(sample.means, n=input$nrruns) # Compute density of our samples
                
                simulation.summary = data.frame( round(c(mean(sample.means),1/input$lambda), digit=3),
                                                 round(c(sample.sd,1/(input$lambda*sqrt(input$nrruns)) ), digit=3),
                                                 round(c(sample.var,1/(input$lambda^2*input$nrruns)), digit=3) )
                rownames(simulation.summary) =  c("Our sample value","Expected value")
                colnames(simulation.summary) =  c("Mean","Standard Deviation","Variance")
                
                simulation.summary

        })  

        output$expDist <- renderPlot({
                g = ggplot(data = data.frame( x = rexp(input$nrsims,rate=input$lambda) ))
                g = g + geom_histogram(aes(x=x, y=..density..),  # Histogram of a sample distribution
                                        size = 0.3, binwidth = .2, 
                                        fill = "red", color = "black", alpha = 0.5)
                g = g + stat_function(fun=dexp, # Compare our output against the expected expected
                                    geom = "line", 
                                    args = list(rate=input$lambda), 
                                    size = 1, col="blue", alpha=0.5 )
                print(g)
        })
        
        output$meanDist <- renderPlot({
                sample.means = simulate(input$lambda, input$nrruns, input$nrsims)
                g = ggplot(data = data.frame( x = sample.means ))
                g = g + geom_histogram(aes(x=sample.means, y=..density..),  # Plot histogram of means
                                    size = 0.3, binwidth = .2, 
                                    fill = "red", color = "black", alpha = 0.5)
                g = g + geom_density( aes( x = sample.means ), # Smooth the above histogram with its density curve
                                    fill = "red", size = 0.6, 
                                    col="red", alpha = 0.1)
                g = g + labs(y = "Density", x = "Average mean") # Give our plot nice labels
                print(g)
        })
        

    }
)
