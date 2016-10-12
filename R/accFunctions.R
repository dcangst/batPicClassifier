#' changeSelectize
#' 
#' helper function to change Selectize input by 1
#'
#' @param dir +1 or -1 for next or previous element
#' @param values a vector of values that can be selectegd
#' @param selected the currently selected value
#' @return a value
#' @family accessory functions
#' @export
changeSelectize <- function(dir, values, selected) {
  current <- which(values == selected)
  future <- current + dir
  if (future > length(values)){
    future <- 1
  }
  if (future == 0){
    future <- length(values)
  }
  return(values[future])
}