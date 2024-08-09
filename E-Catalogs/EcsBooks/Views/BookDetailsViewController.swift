//
//  DetailsViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 09/08/24.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    var detailsView: BookDetailsView
    
    var book: Book! {
        didSet {
            navigationItem.title = book.title
        }
    }
    var store: BookStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView(<#T##view: UIView##UIView#>)
    }
    
}
