import Foundation

final class NetworkClient {
    private let urlSession = URLSession.shared
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func fetchData() {
        guard let url = URL(string: AppConstatns.apiEndpoint) else {
            print("Failed to creare URL")
            return
        }
        
        urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error getting data from API: \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                print("Data is missing")
                return
            }
            
            guard let networkResponse: NetworkResponse = try? JSONDecoder().decode(NetworkResponse.self, from: data) else {
                print("Failed to decode network response")
                return
            }
            
            DispatchQueue.main.async {
                self.storage.collections = networkResponse.data
            }
        }.resume()
    }
}
