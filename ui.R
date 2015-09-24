library(shiny)

shinyUI(fluidPage( #pageWithSidebar( 
    titlePanel("Central Limit Theorem applied to exponential distribution"),
    wellPanel(p("This shiny application illustrates the Central Limit Theorem (CLT) based of a well known distribution called Exponential Distribution: λe(−λx). Particularity of this distribution is that its mean equals its standard deviation equals 1/λ."),
              p("It will focus on the 2 outcomes of that theorem:"),
              p("----- The distribution of averages of iid variables (properly normalized) becomes that of a standard normal as the sample size increases. Hence we will demonstrate that the higher the number of runs on which average is done, the closer the shape will get to a Gaussian. And this whatever initial distribution of iid."),
              p("----- For large n, this normalized variable, (X′−μ)/(σ/√‾‾n) is almost normally distributed with mean 0 and variance 1. Therefore we will demonstrate that the higher the number of runs on which average is done, the closer its mean μ and its standard deviation σ to get to 1/λ."),
              p("Below widgets enable '# of simulations' simulations averaging '# of runs' runs for λ='Lambda'."),
              h4("Caution:"),
              p("Since Shiny Server hosts lots of running application, setting a number of simulation too high may froze the shiny application while refreshing graphs.")
    ),
    sidebarPanel(
        sliderInput("lambda", "Lambda", 0.2, min=0.1, max=1, step=0.1),
        sliderInput("nrruns", "# of runs", 40, min=10, max=100, step=10),
        sliderInput("nrsims", "# of simulations", 100, min=100, max=2000, step=200)
    ), 
    mainPanel(
        tabsetPanel(type = "tabs", 
            tabPanel("Exponential Distribution",  
                h4("Exponential distribution"),
                plotOutput('expDist')
            ),
            tabPanel("Simulation Mean Distribution",  
                h4("Distribution of the mean of samples"), 
                plotOutput('meanDist')
            )
        ),
        h4('Sample mean and variance'),
        tableOutput('meanVarTable')
    ) 
))
