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
private let kTotalNum:Int  = (Int)((kRow - 1) * kCol)//格子总数

typealias DaysSelectedBlock = [NSTimeInterval] -> ()

class LDCalendar: UIView {
    //UI
    var dateBgView:UIView!
    var titleLab:UILabel!
    var contentBgView:UIView!
    var doneBtn:UIButton!
    //Data
    var month:Int = 0
    var year:Int = 0
    var today:NSDate!
    var currentMonthDaysArray:[NSTimeInterval] = []
    var selectArray:[NSTimeInterval] = [2,2]
    var touchRect:CGRect = CGRectZero
    var complete:DaysSelectedBlock!
    
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
        contentBgView.addGestureRecognizer(tapGesture)
        
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