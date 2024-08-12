//
//  BookListView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

class BookListView: UIView {
    
    private var bookStore: BookStore = EcsTabBarController.bookStore
    private var books: [Book] = []
    public weak var delegate: BookListViewDelegate?
    
    // MARK: - Views
    
    private let categoryLabel = {
        let view = UILabel()
        view.text = "Selected category:"
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let optionsButton = {
        var viewConfig = UIButton.Configuration.gray()
        viewConfig.title = "Fiction"
        let view = UIButton(configuration: viewConfig)
        let options = ["Fiction", "Non fiction", "Miscellaneous", "Graphical/Manga"]
        let actions: [UIAction] = options.map {
            let action = UIAction(title: $0, handler:{ action in
                view.configuration?.title = action.title
            })
            return action
        }
        let menu = UIMenu(children: actions)
        view.menu = menu
        view.showsMenuAsPrimaryAction = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favoriteButton: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.image = UIImage(systemName: "star")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    // MARK: - GESTURES
    @objc private func onFavoriteClick(_ sender: Any) {
        let vc = BookFavoriteViewController()
        vc.store = bookStore
        delegate?.navigateToFavorites(vc: vc)
    }
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(categoryLabel, optionsButton, favoriteButton, collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        bookStore.fetchFictionBestsellers { _ in // on Completion, call the cached data
            self.fetchCachedFiction()
        }
        favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFavoriteClick(_:))))
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
            
            categoryLabel.leftAnchor.constraint(equalTo: leftAnchor),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.heightAnchor.constraint(equalToConstant: 30),
            
            optionsButton.topAnchor.constraint(equalTo: topAnchor),
            optionsButton.heightAnchor.constraint(equalToConstant: 30),
            optionsButton.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: -4),
            optionsButton.leftAnchor.constraint(equalTo: categoryLabel.rightAnchor, constant: 4),

            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            
            collectionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
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
                self?.collectionView.reloadData()
            case .failure(_):
                self?.books.removeAll()
                self?.collectionView.reloadData()
            }
        })
        spinner.stopAnimating()
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
        vc.store = bookStore
        vc.book = book
        delegate?.didSelectBook(vc: vc)
    }
}

protocol BookListViewDelegate: AnyObject {
    func didSelectBook(vc: BookDetailsViewController)
    func navigateToFavorites(vc: BookFavoriteViewController)
}
