//
//  MainViewController.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit

final class MainViewController: UIViewController {
    
    lazy private var data: [[String]] = [[String]]()
    
    lazy private var datePartView: DateView = {
        let dateView = DateView()
        dateView.delegate = self
        return dateView
    }()
    
    lazy private var restaurantSelectView: RestaurantListView = {
        let view = RestaurantListView()
        view.delegate = self
        return view
    }()
    
    private var type: RestaurantType = .HumanEcology
    private var date: Date = Date()
    
    
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
        label.text = "등록된 정보를 찾지 못했어요😢"
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
        requestData()
    }
    
    func requestData() {
        LoadingService.showLoading()
        CrawlManager.shared.crawlRestaurantMenuAsyncAndURL(date: date,  restaurantType: type, completion: { result in
            switch result {
            case .success(let crawledData):
                let parsed = crawledData.map({ strArray in
                    strArray.filter { str in
                        !["-"].contains(str)
                    }
                })
                LoadingService.hideLoading()
                DispatchQueue.main.async { [weak self] in
                    self?.data = parsed
                    self?.dietCollectionView.reloadData()
                    self?.emptyMenuInformation.isHidden = (self?.data.isEmpty)! ? false : true
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
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
        let model = MenuViewModel(diet: data[indexPath.row], type: type)
        cell.configure(with: model)
        
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


extension MainViewController: RestaurantCollectionViewCellDelegate {
    
    func restaurantCollectionViewCellTapped(_ type: RestaurantType) {
        self.type = type
        requestData()
    }
    
}

extension MainViewController: DateViewDelegate {
    func dateViewValueChange(_ date: Date) {
        self.date = date
        requestData()
    }
    
}
