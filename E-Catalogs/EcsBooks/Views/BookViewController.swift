//
//  BookViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

class BookViewController: UIViewController, BookListViewDelegate {
    
    private let bookListView = BookListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bestsellers"
//        bookListView.bookStore = store
        bookListView.delegate = self
        setupView(bookListView)
    }
    
    func didSelectBook(vc: BookDetailsViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToFavorites(vc: BookFavoriteViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
