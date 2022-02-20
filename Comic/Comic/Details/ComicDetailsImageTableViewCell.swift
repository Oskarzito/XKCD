//
//  ComicDetailsImageTableViewCell.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-20.
//

import UIKit

final class ComicDetailsImageTableViewCell: UITableViewCell {
    
    private let comicImageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        comicImageView.align(in: contentView)
    }
    
    func configure(with image: UIImage) {
        comicImageView.image = image
    }
}
