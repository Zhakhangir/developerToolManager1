//
//  DeveloperToolManager.swift
//  DeveloperToolManager
//
//  Created by &&TairoV on 24.05.2023.
//

import SbiDevelopMenu

public class DeveloperToolManager {

    var menuController: UIViewController!

    public static let shared = DeveloperToolManager()

    private init() { }

    public func createDeveloperTool(items: [IMenuItem]) {
        let devMenu = DevMenuAssembly().makeDebugMenuModule(items: items)
        menuController = UINavigationController(rootViewController: devMenu)
        menuController?.modalPresentationStyle = .fullScreen
    }
}
