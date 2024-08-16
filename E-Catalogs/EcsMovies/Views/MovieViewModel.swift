//
//  MovieViewModel.swift
//  E-Catalogs
//
//  Created by rColeJnr on 13/08/24.
//

import Foundation

class MovieViewModel {
    
    var isLoading: EcsObservable<Bool> = EcsObservable(false)
    var isLoadingMoreMovies: EcsObservable<Bool> = EcsObservable(false)
    var movies: EcsObservable<[MovieResponse]> = EcsObservable(nil)

    init() {
        // Allways fetch first page on init
        EcsTabBarController.movieStore.fetchTrendingMovies(1) { _ in
            self.fetchAllMovies()
        }
    }
    
    private func fetchAllMovies() {
        if isLoading.value ?? true {
            return
        }
        
        isLoading.value = true
        EcsTabBarController.movieStore.fetchAllMovies(completion: { [weak self] result in
            switch result {
            case .success(let success):
                self?.isLoading.value = false
                self?.movies.value = success
            case .failure(let failure):
                self?.isLoading.value = false
                print(String(describing: failure))
            }
        })
    }
    
    func fetchMoreMovies(page: Int) {
        if isLoadingMoreMovies.value ?? true {
            return
        }
  
        isLoadingMoreMovies.value = true

        EcsTabBarController.movieStore.fetchTrendingMovies(page) { [weak self] result in
            switch result {
            case .success(let success):
                self?.isLoadingMoreMovies.value = false
                self?.movies.value! += success
            case .failure(let failure):
                self?.isLoadingMoreMovies.value = false
                print(String(describing: failure))
            }
        }
        
    }
}
