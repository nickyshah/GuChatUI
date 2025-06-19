import Foundation

struct CountryCode: Identifiable, Hashable, Decodable {
    let id = UUID()
    let countryCode: String
    let name: String
    let dialCode: String
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "code"
        case name
        case dialCode = "dial_code"
    }
    
    var flag: String {
        let base: UInt32 = 127397
        var flag = ""
        for scalar in countryCode.unicodeScalars {
            guard let scalarValue = UnicodeScalar(base + scalar.value) else { continue }
            flag.append(String(scalarValue))
        }
        return flag
    }
    
    static let defaultCodes: [CountryCode] = [
        CountryCode(countryCode: "AU", name: "Australia", dialCode: "+61"),
        CountryCode(countryCode: "US", name: "United States", dialCode: "+1"),
        CountryCode(countryCode: "GB", name: "United Kingdom", dialCode: "+44"),
        CountryCode(countryCode: "IN", name: "India", dialCode: "+91"),
        CountryCode(countryCode: "JP", name: "Japan", dialCode: "+81")
    ]
}
