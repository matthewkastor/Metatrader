# Managing Basket Trades With the Multi Pair Closer Expert Advisor

This EA will monitor the net profit of a currency basket and close all positions when the specified profit has been acquired. It does not matter which chart you run the bot on, all pairs that you have chosen to monitor will be monitored.

## Settings

![Screenshot of settings](README%20images/Multi%20Pair%20Closer%20Settings.png)

 - **Currency basket** : A comma separated list of the currency pairs to watch. This is case sensitive, so use the exact names of your instruments as shown in the market watch window.
 - **Profit target in account currency** : The net profit amount you're aiming for with the currency basket.
 - **Maximum allowed loss in account currency** : The net loss amount you're willing to withstand.
 - **Allowed slippage when closing orders** : The slippage setting to send with the commands that close positions.
 - **Minimum age of order in seconds** : The minimum age of an order to be closed, by default orders created within the last 60 seconds will not be closed.
