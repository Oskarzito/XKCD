//
//  ComicDetailsTextTableViewCell.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-20.
//

import UIKit

final class ComicDetailsTextTableViewCell: UITableViewCell {
    
    enum TextStyle {
        case normal
        case large
    }
    
    enum TextAlignment {
        case center
        case left
    }
    
    private let labelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textColor = .primaryBeige
        labelView.numberOfLines = 0
        return labelView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.backgroundColor = .primaryNavy
        labelView.backgroundColor = .primaryNavy
        labelView.align(in: contentView, withInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
    }
    
    func configure(text: String, style: TextStyle = .normal, alignment: TextAlignment = .left) {
        labelView.text = text
        labelView.font = labelView.font.withSize(style == .normal ? 16 : 36)
        labelView.textAlignment = alignment == .left ? .left : .center
    }
}
