//
//  utilities.swift
//  campfire-mobile
//
//  Created by Toni on 7/14/23.
//

import Foundation
import UIKit

// MARK: - Utilities Class for View Controllers

final class Utilities {
    static let shared = Utilities()
    private init() {}

    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

// MARK: - Error Types

enum EmailError: Error {
    case noMatch
    case existingUser
    case noExistingUser
}

enum PhoneError: Error {
    case existingUser
    case noExistingUser
}
