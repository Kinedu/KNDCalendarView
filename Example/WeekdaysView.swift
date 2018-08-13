//
//  WeekdaysView.swift
//  KNDCalendarView_Example
//
//  Created by Rogelio Contreras on 8/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        var daysArray = ["Do","Lu","Ma","Mi","Ju","Vi","Sa"]
        for i in 0..<7 {
            let lbl = UILabel()
            lbl.text = daysArray[i]
            lbl.textColor = Style.weekdaysLblColor
            lbl.textAlignment = .center
            stackView.addArrangedSubview(lbl)
        }
    }
    
    let stackView: UIStackView = {
        let stalckViews = UIStackView()
        stalckViews.distribution = .fillEqually
        stalckViews.translatesAutoresizingMaskIntoConstraints = false
        return stalckViews
    }()
    
}
