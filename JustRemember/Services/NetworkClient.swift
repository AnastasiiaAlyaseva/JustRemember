import Foundation

final class NetworkClient: ObservableObject {
    
    @Published var collections: [Collection] = []
    
    
    func fetchDataFromURL() {
        
        guard let url = URL(string: "https://script.google.com/macros/s/AKfycbxjrp93Wy1W2gH-F4IGuDb6dv8-M8aFhuOqwZd4n0TBX6DK8iLUgS0jsjXP0a9B0Ts/exec")
        else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                print("Error getting documents data: \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                print("Error ")
                return
                
            }
            guard let networkResponse: NetworkResponse = try? JSONDecoder().decode(NetworkResponse.self, from: data) else {
                print("networkResponse error")
                return
                
            }
            DispatchQueue.main.async {
                self.collections = networkResponse.data
            }
        }.resume()
    }
}
