//
//  NewReleasesResponse.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 15/11/2022.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
}

//
//    albums =     {
//        href = "https://api.spotify.com/v1/browse/new-releases?country=PL&locale=pl-PL%2Cpl%3Bq%3D0.9&offset=0&limit=1";
//        items =         (
//                        {
//                "album_type" = album;
//                artists =                 (
//                                        {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/5PisHXBfzRVWCw1k6Ud3NC";
//                        };
//                        href = "https://api.spotify.com/v1/artists/5PisHXBfzRVWCw1k6Ud3NC";
//                        id = 5PisHXBfzRVWCw1k6Ud3NC;
//                        name = "Cicho\U0144";
//                        type = artist;
//                        uri = "spotify:artist:5PisHXBfzRVWCw1k6Ud3NC";
//                    }
//                );
//                "available_markets" =                 (
//                    AD,
//                    AE,
//                    ZM,
//                    ZW
//                );
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/album/5ytQWLsZd5fvrhFHTabzge";
//                };
//                href = "https://api.spotify.com/v1/albums/5ytQWLsZd5fvrhFHTabzge";
//                id = 5ytQWLsZd5fvrhFHTabzge;
//                images =                 (
//                                        {
//                        height = 640;
//                        url = "https://i.scdn.co/image/ab67616d0000b27311ec09d2ab548befee2591b5";
//                        width = 640;
//                    },
//                                        {
//                        height = 300;
//                        url = "https://i.scdn.co/image/ab67616d00001e0211ec09d2ab548befee2591b5";
//                        width = 300;
//                    },
//                                        {
//                        height = 64;
//                        url = "https://i.scdn.co/image/ab67616d0000485111ec09d2ab548befee2591b5";
//                        width = 64;
//                    }
//                );
//                name = Humor;
//                "release_date" = "2022-11-09";
//                "release_date_precision" = day;
//                "total_tracks" = 11;
//                type = album;
//                uri = "spotify:album:5ytQWLsZd5fvrhFHTabzge";
//            }
//        );
//        limit = 1;
//        next = "https://api.spotify.com/v1/browse/new-releases?country=PL&locale=pl-PL%2Cpl%3Bq%3D0.9&offset=1&limit=1";
//        offset = 0;
//        previous = "<null>";
//        total = 100;
//    };
//}
