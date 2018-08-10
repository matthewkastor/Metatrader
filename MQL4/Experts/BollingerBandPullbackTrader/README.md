# Bollinger Band Pullback Trader

*This is a bollinger band / moving average system requested by "Maple Mike"*


## Criteria
1) Price touches bollinger band.
2) Price pulls back to the moving average.
3) Enter order anticipating price to move toward touched bollinger band.
4) Stopout level is to be controlled by Atr defined range around current price.

## Settings

**Signal Entry**

![Screenshot of settings](README%20images/Bollinger%20Band%20Pullback%20Settings%20Signal%20Entry.png)

* **Period for Bollinger Bands** : bollinger band period.
* **Fade the BB Touch** : This inverts the order type, basically replacing step 3 with "enter order anticipating price to move away from touched bollinger band."
* **How many bars is a BB touch valid** : After this many bars, a touch of the bollinger band won't count as satisfying step 1.
* **BB standard deviations** : bollinger band standard deviations.
* **BB Applied Price** : bollinger band applied price.
* **Touch Detection Offset** : allows for touch detection to lag behind current price.
* **BB shift** : bollinger band shift.
* **BB indicator color** : color of the indicator box drawn to represent bollinger band levels and periodicity
* **Touch detection indicator color** : color of the box drawn to represent the timespan of valid bollinger band touch detections.
* **MA period** : period of the moving average.
* **MA shift** : shift of the moving average.
* **MA method** : method of calculating the moving average.
* **MA applied price** : price to calculate moving average from.
* **MA indicator color** : color of the trendline drawn to represent the current slope of the moving average.

**Signal Exit**

![Screenshot of settings](README%20images/Bollinger%20Band%20Pullback%20Settings%20Exit.png)

* **ATR Period** : period of the ATR.
* **ATR Vertical Skew** : Shifts the ATR range up or down, controlling the relative risk reward ratio.
* **ATR Multiplier** : multiply the ATR by this much.
* **ATR Indicator Color** : color of the box drawn to indicate the ATR channel and periodicity.

**Signal Settings (general)**

![Screenshot of settings](README%20images/Bollinger%20Band%20Pullback%20Settings%20Signal.png)

* **Signal Shift** : Shifts the entire signal analysis point away from the current price
* **Tp/Sl minimum distance, in spreads** : rejects signals that have the take profit and stop loss closer together than the current spread multiplied by this setting.
* **Quantity of Parallel Signals to use** : This is how many signals to use. Each additional signal beyond the first will have the bollinger band and moving average period multiplied by this number. Basically this gives you multi timeframe analysis, where the higher timeframes are a multiple of whatever period you've chosen. i.e. period of 15 on the minute chart, using 2 parallel signals, will essentially be looking for confirmation between the 15 and 30 minute signal.