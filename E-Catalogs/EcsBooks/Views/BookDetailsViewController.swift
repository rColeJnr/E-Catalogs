//
//  DetailsViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 09/08/24.
//

import UIKit
import CoreData

class BookDetailsViewController: UIViewController {
    
    var detailsView = BookDetailsView()
    var store: BookStore! = EcsTabBarController.bookStore
    
    var book: Book! {
        didSet {
            navigationItem.title = book.title
            detailsView.configure(with: book, store: store)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()  
        setupView(detailsView)
    }
    
}
