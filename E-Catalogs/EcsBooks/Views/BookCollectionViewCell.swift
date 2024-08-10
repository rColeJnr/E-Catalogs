//
//  BookCollectionViewCell.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "BookCollectionViewCell"
    
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
    
    @objc func labelClicked(_ sender: Any) {
        print("Clicked")
    }
        
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
        view.image = UIImage(systemName: "star")
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true       
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let showTranslation: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.text = "Show translation"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
                                  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(bookImage, title, author, favoriteButton, showTranslation
        )
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:))
        )
        favoriteButton.addGestureRecognizer(gestureRecognizer)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 30),
            author.heightAnchor.constraint(equalToConstant: 30),
            showTranslation.heightAnchor.constraint(equalToConstant: 40),
         
            bookImage.widthAnchor.constraint(equalToConstant: 120),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            bookImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bookImage.bottomAnchor.constraint(equalTo: showTranslation.topAnchor, constant: 2),
            
            showTranslation.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            showTranslation.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
            
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
    
    func configure(with bookStore: BookStore?, book: Book) {
        title.text = book.title
        author.text = book.author
        // Download the book image data
        bookStore?.fetchBookImage(url: book.image, key: book.isbn10, completion: { [weak self] result in
            guard case let .success(uIImage) = result else {
                self?.bookImage.image = nil
                return
            }
            self?.bookImage.image = uIImage
        })
    }
}
