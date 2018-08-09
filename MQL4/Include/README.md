# Include

Ugh... You're in here to *create* reusable code for **trading**,
but instead you're going to *waste your life* reinventing things
like [hashmaps](https://en.wikipedia.org/wiki/Hash_table) and
[collections](https://en.wikipedia.org/wiki/Collection_(abstract_data_type)).
It is the ultimate zen truth in [MQL programming](https://encyclopediadramatica.rs/Computer_science#Software_Development)
to finish
reading the MQL4 user manual and realize **"There is no framework"**,
not even on a basic level. This is where you meet a
[reinvented](https://en.wikipedia.org/wiki/Reinventing_the_wheel),
worse version of [C](https://en.wikipedia.org/wiki/C_(programming_language)),
and either quit or think *"Well, at least it isn't brainfuck"* : 
[https://www.muppetlabs.com/~breadbox/bf/](https://www.muppetlabs.com/~breadbox/bf/)
[https://en.wikipedia.org/wiki/Brainfuck](https://en.wikipedia.org/wiki/Brainfuck)

This directory contains the Portfolio Manager framework, supporting files, and products derived from it.

* BacktestOptimizations : A general pupose class holding custom backtesting metrics.
* Candles : A general purpose framework for analyzing japanese candlesticks and chart patterns.
* CodeGenerator : Helper tools for generating code that I don't want to type. MQL likes making me do things like manually create an iterable list of enumerator values, as if I have the time for typing out all the names of the enumerations littered all over the global scope...
* Common : A collection of general purpose classes.
* Currency Basket : A general purpose framework for evaluating currency baskets.
* EA : Classes defining expert advisors built from the Portfolio Manager framework.
* Generic : MQL5 collections classes ported to MQL4
* Graphcs : MQL5 graphics classes ported to MQL4
* MarketWatch : Handles things you'd do with the Market Watch window, like look up symbol info and open charts.
* PLManager : A profit and loss manager. 
* Portfolio Manager : A general purpose framework for managing a trading portfolio.
* Schedule : A general purpose framework for creating schedules.
* Signals : A collection of classes that generate trading signals.
* Stats : Statistics class, you know, for doing technical analysis.
* Stopwatch : A stopwatch, for measuring time.
* Time : Classes related to doing math with time.
* Unit Testing : A framework for creating unit tests and an assertion library. See Scripts\Tests for examples.
