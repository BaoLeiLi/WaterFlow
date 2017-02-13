# WaterFlow
瀑布流布局

####现在很多软件都在使用瀑布流布局来展现产品，于是就自己写了一个，有不完善的地方，希望指点<br>

####先看一下效果图<br>
![](https://github.com/BaoLeiLi/WaterFlow/blob/master/WaterFlow/img/waterFlow.png)

###Description<br>
####为了使用起来更加方便，在设计的时候仿照系统的UITableView，有两个代理Delegate和DataSource，同时考虑到内存管理方面，也仿照系统的UITableView设计模式，添加了缓存池，防止无限创建导致内存泄漏<br>
####<br>
###Using<br>
####可完全仿照使用系统UITableView的使用方法<br>
####Demo的WaterFlow.h中有方法和代理的说明<br>
