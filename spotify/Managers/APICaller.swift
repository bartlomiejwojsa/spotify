//
//  APICaller.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {
        
    }
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: ~ Albums
    
    public func getAlbumDetails(
        for album: Album,
        completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) {data,_, err in
                guard let data = data, err == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
//                    let json = try JSONSerialization.jsonObject(
//                        with: data,
//                        options: .allowFragments
//                    )
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // MARK: ~ Playlists
    public func getPlaylistDetails(
        for playlist: Playlist,
        completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) {data,_, err in
                guard let data = data, err == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: ~ Profile
    public func getCurrentUserProfile(
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        let currentUserProfileURL = Constants.baseAPIURL + "/me"
        createRequest(
            with: URL(string: currentUserProfileURL),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest, completionHandler: {data, _, err in
                guard let data = data, err == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print("get current user profile human read result: \(result)")
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            })
            task.resume()
        }
        
    }
    
    // MARK: Browse
    
    public func getNewReleases(
        completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(json))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(
        completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>)) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(json))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(
        genres: Set<String>,
        completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)
    ) {
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)&limit=20"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(json))
                }
                catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
            
        }
    }
    
    public func getRecommendedGenres(
        completion: @escaping ((Result<AvailableGenreSeedsResponse, Error>) -> Void)
    ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(AvailableGenreSeedsResponse.self, from: data)
                    completion(.success(json))
                }
                catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
            
        }
    }
    
    
    public func getHomeDetails(
        completion: @escaping ((Result<[GroupResponse], Error>) -> Void)
    ) {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        // new releases
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error)
            }
        }
        // featured playlists
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylists = model
            case .failure(let error):
                print(error)
            }
        }
        // recommended tracks
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResults in
                    defer {
                        group.leave()
                    }
                    switch recommendedResults {
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases,
                  let playlists = featuredPlaylists,
                  let tracks = recommendations else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            completion(.success([
                GroupResponse.newRealeses(newAlbums),
                GroupResponse.featuredPlaylists(playlists),
                GroupResponse.recommendations(tracks)
            ]))
        }
    }
    
    // MARK: ~ Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken(completion: { token in
            guard let apiURL = url else {
                return
            }
            print(token)
            var request = URLRequest(url: apiURL)
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
            request.httpMethod = type.rawValue
            // give 30s to return result (timeout)
            request.timeoutInterval = 30
            completion(request)
            // do request being sure that valid token is supplied
        })
        
    }
}
