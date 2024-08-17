//
//  BookCollectionViewCell.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit
import CoreData

class BookCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "BookCollectionViewCell"
    
    private var book: Book!
    private var store: BookStore = EcsTabBarController.bookStore
 
    // MARK: - Views
    private let bookImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let title: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = .label
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let author: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = .label
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favoriteButton: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true       
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Gestures
    // Response to user on click actions
    
    /// Update isFavorite book property, attach book to new bookFavorite with a date.now object
    @objc private func onFavoriteClicked(_ sender: Any) {
        book.isFavorite = !book.isFavorite
        favoriteButton.image = if book.isFavorite {
            UIImage(systemName: "star.fill")
        } else {
            UIImage(systemName: "star")
        }
//        let newFav = NSEntityDescription.insertNewObject(forEntityName: "BookFavorite", into: context)
//        if (book.isFavorite) {
//            newFav.setValue(Date.now, forKey: "dateAdded")
//            book.favorite = newFav as? BookFavorite
//        } else {
//            // TODO, update item list after removal, maybe also give option to cancel removal
//            book.favorite = nil
//        }
//        
        do {
            try EcsStore.shared.persistentContainer.viewContext.save()
        } catch let error {
            print("Failed to save book favorite to core data: \(error)")
        }
    }
         
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(bookImage, title, author, favoriteButton)
         
        favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFavoriteClicked(_:))))
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View configurations
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 30),
            author.heightAnchor.constraint(equalToConstant: 30),
         
            bookImage.widthAnchor.constraint(equalToConstant: 120),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            bookImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bookImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
               
            title.topAnchor.constraint(equalTo: bookImage.topAnchor),
            title.leftAnchor.constraint(equalTo: bookImage.rightAnchor, constant: 4),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
            
            author.bottomAnchor.constraint(equalTo: bookImage.bottomAnchor),
            author.leftAnchor.constraint(equalTo: bookImage.rightAnchor, constant: 4),
            author.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
            
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
        ])
    }
    
    override func prepareForReuse() {
        bookImage.image = nil
    }
    
    /// BInd book data to UI
    func configure(book: Book) {
        self.book = book
        title.text = book.title
        author.text = book.author
        self.favoriteButton.image = if book.isFavorite {UIImage(systemName: "star.fill")} else { UIImage(systemName: "star")}
        // Download the book image data
        EcsStore.shared.ecsFetchImage(url: book.image, key: book.isbn10, completion: { [weak self] result in
            guard case let .success(uIImage) = result else {
                self?.bookImage.image = nil
                return
            }
            self?.bookImage.image = uIImage
        })
    }
}
