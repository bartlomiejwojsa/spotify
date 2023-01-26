//
//  UserProfile.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
//    let followers: [String: Codable?]
    let id: String
    let product: String
    let images: [APIImage]
    let uri: String
}


//
//{
//    country = PL;
//    "display_name" = Wojsik;
//    email = "solainer1521@gmail.com";
//    "explicit_content" =     {
//        "filter_enabled" = 0;
//        "filter_locked" = 0;
//    };
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/user/mblm5ee6q3s5fpknaaas0cxbn";
//    };
//    followers =     {
//        href = "<null>";
//        total = 1;
//    };
//    href = "https://api.spotify.com/v1/users/mblm5ee6q3s5fpknaaas0cxbn";
//    id = mblm5ee6q3s5fpknaaas0cxbn;
//    images =     (
//                {
//            height = "<null>";
//            url = "https://i.scdn.co/image/ab6775700000ee854d65832625386c046cc7b5ee";
//            width = "<null>";
//        }
//    );
//    product = premium;
//    type = user;
//    uri = "spotify:user:mblm5ee6q3s5fpknaaas0cxbn";
//}
