//
//  MainViewController.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy private var datePartView: DateView = DateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    private func render() {
        view.backgroundColor = .white
        
        view.addSubviews(datePartView)
        
        let datePartViewConstraints = [
            datePartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            datePartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            datePartView.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        NSLayoutConstraint.activate(datePartViewConstraints)
    }
}

