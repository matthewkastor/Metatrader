# Keltner Pullback Trader

Per request by "Maple Mike", this amazing EA trades keltner Channels, which is basically just a channel whose height is defined by ATR and whose center line follows a moving average. This EA buys when the moving average is going up, price is below the mid point of it's high and low within the ATR period, and price is below the moving average. This EA sells when price is above the midpoint, above the moving average, and the moving average is sloping down. Exits are set 1 ATR away from entry price.

![Screenshot of settings](README%20images/Keltner%20Pullback%20Trader%20Settings.png)

The Keltner channel shift setting will cause this signal to lag behind the current price.

The Tp/Sl setting will ignore signals whose distance between the stop loss and take profit are not at least a multiple of the current spread. You set the multiple here.

The parallel signals setting will add a second instance of this signal that is shifted back by a multiple of the MA Period. This makes the parallel signal a filter for ranging markets with uniform volatility.