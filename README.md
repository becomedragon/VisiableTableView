# VisiableTableView
a method that can detect tableview cell appear or disappear by custom ratio



* default ratio is 0.5 , means when a cell in tableview is scoll out 50% percent, the cell is disappear, ohterwise cell is appear.

* Through KVO to listen tableview contentOffset, and judge cell's rect.

* There have two method to control listen behavior: `startListen`,`endListen` 

  

![Jietu20190729-145348 2](https://github.com/becomedragon/VisiableTableView/blob/master/Jietu20190729-145348%202.jpg)

