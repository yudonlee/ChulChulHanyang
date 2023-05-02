//
//  RestaurantMenuList.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2023/04/28.
//

import Combine
import UIKit

final class RestaurantMenuListView: UIView {

    private var viewModel: RestaurantMenuListViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var menus: [[String]] = []
    private var date: Date!
    private var input: PassthroughSubject<RestaurantMenuListViewModel.Action, Never> = .init()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        return indicatorView
    }()
    
    lazy private var menuListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelectionDuringEditing = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundGray
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return tableView
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.isHidden = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
      
    private func setupTableView() {
        menuListTableView.delegate = self
        menuListTableView.dataSource = self
        menuListTableView.allowsSelection = false
    }
    
    func setViewModel(viewModel: RestaurantMenuListViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupLayout()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews(menuListTableView, indicatorView, informationLabel)
        informationLabel.isHidden = true
        
        let menuTableConstraints = [
            menuListTableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            menuListTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            menuListTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            menuListTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ]
        
        let indicatorViewConstraints = [
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ]
        
        let informationLabelConstraints = [
            informationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            informationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        [menuTableConstraints, indicatorViewConstraints, informationLabelConstraints].forEach {
            NSLayoutConstraint.activate($0)
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.sink { (state, action) in
            self.informationLabel.isHidden = true
            if state.isRefreshLoading == false {
                DispatchQueue.main.async {
                    self.menuListTableView.refreshControl?.endRefreshing()
                }
            }
            
            if state.isLoading {
                DispatchQueue.main.async {
                    self.indicatorView.startAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                }
            }
            
            switch state.loadingError {
            case .none:
                DispatchQueue.main.async {
                    self.informationLabel.isHidden = true
                }
            case .emptyData:
                DispatchQueue.main.async {
                    self.informationLabel.isHidden = false
                    self.informationLabel.text = "식단 데이터가 없어요.😢\n 화면을 아래로 당겨 새로고침 해보세요."
                }
            case .failedToNetworkLoading:
                DispatchQueue.main.async {
                    self.informationLabel.isHidden = false
                    self.informationLabel.text = "서버요청이 실패했어요.😢\n 화면을 아래로 당겨 새로고침 해보세요."
                }
            }
            
            switch action {
            case .requestMenu, .refreshMenu:
                self.menus = state.menuData
                DispatchQueue.main.async {
                    self.menuListTableView.reloadData()
                }
            }
        }.store(in: &cancellables)
    }
}

// ViewModel action 관련 함수
extension RestaurantMenuListView {
    
    @objc
    private func refreshData() {
        self.input.send(.refreshMenu(date))
    }
    
    private func requestMenuList() {
        self.input.send(.requestMenu(date))
    }
    
    func displayView(date: Date) {
        self.date = date
        requestMenuList()
    }
}

// TableView DataSource
extension RestaurantMenuListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        
        var content = cell.defaultContentConfiguration()
        
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        content.text = menus[indexPath.section][indexPath.row]
        content.textProperties.adjustsFontForContentSizeCategory = true
        content.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        
        content.textProperties.font = indexPath.row != 0 ? UIFont.systemFont(ofSize: 16) : UIFont.systemFont(ofSize: 18, weight: .bold)
        content.textProperties.alignment = indexPath.row != 0 ? .center : .natural

//        if indexPath.row == 0 {
//            if let text = content.text, let time = type.restaurantTime[text] {
//                content.secondaryText = time
//                content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//                content.prefersSideBySideTextAndSecondaryText = true
//            }
//        }
        
        if let text = content.text, text.contains("[") {
            content.textProperties.alignment = .natural
            content.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }

        cell.contentConfiguration = content
//        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension RestaurantMenuListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 35
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
}


