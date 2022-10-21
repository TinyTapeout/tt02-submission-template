![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg)

Go to https://tinytapeout.com for instructions!

# How to change the Wokwi project

Edit the [info.yaml](info.yaml) and change the wokwi_id to match your project.

# What is this about?

This repo is a template you can make a copy of for your own [ASIC](https://www.zerotoasiccourse.com/terminology/asic/) design using [Wokwi](https://wokwi.com/).

When you edit the info.yaml to choose a different ID, the [GitHub Action](.github/workflows/gds.yaml) will fetch the digital netlist of your design from Wokwi.

After that, the action uses the open source ASIC tool called [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/) to build the files needed to fabricate an ASIC.

# Setup

Due to Github limitations, you need to do some work to get everything to work.

1. Go to Actons tab and press enable Github Actions
2. Go to Settings tab and select Pages, then change Source from `Deploy from a branch` to `Github Actions`

# What files get made?

When the action is complete, you can click on the 'Actions' tab above, choose the 'gds' action and then click on the latest result.
You should see a page with the results of the build:

* Number of cells used
* Length of wire used
* A picture of your GDS
* A link to open the interactive 3D viewer

You can also download a zipped artifact that contains:

* runs/wokwi/reports/metrics.csv  - CSV file with lots of details about the design
* runs/wokwi/reports/synthesis/1-synthesis.AREA 0.stat.rpt - list of the [standard cells](https://www.zerotoasiccourse.com/terminology/standardcell/) used by your design
* runs/wokwi/results/final/gds/user_module.gds - the final [GDS](https://www.zerotoasiccourse.com/terminology/gds2/) file needed to make your design

# What next?

* Share your GDS on twitter, tag it [#tinytapeout](https://twitter.com/hashtag/tinytapeout?src=hashtag_click) and [link me](https://twitter.com/matthewvenn)!
* [Submit it to be made](https://docs.google.com/forms/d/e/1FAIpQLSc3ZF0AHKD3LoZRSmKX5byl-0AzrSK8ADeh0DtkZQX0bbr16w/viewform?usp=sf_link)
* [Join the community](https://discord.gg/rPK2nSjxy8)
