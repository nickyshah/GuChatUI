import Foundation
import Combine

// API Error Handeling
enum NetworkError: Error, LocalizedError{
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int, message: String)
    case authenticationError // For 401 Unauthorized
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid API URL."
        case .noData: return "No data received from the server."
        case .decodingError(let error): return "Failed to process server response: \(error.localizedDescription)"
        case .serverError(let statusCode, let message): return "Server error \(statusCode): \(message)"
        case .authenticationError: return "Authentication required or failed."
        case .unknown(let error): return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}

// API Response Model
struct APIResponse: Decodable {
    let success: Bool
    let message: String?
}

// OTP verification/Login response
struct AuthResponse: Decodable {
    let success: Bool
    let message: String?
    let token: String? // JWT token
    let userId: String?
}

// Username availability response
struct UsernameAvailabilityResponse: Decodable {
    let isAvailable: Bool // true if available, false if taken
    let message: String?
}

class APIManager: ObservableObject {
    static let shared = APIManager()
    
    private let baseURL = "https://vvgatewaybck.net.au/"
    
    @Published var authToken: String? = nil {
        didSet {
            if let token = authToken {
                UserDefaults.standard.set(token, forKey: "authToken")
            } else {
                UserDefaults.standard.removeObject(forKey: "authToken")
            }
            print("Auth Token updated: \(authToken ?? "nil")")
        }
    }
    
    @Published var currentUserId: String? = nil{
        didSet {
            // Persist User ID
            if let userId = currentUserId {
                UserDefaults.standard.set(userId, forKey: "currentUserId")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUserId")
            }
            print("Current User ID updated: \(currentUserId ?? "nil")")
        }
    }
    
    private init(){
            // Load persisted token and userId on app launch
        self.authToken = UserDefaults.standard.string(forKey: "authToken")
        self.currentUserId = UserDefaults.standard.string(forKey: "currentUserId")
    }
    
    // Generic function to perform a network request
    private func performRequest<T: Decodable>(url: URL, method:String, body:[String:Any]? = nil, requiresAuth:Bool = true) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        if requiresAuth, let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if requiresAuth{
            throw NetworkError.authenticationError
        }
        
        if let body = body{
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options:[])
        }
        
        let (data, response) = try await URLSession.shared.data(for : request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            // Handle specific status code
            if httpResponse.statusCode == 401 {
                self.logout()
                throw NetworkError.authenticationError
            }
            // Attempt to decode server error message
            if let jsonError = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = jsonError["message"] as? String {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: message)
            } else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: "Unknown server error")
            }
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // --- API Methods for the Auth Flow ---
    
    func logout(){
        self.authToken = nil
        self.currentUserId = nil
        print( "Logged out")
    }
}
