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
        view.backgroundColor = .brown
        title = "Anime"
        setupView()
    }
    
    private func setupView() {
//        animeListView.delegate = self
        view.addSubview(animeListView)
        NSLayoutConstraint.activate([
            animeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            animeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            animeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            animeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
