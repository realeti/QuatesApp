//
//  TabBarController.swift
//  QuatesApp
//
//  Created by Apple M1 on 22.06.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        setupTabs()
    }
    
    // MARK: - Configure TabBar
    private func configureTabBar() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = UIColor(resource: .heavyGray)
    }
    
    // MARK: - Setup Tabs
    private func setupTabs() {
        let homeVC = CategoriesViewController()
        let favoritesVC = FavoritesViewController()
        
        let home = self.createTabBarItem(
            title: K.homeTabTitle,
            image: UIImage(resource: .gridOutline),
            selectedImage: UIImage(resource: .gridFilled),
            tag: 0,
            vc: homeVC
        )
        
        let favorites = self.createTabBarItem(
            title: K.favoritesTabTitle,
            image: UIImage(resource: .heartOutline),
            selectedImage: UIImage(resource: .heartFilled),
            tag: 1,
            vc: favoritesVC
        )
        
        self.setViewControllers([home, favorites], animated: true)
    }
    
    // MARK: - Create TabBar Item
    private func createTabBarItem(title: String, image: UIImage, selectedImage: UIImage, tag: Int, vc: UIViewController) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        vc.tabBarItem.tag = tag
        vc.tabBarItem.selectedImage = selectedImage
        
        return vc
    }
}
