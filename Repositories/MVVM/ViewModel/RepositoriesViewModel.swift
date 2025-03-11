//
//  RepositoriesViewModel.swift
//  Repositories
//
//  Created by hirrasalim on 11/03/2025.
//

import Foundation
import Combine

class RepositoriesViewModel {
    // MARK: - Properties
    private let githubService = GitHubService()
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var repositories: [RepositoryEntity] = []
    @Published var isLoading = false
    @Published var error: Error?

    private var currentPage = 1
    private var hasMorePages = true

    // MARK: - Public Methods
    func fetchRepositories() {
        guard !isLoading, hasMorePages else { return }

        isLoading = true
        githubService.fetchRepositories(page: currentPage)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            } receiveValue: { [weak self] repositories in
                self?.handleFetchedRepositories(repositories)
            }
            .store(in: &cancellables)
    }

    func refreshRepositories() {
        currentPage = 1
        hasMorePages = true
        repositories.removeAll()
        fetchRepositories()
    }

    // MARK: - Private Methods
    private func handleFetchedRepositories(_ repositories: [Repository]) {
        // Save repositories to CoreData
        coreDataManager.saveRepositories(repositories)

        // Fetch repositories from CoreData
        self.repositories = coreDataManager.fetchRepositories()
        print(repositories)

        // Update pagination state
        if repositories.isEmpty {
            hasMorePages = false
        } else {
            currentPage += 1
        }
    }
}
