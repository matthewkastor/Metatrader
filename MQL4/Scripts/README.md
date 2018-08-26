# Scripts
Scripts for metatrader

* **Canvas Glitter Bomb** : Basic example of drawing 3d scatter plots on the chart utilizing  x,y coordinates as normal and represinting z with transparency.
* **Change Time Frame All** : Changes the timeframe on all open charts.
* **Change Zoom Level All** : Changes the zoom level on all open charts.
* **Code Generator** : Generates some source code.
* **Export Order Book** : Export the active and historic order information to CSV file.
* **Get All History** : Automatically opens all charts of all symbols in the Market Watch, for all timeframes, and scrolls back until no new history is downloaded. This method is the only way to actually get historic data from your broker.
* **Scale Auto All** : Sets all open charts to automatic scaling.
* **Scale Fix All** : Sets all open charts to fixed scaling centered on a window whose height is a percentage of the current price.
* **Scroll Sync Charts** : Synchronizes scrolling across two charts.
* **Start Process** : Starts an external process from the command line specified in settings.

## Scale All Charts

Two scripts are included for scaling all of the charts. "Scale Auto All" will set all of the open charts to automatic scaling. "Scale Fix All" will set all of the open charts to use fixed scaling. When switching to fixed scaling one option must be specified "Percent of current price", which causes the chart to scale to a height equal to that percent of the current price and center the current price vertically in view. Fixing the scale on 12 charts simultaneously saves me a lot of time compared to doing it manually, and since they're all showing the same vertical scale it's extremely easy to see which pairs are making the biggest moves.

## Change Zoom Level All

This script sets the zoom level for all opened charts simultaneously. This saves me a lot of time when I'm looking at 12 charts and want to adjust them all.

## Change Timeframe All

This script will change the timeframe of all the opened charts. It has one setting for selecting the desired timeframe. This saves me a lot of time when doing multi timeframe analysis across 12 currency pairs simultaneously.

## Scroll Sync Charts

This script allows for multi-timeframe analysis by opening a second chart set to a different timeframe, then keeping the edge of both charts at the same time while you scroll.

## Start External Process

This script allows you to start any arbitrary external program. Use it as-is or as a starting point for something amazing.

In order for this script to work, you will have to allow it to import DLLs. The DLL should be present in computers running the windows operating system.

**Script Parameters**

* **Executable name** : The executable to run. Include the full path to it if you have to.
* **Commandline parameters** : Optional, you can use switches and arguments here.
* **Working directory** : Optional, specify the working directory.
* **Window display mode** : Set the option for how you want the application to launch.
