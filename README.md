### ssbR: Download data from Statistics Norway (SSB)

This R-package provides functions for viewing, searching and downloading data from Statistics Norway (SSB) directly in R.

#### Installation

You need the `devtools` package in order to install `ssbR`. You can install it using the follow code (note that you only need to run this once):

``` R
if(!require(devtools)) install.packages("devtools")
```

You can then load `devtools` and install `ssbR` by running:

``` R
library(devtools)
install_github("mikaelpoul/ssbR", dependencies = TRUE)
```

#### Contact

If you have any problems or suggestions, feel free to [open an issue](https://github.com/mikaelpoul/ssbR/issues/new) or send me an [email](mailto:mikajoh@gmail.com).
