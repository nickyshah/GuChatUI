import Foundation

final class CountryCodeViewModel: ObservableObject {
    @Published var codes: [CountryCode] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func load() {
        guard codes.isEmpty else { return }
        isLoading = true
        
        // Start with local codes immediately
        self.codes = CountryCode.defaultCodes
        
        // Then try to fetch from API
        fetchFromAPI {
            self.isLoading = false
        }
    }
    
    private func fetchFromAPI(completion: @escaping () -> Void) {
        // Use a reliable JSON source
        guard let url = URL(string: "https://gist.githubusercontent.com/anubhavshrimal/75f6183458db8c453306f93521e93d37/raw/f77e7598a8503f1f70528ae1cbf9f66755698a16/CountryCodes.json") else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("API Error: \(error.localizedDescription)")
                    completion()
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    completion()
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode([CountryCode].self, from: data)
                    self.codes = decoded.sorted { $0.name < $1.name }
                    print("Successfully loaded \(self.codes.count) countries")
                } catch {
                    print("Decoding error: \(error)")
                }
                completion()
            }
        }.resume()
    }
}
