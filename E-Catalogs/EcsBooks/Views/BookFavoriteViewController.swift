//
//  BookFavoriteViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 10/08/24.
//

import UIKit
import CoreData

class BookFavoriteViewController: UIViewController, BookListViewDelegate {
    
    private let bookFavoriteListView = BookFavoriteListView()
    var store: BookStore = EcsTabBarController.bookStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Bestsellers"
        bookFavoriteListView.delegate = self
        bookFavoriteListView.store = store
        setupView(bookFavoriteListView)
    }
    
    func didSelectBook(vc: BookDetailsViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToFavorites(vc: BookFavoriteViewController) {
        // Do nothing
    }
    
}
