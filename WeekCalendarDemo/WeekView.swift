//
//  WeekView.swift
//  WeekCalendarDemo
//
//  Created by Ducere on 24/05/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit

struct WeekViewCons {
    
    static let weekViewCount = 7
    static let dayTitleViewHeight = 20
    static let dayTitleTagInitialVal = 100
}

protocol WeekViewDelegate {
    func weekViewSelection(weekView : WeekView, didSelectedDate : Date)
}

class WeekView: UIView {
    
    var monthNameLbl : UILabel!
    var dayInfoView : UIView!
    var weekStartDate : Date?
    var weekEndDate : Date?
    
    var dayTextColor : UIColor?

    var currentWeekDaysList : NSMutableArray = NSMutableArray()
    
    var delegate : WeekViewDelegate?
    
    var lightGrayColor : UIColor = {
        return UIColor.lightGray
    }()
    
    var dayFontFamily : UIFont? = {
        return UIFont(name: "Raleway-Regular", size: 12)
    }()
    
    var monthFont : UIFont? = {
        return UIFont(name: "Raleway-Regular", size: 16)
    }()
    
    
    //MARK:- Initial View setup
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        self.addMothNameLable()
        addDayInfoSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- Add Subviews
    func addMothNameLable() {
        
        monthNameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 20))
        monthNameLbl.textAlignment = .center
        monthNameLbl.text = "July, 2017"
        monthNameLbl.font = monthFont
        self.addSubview(monthNameLbl)
        
    }
    
    func addDayInfoSubView() {
        
        dayInfoView = UIView(frame: CGRect(x: 0, y: 20, width: self.frame.size.width, height: 40))
        self.addSubview(dayInfoView)
        
        let rightSwifeGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightSwifeGestureAction(rightSwife:)))
        rightSwifeGesture.direction = .right
        self.addGestureRecognizer(rightSwifeGesture)
        
        let leftSwiftGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwifeGestureAction(leftSwift:)))
        leftSwiftGesture.direction = .left
        self.addGestureRecognizer(leftSwiftGesture)
     
        initDailyViews()

    }
    
    func initDailyViews() {
        
        let dayWidth : CGFloat = self.bounds.size.width/CGFloat(WeekViewCons.weekViewCount)
        let today = Date()
        weekStartDate = today.getWeekStartDate(fromDate: today)
        for view in self.dayInfoView.subviews {
            view.removeFromSuperview()
        }
        
        currentWeekDaysList.removeAllObjects()
        
        for var i in 0..<WeekViewCons.weekViewCount {
            let nextDate = weekStartDate?.getNextDay(value: i, currentDate: weekStartDate)
            currentWeekDaysList.add(nextDate!)
            
            dayTitleViewForDate(date: nextDate, frame: CGRect(x: Int(dayWidth)*i, y: 10, width: Int(dayWidth), height: WeekViewCons.dayTitleViewHeight), tagVal: i)
        }
        
        monthNameLbl.text = weekStartDate?.getMonthAndYear(date: weekStartDate!)
    }
    
    func dayTitleViewForDate(date : Date?, frame : CGRect, tagVal : Int) {
        
        let currentDateLbl = UILabel(frame: CGRect(x: frame.origin.x + frame.size.width/4 , y: 5, width: 30, height: 30))
        currentDateLbl.backgroundColor = UIColor.blue
        currentDateLbl.layer.masksToBounds = true
        currentDateLbl.layer.cornerRadius = currentDateLbl.frame.size.width/2
        
        let dayLbl : UILabel = UILabel(frame: frame)
        dayLbl.backgroundColor = UIColor.clear
        dayLbl.textAlignment = .center
        dayLbl.font = dayFontFamily
        dayLbl.text = "\((weekStartDate?.dayOfWeek(date: date!))!)"
        dayLbl.isUserInteractionEnabled = true
        dayLbl.tag = WeekViewCons.dayTitleTagInitialVal + tagVal
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(dayTitleViewDidClick(singleTap:)))
        
        let today = Date()

        if ((weekStartDate?.fullDateToYear(date: date!))! == (weekStartDate?.fullDateToYear(date: today))!) {
            
            dayInfoView.addSubview(currentDateLbl)
            dayLbl.textColor = UIColor.white
            dayLbl.addGestureRecognizer(singleFingerTap)

            
        } else  if (((weekStartDate?.fullDateToYear(date: date!))! > (weekStartDate?.fullDateToYear(date: today))!) && ((weekStartDate?.monthOfWeek(date: date!))!  >= (weekStartDate?.monthOfWeek(date: today))!)) || (((weekStartDate?.monthOfWeek(date: date!))!  > (weekStartDate?.monthOfWeek(date: today))!) && ((weekStartDate?.yearOfWeek(date: date!))!  >= (weekStartDate?.yearOfWeek(date: today))!)) {
            
            dayLbl.textColor = lightGrayColor
            
        } else {
            
            dayLbl.addGestureRecognizer(singleFingerTap)
        }
        
        dayInfoView.addSubview(dayLbl)

    }

    
    //MARK:- Gestures
    
    func dayTitleViewDidClick(singleTap : UITapGestureRecognizer) {
        
        var index = 0
        for view in self.dayInfoView.subviews {
            let anotherLbl : UILabel = view as! UILabel
            if anotherLbl.tag >= WeekViewCons.dayTitleTagInitialVal {
                anotherLbl.text = "\((weekStartDate?.dayOfWeek(date: currentWeekDaysList[index] as! Date))!)"
                index = index + 1
            }
        }
        
        let lbl : UILabel = singleTap.view as! UILabel
        lbl.text = weekStartDate?.getDayNameFromDate(date: currentWeekDaysList[lbl.tag - WeekViewCons.dayTitleTagInitialVal] as! Date)
        
        delegate?.weekViewSelection(weekView: self, didSelectedDate: currentWeekDaysList[lbl.tag - WeekViewCons.dayTitleTagInitialVal] as! Date)
    }
    
    func rightSwifeGestureAction(rightSwife : UISwipeGestureRecognizer) {
        print("Right Swife")
        directionSwifeAnimation(isSwiftRight: true, isToday: false, selectedDate: nil)
    }
    
    func leftSwifeGestureAction(leftSwift : UISwipeGestureRecognizer) {
        print("Left Swife")
        directionSwifeAnimation(isSwiftRight: false, isToday: false, selectedDate: nil)
    }
    
    func directionSwifeAnimation(isSwiftRight : Bool, isToday : Bool, selectedDate : Date?) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            if isSwiftRight == true {
                self.initPreviousOrNextViews(isNext: true)
            } else {
                self.initPreviousOrNextViews(isNext: false)
            }
        }) { (finished) in
        }
    }
    
    func initPreviousOrNextViews(isNext : Bool) {
        
        let dayWidth : CGFloat = self.bounds.size.width/CGFloat(WeekViewCons.weekViewCount)
        if !isNext {
            weekEndDate = currentWeekDaysList.lastObject as? Date
            weekStartDate = weekStartDate?.getPreviousOrNextWeek(weekDate: weekEndDate!, value: 1)
        } else {
            weekStartDate = weekStartDate?.getPreviousOrNextWeek(weekDate: weekStartDate!, value: -1)
        }
        for view in self.dayInfoView.subviews {
            view.removeFromSuperview()
        }
        
        currentWeekDaysList.removeAllObjects()
        
        for var i in 0..<WeekViewCons.weekViewCount {
            let nextDate = weekStartDate?.getNextDay(value: i, currentDate: weekStartDate)
            currentWeekDaysList.add(nextDate!)
            
            dayTitleViewForDate(date: nextDate, frame: CGRect(x: Int(dayWidth)*i, y: 10, width: Int(dayWidth), height: WeekViewCons.dayTitleViewHeight), tagVal: i)
        }
        
        monthNameLbl.text = weekStartDate?.getMonthAndYear(date: weekStartDate!)
    }
    
    
}
