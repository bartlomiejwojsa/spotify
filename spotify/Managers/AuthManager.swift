//
//  AuthManager.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import Foundation

// make sure user is signed in and stuff..

struct AuthConfig {
    var clientID: String?
    var clientSecret: String?
}

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    private var clientID: String = ""
    private var clientSecret: String = ""

    struct Constants {
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.google.com/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {
        let configuration = getConfiguration()
        guard let safeClientID = configuration?.clientID, let safeClientSecret = configuration?.clientSecret else {
            return
        }
        self.clientID = safeClientID
        self.clientSecret = safeClientSecret
    }
    
    private func getConfiguration() -> AuthConfig? {
        guard let path = Bundle.main.path(forResource: "AuthConfiguration", ofType: "plist") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainers,
            format: nil) as? [String: String] else {
            return nil
        }
        var result = AuthConfig()
        for (key, value) in plist {
            if key == "clientID" {
                result.clientID = value
            } else if key == "clientSecret" {
                result.clientSecret = value
            }
        }
        return result
    }
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(self.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return true
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        //Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = self.clientID+":"+self.clientSecret
        let tokenRepresentation = basicToken.data(using: .utf8)
        guard let tokenEncoded = tokenRepresentation?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue(
            "Basic \(tokenEncoded)",
            forHTTPHeaderField: "Authorization"
        )
        request.httpBody = components.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data,_,error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
            }
            catch {
                
            }
        })
        task.resume()
    }
    
    // array with executable completions of token refresh results
    private var onRefreshBlocks = [((String) -> Void)]()
    
    
    /// Supplies valid token to be used with API Calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // append the completion to be executed once the refreshing is finished
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            // refresh
            refreshIfNeeded(completion: {[weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            })
        }
        else if let token = accessToken {
            // return
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        // make sure that there is no another refreshing process in background
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        //Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"),
            URLQueryItem(name: "refresh_token",
                         value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = self.clientID+":"+self.clientSecret
        let tokenRepresentation = basicToken.data(using: .utf8)
        guard let tokenEncoded = tokenRepresentation?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        request.setValue(
            "Basic \(tokenEncoded)",
            forHTTPHeaderField: "Authorization"
        )
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("successfully refreshed token !!\(result)")
                self?.onRefreshBlocks.forEach( {completion in
                    completion(result.access_token)
                })
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch {
                
            }
            
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(
            result.access_token,
            forKey: "access_token"
        )
        UserDefaults.standard.setValue(
            Date().addingTimeInterval(TimeInterval(result.expires_in)),
            forKey: "expirationDate"
        )
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(
                refresh_token,
                forKey: "refresh_token")
        }
        
    }
    
    public func clearToken() {
        UserDefaults.standard.setValue(
            nil,
            forKey: "access_token"
        )
        UserDefaults.standard.setValue(
            nil,
            forKey: "expirationDate"
        )
        UserDefaults.standard.setValue(
            nil,
            forKey: "refresh_token")
    
    }
}
