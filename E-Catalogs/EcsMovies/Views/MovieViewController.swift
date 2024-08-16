//
//  MoviesViewController.swift
//  E-Catalogs
//
//  Created by rColeJnr on 12/08/24.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    private var viewModel: MovieViewModel!
    private var movies: [MovieResponse] = []
    
    private var footerIndicator = UIActivityIndicatorView(style: .large)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = MovieViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        indicator.hidesWhenStopped = true
        footerIndicator.hidesWhenStopped = true
    
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        tableView.tableFooterView = footerIndicator
        
        viewModel.movies.bind { [weak self] movies in
            guard let list = movies else {
                return
            }
            self?.movies = list
            self?.tableView.reloadData()
            self?.indicator.stopAnimating()
        }
    
        viewModel.isLoading.bind { [weak self] isLoading in
            
            guard let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async{
                if isLoading {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }
        }
        
        viewModel.isLoadingMoreMovies.bind{ [weak self] loading in
            guard let isLoading = loading else {
                return
            }
            DispatchQueue.main.async{
                if isLoading {
                    self?.footerIndicator.startAnimating()
                } else {
                    self?.footerIndicator.stopAnimating()
                }
            }
        }        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.overview.text = movie.overview
        // Download the book image data
        
        if let urlString = movie.image {
            EcsStore.shared.ecsFetchImage(url: NSURL(string: "https://image.tmdb.org/t/p/w400\(urlString)"), key: String(movie.movieId), completion: { result in
                guard case let .success(uIImage) = result else {
                    cell.movieImage.image = nil
                    return
                }
                cell.movieImage.image = uIImage
            })
        }
        
      
        cell.selectionStyle = .none
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height && !viewModel.isLoadingMoreMovies.value! && !movies.isEmpty {
            viewModel.fetchMoreMovies(page: Int(movies.last!.page) + 1)
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
