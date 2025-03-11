//
//  GitHubService.swift
//  Repositories
//
//  Created by hirrasalim on 11/03/2025.
//

import Foundation
import Combine

class GitHubService {
    private let baseURL = "https://api.github.com/orgs/square/repos"

    func fetchRepositories(page: Int) -> AnyPublisher<[Repository], Error> {
        let urlString = "\(baseURL)?page=\(page)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
