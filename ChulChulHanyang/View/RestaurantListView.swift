//
//  RestaurantListView.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import UIKit

final class RestaurantListView: UIView {
    
    private let restaurantName = ["생과대", "신소재", "제1생", "제2생", "학생식당", "행원파크"]
    private var parent: MainViewController?
    private var type: RestaurantType = .HumanEcology
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 16.0
        static let collectionVerticalSpacing: CGFloat = 0.0
        static let cellWidth: CGFloat = 90
        static let cellHeight: CGFloat = 45
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    // MARK: - property
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = 8
        return flowLayout
    }()
    
    private lazy var restaurantCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RestaurantCollectionViewCell.self,
                                forCellWithReuseIdentifier: RestaurantCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.restaurantCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        setCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionViewLayout() {
        self.addSubview(restaurantCollectionView)
        
        restaurantCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let listCollectionViewConstraints = [
            restaurantCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            restaurantCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            restaurantCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            restaurantCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(listCollectionViewConstraints)
    }
    
    func setParentViewController(view: MainViewController) {
        parent = view
    }
    
    func typeData() -> RestaurantType {
        return type
    }
    
}

// MARK: - UICollectionViewDataSource
extension RestaurantListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as? RestaurantCollectionViewCell else {
            assert(false, "Wrong Cell")
        }
        
        cell.configure(with: restaurantName[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RestaurantListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        switch indexPath.item {
        case RestaurantType.HanyangPlaza.rawValue:
            type = .HanyangPlaza
        case RestaurantType.HumanEcology.rawValue:
            type = .HumanEcology
        case RestaurantType.MaterialScience.rawValue:
            type = .MaterialScience
        case RestaurantType.ResidenceOne.rawValue:
            type = .ResidenceOne
        case RestaurantType.ResidenceTwo.rawValue:
            type = .ResidenceTwo
        case RestaurantType.HangwonPark.rawValue:
            type = .HangwonPark
        default:
            print("error")
        }
        self.parent?.requestData()
    }
    
    
}


