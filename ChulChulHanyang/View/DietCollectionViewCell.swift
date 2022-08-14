//
//  DietCollectionViewCell.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import UIKit

class DietCollectionViewCell: UICollectionViewCell {
    
    private var menu: [String] = []
    private var type: RestaurantType = .HumanEcology
    private let price: [String: String] = ["[Dam-A]": "5500원", "[Pangeos]": "5500원", "[정식]": "5500원", "[일품]": "5500원", "[덮밥]": "4200원", "석식": "5500원"]
    
    static let identifier = "DietCollectionViewCell"
    
    lazy private var menuTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        table.allowsSelectionDuringEditing = false
        table.separatorStyle = .none
        table.isUserInteractionEnabled = false
        return table
    }()
    
    lazy private var priceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        label.text = "5500원"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTableViewProtocol()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    private func setTableViewProtocol() {
        menuTable.delegate = self
        menuTable.dataSource = self
    }
    
    private func render() {
        clipsToBounds = true

        menuTable.frame = contentView.bounds
        
        self.addSubviews(menuTable)
        
        let menuTableConstraints = [
            menuTable.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            menuTable.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            menuTable.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            menuTable.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
        ]
        
        NSLayoutConstraint.activate(menuTableConstraints)
    }
    
    func configure(with model: MenuViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            self?.menu = model.diet
            self?.type = model.type
            self?.menuTable.reloadData()
        }
    }
}

extension DietCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        
        var content = cell.defaultContentConfiguration()
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        content.text = menu[indexPath.row]
        content.textProperties.adjustsFontForContentSizeCategory = true
        content.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        
        content.textProperties.font = indexPath.row != 0 ? UIFont.systemFont(ofSize: 16) : UIFont.systemFont(ofSize: 18, weight: .bold)
        content.textProperties.alignment = indexPath.row != 0 ? .center : .natural

        if indexPath.row == 0 {
            if let text = content.text, let time = type.restaurantTime[text] {
                content.secondaryText = time
                content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                content.prefersSideBySideTextAndSecondaryText = true
            }
        }
        
        if let text = content.text, text.contains("[") {
            content.textProperties.alignment = .natural
            content.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }

        cell.contentConfiguration = content
        return cell
    }
    
    
}

extension DietCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 35
        }
        return 40
    }
}

