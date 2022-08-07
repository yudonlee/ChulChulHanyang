//
//  DateView.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit

class DateView: UIView {

    private let leftChevronButton: UIButton = { button in
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .black
        return button
    
    }(UIButton())
    
    private let rightChevronButton: UIButton = { button in
        
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        button.tintColor = .black
        return button
    }(UIButton())
    
    private let dateLabel: UILabel = { label in
        label.text = Date().dateText
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }(UILabel())
    
    private let dayLabel: UILabel = { label in
        label.text = Date().dayText
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
    
}
