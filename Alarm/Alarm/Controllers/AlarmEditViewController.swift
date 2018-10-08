//
//  AlarmEditViewController.swift
//  Alarm
//
//  Created by Apple on 04/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

class AlarmEditViewController: UIViewController
{
    @IBOutlet weak var viewDays: UIView!
    @IBOutlet weak var viewFromDate: UIView!
    @IBOutlet weak var viewToDate: UIView!
    @IBOutlet weak var viewEveryday: UIView!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var lblSession: UILabel!
    @IBOutlet weak var txtMinutes: UITextField!
    @IBOutlet weak var txtHours: UITextField!
    @IBOutlet weak var imgIsRepeat: UIImageView!
    @IBOutlet weak var imgIsEveryday: UIImageView!
    @IBOutlet weak var btnFromDate: UIButton!
    @IBOutlet weak var btnToDate: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    let window = UIWindow()
    
    var isRepeat = false
    var isEveryday = false
    var isDate = false
    var isTime = false
    var dateType = ""
    var selectedAlarmTime = Date()
    
    var fromDate = Date()
    var toDate = Date()
    var today = Date()
    
    var selectedDaysArr = NSMutableArray()
    
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()
    var snoozeEnabled: Bool = false
    var enabled: Bool!
    var segueInfo: SegueInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI updates
        self.viewDays.isHidden = true
        self.viewEveryday.isHidden = true
        
        dateTimePicker.minimumDate = Date()
        dateTimePicker.timeZone = TimeZone(abbreviation: "IST")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        alarmModel = Alarms()
    }
    
    //MARK: Button Actions
    
    @IBAction func clickPickerCancel(_ sender: Any)
    {
        self.viewDatePicker.isHidden = true
    }
    
    @IBAction func clickPickerDone(_ sender: Any)
    {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.timeZone = TimeZone(abbreviation: "IST")
        self.viewDatePicker.isHidden = true
        
        if isDate
        {
            if dateType == "from"
            {
                dateFormatterPrint.dateFormat = "dd-MM-yyyy"
                
                let selectedDate = dateFormatterPrint.string(from: dateTimePicker.date)
                
                self.btnFromDate.titleLabel?.text = selectedDate
                fromDate = dateTimePicker.date
            }
            else
            {
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MM-yyyy"
                
                let selectedDate = dateFormatterPrint.string(from: dateTimePicker.date)
                
                self.btnToDate.titleLabel?.text = selectedDate
                toDate = dateTimePicker.date
            }
        }
        else
        {
            dateFormatterPrint.dateFormat = "hh"
            
            let selectedHour = dateFormatterPrint.string(from: dateTimePicker.date)
            self.txtHours.text = selectedHour
            
            dateFormatterPrint.dateFormat = "mm"
            let selectedMinute = dateFormatterPrint.string(from: dateTimePicker.date)
            self.txtMinutes.text = selectedMinute
            
            dateFormatterPrint.dateFormat = "a"
            let selectedSession = dateFormatterPrint.string(from: dateTimePicker.date)
            self.lblSession.text = selectedSession
            
            dateFormatterPrint.dateFormat = "dd-MM-yyyy hh:mm a"
            selectedAlarmTime = dateTimePicker.date
        }
    }
    
    @IBAction func clickToDate(_ sender: Any)
    {
        if btnFromDate.titleLabel?.text == "Select From Date"
        {
            let alert = UIAlertController(title: "Sorry", message: "Please Select From date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            isDate = true
            dateType = "to"
            dateTimePicker.minimumDate = fromDate
            dateTimePicker.datePickerMode = .date
            self.viewDatePicker.isHidden = false
        }
    }
    
    @IBAction func clickFromDate(_ sender: Any)
    {
        isDate = true
        isTime = false
        dateType = "from"
        
        dateTimePicker.datePickerMode = .date
        self.viewDatePicker.isHidden = false
    }
    
    @IBAction func clickTime(_ sender: Any)
    {
        isTime = true
        isDate = false
        dateType = "to"
        
        dateTimePicker.minimumDate = Date()
        dateTimePicker.datePickerMode = .time
        self.viewDatePicker.isHidden = false
    }
    
    @IBAction func clickSnooze(_ sender: UISwitch)
    {
        snoozeEnabled = sender.isOn
    }
    
    @IBAction func clickRepeat(_ sender: Any)
    {
        if !isRepeat
        {
            isRepeat = true
            self.viewFromDate.isHidden = false
            self.viewToDate.isHidden = false
            self.viewEveryday.isHidden = false
            imgIsRepeat.image = UIImage (named: "ic_check_box")
            
            if !isEveryday
            {
                self.viewDays.isHidden = false
            }
            else
            {
                self.viewDays.isHidden = true
            }
        }
        else
        {
            imgIsRepeat.image = UIImage (named: "ic_uncheck_box")
            isRepeat = false
            self.viewFromDate.isHidden = true
            self.viewToDate.isHidden = true
            self.viewEveryday.isHidden = true
            self.viewDays.isHidden = true
            
            selectedDaysArr.removeAllObjects()
        }
    }
    
    @IBAction func clickEveryday(_ sender: Any)
    {
        if !isEveryday
        {
            imgIsEveryday.image = UIImage (named: "ic_check_box")
            isEveryday = true
            self.viewDays.isHidden = true
            
            for i in 0...6
            {
                selectedDaysArr.add(i)
            }
        }
        else
        {
            imgIsEveryday.image = UIImage (named: "ic_uncheck_box")
            isEveryday = false
            self.viewDays.isHidden = false
            selectedDaysArr.removeAllObjects()
        }
    }
    
    @IBAction func clickDays(_ sender: UIButton)
    {
        if selectedDaysArr.contains(sender.tag)
        {
            selectedDaysArr.remove(sender.tag)
          //  sender.isSelected = false
            sender.backgroundColor = .groupTableViewBackground
        }
        else
        {
            selectedDaysArr.add(sender.tag)
          //  sender.isSelected = true
            sender.backgroundColor = .yellow
        }
    }
    
    @IBAction func clickSave(_ sender: Any)
    {
        if !txtHours.hasText || !txtMinutes.hasText
        {
            let alert = UIAlertController(title: "Sorry", message: "Please Select Time to set Alarm", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let date = Scheduler.correctSecondComponent(date: selectedAlarmTime)
            let index = segueInfo.curCellIndex
            var tempAlarm = Alarm()
            tempAlarm.date = date
            tempAlarm.label = segueInfo.label
            tempAlarm.enabled = true
            tempAlarm.mediaLabel = segueInfo.mediaLabel
            tempAlarm.mediaID = segueInfo.mediaID
            tempAlarm.snoozeEnabled = snoozeEnabled
            tempAlarm.repeatWeekdays = segueInfo.repeatWeekdays
            tempAlarm.uuid = UUID().uuidString
            tempAlarm.onSnooze = false
            if segueInfo.isEditMode {
                alarmModel.alarms[index] = tempAlarm
            }
            else
            {
                alarmModel.alarms.append(tempAlarm)
            }
            self.performSegue(withIdentifier: Identifier.saveSegueIdentifier, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Identifier.saveSegueIdentifier {
            let dist = segue.destination as! AlarmListViewController
            let cells = dist.tableView.visibleCells
            for cell in cells {
                let sw = cell.accessoryView as! UISwitch
                if sw.tag > segueInfo.curCellIndex
                {
                    sw.tag -= 1
                }
            }
            alarmScheduler.reSchedule()
        }
    }
    
    static func repeatText(weekdays: [Int]) -> String {
        if weekdays.count == 7 {
            return "Every day"
        }
        
        if weekdays.isEmpty {
            return "Never"
        }
        
        var ret = String()
        var weekdaysSorted:[Int] = [Int]()
        
        weekdaysSorted = weekdays.sorted(by: <)
        
        for day in weekdaysSorted {
            switch day{
            case 1:
                ret += "Sun "
            case 2:
                ret += "Mon "
            case 3:
                ret += "Tue "
            case 4:
                ret += "Wed "
            case 5:
                ret += "Thu "
            case 6:
                ret += "Fri "
            case 7:
                ret += "Sat "
            default:
                //throw
                break
            }
        }
        return ret
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
