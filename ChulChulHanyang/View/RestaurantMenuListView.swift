//
//  RestaurantMenuList.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2023/04/28.
//

import UIKit

final class RestaurantMenuListView: UIView {

    private var viewModel: RestaurantMenuListViewModel!
    
    func setViewModel(viewModel: RestaurantMenuListViewModel) {
        self.viewModel = viewModel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        self.backgroundColor = .magenta
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        
    }
}
