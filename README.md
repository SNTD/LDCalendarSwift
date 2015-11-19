简单的日历选择器Swift版(需要OC版的可点击:[基于手势的OC版](https://github.com/SNTD/LDCalendarView)）

1.今天用红框标注，只能选择今天以后的工作日期，支持跨月份多选

2.因为每个月的第一天在第一行，所以有时候需要6行才能显示，仿照铁路12306的日历，显示了6行，  选择点击下一个月的日期时会自动切到下一个月，但是可以直接在当前月取消。

3.**基于UIButton 的Normal Disable Selected 三种状态实现, 简单易懂。**

## 日历效果演示

![](https://github.com/sntd/LDCalendar/raw/master/Picture/LDCalendar.gif)


## 功能说明：

详情可查看Demo中代码

``` 
if calendar == nil {
    calendar = LDCalendar.init(frame: self.view.frame)
    self.view.addSubview(calendar)

    calendar.complete = { (result) -> Void in
        self.seletedDays = result
        self.tableView.reloadData()
    }
}
calendar.defaultDays = self.seletedDays
calendar.show()
```
## 特殊说明
因为用到了NSDate的第三方扩展[Timepiece](https://github.com/naoty/Timepiece)，所以此日历需要iOS8+