//
//  BookFavoriteListView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 11/08/24.
//

import UIKit

class BookFavoriteListView: UIView {
    
    var store: BookStore = EcsTabBarController.bookStore
    private var books: [Book] = []
    public weak var delegate: BookListViewDelegate?
    private var errorView: UIView?
    
    // MARK: - Views
    private let spinner = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.cellIdentifier)
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        fetchFavorites()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View config
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
          
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func fetchFavorites() {
        store.fetchFavoriteBestsellers(completion: { [weak self] booksResult in
            switch booksResult {
            case .success(let books):
                self?.books = books
            case .failure(_):
                self?.books.removeAll()
                guard let view =  self?.showErrorMsg(msg: "Failed to get favorites") else {
                    return
                }
                self?.addSubview(view)
                NSLayoutConstraint.activate([
                
                    view.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                    view.centerXAnchor  .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
                ])
            }
        })
        spinner.stopAnimating()
        collectionView.reloadData()
    }
}

extension BookFavoriteListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? BookCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let book = books[indexPath.row]
        cell.configure(book: book)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width: CGFloat
        if UIDevice.isiPhone {
            width = bounds.width-30
        } else {
            width = (bounds.width-50)/4
        }
        
        return CGSize(width: width, height: width/2.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // do nothing
        let book = books[indexPath.row]
        
        let vc = BookDetailsViewController()
        vc.store = store
        vc.book = book
        delegate?.didSelectBook(vc: vc)
    }
}
