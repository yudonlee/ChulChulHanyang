//
//  DateView.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit
import Combine

protocol DateViewDelegate: AnyObject {
    func dateViewValueChange(_ date: Date)
}


class DateView: UIView {
    
    private var userDate: Date = Date()
    
    weak var delegate: DateViewDelegate?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged(_:)), name: UIApplication.significantTimeChangeNotification, object: nil)
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
    
    @objc private func addOneDayToCurrent() {
        guard let date = Calendar.current.date(byAdding: .day, value: 1, to: userDate) else {
            return
        }
        userDate = date
        setDateAndDayLabel()
        self.delegate?.dateViewValueChange(userDate)
    }
    
    @objc private func minusOneDayToCurrent() {
        guard let date = Calendar.current.date(byAdding: .day, value: -1, to: userDate) else {
            return
        }
        userDate = date
        setDateAndDayLabel()
        self.delegate?.dateViewValueChange(userDate)
    }
    
    @objc private func dayChanged(_ notification: Notification) {
        
        userDate = Date()
        setDateAndDayLabel()
        self.delegate?.dateViewValueChange(userDate)
    }
    
}

//final class GenderViewModel {
//    enum Action {
//        case requestInitialUser
//        case requestAppendedUser
//        case refreshUser
//    }
//
//    enum Mutation {
//        case intialUser([Person])
//        case renewUser([Person])
//        case appendUser([Person])
//        case setRefreshLoading(Bool)
//        case setLoading(Bool)
//    }
//
//    struct State {
//        var personData: [Person] = []
//        var emailList: [String: Bool] = [:]
//        var gender: String
//        var isLoading = false
//        var isRefreshControlLoading = false
//    }
//
//    var state: State
//    var cancellables = Set<AnyCancellable>()
//    var output: CurrentValueSubject<(State, Action), Never>
//
//    func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
//        switch action {
//        case .requestInitialUser:
//            let loadingPublisher = Just(Mutation.setLoading(true))
//            let resultPublisher = NetworkManager.shared.requestUserInformation(gender: state.gender, count: 40)
//                .catch { error in
//                    return Just([Person]())
//                }
//                .map { Mutation.renewUser($0) }
//                .eraseToAnyPublisher()
//            return loadingPublisher.append(resultPublisher).append(Just(Mutation.setLoading(false)))
//                .eraseToAnyPublisher()
//        case .refreshUser:
//            let loadingPublisher = Just(Mutation.setRefreshLoading(true))
//            let resultPublisher = NetworkManager.shared.requestUserInformation(gender: state.gender, count: 40)
//                .catch { error in
//                    return Just([Person]())
//                }
//                .map { Mutation.renewUser($0) }
//                .eraseToAnyPublisher()
//            return loadingPublisher.append(resultPublisher).append(Just(Mutation.setRefreshLoading(false)))
//                .eraseToAnyPublisher()
//        case .requestAppendedUser:
//            let loadingPublisher = Just(Mutation.setLoading(true))
//            let resultPublisher = NetworkManager.shared.requestUserInformation(gender: state.gender, count: 40)
//                .catch { error in
//                    return Just([Person]())
//                }
//                .map { Mutation.appendUser($0.filter { person in self.state.emailList[person.email] == nil }) }
//                .eraseToAnyPublisher()
//            return loadingPublisher.append(resultPublisher).append(Just(Mutation.setLoading(false)))
//                .eraseToAnyPublisher()
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        switch mutation {
//        case .intialUser(let personUserData), .renewUser(let personUserData):
//            var newState = state
//            newState.personData = personUserData
//            var newEmailList: [String: Bool] = [:]
//            for person in personUserData {
//                newEmailList[person.email] = true
//            }
//            newState.emailList = newEmailList
//            return newState
//        case .appendUser(let appendedUserData):
//            var newState = state
//            newState.personData += appendedUserData
//            for person in appendedUserData {
//                newState.emailList[person.email] = true
//            }
//            return newState
//        case .setRefreshLoading(let loading):
//            var newState = state
//            newState.isRefreshControlLoading = loading
//            return newState
//        case .setLoading(let loading):
//            var newState = state
//            newState.isLoading = loading
//            return newState
//        }
//    }
//
//    func transform(input: AnyPublisher<Action, Never>) -> AnyPublisher<(State, Action), Never> {
//        input.sink { action in
//            self.mutate(action: action).sink { mutation in
//                let newState = self.reduce(state: self.state, mutation: mutation)
//                self.state = newState
//                self.output.send((self.state, action))
//            }.store(in: &self.cancellables)
//        }.store(in: &cancellables)
//
//        return output.eraseToAnyPublisher()
//    }
//
//    init(gedner: String) {
//        self.state = State(gender: gedner)
//
//        output = CurrentValueSubject<(State, Action), Never>((self.state, .refreshUser))
//
//    }
//}
//
//
//// 로직 관련 함수
//
////    private func isUserDefaultDataToday() -> Bool {
////        if Calendar.current.isDateInToday(date), UserDefaults.shared.string(forKey: "DateOf\(type.name)") == "\(date.keyText)" {
////            return true
////        }
////        return false
////    }
////
////    private func shouldUserDefaultUpdate() -> Bool {
////
////        let dateText: String = {
////            let date = Date()
////            return date.keyText
////        }()
////
////        if Calendar.current.isDateInToday(date) {
////            guard let data = UserDefaults.shared.string(forKey: "DateOf\(type.name)") else {
////                return true
////            }
////
////            if data != "\(dateText)" {
////                return true
////            }
////        }
////        return false
////
////    }
////
////    @objc
////    private func requestDataByRefreshControl() {
////        CrawlManager.shared.crawlRestaurantMenuAsyncAndURL(date: date,  restaurantType: type, completion: { [weak self] result in
////            switch result {
////            case .success(let crawledData):
////                let parsed = crawledData.map({ strArray in
////                    strArray.filter { str in
////                        !["-"].contains(str)
////                    }
////                })
////
////                if !parsed.isEmpty, let status = self?.shouldUserDefaultUpdate(), status, let dateKeyText = self?.date.keyText, let typeName = self?.type.name {
////                    UserDefaults.shared.set("\(dateKeyText)", forKey: "DateOf\(typeName)")
////                    UserDefaults.shared.set(parsed, forKey: "TodayMenuOf\(typeName)")
////                }
////
////                DispatchQueue.main.async { [weak self] in
////                    self?.data = parsed
////                    self?.dietCollectionView.reloadData()
////                    self?.emptyMenuInformation.isHidden = (self?.data.isEmpty)! ? false : true
////                    self?.dietCollectionView.refreshControl?.endRefreshing()
////                }
////
////            case .failure(let error):
////                print(error.localizedDescription)
////                DispatchQueue.main.async {
////                    self?.dietCollectionView.refreshControl?.endRefreshing()
////                }
////            }
////        })
////    }
////
////    func requestData() {
////
////        if isUserDefaultDataToday(), let data = UserDefaults.shared.array(forKey: "TodayMenuOf\(type.name)") as? [[String]] {
////            DispatchQueue.main.async { [weak self] in
////                self?.data = data
////                self?.dietCollectionView.reloadData()
////                self?.emptyMenuInformation.isHidden = (self?.data.isEmpty)! ? false : true
////            }
////        } else {
////            LoadingService.showLoading()
////            CrawlManager.shared.crawlRestaurantMenuAsyncAndURL(date: date,  restaurantType: type, completion: { [self] result in
////                switch result {
////                case .success(let crawledData):
////                    let parsed = crawledData.map({ strArray in
////                        strArray.filter { str in
////                            !["-"].contains(str)
////                        }
////                    })
////
////                    if !parsed.isEmpty, shouldUserDefaultUpdate() {
////                        UserDefaults.shared.set("\(date.keyText)", forKey: "DateOf\(type.name)")
////                        UserDefaults.shared.set(parsed, forKey: "TodayMenuOf\(self.type.name)")
////                    }
////                    LoadingService.hideLoading()
////                    DispatchQueue.main.async { [weak self] in
////                        self?.data = parsed
////                        self?.dietCollectionView.reloadData()
////                        self?.emptyMenuInformation.isHidden = (self?.data.isEmpty)! ? false : true
////                    }
////
////                case .failure(let error):
////                    print(error.localizedDescription)
////                    LoadingService.hideLoading()
////                }
////            })
////        }
////    }
////
//
//
////extension MainViewController: UICollectionViewDataSource {
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return data.compactMap { $0 }.count
////    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DietCollectionViewCell.identifier, for: indexPath) as? DietCollectionViewCell else {
////            return UICollectionViewCell()
////        }
////
////        cell.layer.cornerRadius = 22
////        let model = MenuViewModel(diet: data[indexPath.row], type: type)
////        cell.configure(with: model)
////
////        return cell
////    }
////
////
////}
////
////extension MainViewController: UICollectionViewDelegateFlowLayout {
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: Int(UIScreen.screenWidth * 0.88), height: data[indexPath.row].count * 35 + 5)
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return 24
////    }
////
////}
//
//
////extension MainViewController: UICollectionViewDataSource {
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return restaurantName.count
////    }
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as? RestaurantCollectionViewCell else { return
////            UICollectionViewCell()
////        }
////
////        cell.configure(with: restaurantName[indexPath.item])
////
////        return cell
////    }
////}
