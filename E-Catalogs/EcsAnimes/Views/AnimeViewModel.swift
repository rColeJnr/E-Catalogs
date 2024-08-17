//
//  AnimeViewModel.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//

import Foundation

class AnimeViewModel {
    
    private let animeStore = EcsTabBarController.animeStore
    
    var errorMsg: EcsObservable<String?> = EcsObservable(nil)
    var isLoading: EcsObservable<Bool> = EcsObservable(false)
    var animes: EcsObservable<[Anime]> = EcsObservable(nil)
    
    init() {
        // Fetch api on start
        animeStore?.fetchTopAnime { _ in
            self.fetchAllAnimes()
        }
    }
    
    private func fetchAllAnimes() {
        if isLoading.value ?? true {
            return
        }
        
        isLoading.value = animeStore?.isLoading
        animeStore?.fetchAllAnimes(completion: { [weak self] result in
            switch result {
            case .success(let animes):                self?.animes.value = animes
            case .failure(let animeApiError):
                self?.errorMsg.value = animeApiError.localizedDescription
            }})
    }
    
}
