# Metatrader
Expert advisors, scripts, indicators and code libraries for Metatrader.

## Manual Test Environment Setup

1) Install a copy of Metatrader to do your development work in, and create a demo account. You can get Metatrader 4 and a demo account from [Oanda](https://www.oanda.com/forex-trading/platform/metatrader-platform), [Forex.com](https://www.forex.com/en-us/trading-platforms/metatrader/download-metatrader/), etc.
2) Create a clone of this repository's master branch on your local machine.
3) Open Metatrader, in the main menu click File -> Open Data Folder.

![Open Data Folder menu item image](README%20images/Open%20Data%20Folder.png)

4) Cut and paste the .git folder from your cloned repo into your Metatrader data folder. The .git folder is hidden, so you might need to show hidden files if you don't see it.
5) Delete the local copy of your clone.
6) In your git tool of choice, when it is complaining that the repo has disappeared, find the repo in your Metatrader data folder instead of wherever you cloned it to.
7) Using your git tool, it should show a bunch of changes since you've moved the .git folder. Tell it to undo all of the changes. There should be new files in your data folder now, and the git tool should be saying that there aren't any changes.
8) Fetch and Pull the latest changes in the master branch of your clone, there shouldn't be any at this point but just in case I checked something in while you were setting up... This should update your Metatrader data folder with all the code. Repeat this whenever you need to get updates of the bots. Let me know if you end up with any files that your git tool thinks you've changed, I'll update the settings to ignore them so you aren't bothered by it. Alternatively, you can just select the file and tell git to undo the changes if you've accidentally edited something.

## Dev Environment Setup

Setting up an environment with the intention of editing the source code, and possibly submitting pull requests, is the same as setting up to do manual testing. The only real difference is that you'd fork this repo and clone your fork to your local machine, instead of cloning this repo directly. There's nothing special after that, just the normal git stuff like switching branches will swap out different versions of the source code in your Metatrader terminal (so recompile). Tracking upstream/master in your master branch and merging to your dev branches is just the same as any other standard repo, nothing special to do there.

I do ask that you use the "styler" tool in Metaeditor, use spaces instead of tabs so the formatter will actually work, and that's about it really. If your pull request is accepted then it'll end up as part of this repo, which is totally open source and licensed for basically any use case. If you don't mind other people using your code in commercial products, and not paying you for that, then submit away. I'm building this thing with the express intention of letting people use it for fun and profit, without compensating me. I mean they can if they really want to, I'll take bitcoins or coffee, but it's not a requirement at all. If you're the greedy type who wants to cling to your simple code because nobody is going to pay you for it, then don't submit a pull request and please enjoy this library to your heart's content! :D