//
//  BookListView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

class BookListView: UIView {
    
    private let bookStore = BookStore()
    private var books: [Book] = []
    public weak var delegate: BookListViewDelegate?
    
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
        bookStore.fetchFictionBestsellers { _ in // on Completion, call the cached data
            self.fetchCachedFiction()
        }
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

    private func fetchCachedFiction() {
        bookStore.fetchAllBooks(completion: { [weak self] booksResult in
            switch booksResult {
            case .success(let books):
                self?.books = books
            case .failure(_):
                self?.books.removeAll()
            }
        })
        spinner.stopAnimating()
        collectionView.reloadData()
    }
}

extension BookListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        cell.configure(with: bookStore, book: book)
        
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
        vc.store = bookStore
        vc.book = book
        delegate?.didSelectBook(vc: vc)
    }
}

protocol BookListViewDelegate: AnyObject {
    func didSelectBook(vc: BookDetailsViewController)
}
