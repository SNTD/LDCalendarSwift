//
//  LDCalendar.swift
//  LDCalendarSwift
//
//  Created by lidi on 11/18/15.
//  Copyright © 2015 lidi. All rights reserved.
//

import UIKit
import Timepiece

private let kUnitWidth:CGFloat = 35 * kScreenRadio//每小格宽度
private let kRow:CGFloat       = 1 + 6//一,二,三... 1行 日期6行
private let kCol:CGFloat       = 7
private let kTotalNum:Int      = (Int)((kRow - 1) * kCol)//格子总数
private let kBtnStartTag       = 100

typealias DaysSelectedBlock = [NSTimeInterval] -> ()

class LDCalendar: UIView {
    //UI
    private var dateBgView:UIView!
    private var titleLab:UILabel!
    private var contentBgView:UIView!
    private var doneBtn:UIButton!
    //Data
    private var month:Int                              = 0
    private var year:Int                               = 0
    private var currentMonthDaysArray:[NSTimeInterval] = []
    private var currentMonthStartIndex:Int             = 0
    private var selectArray:[NSTimeInterval]           = []

    //供外面调用的接口
    var complete:DaysSelectedBlock!
    var defaultDays:[NSTimeInterval] = [] {
        didSet {
            selectArray = defaultDays
            //已选择的高亮选中
            refreshDateView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dateBgView                 = UIView.init(frame: frame)
        dateBgView.alpha           = 0.3
        dateBgView.backgroundColor = UIColor.blackColor()
        self.addSubview(dateBgView)
        
        contentBgView                        = UIView.init(frame: CGRectMake((kScreenWidth - kUnitWidth*kCol)/2.0, 100.0, kUnitWidth*kCol, 42 + kUnitWidth*kRow + 50))
        contentBgView.layer.cornerRadius     = 2.0
        contentBgView.layer.masksToBounds    = true
        contentBgView.userInteractionEnabled = true
        contentBgView.backgroundColor        = UIColor.whiteColor()
        self.addSubview(contentBgView)
        
        let leftImage:UIImageView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(contentBgView.frame)/3.0 - 8 - 10, (42-13)/2.0, 8, 13))
        leftImage.image           = UIImage.init(named: "com_arrows_right")
        leftImage.transform       = CGAffineTransformMakeRotation(CGFloat(M_PI))
        contentBgView.addSubview(leftImage)
        
        let rightImage:UIImageView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(contentBgView.frame)*2/3.0 + 8, (42-13)/2.0, 8, 13))
        rightImage.image           = UIImage.init(named: "com_arrows_right")
        contentBgView.addSubview(rightImage)
        
        titleLab                        = UILabel.init(frame: CGRectMake(0, 0, CGRectGetWidth(contentBgView.frame), 42))
        titleLab.textColor              = UIColor.blackColor()
        titleLab.font                   = UIFont.systemFontOfSize(14)
        titleLab.textAlignment          = NSTextAlignment.Center
        titleLab.userInteractionEnabled = true
        contentBgView.addSubview(titleLab)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "switchMonthTap:")
        titleLab.addGestureRecognizer(tapGesture)
        
        let upLine:UIView      = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(titleLab.frame) - 0.5, CGRectGetWidth(contentBgView.frame), 0.5))
        upLine.backgroundColor = UIColor(hexString: "dddddd")
        contentBgView.addSubview(upLine)
        
        dateBgView                        = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(titleLab.frame), CGRectGetWidth(contentBgView.frame), kUnitWidth*kRow))
        dateBgView.userInteractionEnabled = true;
        dateBgView.backgroundColor        = UIColor(hexString: "ededed")
        contentBgView.addSubview(dateBgView)
        
        
        doneBtn = UIButton.init(type: .Custom)
        doneBtn.frame            = CGRectMake((CGRectGetWidth(contentBgView.frame) - 150) / 2.0, CGRectGetHeight(contentBgView.frame) - 40, 150, 30)
        doneBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        doneBtn.setBackgroundImage(UIImage.init(named: "b_com_bt_blue_normal")!.stretchableImageWithLeftCapWidth(15, topCapHeight: 10), forState: .Normal)
        doneBtn.setBackgroundImage(UIImage.init(named: "b_com_bt_blue_normal")!.stretchableImageWithLeftCapWidth(15, topCapHeight: 10), forState: .Selected)
        doneBtn.setBackgroundImage(UIImage.init(named: "com_bt_gray_normal")!.stretchableImageWithLeftCapWidth(15, topCapHeight: 10), forState: .Disabled)
        doneBtn.addTarget(self,action:Selector("doneBtnClick"),forControlEvents:.TouchUpInside)
        doneBtn.setTitle("确定", forState: .Normal)
        contentBgView.addSubview(doneBtn)
        
        //初始化数据
        initData()
    }

    private func initData() {
        self.year = NSDate.today().year
        self.month = NSDate.today().month
        
        for _ in 0...kTotalNum {
            currentMonthDaysArray.append(0)
        }
        
        refreshDateTitle()
    }
    
    func switchMonthTap(tap:UITapGestureRecognizer) {
        let loc:CGPoint = tap.locationInView(titleLab)
        let titleLabWidth:CGFloat = CGRectGetWidth(titleLab.frame)
        if loc.x <= titleLabWidth/3.0 {
            leftSwitch()
        }else {
            rightSwitch()
        }
    }
    
    private func leftSwitch() {
        //左
        if month > 1 {
            month -= 1
        }else {
            month = 12
            year -= 1
        }
        
        refreshDateTitle()
    }
    private func rightSwitch() {
        if month < 12 {
            month += 1
        }else {
            month = 1
            year += 1
        }
        
        refreshDateTitle();
    }
    
    private func refreshDateTitle() {
        titleLab.text = "\(month)月,\(year)年"
        showDateView()
    }
    
    private func showDateView() {
        //移除所有子视图
        for view in dateBgView.subviews {
            view.removeFromSuperview()
        }
        
        drawTitles()
        
        drawCurrentMonthDate()
        
        refreshDateView()
    }
    
    func drawTitles() {
        let titles = ["一","二","三","四","五","六","日"]
        
        var baseRect:CGRect = CGRectMake(0, 0, kUnitWidth, kUnitWidth)
        for i in 0..<titles.count {
            let lab:UILabel = UILabel.init(frame: baseRect)
            lab.textColor = UIColor(hexString: "848484")
            lab.textAlignment = NSTextAlignment.Center
            lab.font = UIFont.systemFontOfSize(10.0)
            lab.text = titles[i]
            dateBgView.addSubview(lab)
            
            baseRect.origin.x += baseRect.size.width
        }
    }
    
    func drawCurrentMonthDate() {
        let monthFirstDay = NSDate.date(year: year, month: month, day: 1)
        currentMonthStartIndex = monthFirstDay.weekday
        if currentMonthStartIndex == 1 {
            currentMonthStartIndex = 6
        }else {
            currentMonthStartIndex -= 2
        }
        print("\(currentMonthStartIndex)")
        var baseRect:CGRect = CGRectMake(CGFloat(currentMonthStartIndex)*kUnitWidth, kUnitWidth, kUnitWidth, kUnitWidth)
        for var i = currentMonthStartIndex; i < kTotalNum; i++ {
            if CGFloat(i) % kCol == 0 && i != 0 {
                baseRect.origin.y += baseRect.size.height
                baseRect.origin.x = 0.0
            }
            
            createBtn(i - currentMonthStartIndex, frame:baseRect)
            
            baseRect.origin.x += baseRect.size.width
        }
    }
    
    func createBtn(index:Int , frame:CGRect) -> UIButton {
        let btn = UIButton.init(type: .Custom)
        btn.tag = kBtnStartTag + index
        btn.frame = frame
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        
        let monthFirstDay = NSDate.date(year: year, month: month, day: 1)
        let date:NSDate = monthFirstDay + index.days
        currentMonthDaysArray[index] = date.timeIntervalSince1970
        var title:String = String(date.day)
        if date.isEqualToDate(NSDate.today()) {
            title = "今天"
            btn.layer.borderColor = UIColor(hexString: "f49e79").CGColor
            btn.layer.borderWidth = 0.5
        }
        else if (date.day == 1) {
            let monthLab:UILabel = UILabel.init(frame: CGRectMake(0, frame.size.height - 7, frame.size.width, 7))
            monthLab.textAlignment = NSTextAlignment.Center
            monthLab.font = UIFont.systemFontOfSize(7)
            monthLab.textColor = UIColor(hexString: "c0c0c0")
            monthLab.text = String(date.month)
            btn.addSubview(monthLab)
        }
        
        if date > NSDate.today() {
            btn.setTitleColor(UIColor(hexString: "2b2b2b"), forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            
            btn.setBackgroundImage(UIImage.imageWithColor(UIColor.init(hexString: "77d2c5")), forState: .Selected)
            btn.setBackgroundImage(UIImage.imageWithColor(UIColor.clearColor()), forState: .Normal)
                
            btn.enabled = true
        } else {
            btn.setTitleColor(UIColor(hexString: "bfbfbf"), forState: .Disabled)
            btn.enabled = false
        }
        
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self,action:Selector("btnClick:"),forControlEvents:.TouchUpInside)
        dateBgView.addSubview(btn)
        
        return btn
    }
    func btnClick(btn:UIButton) {
        btn.selected = !btn.selected
        
        //刷新存储的日期数组
        let currentInterval:NSTimeInterval = currentMonthDaysArray[btn.tag - kBtnStartTag]
        if btn.selected == true {
            if !selectArray.contains(currentInterval) {
                selectArray.append(currentInterval)
            }
        }else {
            if selectArray.contains(currentInterval) {
                selectArray.removeAtIndex(selectArray.indexOf(currentInterval)!)
            }
        }
        
        
        //如果点击的时间不在本月，切换到下一月
        let date = NSDate.init(timeIntervalSince1970: currentInterval)
        if btn.selected && date.month > self.month {
            rightSwitch()
        }
    }
    
    func refreshDateView() {
        for i in 0..<kTotalNum {
            let btn = dateBgView.viewWithTag(kBtnStartTag + i) as?UIButton
            if selectArray.contains(currentMonthDaysArray[i]) {
                btn?.selected = true
            }
        }
    }
    
    func doneBtnClick() {
        if complete != nil {
            complete(selectArray)
        }
        hide()
    }
    func show() {
        self.hidden = false
    }
    
    func hide() {
        self.hidden = true
    }
}