//
//  AnimeViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

class AnimeViewController: UIViewController {
    
    private let animeListView = AnimeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Anime"
        setupView(animeListView)
    }
    
}
