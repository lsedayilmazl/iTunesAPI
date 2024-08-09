import Foundation

class Network {
    
    static let shared = Network()
    
    private init() {}
    
    func request(url: String, completion: @escaping (Result<ITunesSearchResponse, NetworkError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let products = try JSONDecoder().decode(ITunesSearchResponse.self, from: data)
                completion(.success(products))
            }
            catch {
                completion(.failure(.message(error)))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidData
    case invalidResponse
    case invalidUrl
    case message(_ error: Error?)
}



