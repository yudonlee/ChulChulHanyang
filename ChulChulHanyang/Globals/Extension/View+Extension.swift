//
//  View+Extension.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
}
