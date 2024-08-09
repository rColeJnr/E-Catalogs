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
        let view = UILabel()
        view.text = "Overview of a book usually goes a few lines long, just long enough for a review"
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let author = {
        let view = UILabel()
        view.text = "Author rothua"
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let rank = {
        let view = UILabel()
        view.text = "rank: 1"
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let rankLastWeek = {
        let view = UILabel()
        view.text = "rank last week: 1"
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let weeksOnList = {
        let view = UILabel()
        view.text = "weeks on list: 22"
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let amazonLink = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .label
        view.text = "Show on amazon"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(image/* overview, author, rank, rankLastWeek, weeksOnList, amazonLink*/)
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 500),
            image.widthAnchor.constraint(equalToConstant: 333),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
