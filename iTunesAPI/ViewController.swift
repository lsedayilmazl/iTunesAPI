//
//  ViewController.swift
//  iTunesAPI
//
//  Created by Finartz on 23.07.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var mytableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    let cellIdentifier = "TableViewCellIdentifier"
    let viewModel = iTunesListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        mytableView.dataSource = self
        mytableView.delegate = self
        
        mytableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        search()
    }
    
    func search() {
        guard let searchTerm = searchTextField.text, !searchTerm.isEmpty else {
            showAlert(message: "Lütfen sanatçı adını giriniz.")
            return
        }
        
        viewModel.search(term: searchTerm) {
            DispatchQueue.main.async {
                self.mytableView.reloadData()
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItem()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        let result = viewModel.getSearchResult(at: indexPath.row)
        cell.artistNameLabel.text = result.artistName ?? "Bilinmeyen Sanatçı"
        cell.collectionNameLabel.text = result.collectionName ?? "Bilinmeyen Albüm"
        if let price = result.collectionPrice {
            cell.collectionPriceLabel.text = "\(price) $"
        } else {
            cell.collectionPriceLabel.text = "Bilinmeyen Fiyat"
        }
        
        if let artworkUrl = result.artworkUrl100 {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: artworkUrl)!) {
                    DispatchQueue.main.async {
                        cell.artistImageView?.image = UIImage(data: data)
                        cell.artistImageView?.layer.cornerRadius = (cell.artistImageView?.bounds.size.width ?? 0) / 2.0
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArtist = viewModel.searchResults[indexPath.row]
        
        // Storyboard'dan ArtistDetailViewController'ı yükleme
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let artistDetailVC = storyboard.instantiateViewController(withIdentifier: "ArtistDetailViewController") as? ArtistDetailViewController else {
            fatalError("Unable to instantiate ArtistDetailViewController")
        }
        
        // Seçilen sanatçının bilgilerini ArtistDetailViewController'a aktar
        artistDetailVC.artistName = selectedArtist.artistName ?? "Bilinmeyen Sanatçı"
        artistDetailVC.collectionName = selectedArtist.collectionName ?? "Bilinmeyen Albüm"
        artistDetailVC.collectionPrice = selectedArtist.collectionPrice
        artistDetailVC.artworkUrl = selectedArtist.artworkUrl100
        
        // ArtistDetailViewController'ı göster
        navigationController?.pushViewController(artistDetailVC, animated: true)
    }
}
extension ViewController: ITunesListViewDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.mytableView.reloadData()
        }
    }
}



