//
//  MainViewModel.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-06.
//

import Foundation
import Combine

final class MainViewModel {
    
    struct ComicResponse: Codable {
        let month: String
        let num: Int
        let link: String
        let year: String
        let news: String
        let safe_title: String
        let transcript: String
        let alt: String
        let img: String //URL
        let title: String
        let day: String
    }
    
    indirect enum ViewState {
        case uninitiated
        case initialLaunch
        case loading
        case didFinishLoading(with: ComicResponse, fromState: ViewState)
        case error
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private(set) var viewState: ViewState = .uninitiated
    
    private var comicIds: Set<Int> = []
    
    func start() {
        viewState = .initialLaunch
        fetchComic(withId: findNextComicId())
    }
    
    // Finds a random id for a comic that hasn't been viewed in this session
    private func findNextComicId() -> Int {
        let maxId = 2000
        
        if comicIds.count >= maxId {
            comicIds.removeAll()
        }
        
        var id: Int
        repeat {
            id = Int.random(in: 1...maxId)
        } while comicIds.contains(id)
        
        comicIds.update(with: id)
        return id
    }
    
    private func fetchComic(withId id: Int) {
        let initialUrl = URL(string: "https://xkcd.com/\(id)/info.0.json")!

        URLSession.shared
            .dataTaskPublisher(for: initialUrl)
            .map {
                return $0.data
            }
            .decode(type: ComicResponse.self, decoder: JSONDecoder())
            .mapError({ error in
                fatalError()
            })
            .eraseToAnyPublisher()
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.viewState = .error
                case .finished:
                    break
                }
            } receiveValue: { response in
                print("response: \(response)")
                self.viewState = .didFinishLoading(with: response, fromState: self.viewState)
            }
            .store(in: &cancellables)
    }
    
    func didTapNext() {
        viewState = .loading
        fetchComic(withId: findNextComicId())
    }
    
    func didTapPrevious() {
        
    }
}
