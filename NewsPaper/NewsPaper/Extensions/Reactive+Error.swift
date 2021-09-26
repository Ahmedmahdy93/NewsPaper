//
//  Reactive+Error.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIViewController: errorViewable {}

extension Reactive where Base: UIViewController {

    /// Bindable sink for isError() method.
    public var isError: Binder<Error> {
        return Binder(self.base, binding: { (viewController, error) in
            let error = error as? NewsException
            switch error?.code {
            case 401:
                // logout
                print("invalid user")
            default:
                base.showError(with: error)
                break
            }
        })
    }
}

protocol errorViewable {
    func showError(with: NewsException?)
}
extension errorViewable where Self: UIViewController {
    func showError(with: NewsException?) {
        let alertController =
            UIAlertController(title: with?.title, message: with?.message, preferredStyle: UIAlertController.Style.alert)
        let okAction =
            UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
            if let action = with?.action {
                action()
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
