# Analysis of the Survey of Income and Program Participation

This repository contains data and code supporting a [BuzzFeed News article](https://www.buzzfeednews.com/article/venessawong/millennials-parents-stereotypes-boomers-data) on generational trends in support providers, published November 11, 2019. See below for details.

## Data Source

This repository analyzes the U.S. Census Survey of Income and Program Participation (SIPP). The SIPP surveys the same group of respondents across four years. Each year's data set is released in "waves." [Wave 1](https://www.census.gov/programs-surveys/sipp/data/2014-panel/wave-1.html) covers 2013 and [Wave 4](https://www.census.gov/programs-surveys/sipp/data/datasets/2014-panel/wave-4.html) covers 2016.

These files are very large and so are not included in this repository. Please download them from the U.S. Census or use the included Makefile. See the `Reproducibility` section below. 

## Methodology

The aim of this analysis was to produce two main tables:

- The number of individuals providing financial support to parents living outside the house (by age of provider)
- The number of individuals providing financial support to adult children living outside the house (by age of provider)
  
The SIPP records these data points in the following variables:

- `eothsuprt1yn`: Flag for whether the individual supports a parent living outside the house
- `eothsuprt2yn`: Flag for whether the individual supports a child aged 21 or older living outside the house
- `tage`: Age as of last birthday
- `tdob_byear`: Year of birth

As a guide, we used this [report on support providers](https://www.census.gov/content/dam/Census/library/publications/2018/demo/P70BR-158.pdf) which used Wave 1 data. We replicated the estimates for providers by age in Table 2 and Table 3 and used the same methodology for Wave 4. We consulted with three experts at the U.S. Census during the development of this analysis to ensure we were using the correct methodology.

### Unique Identifiers

The SIPP is a monthly survey of households and their participants. As such, there is no unique ID for individuals, but there does exist a unique ID for each household, and one for each individual within the household. For the purposes of filtering and joining, we created a unique ID column, `uid`, by concatenating `ssuid` (household identifier) and `pnum` (individual identifier within a household).

### Accounting for age

The U.S. Census uses the `tage` variable to calculate an individual's age. We used this variable when calculating age ranges. 

To delineate generations, we used the guidelines from the [Pew Research Center](https://www.pewresearch.org/topics/generations-and-age/), which relies on birth year.

### Accounting for weights

The SIPP public use files include weights which can be used to extrapolate estimates to the broader population. Because the SIPP is a monthly survey, each person-month has a different weight. Following guidance from the Census, we used the December values as the weights for both years. Population estimates for various measures are simply the sums of those weights, filtered for those measures.

### Accounting for error

The SIPP prodides ["replicate weights"](https://www.census.gov/programs-surveys/sipp/data/datasets/2014-panel/wave-4.html) which can be used to calculate more accurate standard error values when joined to the public use data. We used these weights and "Formula (16)" from the documentation provided by the SIPP [Source and Accuracy Statement](https://www.census.gov/programs-surveys/sipp/tech-documentation/source-accuracy-statements.html) to calculate standard error.

Our final 90% confidence interval values differ slightly from the values in the [Support Providers: 2013](https://www.census.gov/content/dam/Census/library/publications/2018/demo/P70BR-158.pdf) report because the replicate weights the Census makes available for public use contain slightly modified values. In general, our standard errors are slightly larger and more conservative. 

## Notebooks

These notebooks are used for loading and filtering the SIPP data:

- [`load_public.ipynb`](notebooks/load_public.ipynb): loads the public use data, selects the columns necessary for the analysis and generates the unique identifier
- [`filter_supports.ipynb`](notebooks/filter_supports.ipynb): filters the public use data by support providers and by month
- [`load_replicates.ipynb`](notebooks/load_replicates.ipynb): loads the replicate weight files, drops the non-December months, and generates the unique indentifier

This notebook performs the main analysis and provides a sample hypothesis test. This must be run after the three data cleaning notebooks. See the `Reproducibility` section below.

- [`analysis.ipynb`](notebooks/analysis.ipynb) analyzes the data by age group and generation, also joins to replicate weights to produce standard errors

## Output

To keep file sizes manageable, many filtered versions of these files are in the `output/` directory:

- [`wave1.csv`](output/wave1.csv): The full public use dataset for Wave 1 of the SIPP with simplified columns and a unique identifier added. 
- [`wave4.csv`](output/wave4.csv): The full public use dataset for Wave 4 of the SIPP with simplified columns and a unique identifier added. 
- [`w1_supports_parents.csv`](output/w1_supports_parents.csv): Unique individuals who financially support a parent who lives outside of the house, Wave 1.
- [`w4_supports_parents.csv`](output/w4_supports_parents.csv): Unique individuals who financially support a parent who lives outside of the house, Wave 4.
- [`w1_supports_children.csv`](output/w1_supports_children.csv): Unique individuals who financially support a child aged 21+ who lives outside the house, Wave 1.
- [`w4_supports_children.csv`](output/w4_supports_children.csv): Unique individuals who financially support a child aged 21+ who lives outside the house, Wave 4.

These files are too large to be committed to the repository but the notebooks will recreate them:

- [`w1_replicates.csv`](output/w1_replicates.csv): Replicate weights for Wave 1.
- [`w4_replicates.csv`](output/w4_replicates.csv): Replicate weights for Wave 4.

## Reproducibility

The analysis is written in Python 3, and requires the following Python libraries:

- [pandas](https://pandas.pydata.org/) for data loading and analysis.
- [jupyter](https://jupyter.org/) to run the notebook infrastructure.
- [nbexec](https://github.com/jsvine/nbexec) to run notebooks via command line.

If you use Pipenv, you can install all required libraries with `pipenv install`.

To download the census data run `make download`. **Warning:** this could take up to a few hours depending on your internet connection and will download and unzip files totaling more than 50 gigabytes.

Run `make analysis` to run the notebooks required to run the analysis. Finally, run the analysis notebook to see the final tables.

## Licensing

All code in this repository is available under the [MIT License](https://opensource.org/licenses/MIT). Files in the `output/` directory are available under the [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) (CC BY 4.0) license.

## Questions / Feedback

Contact Scott Pham at [scott.pham@buzzfeed.com](mailto:scott.pham@buzzfeed.com).

Looking for more from BuzzFeed News? [Click here for a list of our open-sourced projects, data, and code.](https://github.com/BuzzFeedNews/everything)

