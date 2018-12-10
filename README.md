[![Travis build status](https://travis-ci.org/kasaai/pc-pricing-tutorial.svg?branch=master)](https://travis-ci.org/kasaai/pc-pricing-tutorial) [![Gitter chat](https://badges.gitter.im/kasa-official/gitter.png)](https://gitter.im/kasa-official/pc-pricing-tutorial)

# P&C Pricing Tutorial

End-to-end reproducible ratemaking with R.

Interested in joining in on the fun? Look at the [issues](https://github.com/kasaai/pc-pricing-tutorial/issues) page to see what tasks need help and check out [contributing guidelines](https://github.com/kasaai/pc-pricing-tutorial/blob/master/CONTRIBUTING.md).

## Data Access

We're using the publicly available data from the Superintendência de Seguros Privados of Brazil. The data can be downloaded from [http://www2.susep.gov.br/menuestatistica/Autoseg/principal.aspx](http://www2.susep.gov.br/menuestatistica/Autoseg/principal.aspx). We'll be using the first half of 2012 (`Autoseg2012B`) to start, since that's the first time period where CSVs (as opposed to MS Access files) are available. The convention we'll use in this repo is that we'll put the uncompressed directory in `external_data/`, so your directory structure might look something like

```
├── R
├── analysis
├── external_data
│   ├── Autoseg2012B
│   └── gadm36_BRA_gpkg
├── man
└── manuscript
    ├── images
    └── public
```

The `.gpkg` files for drawing state boundaries can be downloaded from [https://biogeo.ucdavis.edu/data/gadm3.6/gpkg/gadm36_BRA_gpkg.zip](https://biogeo.ucdavis.edu/data/gadm3.6/gpkg/gadm36_BRA_gpkg.zip). See [https://gadm.org/download_country_v3.html](https://gadm.org/download_country_v3.html) for details.