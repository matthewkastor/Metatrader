# Biased Martingale

System using a single moving average slope as bias for trading direction, and allowing for martingaling.

## Settings

![Screenshot of settings](README%20images/Biased%20Martingale%20Settings.png)

* **StartFactor** : Starting lots per 1000 of account.
* **IncreaseFactor** : Each additional position's lot size is the sum of open postitions multiplied by this.
* **BiasTimeframe** : The timeframe for the moving average.
* **BiasLookback** : How many bars back to look when checking the slope of MA between now and then.

*The following schedule sets a weekly schedule for when the EA is allowed to open more trades.*

* **Start Day** : What Day to start trading.
* **End Day** : What day to end trading.
* **Start Hour** : What time to start trading.
* **End Hour** : What time to end trading.