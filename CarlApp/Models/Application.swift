//
//  Application.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 15.10.2024.
//

import Foundation

struct Application: Decodable, Hashable {
    let name: String
    let type: String
    let row: Int
    let column: Int
    let appIcon: String?
    let appUrl: String?
    let appStoreUrl: String?
    let radioUrl: String?
    let musicUrl: String?
    let singer: String?
    var images: [Images]?
    let phoneNumber: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case name, type, row, column, appIcon, appUrl, appStoreUrl, radioUrl, musicUrl, singer, images, phoneNumber, imageUrl
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decode(String.self, forKey: .type)
        row = try values.decode(Int.self, forKey: .row)
        column = try values.decode(Int.self, forKey: .column)

        appIcon = try? values.decode(String.self, forKey: .appIcon)
        appUrl = try? values.decode(String.self, forKey: .appUrl)
        appStoreUrl = try? values.decode(String.self, forKey: .appStoreUrl)
        radioUrl = try? values.decode(String.self, forKey: .radioUrl)
        musicUrl = try? values.decode(String.self, forKey: .musicUrl)
        singer = try? values.decode(String.self, forKey: .singer)
        images = try? values.decode([Images].self, forKey: .images)
        phoneNumber = try? values.decode(String.self, forKey: .phoneNumber)
        imageUrl = try? values.decode(String.self, forKey: .imageUrl)
    }
}

struct Images: Decodable, Hashable {
    let description: String?
    let imageUrl: String
    let personImage: String?

    enum CodingKeys: String, CodingKey {
        case description, imageUrl, personImage
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        description = try? values.decode(String.self, forKey: .description)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
        personImage = try? values.decode(String.self, forKey: .personImage)
    }
}
