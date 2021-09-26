//
//  UIViewController+FromNib.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import UIKit

extension UIViewController {
    static func instantiateFromNib() -> Self? {
        func instantiateFromNib<T: UIViewController>(_ viewType: T.Type) -> T? {
            return Bundle.main.loadNibNamed(String(describing: T.self),
                                     owner: nil, options: nil)?.first
            as? T
        }

        return instantiateFromNib(self)
    }
}
