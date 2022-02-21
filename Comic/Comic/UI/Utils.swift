//
//  Utils.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-13.
//

import UIKit

extension UIView {
    func align(in parentView: UIView, withInsets insets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -insets.bottom),
            centerXAnchor.constraint(equalTo: parentView.centerXAnchor)
        ])
    }
}

final class ButtonUtils {
    static func shareButton(withTitle title: String, textColor: UIColor, backgroundColor: UIColor) -> UIButton {
        let button = standardButton(withTitle: title, textColor: textColor, backgroundColor: backgroundColor)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.tintColor = .primaryBeige
        return button
    }
    
    static func standardButton(withTitle title: String, textColor: UIColor, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(textColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(24)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        return button
    }
}

extension UITableViewCell {
    static func register(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: NSStringFromClass(self))
    }
}

extension UITableView {
    func dequeue<Cell: UITableViewCell>(type: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: NSStringFromClass(type), for: indexPath) as! Cell
    }
}

extension UIViewController {
    func presentShareActivity(for image: UIImage) {
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(ac, animated: true)
    }
}
