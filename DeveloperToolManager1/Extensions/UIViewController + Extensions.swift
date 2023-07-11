//
//  UIViewController + Extensions.swift
//  DeveloperToolManager
//
//  Created by &&TairoV on 24.05.2023.
//

import UIKit

extension UIViewController {

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        if let devMenu = DeveloperToolManager.shared.menuController,
           devMenu != rootVC?.presentedViewController,
           motion == .motionShake {
            rootVC?.present(devMenu, animated: true)
        }
    }
}

