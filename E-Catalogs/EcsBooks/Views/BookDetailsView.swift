//
//  DetailsView.swift
//  E-Catalogs
//
//  Created by rColeJnr on 09/08/24.
//

import UIKit

class BookDetailsView: UIView {
    
    private let image = {
        let view = UIImageView()
        view.image = UIImage(systemName: "car")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let overview = {
        let view = UITextView()
        view.text = "Overview of a book usually goes a few lines long, just long enough for a review"
        view.adjustsFontForContentSizeCategory = true
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let author = {
        let view = UILabel()
        view.text = "Book by: Author rothua"
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let rank = {
        let view = UILabel()
        view.text = "Rank: 1"
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let rankLastWeek = {
        let view = UILabel()
        view.text = "Rank last week: 1"
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let weeksOnList = {
        let view = UILabel()
        view.text = "Weeks on list: 22"
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let amazonLink = {
        let view = UILabel()
        view.text = "Show on amazon"
        view.font = .systemFont(ofSize: 26, weight: .medium)
        view.textColor = .label
        view.textAlignment = .center
        view.backgroundColor = .secondarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(image, overview, author, rank, rankLastWeek, weeksOnList, amazonLink)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 320),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            
            overview.topAnchor.constraint(equalTo: image.bottomAnchor),
            overview.heightAnchor.constraint(lessThanOrEqualToConstant: 110),
            overview.leadingAnchor.constraint(equalTo: leadingAnchor),
            overview.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            author.topAnchor.constraint(equalTo: overview.bottomAnchor),
            author.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            author.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            rank.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 10),
            rank.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            rank.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            rankLastWeek.topAnchor.constraint(equalTo: rank.bottomAnchor, constant: 10),
            rankLastWeek.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            rankLastWeek.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            weeksOnList.topAnchor.constraint(equalTo: rankLastWeek.bottomAnchor, constant: 10),
            weeksOnList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            weeksOnList.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            amazonLink.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            amazonLink.heightAnchor.constraint(equalToConstant: 40),
            amazonLink.leadingAnchor.constraint(equalTo: leadingAnchor),
            amazonLink.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
        ])
    }
    
    func configure(with book: Book, store: BookStore) {
        // Download book image
        store.fetchBookImage(url: book.image, key: book.isbn10, completion: { [weak self] result in
            guard case let .success(uIImage) = result else {
                self?.image.image = nil
                return
            }
            self?.image.image = uIImage
        })
        
        overview.text = book.bookDescription
        author.text = "Book by: \(book.author ?? "Unknown")"
        rank.text = "Rank: \(book.rank)"
        rankLastWeek.text = "Rank last week: \(book.rankLastWeek)"
        weeksOnList.text = "Weeks on list: \(book.rank)"
    }
    
    
}
