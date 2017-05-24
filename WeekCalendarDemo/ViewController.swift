//
//  ViewController.swift
//  WeekCalendarDemo
//
//  Created by Ducere on 24/05/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeekViewDelegate {

    var calendarView : WeekView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addCalenderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addCalenderView() {
        calendarView = WeekView(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 60))
        calendarView.backgroundColor = UIColor.groupTableViewBackground
        calendarView.delegate = self
        self.view.addSubview(calendarView)
    }
    
    func weekViewSelection(weekView: WeekView, didSelectedDate: Date) {
        print("Selected Date :@", didSelectedDate)
    }
}

