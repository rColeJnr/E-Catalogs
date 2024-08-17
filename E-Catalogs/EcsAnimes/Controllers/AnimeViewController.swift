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
    private var isLoading: Bool!
    private var errorMsg: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Anime"        
        let viewWidth = view.bounds.width
        
        viewModel.isLoading.bind{ loading in
            if loading != nil {
                self.isLoading = loading
            }
        }
        
        viewModel.errorMsg.bind({ msg in
            if msg != nil {
                self.errorMsg = msg!
            }
        })   
        
        viewModel.animes.bind({ anims in
            if anims != nil {
                self.animes = anims
            }
        })  
        
        addSwiftUIController(viewWidth)
    }
    
    private func addSwiftUIController(_ viewWidth: CGFloat) {
        let uiController = UIHostingController(rootView: AnimeView(viewWidth, animes: animes, isLoading: isLoading, errorMsg: errorMsg))
        addChild(uiController)
        uiController.didMove(toParent: self)
        view.addSubview(uiController.view)
        uiController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uiController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            uiController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            uiController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            uiController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    
        self.animeUIController = uiController
    }
    
}
