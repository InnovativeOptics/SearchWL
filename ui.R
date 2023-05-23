library(bslib)
library(shiny)

page_fluid(
  theme = bs_theme(version = 5,
    bg = "white",
    fg = "black",
    primary = "royalblue",
    base_font = font_google("Karla")),
  
  card(card_header(fluidRow(column(4,align = "center",
                              h3(strong("Enter your device's specifications"))
                              ),
                       column(4,align = "center",
                              numericInput(
                         "wl", h4(strong("Wavelength")), min = 200, max = 11000, step = 1, value = NULL)
                              ),
                       column(4,align = "center",
                              numericInput("od", h4(strong("Optical Density")), min = 0, max = 10, step = 0.5, value = 0)
                       ))
  ),
  
  card_body(
    conditionalPanel("output.links", 
                     h3(em("Compatible Lenses"))),
    fluidRow(
    column(12,align = 'center',h1(uiOutput("links")))),
    fluidRow(column(12,align = 'center',h2(uiOutput("images")))),
    fluidRow(column(12,uiOutput("tables"))
    )
    ),
  
  card_footer(h4(
    a(href = "https://innovativeoptics.com/contact/", "Contact us"))
    )
  )
)