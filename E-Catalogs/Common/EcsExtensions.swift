//
//  Extensions.swift
//  E-Catalogs
//
//  Created by rColeJnr on 08/08/24.
//

import UIKit

extension UIView {
    /// Add multiple subviews
    /// - Parameter views: Variadic views
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
    
    func showErrorMsg(msg: String) -> UIView {
        let errorView = {
            let view = UILabel()
            view.text = "Whoops, failure with msg: \(msg)"
            view.textColor = .systemRed
            view.font = .systemFont(ofSize: 20, weight: .medium)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        return errorView
    }

//    func addPinnedSubview(
//        _ subview: UIView, height: CGFloat? = nil,
//        insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//    ) {
//        addSubview(subview)
//        subview.translatesAutoresizingMaskIntoConstraints = false
//        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
//        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
//        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 * insets.right)
//            .isActive = true
//        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom)
//            .isActive = true
//        if let height {
//            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
//        }
//    }
    
}

extension UIViewController {
    
    func setupView(_ view: UIView) {
        self.view.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension UIDevice {
    /// Check if current device is phone idiom
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}


