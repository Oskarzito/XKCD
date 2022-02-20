//
//  CardView.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-13.
//

import Foundation
import UIKit

protocol CardViewDelegate: AnyObject {
    func didTapCardView(_ cardView: CardView, image: UIImage?)
}

final class CardView: UIView {
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    weak var delegate: CardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        layer.cornerRadius = 12
        layer.backgroundColor = UIColor.primaryTeal.cgColor
        
        addSubview(imageView)
        imageView.align(
            in: self,
            withInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        )
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
    }
    
    @objc
    private func didTapView(_ sender: Any) {
        delegate?.didTapCardView(self, image: imageView.image)
    }
    
    func loading() {
        
    }
    
    func set(image: UIImage) {
        imageView.image = image
    }
}
