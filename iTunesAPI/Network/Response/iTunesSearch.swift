
import Foundation


struct ITunesSearchResponse: Codable {
    let resultCount: Int?
    let results: [BodyResult]?
}

struct BodyResult: Codable {
   
    let artistName: String?
    let collectionName: String?
    let collectionPrice: Double?
    let artworkUrl100: String?
    
}

