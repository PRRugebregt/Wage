//
//  NavigationBarExtensions.swift
//  Wage
//
//  Created by Patrick Rugebregt on 05/03/2022.
//

import UIKit

extension UINavigationBar {
    
    static func changeAppearance(clear: Bool) {
        let appearance = UINavigationBarAppearance()
        if clear {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithDefaultBackground()
        }
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
}
