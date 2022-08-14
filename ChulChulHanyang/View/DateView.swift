//
//  DateView.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit

class DateView: UIView {
    
    private var userDate: Date = Date()
    
    private var parent: MainViewController?
    
    lazy private var leftChevronButton: UIButton = { button in
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(minusOneDayToCurrent), for: .touchUpInside)
        button.tintColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 16)
        return button
        
    }(UIButton())
    
    lazy private var rightChevronButton: UIButton = { button in
        
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(addOneDayToCurrent), for: .touchUpInside)
        button.tintColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 16)
        return button
    }(UIButton())
    
    lazy private var dateLabel: UILabel = { label in
        label.text = userDate.dateText
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }(UILabel())
    
    lazy private var dayLabel: UILabel = { label in
        label.text = userDate.dayText
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("DateView Error")
    }
    
    private func render() {
        addSubviews(dateLabel, dayLabel, leftChevronButton, rightChevronButton)
        
        let dateLabelConstriants = [
            dateLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 4),
            dateLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ]
        
        let dayLabelConstraints = [
            dayLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            dayLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ]
        
        let leftChevronButtonConstraints = [
            leftChevronButton.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -16),
            leftChevronButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        let rightChevronButtonConstraints = [
            rightChevronButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            rightChevronButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        [dateLabelConstriants, dayLabelConstraints, leftChevronButtonConstraints, rightChevronButtonConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
        
    }
    
    
    private func setDateAndDayLabel() {
        dateLabel.text = userDate.dateText
        dayLabel.text = userDate.dayText
    }
    
}


extension DateView {
    
    func userDateData() -> Date {
        return userDate
    }
    
    func setParentViewController(view: MainViewController) {
        parent = view
    }
    
    @objc func addOneDayToCurrent() {
        guard let date = Calendar.current.date(byAdding: .day, value: 1, to: userDate) else {
            return
        }
        userDate = date
        setDateAndDayLabel()
        parent?.requestData()
    }
    
    @objc func minusOneDayToCurrent() {
        guard let date = Calendar.current.date(byAdding: .day, value: -1, to: userDate) else {
            return
        }
        userDate = date
        setDateAndDayLabel()
        parent?.requestData()
    }
    
}