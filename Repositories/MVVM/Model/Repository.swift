//
//  Repository.swift
//  Repositories
//
//  Created by hirrasalim on 11/03/2025.
//
import Foundation
struct Repository : Codable {

    let name : String?
    let owner : Owner?
    let html_url : String?
    let stargazers_count : Int?
    let description : String?

    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case owner = "owner"
        case html_url = "html_url"
        case stargazers_count = "stargazers_count"
        case description = "description"
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        name = try values.decodeIfPresent(String.self, forKey: .name)
        owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
        html_url = try values.decodeIfPresent(String.self, forKey: .html_url)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        stargazers_count = try values.decodeIfPresent(Int.self, forKey: .stargazers_count)

        
    }

}
