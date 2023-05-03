//
//  RestaurantViewModel.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import Combine
import Foundation

final class RestaurantMenuListViewModel {
    enum DataLoadingError: Error {
        case none
        case emptyData
        case failedToNetworkLoading
    }
    
    enum Action {
        case requestMenu(Date)
        case refreshMenu(Date)
    }
    
    enum Mutation {
        // 날짜변경으로 인한 새로운 메뉴 데이터 로딩
        case renewMenu(Date, [[String]])
        // 메뉴 데이터 refresh 요청
        case refreshMenu(Date, [[String]])
        case setRefreshLoading(Bool)
        case setLoading(Bool)
        case dataLoadError(DataLoadingError)
        
    }
    
    struct State {
        var menuData: [[String]] = []
        var isLoading = false
        var date: Date?
        var isRefreshLoading = false
        var loadingError: DataLoadingError = .none
    }
    
    private var restaurant: RestaurantType
    private var date: Date
    var state: State
    var cancellables = Set<AnyCancellable>()
    var output: PassthroughSubject<(State, Action), Never> = .init()
    
    func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
        switch action {
        case .requestMenu(let newDate):
            guard !self.state.isLoading, !self.state.isRefreshLoading else {
                return Just(Mutation.setLoading(false))
                    .eraseToAnyPublisher()
            }
            
            if let date = self.state.date, Calendar.current.isDate(date, inSameDayAs: newDate) {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            
            let loadingPublisher = Just(Mutation.setLoading(true))
            let menuPublisher = CrawlManager.shared.requestMenu(date: newDate, restaurantType: restaurant)
                .map { return Mutation.renewMenu(newDate, $0) }
                .catch { _ in
                    return Just(Mutation.dataLoadError(.failedToNetworkLoading))
                }
                .eraseToAnyPublisher()
            return loadingPublisher.append(menuPublisher).append(Just(Mutation.setLoading(false)))
                .eraseToAnyPublisher()
            
        case .refreshMenu(let date):
            guard !self.state.isLoading, !self.state.isRefreshLoading else {
                return Just(Mutation.setRefreshLoading(false))
                    .eraseToAnyPublisher()
            }
            
            let loadingPublisher = Just(Mutation.setRefreshLoading(true))
            let resultPublisher = CrawlManager.shared.requestMenu(date: date, restaurantType: restaurant)
                .map { return Mutation.refreshMenu(date, $0) }
                .catch { _ in
                    return Just(Mutation.dataLoadError(.failedToNetworkLoading))
                }
                .eraseToAnyPublisher()
            return loadingPublisher.append(resultPublisher).append(Just(Mutation.setRefreshLoading(false)))
                .eraseToAnyPublisher()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .renewMenu(let newDate, let menuList):
            var newState = state
            newState.menuData = menuList
            newState.date = newDate
            if menuList.isEmpty {
                newState.loadingError = .emptyData
            }
            return newState
        case .refreshMenu(let newDate, let menuList):
            var newState = state
            newState.menuData = menuList
            newState.date = newDate
            if menuList.isEmpty {
                newState.loadingError = .emptyData
            }
            return newState
        case .setRefreshLoading(let loading):
            var newState = state
            newState.isRefreshLoading = loading
            if loading {
                newState.loadingError = .none
            }
            return newState
        case .setLoading(let loading):
            var newState = state
            newState.isLoading = loading
            if loading {
                newState.loadingError = .none
            }
            return newState
        case .dataLoadError(let error):
            var newState = state
            newState.menuData = []
            newState.loadingError = error
            return newState
        }
    }
    
    func transform(input: AnyPublisher<Action, Never>) -> AnyPublisher<(State, Action), Never> {
        input.sink { action in
            self.mutate(action: action).sink { mutation in
                let newState = self.reduce(state: self.state, mutation: mutation)
                self.state = newState
                self.output.send((self.state, action))
            }.store(in: &self.cancellables)
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }

    init(restaurant: RestaurantType) {
        self.restaurant = restaurant
        self.date = Date()
        self.state = State()
        output = PassthroughSubject<(State, Action), Never>()
    }
}
