# Keltner Pullback Trader

Trades keltner Channels, which is basically just a channel whose height is defined by ATR and whose center line follows a moving average. This EA fades when price moves 1 ATR away from the moving average, and allows you to define which moving average and ATR to use.

![Screenshot of settings](README%20images/Keltner%20Pullback%20Trader%20Settings.png)

The Keltner channel shift setting will cause this signal to lag behind the current price.

The Tp/Sl setting will ignore signals whose distance between the stop loss and take profit are not at least a multiple of the current spread. You set the multiple here.

The parallel signals setting will add a second instance of this signal that is shifted back by a multiple of the MA Period. This makes the parallel signal a filter for ranging markets with uniform volatility.