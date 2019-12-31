#' theme_dotdensity
#'
#' A function which colours the background of a dot density map.
#' These tend to look best when on a dark background so defaults to darkgrey.
#'
#'
#' @param legend whether or not to include a legend
#' @param background_colour the colour code of the background of the plot. Defaults to #212121 (very dark grey)
#' @param text_colour the text colour for the plot. Defaults to white
#' @param border whether or not to include a border
#'
#' @author
#' Robert Hickman
#' @export

theme_dotdensity <- function(legend = TRUE,
                             background_colour = background_colour,
                             text_colour = "white",
                             border = FALSE) {
  basic_theme <- ggplot2::theme_void()

  #if including a legend
  if(legend == FALSE) {
    basic_theme <- basic_theme + 
      ggplot2::theme(legend.position = "none")
  } else {
    basic_theme <- basic_theme + 
      ggplot2::theme(legend.text = element_text(size = 12, colour = text_colour)) +
      ggplot2::theme(legend.background = element_rect(fill = background_colour, color = NA))
  }

  #to colour the bacground
  if(!background_colour) {
    basic_theme <- basic_theme
  } else {
    basic_theme <- basic_theme + 
      ggplot2::theme(plot.background = element_rect(fill = background_colour, color = NA), 
                     panel.background = element_rect(fill = background_colour, color = NA),
                     text = element_text(color = text_colour, size = 20),
                     title = element_text(color = text_colour, size = 16))
  }
  
  if(!border) {
    basic_theme <- basic_theme
  } else {
    basic_theme <- basic_theme + 
      ggplot2::theme(panel.border = ggplot2::element_rect(colour = "#F5F5F5", fill = NA)) # white smoke colour
  }
  
  basic_theme
}