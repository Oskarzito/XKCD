//
//  ViewController.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-06.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    private let loadingOverlayView: UIView = {
        let overylayView = UIView()
        overylayView.backgroundColor = .primaryNavy
        overylayView.isUserInteractionEnabled = false
        return overylayView
    }()
    
    private let loadingSpinnerView: UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .primaryBeige
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let cardView: CardView = {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isHidden = true
        return cardView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryBeige
        label.numberOfLines = 0
        label.font = label.font.withSize(36)
        label.text = ""
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.isHidden = true
        return stackView
    }()
    
    private let previousButton: UIButton = {
        return ButtonUtils.standardButton(withTitle: "< Previous", textColor: .primaryBeige, backgroundColor: .primaryTeal)
    }()

    private let nextButton: UIButton = {
        return ButtonUtils.standardButton(withTitle: "Next >", textColor: .primaryBeige, backgroundColor: .primaryTeal)
    }()
    
    private let viewModel = MainViewModel()
    
    private var observers: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeViewState()
        viewModel.start()
    }
    
    private func setupView() {
        view.backgroundColor = .primaryNavy
        view.addSubview(cardView)
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.heightAnchor.constraint(equalToConstant: 400),
            
            titleLabel.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -24),
            titleLabel.leadingAnchor.constraint(lessThanOrEqualTo: cardView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -8),
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            buttonStack.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
        ])
        
        previousButton.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
    }
    
    @objc
    private func didTapNext(_ sender: UIButton) {
        viewModel.didTapNext()
    }
    
    @objc
    private func didTapPrevious(_ sender: UIButton) {
        viewModel.didTapPrevious()
    }
    
    private func observeViewState() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                guard let strongSelf = self else {
                    return
                }
                
                switch viewState {
                case .initialLaunch:
                    strongSelf.showLoadingOverlay()
                case .loading:
                    strongSelf.showLoading()
                case .didFinishLoading(let comic, let fromState):
                    strongSelf.showComic(comic, fromState)
                case .error:
                    strongSelf.showError()
                case .uninitiated:
                    break //do nothing
                }
                
            }
            .store(in: &observers)
    }
    
    private func showLoadingOverlay() {
        loadingOverlayView.align(in: view)
        loadingOverlayView.addSubview(loadingSpinnerView)
        NSLayoutConstraint.activate([
            loadingSpinnerView.centerXAnchor.constraint(equalTo: loadingOverlayView.centerXAnchor),
            loadingSpinnerView.centerYAnchor.constraint(equalTo: loadingOverlayView.centerYAnchor)
        ])
        loadingSpinnerView.startAnimating()
    }
    
    private func showLoading() {
        loadingSpinnerView.startAnimating()
        loadingOverlayView.alpha = 0.55
        loadingSpinnerView.isHidden = false
        loadingOverlayView.isHidden = false
    }
    
    private func showComic(_ comic: MainViewModel.ComicResponse, _ fromState: MainViewModel.ViewState) {
        cardView.isHidden = false
        titleLabel.isHidden = false
        buttonStack.isHidden = false
        
        titleLabel.text = comic.title
        
        let url = URL(string: comic.img)!
        let data = try? Data(contentsOf: url)
        cardView.set(image: UIImage(data: data!)!)
        
        switch fromState {
        case .initialLaunch:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismissInitialLoadingView()
            }
        default:
            dismissLoading()
        }
    }
    
    private func dismissInitialLoadingView() {
        UIView.animate(withDuration: 0.75) {
            self.loadingOverlayView.alpha = 0.0
        } completion: { didFinish in
            self.loadingOverlayView.isHidden = true
            self.loadingSpinnerView.stopAnimating()
        }
    }
    
    private func dismissLoading() {
        self.loadingOverlayView.isHidden = true
        self.loadingSpinnerView.stopAnimating()
    }
    
    private func showError() {
        
    }
}

