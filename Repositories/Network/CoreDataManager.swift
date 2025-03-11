//
//  CoreDataManager.swift
//  Repositories
//
//  Created by hirrasalim on 11/03/2025.
//

import CoreData
class CoreDataManager {
    static let shared = CoreDataManager()
    private let context: NSManagedObjectContext
    
    private init() {
        let container = NSPersistentContainer(name: "Repositories") // Replace with your model name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        context = container.viewContext
    }
    
    
    func saveRepositories(_ repositories: [Repository]) {
        for repo in repositories {
            let entity = RepositoryEntity(context: context)
            entity.name = repo.name
            entity.star = Int32(repo.stargazers_count ?? 0 )
            entity.isBookmarked = false
            entity.ownerAvatarURL = repo.owner?.avatar_url ?? ""
            entity.ownerProfileURL = repo.html_url ?? ""
        }
        saveContext()
    }
    
    
    func fetchRepositories() -> [RepositoryEntity] {
        let request: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch repositories: \(error)")
            return []
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
