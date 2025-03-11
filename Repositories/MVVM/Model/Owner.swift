//
//  Owner.swift
//  Repositories
//
//  Created by hirrasalim on 12/03/2025.
//

import Foundation
struct Owner : Codable {

    let avatar_url : String?
   
    enum CodingKeys: String, CodingKey {
        case avatar_url = "avatar_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avatar_url = try values.decodeIfPresent(String.self, forKey: .avatar_url)
    }

}
