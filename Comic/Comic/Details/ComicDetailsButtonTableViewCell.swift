//
//  ComicDetailsButtonTableViewCell.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-20.
//

import UIKit
import Combine

final class ComicDetailsButtonTableViewCell: UITableViewCell {

    enum ButtonEvent {
        case share
        case explanation
    }
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton, explanationButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.backgroundColor = .primaryNavy
        return stackView
    }()
    
    private let shareButton: UIButton = {
        return ButtonUtils.shareButton(withTitle: "Share", textColor: .primaryBeige, backgroundColor: .primaryTeal)
    }()
    
    private let explanationButton: UIButton = {
        return ButtonUtils.standardButton(withTitle: "Explanation?", textColor: .primaryBeige, backgroundColor: .primaryTeal)
    }()
    
    let actions = PassthroughSubject<ButtonEvent, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.backgroundColor = .primaryNavy
        shareButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonStack.align(in: contentView, withInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
        
        shareButton.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)
        
        explanationButton.addTarget(self, action: #selector(didTapExplain(_:)), for: .touchUpInside)
    }
    
    @objc
    private func didTapShare(_ sender: Any) {
        actions.send(.share)
    }
    
    @objc
    private func didTapExplain(_ sender: Any) {
        actions.send(.explanation)
    }

}
