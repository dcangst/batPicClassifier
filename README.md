# batPicClassifier

## About `batPicClassifier`

`batPicClassifier` is a `R` package for quickly noting down the visible species of bat in pictures aquired with a light barrier triggered camera

## How to install

To install `batplotr` you need the [`devtools`](https://github.com/hadley/devtools)package which can be installed from CRAN (`install.packages("devtools")`. Once installed you can run the following code to get the latest version `batplotr`:

```r
library(devtools)
install_github("dcangst/batPicClassifier")
```

or to get a specific version:

```r
library(devtools)
install_github("dcangst/batPicClassifier", ref="v0.1")
```

## the main (and almost only) function of the web app

The package consists of the function `batPicClassifier()`. It launches a shiny app to classify bat pictures. For ease of use you can set up a script to launch the web app directly from your computer.

### Mac OS / probably other UNIX systems (tested in macOS 10.12 only)
Paste the following code into a plain text file with extension '.command'
```
#! /usr/local/bin/Rscript

if(!("batPicClassifier" %in% rownames(installed.packages()))){
  if("devtools" %in% rownames(installed.packages())){
    devtools::install_github("dcangst/batPicClassifier",dependencies=TRUE)
  } else {
    install.packages(c("devtools"),dependencies=TRUE)
    devtools::install_github("dcangst/batPicClassifier",dependencies=TRUE)
  }
}

suppressMessages(library(batPicClassifier))
batPicClassifier()
```
The file then needs to be made executable, which you can do in the terminal using the following command:
```
chmod +x /path/to/shellfile.command
```
(you can drag and drop the file into the terminal so you don't have to type the path).
This Script will install and or update all necessary components and launch the shiny web app.

### Windows 
the easiest way on windows is to follow the instructions on this page:
http://www.r-datacollection.com/blog/Making-R-files-executable/
and use the following R-Script:

```r
devtools::install_github("dcangst/batPicClassifier",dependencies=TRUE)
suppressMessages(library(batPicClassifier))
batPicClassifier()
```

This will install batplotr and launch the app. 

## Usage in R

```r
devtools::install_github("dcangst/batPicClassifier",dependencies=TRUE)
suppressMessages(library(batPicClassifier))
batPicClassifier()
```

This will install batplotr and launch the app. 
