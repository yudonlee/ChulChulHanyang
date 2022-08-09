//
//  DietCollectionViewCell.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import UIKit

class DietCollectionViewCell: UICollectionViewCell {
    
    private var menu: [String] = ["조식", "닭곰탕", "미트볼케찹조림", "청포묵김가루무침", "무말랭이고춧잎무침", "포기김치", "쌀밥"]

    static let identifier = "DietCollectionViewCell"
    
    lazy private var menuTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        table.allowsSelectionDuringEditing = false
        table.separatorStyle = .none
        table.isUserInteractionEnabled = false
        return table
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
    
    func configure(with model: [String]) {
        menu = model
        DispatchQueue.main.async { [weak self] in
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
        
        cell.textLabel?.text = menu[indexPath.row]
        
        cell.textLabel?.textAlignment = indexPath.row != 0 ? .center : .left
        cell.textLabel?.font = indexPath.row != 0 ? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 25, weight: .bold)
        if menu[indexPath.row] == "[Dam-A]" || menu[indexPath.row] == "[Pangeos]" {
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        
        return cell
    }
    
    
}

extension DietCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 40
        }
        return 50
    }
}

