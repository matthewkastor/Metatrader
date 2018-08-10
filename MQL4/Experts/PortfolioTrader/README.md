# Portfolio Trader

This EA trades on the boundaries of recent high and low prices. When it detects that the recent price is range bound, it'll fade the high and low prices. When it detects price is trending or breaking out of the range, it'll trade with the direction of the trend or breakout. Exits are set by ATR.

![Screenshot of settings](README%20images/Portfolio%20Trader%20Settings.png)

Using parallel signals will add multiple instances of the signal analyzer that lag price. This will cause the signal to look for confirmation between all instances on whether the price is range bound or not, and whether the price is hitting the high or low for all instances.