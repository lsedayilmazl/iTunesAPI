
import UIKit

class ArtistDetailViewController: UIViewController {

    
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var collectionNameLabel: UILabel!
    @IBOutlet var collectionPriceLabel: UILabel!
    @IBOutlet var artistImageView: UIImageView!
    
    var artistName: String?
    var collectionName: String?
    var collectionPrice: Double?
    var artworkUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sanatçı bilgilerini UI bileşenlerine yüklemek
        artistNameLabel.text = artistName ?? "Bilinmeyen Sanatçı"
        collectionNameLabel.text = collectionName ?? "Bilinmeyen Albüm"
        
        if let price = collectionPrice {
            collectionPriceLabel.text = "\(price) $"
        } else {
            collectionPriceLabel.text = "Bilinmeyen Fiyat"
        }
        
        // Sanatçı resmini yükle (eğer artworkUrl mevcutsa)
        if let artworkUrl = artworkUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: artworkUrl)!) {
                    DispatchQueue.main.async {
                        self.artistImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }

}
