//
//  KNDCalendarView.swift
//  KNDCalendarView_Example
//
//  Created by Juan Sosa, Rogelio Contreras, Alex de la Rosa on 8/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.gray
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.gray
    
}

protocol CalendarViewDelegate: class {
    func didCleanInfo()
    func didShowAllEventsDetail(event:[KNDCalendarEvent])
    
}

@IBDesignable
class KNDCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    var delegate: CalendarViewDelegate?
    var allEventsOfDay = [KNDCalendarEvent()]
    var eventsSource : [KNDCalendarEvent] = []
    
    @IBInspectable var selectionColor : UIColor = .blue
    @IBInspectable var currentDayColor : UIColor = .yellow
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        initializeView()
        
    }
    
    func changeTheme(){
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.stackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor = UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        }else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.showEvent(flag: self.setEvent(day: calcDate))
            
            cell.lbl.text = "\(calcDate)"
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.lbl.textColor = UIColor.lightGray
            }else if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.backgroundColor = currentDayColor
                cell.lbl.textColor = UIColor.white
                
            }else{
                cell.isUserInteractionEnabled = true
                cell.lbl.textColor = Style.activeCellLblColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? dateCVCell
        cell?.backgroundColor = selectionColor
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = UIColor.white
        let calcDate = indexPath.row - firstWeekDayOfMonth + 2
        if self.setEvent(day: calcDate) {
            self.delegate?.didShowAllEventsDetail(event: self.allEventsOfDay)
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? dateCVCell
        cell?.backgroundColor = UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
        self.delegate?.didCleanInfo()
        let calcDate = indexPath.row - firstWeekDayOfMonth + 2
        if  calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
            cell?.backgroundColor = currentDayColor
            cell?.lbl.textColor = UIColor.white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section:Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section:Int) -> CGFloat {
        return 8.0
    }
    
    func setEvent(day: Int) -> Bool {
        self.allEventsOfDay.removeAll()
        var flag: Bool = false
        for event in eventsSource {
            if  event.startTypeDate.month == currentMonthIndex  && event.startTypeDate.year == currentYear {
                if  event.startTypeDate.day == day{
                    self.allEventsOfDay.append(event)
                    flag = true
                }else if day > event.startTypeDate.day! && day <= event.endTypeDate.day! {
                    self.allEventsOfDay.append(event)
                    flag = true
                }
            }
        }
        return flag
    }
    
    
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        myCollectionView.reloadData()
        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    
    func didChangeMonthAndYear(monthIndex: Int, yearIndex: Int) {
        
    }
    
    func setupViews(){
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        monthView.delegate = self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
    
    let monthView: MonthView = {
        let v = MonthView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v = WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection = false
        return myCollectionView
    }()
}

@objc protocol DateCellDelegate {
    @objc optional func didAddEvent()
}

@IBDesignable
class dateCVCell: UICollectionViewCell {
    
    @IBInspectable var alertColor : UIColor = .orange
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addEventCell))
        tapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addEventCell() {
        let alert = UIAlertController(title: "UIAlertController", message: "Would you like  how to use iOS alerts?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        // self.present(alert, animated: true, completion: nil)
    }
    
    func showEvent(flag:Bool){
        registerAlert.isHidden = !flag
        
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(registerAlert)
        registerAlert.frame = CGRect(x:0, y: 0, width:8, height:8)
        //registerAlert.topAnchor.constraint(equalTo: topAnchor).isActive = true
        //registerAlert.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        registerAlert.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        registerAlert.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = Colors.darkGray
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let registerAlert: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .orange
        return view
    }()
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
