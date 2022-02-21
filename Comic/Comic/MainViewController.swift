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
    
    private lazy var cardView: CardView = {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isHidden = true
        cardView.delegate = self
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
    
    private let comicIdTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .primaryTeal
        textField.textColor = .primaryBeige
        textField.textAlignment = .center
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton, nextButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.isHidden = true
        return stackView
    }()
    
    private let shareButton: UIButton = {
        return ButtonUtils.shareButton(withTitle: String(.generalShare), textColor: .primaryBeige, backgroundColor: .primaryTeal)
    }()

    private let nextButton: UIButton = {
        return ButtonUtils.standardButton(withTitle: "\(String(.generalNext)) >", textColor: .primaryBeige, backgroundColor: .primaryTeal)
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
        view.addSubview(titleLabel)
        view.addSubview(cardView)
        view.addSubview(comicIdTextField)
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
            
            comicIdTextField.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            comicIdTextField.widthAnchor.constraint(equalToConstant: 56),
            comicIdTextField.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            comicIdTextField.heightAnchor.constraint(equalToConstant: 24),
            
            buttonStack.topAnchor.constraint(equalTo: comicIdTextField.bottomAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
        ])
        
        shareButton.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        
        let numberPadToolbar: UIToolbar = UIToolbar()
        
        numberPadToolbar.items=[
            UIBarButtonItem(
                title: String(.generalCancel),
                style: .plain,
                target: self,
                action: #selector(didTapCancel(_:))
            ),
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
                title: String(.generalSearch),
                style: .plain,
                target: self,
                action: #selector(didTapSearch(_:))
            )
        ]

        numberPadToolbar.sizeToFit()
        comicIdTextField.inputAccessoryView = numberPadToolbar
    }
    
    @objc
    private func didTapNext(_ sender: UIButton) {
        viewModel.didTapNext()
    }
    
    @objc
    private func didTapShare(_ sender: UIButton) {
        guard let currentComicImage = cardView.imageView.image else {
            return
        }
        presentShareActivity(for: currentComicImage)
    }
    
    @objc
    private func didTapSearch(_ sender: Any) {
        guard var id = Int(comicIdTextField.text ?? "") else {
            return
        }
        
        if id > 2000 {
            id = 2000
        } else if id <= 0 {
            id = 1
        }
        comicIdTextField.resignFirstResponder()
        viewModel.didTapSearch(withId: id)
    }
    
    @objc
    private func didTapCancel(_ sender: Any) {
        comicIdTextField.resignFirstResponder()
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
    
    private func showComic(_ comic: Comic, _ fromState: MainViewModel.ViewState) {
        cardView.isHidden = false
        titleLabel.isHidden = false
        buttonStack.isHidden = false
        
        titleLabel.text = comic.title
        comicIdTextField.text = "\(comic.num)"
        
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

extension MainViewController: CardViewDelegate {
    func didTapCardView(_ cardView: CardView, image: UIImage?) {
        guard let currentComic = viewModel.currentComic,
              let image = image else {
            return
        }
        let vc = ComicDetailsViewController().inject(with: currentComic, image: image)
        let navVc = UINavigationController(rootViewController: vc)
    
        present(navVc, animated: true, completion: nil)
    }
}
