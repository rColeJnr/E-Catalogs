//
//  EcsTabBarController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

class EcsTabBarController: UITabBarController {
    
    static let bookStore: BookStore = BookStore()
    static let movieStore: MovieStore = MovieStore()
    static let animeStore: AnimeStore! = AnimeStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let animeVC = AnimeViewController()
        let bookVC = BookViewController()
        let moviesVC = MovieViewController()

        bookVC.navigationItem.largeTitleDisplayMode = .automatic
        moviesVC.navigationItem.largeTitleDisplayMode = .automatic
        animeVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let bookNav = UINavigationController(rootViewController: bookVC)
        let moviesNav = UINavigationController(rootViewController: moviesVC)
        let animeNav = UINavigationController(rootViewController: animeVC)
        
        bookNav.tabBarItem = UITabBarItem(title: "Books", image: UIImage(systemName: "book"), tag: 1)
        moviesNav.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "movieclapper"), tag: 2)
        animeNav.tabBarItem = UITabBarItem(title: "Anime", image: UIImage(systemName: "figure.martial.arts"), tag: 3)
        
        setViewControllers([bookNav, moviesNav, animeNav], animated: true)
        
    }
    
}
