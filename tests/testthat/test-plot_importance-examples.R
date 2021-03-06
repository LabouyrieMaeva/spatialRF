test_that("`plot_importance()` works", {
  data(plant_richness_df)
  data(distance_matrix)

  rf.model <- rf(
    data = plant_richness_df,
    dependent.variable.name = "richness_species_vascular",
    predictor.variable.names = colnames(plant_richness_df)[5:21],
    distance.matrix = distance_matrix,
    distance.thresholds = c(0, 1000, 2000),
    verbose = FALSE
  )

  p <- plot_importance(x = rf.model, verbose = FALSE)
  expect_equal(inherits(p, "ggplot"), TRUE)
})
