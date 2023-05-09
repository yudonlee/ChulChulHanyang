//
//  MainViewController.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit

final class MainViewController: UIViewController {
    
    lazy private var datePartView: DateView = {
        let dateView = DateView()
        dateView.delegate = self
        return dateView
    }()
    
    lazy private var segmentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy private var segmentCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .backgroundGray
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    private let segmentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var restaurantMenuListViews: [RestaurantMenuListView]!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var restaurantType: RestaurantType = .HumanEcology
    private var date: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRestaurantMenuListViews()
        
        configureLayout()
        configureDataSource()
        
        setupIntialState()
        
    }

    private func setupRestaurantMenuListViews() {
        restaurantMenuListViews = RestaurantType.allCases.map {
            let view = RestaurantMenuListView()
            view.setViewModel(viewModel: RestaurantMenuListViewModel(restaurant: $0))
            return view
        }
    }
    
    private func setupIntialState() {
        segmentCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        restaurantMenuListViews.forEach { $0.displayView(date: date) }
    }
}

// MARK: Deeplink 처리
extension MainViewController {
    // Process Deeplink
    func selectRestaurant(restaurant: String) {
        guard let deeplinkRestaurant = RestaurantType(englishName: restaurant) else { return }
        if deeplinkRestaurant != self.restaurantType {

            guard let indexPath = dataSource.indexPath(for: Item(restaurantType: deeplinkRestaurant)) else { return }
            segmentCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            collectionView(segmentCollectionView, didSelectItemAt: indexPath)
        }
    }
}

// MARK: Set Autolayout
extension MainViewController {
    private func configureLayout() {
        self.view.backgroundColor = .backgroundGray
        
        view.addSubviews(datePartView, segmentScrollView, segmentCollectionView)
        segmentScrollView.addSubviews(segmentStackView)
        
        restaurantMenuListViews.forEach {
            segmentStackView.addArrangedSubview($0)
        }
        
        let datePartViewConstraints = [
            datePartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            datePartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            datePartView.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        let segmentCollectionViewConstraints = [
            segmentCollectionView.topAnchor.constraint(equalTo: datePartView.bottomAnchor),
            segmentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentCollectionView.heightAnchor.constraint(equalToConstant: 51)
        ]
        
        let segmentScrollViewConstraints = [
            segmentScrollView.topAnchor.constraint(equalTo: segmentCollectionView.bottomAnchor),
            segmentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        let segmentStackViewConstrinats = [
            segmentStackView.topAnchor.constraint(equalTo: segmentScrollView.topAnchor),
            segmentStackView.leadingAnchor.constraint(equalTo: segmentScrollView.leadingAnchor),
            segmentStackView.trailingAnchor.constraint(equalTo: segmentScrollView.trailingAnchor),
            segmentStackView.bottomAnchor.constraint(equalTo: segmentScrollView.bottomAnchor),
            segmentStackView.heightAnchor.constraint(equalTo: segmentScrollView.heightAnchor)
        ]
        
        let restaurantViewConstraints = restaurantMenuListViews.map {
            $0.widthAnchor.constraint(equalTo: segmentScrollView.widthAnchor)
        }
        
        [datePartViewConstraints, segmentCollectionViewConstraints, segmentScrollViewConstraints, segmentStackViewConstrinats, restaurantViewConstraints].forEach {
            NSLayoutConstraint.activate($0)
        }
    }
}

// MARK: CollectionView Layout, DiffableDataSource {
extension MainViewController {
    enum Section {
        case main
    }
    
    struct Item: Hashable {
//        private let identifier = UUID()
        let restaurantType: RestaurantType
        
        init(restaurantType: RestaurantType) {
            self.restaurantType = restaurantType
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(31))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        let restaurantName = ["생과대", "신소재", "제1생", "제2생", "학생식당", "행원파크"]
        let cellRegistration = UICollectionView.CellRegistration<RestaurantCollectionViewCell, Item> { (cell, indexPath, identifier) in
            cell.configure(with: restaurantName[indexPath.item])
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: segmentCollectionView) {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(RestaurantType.allCases.map { Item(restaurantType: $0) })
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        guard let newType = dataSource.itemIdentifier(for: indexPath)?.restaurantType else { return }
        
        // VC의 식당 변경 및 데이터 요청
        self.restaurantType = newType
        restaurantMenuListViews[indexPath.item].displayView(date: date)
        
        // target 식당으로 scrollView이동
        guard let windowWidth = view.window?.windowScene?.screen.bounds.width else { return }
        let point = CGPoint(x: CGFloat(indexPath.item) * windowWidth, y: 0)
        segmentScrollView.setContentOffset(point, animated: true)
    }
}

extension MainViewController: UIScrollViewDelegate {
    // didScroll을 통해서 page시 에러가 발생할 수 있음
    // didEndDecelerating 사용
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let windowWidth = view.window?.windowScene?.screen.bounds.width else { return }
        let currentPage = Int(scrollView.contentOffset.x / windowWidth)
        
        guard let currentPageRestaurant = dataSource.itemIdentifier(for: IndexPath(item: currentPage, section: 0))?.restaurantType else { return }
        
        // 식당변경 및 data요청은 collectionViewDelegate에서만 진행
        if currentPageRestaurant != restaurantType {
            segmentCollectionView.selectItem(at: IndexPath(item: currentPage, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            collectionView(segmentCollectionView, didSelectItemAt: IndexPath(item: currentPage, section: 0))
        }
    }
}
extension MainViewController: DateViewDelegate {
    func dateViewValueChange(_ date: Date) {
        guard let windowWidth = view.window?.windowScene?.screen.bounds.width else { return }
        let currentPage = Int(segmentScrollView.contentOffset.x / windowWidth)
        self.date = date
        restaurantMenuListViews[currentPage].displayView(date: date)
    }
    
}
