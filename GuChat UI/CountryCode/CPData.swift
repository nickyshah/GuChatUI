import Foundation
struct CPData: Codable, Identifiable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    let limit: Int
    
    static let allCountry: [CPData] = Bundle.main.decode("CountryNumbers.json")
    static let example = allCountry[0]
}

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

struct CountryCode: Identifiable, Hashable{
    let id: String         // Use CPData's ID
    let name: String
    let dialCode: String
    let flag: String
    // Added pattern and limit as these are useful properties
    let pattern: String
    let limit: Int
    
    // Convenience initializer to create from CPData
    init(cpData: CPData){
        self.id = cpData.id
        self.name = cpData.name
        self.dialCode = cpData.dial_code
        self.flag = cpData.flag
        self.pattern = cpData.pattern
        self.limit = cpData.limit
    }
}

final class CountryCodeViewModel: ObservableObject {
    @Published var countryCodes: [CountryCode] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        self.countryCodes = CPData.allCountry.map{ CountryCode(cpData: $0) }
        self.isLoading = false
    }
    
    func load(){
        if countryCodes.isEmpty{
            self.countryCodes = CPData.allCountry.map{ CountryCode(cpData: $0) }
        }
        self.isLoading = false
        self.errorMessage = nil
    }
}
