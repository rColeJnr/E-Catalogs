//
//  BookViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

class BookViewController: UIViewController {
    
    private let bookListView = BookListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bestsellers"
        setupView(bookListView)
    }
}
