//
//  iTunesListViewModel.swift
//  iTunesAPI
//
//  Created by Finartz on 25.07.2024.
//call backli yazmaya çalış sonra
//protocol iTunesListViewModelDelegate: AnyObject{ func updateUI ile dene
//didload içine configureUI() ve iTunes... .delegate = self , viewController da extension yap bunun içinde updateUI fonksiyonu olacak (reloaddata burda)



import Foundation
import Kingfisher

protocol ITunesListViewDelegate: AnyObject {
    func updateUI()
}
 
class iTunesListViewModel {
    
    weak var delegate: ITunesListViewDelegate?
    let network = Network.shared
    var searchResults: [BodyResult] = []
    
    func search(term: String, completion: @escaping () -> Void) {
        network.request(url: "https://itunes.apple.com/search?term=\(term)") { result in
            switch result {
            case .success(let response):
                guard let count = response.resultCount, count > 0 else{
                    _ = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sanatçı bulunamadı."])
                    completion()
                    return
                }
                if let results = response.results {
                    self.searchResults = results
                    self.delegate?.updateUI()
                    completion()
                } else {
                    _ = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sanatçı bulunamadı."])
                    completion()
                }
            case .failure(_):
                completion()
            }
        }
    }
    
    func getSearchResult(at index: Int) -> BodyResult {
        return searchResults[index]
    }
    func getNumberOfItem() -> Int {
        searchResults.count
    }
    
}




