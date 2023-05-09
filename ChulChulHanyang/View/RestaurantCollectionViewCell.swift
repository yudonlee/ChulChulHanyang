//
//  RestaurantCollectionViewCell.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import UIKit

final class RestaurantCollectionViewCell: UICollectionViewCell {
    static let identifier = "RestaurantCollectionViewCell"
    
    // MARK: - property
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .mainBlue
            } else {
                contentView.backgroundColor = .mainGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .mainGray
        
        contentView.addSubviews(nameLabel)
        
        let nameLabelConstraints = [
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22)
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
    
    func configure(with restaurant: String) {
        nameLabel.text = restaurant
    }
    
}
