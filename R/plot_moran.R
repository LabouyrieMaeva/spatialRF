#' @title plot_moran
#' @description Plots results of spatial autocorrelation tests for a variety of functions within the package.
#' @param x a data frame resulting from [moran_multithreshold]. Default: NULL
#' @param verbose logical, if TRUE, the resulting table is printed into the console, Default: TRUE
#' @return a ggplot.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  data(plant_richness_df)
#'  data(distance.matrix)
#'  #basic model
#'  rf.model <- rf(
#'    data = plant_richness_df,
#'    dependent.variable.name = "richness_species_vascular",
#'    predictor.variable.names = colnames(plant_richness_df)[5:21],
#'    distance.matrix = distance_matrix,
#'    distance.thresholds = c(0, 1000, 2000),
#'    verbose = FALSE
#'  )
#'
#'  plot_moran(x = rf.model$spatial.correlation.residuals$per.distance)
#'  }
#' }
#' @rdname plot_moran
#' @export
#' @importFrom ggplot2 ggplot aes geom_hline geom_point geom_line xlab ylab ggtitle theme labs scale_colour_manual
#' @export
plot_moran <- function(x, verbose = TRUE){

  #declaring variables
  distance.threshold <- NULL
  moran.i <- NULL
  p.value.binary <- NULL
  repetition <- NULL
  model <- NULL

  if(!is.data.frame(x)){
    stop("'x' must be a data frame.")
  }

  #adding binary p.value
  x$p.value.binary <- "< 0.05"
  x[x$p.value >= 0.05, "p.value.binary"] <- ">= 0.05"

  #plotting rf
  if(sum(c("model", "repetition") %in% colnames(x)) == 0){

    p <- ggplot2::ggplot(data = x) +
      ggplot2::aes(
        x = distance.threshold,
        y = moran.i,
        size = p.value.binary
      ) +
      ggplot2::geom_hline(
        yintercept = 0,
        col = "gray10",
        size = 0.7,
        linetype = "dashed"
      ) +
      ggplot2::geom_point(color = "#440154FF") +
      ggplot2::geom_line(size = 1, color = "#440154FF") +
      ggplot2::xlab("Distance thresholds") +
      ggplot2::ylab("Moran's I of residuals") +
      ggplot2::ggtitle("Multiscale Moran's I") +
      ggplot2::theme(legend.position = "bottom") +
      ggplot2::labs(size = "Moran's I p-value")

  }

  #plotting rf_repeat
  if("repetition" %in% colnames(x) & !("model" %in% colnames(x))){

    p <- ggplot2::ggplot(data = x) +
      ggplot2::aes(
        x = distance.threshold,
        y = moran.i,
        group = repetition,
        size = p.value.binary
      ) +
      ggplot2::geom_hline(
        yintercept = 0,
        col = "gray10",
        size = 0.7,
        linetype = "dashed"
      ) +
      ggplot2::geom_point(
        color = "#440154FF",
        alpha = 0.7
        ) +
      ggplot2::geom_line(
        size = 1,
        color = "#440154FF",
        alpha = 0.7
        ) +
      ggplot2::xlab("Distance thresholds") +
      ggplot2::ylab("Moran's I of residuals") +
      ggplot2::ggtitle("Moran's I of the residuals") +
      ggplot2::theme(legend.position = "bottom") +
      ggplot2::labs(color = "Model", size = "Moran's I p-value")

  }

  #plotting rf_spatial with rf
  if("model" %in% colnames(x) & !("repetition" %in% colnames(x))){

    p <- ggplot2::ggplot(data = x) +
      ggplot2::aes(
        x = distance.threshold,
        y = moran.i,
        color = model,
        size = p.value.binary
      ) +
      ggplot2::geom_hline(
        yintercept = 0,
        col = "gray10",
        size = 0.7,
        linetype = "dashed"
      ) +
      ggplot2::geom_point(alpha = 0.7) +
      ggplot2::geom_line(
        size = 1,
        alpha = 0.7
        ) +
      ggplot2::scale_colour_manual(values = c("#440154FF", "#35B779FF")) +
      ggplot2::xlab("Distance thresholds") +
      ggplot2::ylab("Moran's I of residuals") +
      ggplot2::ggtitle("Residuals' Moran's I of the spatial and non-spatial models") +
      ggplot2::theme(legend.position = "bottom") +
      ggplot2::labs(
        color = "Model",
        size = "Moran's I p-value"
        )

  }

  #plotting rf_spatial with rf_repeat
  if(sum(c("model", "repetition") %in% colnames(x)) == 2){

    p <- ggplot2::ggplot(data = x) +
      ggplot2::aes(
        x = distance.threshold,
        y = moran.i,
        color = model,
        size = p.value.binary,
        group = interaction(repetition, model)
      ) +
      ggplot2::geom_hline(
        yintercept = 0,
        col = "gray10",
        size = 0.7,
        linetype = "dashed"
      ) +
      ggplot2::geom_point(alpha = 0.7) +
      ggplot2::geom_line(
        size = 1,
        alpha = 0.7
        ) +
      ggplot2::scale_colour_manual(
        values = c(
          "#440154FF",
          "#35B779FF")
        ) +
      ggplot2::xlab("Distance thresholds") +
      ggplot2::ylab("Moran's I of residuals") +
      ggplot2::ggtitle("Residuals' Moran's I of the spatial and non-spatial models") +
      ggplot2::theme(legend.position = "bottom") +
      ggplot2::labs(
        color = "Model",
        size = "Moran's I p-value"
        )

  }

  if(verbose == TRUE){
    suppressWarnings(print(p))
  }

  p

}