//
//  RepositoryDetailsViewModel.swift
//  Repositories
//
//  Created by hirrasalim on 11/03/2025.
//
import Foundation
import Combine

class RepositoryDetailsViewModel {
    // MARK: - Properties
    @Published var repositoryName: String = ""
    @Published var repositoryStars: Int = 0
    @Published var isBookmarked: Bool = false
    @Published var ownerAvatarURL: String = ""
    @Published var ownerProfileURL: String = ""
    private let repository: RepositoryEntity
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(repository: RepositoryEntity) {
        self.repository = repository
        setupBindings()
    }
    
    // MARK: - Public Methods
    func toggleBookmark() {
        repository.isBookmarked.toggle()
        coreDataManager.saveContext()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Bind repository properties to the view model
        repositoryName = repository.name ?? "Unknown"
        repositoryStars = Int(repository.star)
        
        // Observe changes to isBookmarked
        repository.publisher(for: \.isBookmarked)
            .assign(to: \.isBookmarked, on: self)
            .store(in: &cancellables)
        ownerAvatarURL = repository.ownerAvatarURL ?? ""
        ownerProfileURL = repository.ownerProfileURL ?? ""
    }
    
}
