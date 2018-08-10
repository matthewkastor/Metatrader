# Puppy

This EA places a trade with the exits set to 1 ATR away from the entry price. If the last trade closed out at a profit, then it will trade in that same direction again. If the last trade closed out at a loss, then it will trade in the opposite direction. 

![Screenshot of settings](README%20images/Puppy%20Settings.png)

The period for calculating ATR will affect the distance between the stop loss and take profit.

The take profit and stop loss minimum distance will filter out signals that set the exits too close to one another. "Too close" is defined as the spread width multiplied by this setting.

The signal can be inverted so that wins cause a trade direction switch and losses do not.

Skewing the sl/tp spread adjusts the risk reward ratio. This can be a number from -4.9 to 4.9, 0 sets the stop loss and take profit to be centered on the entry price. 0.17 would cause the open price to be about 1/3 away from stop loss and 2/3 away from take profit.

See [Portfolio Manager Settings](../README.md#common-settings-for-portfolio-manager) for additional configuration settings.