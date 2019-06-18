---
title: gbest Correlation
categories:
- RS
tags:
- correlation
- coefficient of variation
- WOFOST
date: 2019-06-18
mathjax: true
---

# Intro
Calculates the correlation between `gbest` and `LAI` / `WSO` at different times.

# Content Table

| File             	| Description                                                                                                                            	|
|------------------	|----------------------------------------------------------------------------------------------------------------------------------------	|
| `Correlation.m`  	| Correlation between images. All images are masked and converted to 1D array.                                                           	|
| `CorrImage.mlx`  	| Correct images with proper spatial reference.                                                                                          	|
| `GradingStat.m`  	| Calculates the percentage and amount of pixels for each 0.1 gbest interval.                                                            	|
| `SeriesMean.m`   	| Calculates the mean value of a pixel time series. Due to lack of spatial reference, this script also borrows CRS info from raw images. 	|
| `SeriesMean.mlx` 	| mlx version of `SeriesMean.m`                                                                                                          	|

*For more detailed info about input and output params please refer to script comments.*
