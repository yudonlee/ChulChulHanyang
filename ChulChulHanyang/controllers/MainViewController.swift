//
//  MainViewController.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit

final class MainViewController: UIViewController {
    
    lazy private var data: [[String]] = [[String]]()
    lazy private var datePartView: DateView = DateView()
    lazy private var restaurantSelectView: RestaurantListView = RestaurantListView()
    
    lazy private var dietCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DietCollectionViewCell.self, forCellWithReuseIdentifier: DietCollectionViewCell.identifier)
        collectionView.backgroundColor = .backgroundGray
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    private let emptyMenuInformation: UILabel = {
       let label = UILabel()
        label.text = "해당 식당은 오늘 운영하지 않아요😢"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        dietCollectionView.delegate = self
        dietCollectionView.dataSource = self
        datePartView.setParentViewController(view: self)
        restaurantSelectView.setParentViewController(view: self)
        requestData()
    }
    
    func requestData() {
        
        guard let crawledData = CrawlManager.shared.crawlRestaurantMenu(date: datePartView.userDateData(), restaurantType: restaurantSelectView.typeData()) else {
            return
        }
        
        data = crawledData.map({ strArray in
            strArray.filter { str in
                !["-"].contains(str)
            }
        })
        DispatchQueue.main.async { [weak self] in
            self?.dietCollectionView.reloadData()
            self?.emptyMenuInformation.isHidden = (self?.data.isEmpty)! ? false : true
        }
    }
    
    
    private func render() {
        self.view.backgroundColor = .backgroundGray
        
        view.addSubviews(datePartView, restaurantSelectView, dietCollectionView, emptyMenuInformation)
        
        let datePartViewConstraints = [
            datePartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            datePartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            datePartView.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        let restaurantSelectViewConstraints = [
            restaurantSelectView.topAnchor.constraint(equalTo: datePartView.bottomAnchor, constant: 24),
            restaurantSelectView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            restaurantSelectView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            restaurantSelectView.heightAnchor.constraint(equalToConstant: 45)
        ]
        
        let dietCollectionViewConstraints = [
            dietCollectionView.topAnchor.constraint(equalTo: restaurantSelectView.bottomAnchor, constant: 32),
            dietCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dietCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dietCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ]
        
        let emptyMenuInformationConstraints = [
            emptyMenuInformation.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyMenuInformation.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyMenuInformation.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyMenuInformation.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyMenuInformation.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        [datePartViewConstraints, restaurantSelectViewConstraints, dietCollectionViewConstraints, emptyMenuInformationConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.compactMap { $0 }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DietCollectionViewCell.identifier, for: indexPath) as? DietCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 22
        let model = MenuViewModel(diet: data[indexPath.row], type: restaurantSelectView.typeData())
        DispatchQueue.main.async {
            cell.configure(with: model)
        }
        
        return cell
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(UIScreen.screenWidth * 0.88), height: data[indexPath.row].count * 35 + 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

}

