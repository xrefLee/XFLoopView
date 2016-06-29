# XFLoopView
###一个轮播图的 demo
####实现原理:
在一个 scrollview 上，用3张 imageView 实现轮播,左边 imageView、中间 imageView、右边 imageView。动画效果完成中间的 imageView 滑动到左边，右边的 imageView 滑动到中间。

在这一时刻同时做两件事情：

1.把右边的imageView 里的image赋值给中间的 imageView，而右边的 imageView 传入下一张 image。
2.把中间的 imageView 放回屏幕中间，把右边的 imageView 放回屏幕右边右边，（改变 scrollview 的偏移量）

####关于缓存：
传入图片的方式有两种：

imageArr：
传入 image 或者 url，传入 url 是调用的 sdwebimage 实现的缓存。

imageUrlArr：
传入 url 自定义的缓存路径，存储到沙盒的 plist 里。