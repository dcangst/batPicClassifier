#' batPicClassifier
#' 
#' launches an interactive web app
#'
#' @param option.list a list of global shiny options
#' @return launches a WebApp
#' @family interactive functions
#' @export
batPicClassifier <- function(
  option.list = 
    list(
      shiny.launch.browser = TRUE,
      shiny.maxRequestSize = 100 * 1024 ^ 2,
      encoding = "UTF-8")) {
shinyApp(
  onStart = function(options=option.list) {
    options(options)
  },
  ui = shinyUI(navbarPage("PicClassifier",
    tabPanel("Fotos",
      fluidRow(
        column(6,
          textInput("dirpath", "Pfad zu Bildverzeichniss",
            value = "",
            width = "100%",
            placeholder = "Pfad zu Bildverzeichniss...")
        ),
        column(3,
          selectizeInput("imgSelect", "Bild wählen", choices = "")
        ),
        column(3,
          downloadButton("downloadData", "Daten speichern...")
        )
      ),
      fluidRow(
        column(8,
          imageOutput("myImage")
        ),
        column(4,
          rHandsontableOutput("imgData")
        )
      )
    ), # tabPanel Fotos
    tabPanel("Optionen",
      fluidRow(
        column(6,
          rHandsontableOutput("speciesData")
        ),
        column(6,
          textInput("img_ext", "Image file extension",
            value = ".JPG")
        )
      )
    ) # tabPanel Optionen
    )),
  server = shinyServer(function(input, output, session) {
    # observers
    observe({
      updateSelectizeInput(session, "imgSelect",
        choices = imgFiles(),
        selected = imgFiles()[1]
      )
    })
    # rhandsontable observer
    observeEvent(input$imgData_select$select$r, {
      updateSelectizeInput(session, "imgSelect",
        selected = imgFiles()[input$imgData_select$select$r])
    })
    # reactive data
    imgFiles <- reactive({
      validate(
        need(input$dirpath != "","bitte Pfad zu Bildordner angeben!")
        )
      out <- list.files(input$dirpath, input$img_ext)
      return(out)
    })

    data <- reactive({
      if (!is.null(input$imgData)) {
        data <- hot_to_r(input$imgData)
        imgData <- left_join(
          select(data, -species),
          bat_data_lookup(),
          by = "input")
      } else {
        imgData <- data.frame(
          filename = imgFiles(),
          time = as.character(file.mtime(
            str_c(input$dirpath, imgFiles(), sep = "/"))),
          input = "",
          species = "",
          stringsAsFactors = FALSE)
      }
      return(imgData)
    })

    bat_data <- reactive({
      if (!is.null(input$speciesData)) {
        bat_data <- hot_to_r(input$speciesData)
      } else {
        bat_data <- batData
      }
    })

    bat_data_lookup <- reactive({
      gather(bat_data(), "type", "input", 1:2) %>%
        dplyr::select(input, species)
    })

    output$myImage <- renderImage({
      filename <- paste0(input$dirpath, "/", input$imgSelect)
      # Return a list containing the filename and alt text
      list(src = filename,
        alt = input$imgSelect,
        width = "100%")

    },deleteFile = FALSE)

    output$imgData <- renderRHandsontable({
      rhandsontable(data(),
        selectCallback = TRUE, rowHeaders = NULL, height = 600) %>%
        hot_table(highlightCol = FALSE, highlightRow = TRUE) %>%
        hot_col(col = "input", type = "dropdown",
          source = bat_data_lookup()$input, strict = TRUE,
          allowInvalid = TRUE) %>%
        hot_col("filename", readOnly = TRUE) %>%
        hot_col("time", readOnly = TRUE) %>%
        hot_col("species", readOnly = TRUE)
    })

    output$speciesData <- renderRHandsontable({
      rhandsontable(bat_data())
    })

    output$downloadData <- downloadHandler(
      filename = function() {
        "BatPicClassifier_data.csv"
      },
      content = function(file) {
        data_out <- data()
        data_out$folder <- input$dirpath
        write.csv(data_out, file)
      }
    )

  })
)}
