//
//  AnimeViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit
import SwiftUI

class AnimeViewController: UIViewController {
    
    private var animeUIController: UIHostingController<AnimeView>?
    private let viewModel = AnimeViewModel()
    private var animes: [Anime]!
//    private var animes: [NetworkAnime] = [
//        NetworkAnime(animeId: 1, images: nil, title: "Title", source: "Soce", episodes: 23, airing: true, aired: nil, duration: "somet per ep", rating: "rated", rank: 4, popularity: 388383, synopsis: "synopsis", background: "Backgrond text", genres: []),
//        NetworkAnime(animeId: 2, images: nil, title: "Title2", source: "Soce", episodes: 23, airing: true, aired: nil, duration: "somet per ep", rating: "rated", rank: 4, popularity: 388383, synopsis: "synopsis", background: "Backgrond text", genres: []),
//        NetworkAnime(animeId: 3, images: nil, title: "Title3", source: "Soce", episodes: 23, airing: true, aired: nil, duration: "somet per ep", rating: "rated", rank: 4, popularity: 388383, synopsis: "synopsis", background: "Backgrond text", genres: []),
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Anime"
        
        viewModel.animes.bind({ anims in
            if anims != nil {
                print("AnimeController: \(anims!.count)")
                self.animes = anims!
                self.addSwiftUIController(anims!)
            }
            
        })       
        
    }
    
    private func addSwiftUIController(_ anims: [Anime]) {
        let uiController = UIHostingController(rootView: AnimeView(animes: anims))
        addChild(uiController)
        uiController.didMove(toParent: self)
        view.addSubview(uiController.view)
        uiController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uiController.view.topAnchor.constraint(equalTo: view.topAnchor),
            uiController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uiController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            uiController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    
        self.animeUIController = uiController
    }
    
}
