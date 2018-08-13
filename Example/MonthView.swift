//
//  MonthView.swift
//  KNDCalendarView_Example
//
//  Created by Rogelio Contreras on 8/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
    func didChangeMonthAndYear(monthIndex:Int, yearIndex:Int)
}

class MonthView: UIView {
    var monthsArray = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    var currentMonthIndex = 0
    var currentYear:Int = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
//        self.backgroundColor = UIColor(named: "growee_pink")
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        self.setupView()
        
        btnLeft.isEnabled = false
    }
    
    @objc func btnLeftRightAction(sender: UIButton){
        if sender == btnRight {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
            
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        lblName.text = "\(monthsArray[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    @objc func btnCenterAction(sender: UIButton){
        self.delegate?.didChangeMonthAndYear(monthIndex: 3, yearIndex: 4)
    }
    
    func setupView(){
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive =  true
        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lblName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        lblName.text = "\(monthsArray[currentMonthIndex]) \(currentYear)"
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive = true
        btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        btnRight.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive = true
        btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        btnLeft.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    let lblName: UILabel = {
        let lbl = UILabel()
        lbl.text = " "
        lbl.textColor = Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let btnCenter: UIButton = {
        let btn = UIButton()
        btn.setTitle(" ", for: .normal)
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .disabled)
        return btn
    }()
    
    let btnRight: UIButton = {
        let btn = UIButton()
        //btn.setTitle(">", for: .normal)
        btn.setImage(UIImage(named: "right_arrow_icon"), for: .normal)
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .disabled)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn = UIButton()
        // btn.setTitle("<", for: .normal)
        btn.setImage(UIImage(named: "left_arrow_icon"), for: .normal)
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .disabled)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
