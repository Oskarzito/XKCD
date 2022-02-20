//
//  ComicDetailsViewController.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-19.
//

import UIKit
import Combine

final class ComicDetailsViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .primaryNavy
        tableView.delegate = self
        tableView.dataSource = self
        ComicDetailsImageTableViewCell.register(in: tableView)
        ComicDetailsTextTableViewCell.register(in: tableView)
        ComicDetailsButtonTableViewCell.register(in: tableView)
        tableView.separatorStyle = .none
        return tableView
    }()
        
    private var comic: Comic!
    private var comicImage: UIImage!
    
    private var observers: Set<AnyCancellable> = []
    
    func inject(with comic: Comic, image: UIImage) -> Self {
        self.comic = comic
        self.comicImage = image
        return self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = .primaryNavy
        navigationController?.navigationBar.backgroundColor = .primaryTeal
        navigationController?.navigationBar.tintColor = .primaryBeige
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.primaryBeige]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(didTapClose(_:)))
        
        tableView.align(in: view)
        navigationItem.title = comic.safe_title
    }
    
    @objc
    private func didTapClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func shareComic() {
        let ac = UIActivityViewController(activityItems: [comicImage!], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func openComicExplanation() {
        guard let url = URL(string: comic.explanationUrl) else {
            return
        }
        UIApplication.shared.open(url)
    }

}

extension ComicDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeue(type: ComicDetailsImageTableViewCell.self, for: indexPath)
            cell.configure(with: comicImage)
            return cell
        case 1:
            let cell = tableView.dequeue(type: ComicDetailsTextTableViewCell.self, for: indexPath)
            cell.configure(text: comic.title, style: .large, alignment: .center)
            return cell
        case 2:
            let cell = tableView.dequeue(type: ComicDetailsTextTableViewCell.self, for: indexPath)
            cell.configure(text: comic.transcript)
            return cell
        case 3:
            let cell = tableView.dequeue(type: ComicDetailsButtonTableViewCell.self, for: indexPath)
            cell.actions.sink { event in
                switch event {
                case .share:
                    self.shareComic()
                case .explanation:
                    self.openComicExplanation()
                }
            }.store(in: &observers)
            return cell
        default:
            fatalError()
        }
    }
}

extension ComicDetailsViewController: UITableViewDelegate {
}
