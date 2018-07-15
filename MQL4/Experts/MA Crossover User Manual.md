# Moving Average Studies With MA Crossover Expert Advisor

This EA was created to study the effects of various trade and money management strategies applied to a simple system, using only a Moving Average for bias. With this program you can implement a Moving Average trading system that switches between buying and selling automatically. You may also implement a scaling in strategy with options to average up, average down, or both. You can also disable switching directions based on the Moving Average, and simply use it as the bias for opening new positions in a single direction.

There are options for setting the stop loss and take profit, or disabling them if you wish. The position size is dynamically adjusted as the account balance grows or shrinks, with the user setting determining how much of the balance to use per position. If free equity falls below the user defined percentage, then the bot will stop placing new orders, or may be configured to close all open positions. With these configuration options it is possible to execute many different strategies using the same program. This EA does not use a Magic Number because it is intended to manage all of the trades on the given symbol.

Manual intervention during unexpected turns in the market, or for tweaking portfolio exposure is very much expected. While this EA was written to rapidly explore trade management options and optimization through backtesting, it is quite handy to use it with your preferred settings while trading.

As always, there are no promises of profits while using this program and it is trivial to configure it to throw all of your money out as booked losses. The choice to run this on a live account is yours to make, and I honestly hope you forward test your assumptions and trading conditions through a demo account first. Let me know if you find bugs in the code and I'll fix them.



## Settings

 - Allowed Trade Direction: This controls whether the bot is allowed to buy, sell, or do both. It will not cause trades in both directions simultaneously.
 - Hedging Allowed: Set this to true to allow trading both directions simultaneously (Must be supported by your broker).
 - Hidden Tp Sl: Set this to true to have the bot close positions when take profit or stop loss would hit, without actually placing the tp or sl. This could get dangerous in a live account, since there are many different reasons why you might lose internet connectivity.
 - Leverage Per Position: The position size will grow as your account balance grows, this number is how many micro lots (0.01 lot) to buy or sell per 1000 units of account balance. Don't forget to factor the value of 0.01 lot of the base currency in terms of your account currency when setting this.
 - StopLoss Percent: Optional, disable this by setting it to zero. This setting manages the stop loss so that it will be set at a loss in terms of the base currency. If set to 0.5 then the stop loss should be moved to exit when 0.5% loss in the base currency occurs. The account balance would lose more or less than this percentage depending on the current rate of exchange between the account currency and the base currency.
 - Trailing StopLoss Percent: Optional, disable this by setting it to zero. This setting causes the stop loss to move above the average entry price when averaging up is enabled. It should prevent the loss of unrealized gains beyond a certain percentage of the base currency value.
 - TakeProfit Percent: Optional, disable this by setting it to zero. This setting manages the take profit target so that it will be set at a profit in terms of the base currency. If set to 4.5 then the take profit should be moved to exit when 4.5% gain in the base currency occurs. The account balance would gain more or less than this percentage depending on the current rate of exchange between the account currency and the base currency.
 - Slippage: Sets the acceptable amount of slippage for orders.
 - Minimum Free Equity Percent: Disables placing new positions when the free equity is or would fall below the specified percentage. Setting this to 10 causes the bot to stop opening positions if opening a new position would cause the free equity to fall below 10% of the account balance.
 - Close All At Minimum Free Equity Reached: If you would like to close all the positions when free equity reaches the minimum set, then set this to true.
 - Average Up: Set this to true to add positions as price moves in your favor.
 - Average Down: Set this to true to add positions as price moves against you.
 - Averaging Step Size Percent: This controls the distance between positions when using the averaging options. If set to 3, then the price needs to move 3% before a new position would be added.
 - Averaging Down Step Multiplier: This multiplies the distance between positions while averaging down. If the Average Step Size Percent is set to 2, and this setting is set to 3, then the price needs to move 6% before a new position would be added while price moves against you. This option allows for growing net exposure rapidly while averaging up, and growing more slowly while averaging down.
 - Close All At MA Crossover: Set this to true if you would like all positions to be closed when the biasing Moving Average changes between being bullish and bearish.
 - MA Timeframe Previous: Timeframe to use for the slow Moving Average.
 - MA Timeframe Current: Timeframe to use for the fast Moving Average.
 - MA Period Previous Add: The period for the slow Moving Average is the sum of the "current" period plus this number. If the current period is set to 10 and this is set to 2, then the slow Moving Average would have a period of 12.
 - MA Period Current: The period of the fast Moving Average.
 - MA Shift Previous: The shift to apply to the slow Moving Average.
 - MA Shift Current: The shift to apply to the fast Moving Average.
 - MA Method: The method of calculation for both slow and fast Moving Average.
 - MA Applied Price: The applied price to use for both slow and fast Moving Average.
 - Start Day: The day of the week to start trading.
 - End Day: The day of the week to stop trading.
 - Start Time: The time to start trading on the start day.
 - End Time: The time to stop trading on the end day.


## Testing and Optimization

This program will only evaluate whether it should open a new trade at the beginning of a new bar. If you want it to check every minute then put it on a chart set to the 1 minute timeframe. If you want it to check once a week then set the chart timeframe to 1 week. This also means that backtesting on "every tick" is mostly useless during exploratory testing. You should use the option to use "open bars only" to do heavy duty exploratory testing, then narrow down to "control points" or "every tick" to get the exit prices closer to historical reality. Honestly, using the tester's visual mode while "control points" is selected will help you narrow in on what settings you want a lot faster than brute force chugging through all the permutations of settings possible here.
