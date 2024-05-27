//
//  CoreDataManager.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import CoreData

// MARK: Core Data Protocol

public protocol CoreDataManagerProtocol {
    func saveContext()
    func fetchMovies(for category: MovieCategory) -> [Movie]
    func saveMovies(_ movies: [Movie], for category: MovieCategory)
    func deleteAllMovies(for category: MovieCategory)
}

// MARK: - Core Data Manager

class CoreDataManager: CoreDataManagerProtocol {
    // MARK: - Properties

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Methods

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchMovies(for category: MovieCategory) -> [Movie] {
        let fetchRequest: NSFetchRequest<NSManagedObject>
        switch category {
        case .nowPlaying:
            let request: NSFetchRequest<PlayingNowMovies> = PlayingNowMovies.fetchRequest()
            fetchRequest = request as! NSFetchRequest<NSManagedObject>
        case .popular:
            let request: NSFetchRequest<PopularMovies> = PopularMovies.fetchRequest()
            fetchRequest = request as! NSFetchRequest<NSManagedObject>
        case .upcoming:
            let request: NSFetchRequest<UpcomingMovies> = UpcomingMovies.fetchRequest()
            fetchRequest = request as! NSFetchRequest<NSManagedObject>
        }

        do {
            if let categoryEntity = try context.fetch(fetchRequest).first {
                let movies = categoryEntity.value(forKey: "movies") as? NSOrderedSet ?? NSOrderedSet()
                return movies.array.compactMap { $0 as? MovieEntity }.map { $0.toDomainModel() }
            }
        } catch {
            print("Failed to fetch movies: \(error)")
        }
        return []
    }

    func saveMovies(_ movies: [Movie], for category: MovieCategory) {
        deleteAllMovies(for: category)

        let categoryEntity: NSManagedObject
        switch category {
        case .nowPlaying:
            categoryEntity = PlayingNowMovies(context: context)
        case .popular:
            categoryEntity = PopularMovies(context: context)
        case .upcoming:
            categoryEntity = UpcomingMovies(context: context)
        }

        let movieEntities = movies.map { $0.toMovieEntity(context: context) }
        categoryEntity.setValue(NSOrderedSet(array: movieEntities), forKey: "movies")
        saveContext()
    }

    func deleteAllMovies(for category: MovieCategory) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        switch category {
        case .nowPlaying:
            fetchRequest = PlayingNowMovies.fetchRequest()
        case .popular:
            fetchRequest = PopularMovies.fetchRequest()
        case .upcoming:
            fetchRequest = UpcomingMovies.fetchRequest()
        }

        do {
            let categoryEntities = try context.fetch(fetchRequest) as! [NSManagedObject]
            for categoryEntity in categoryEntities {
                context.delete(categoryEntity)
            }
            saveContext()
        } catch {
            print("Failed to delete movies: \(error)")
        }
    }
}

// MARK: - Injection Map

public protocol CoreDataManagerInjected {}

extension CoreDataManagerInjected {
    public var coreDataManager: CoreDataManagerProtocol {
        CoreDataManagerInjectionMap.coreDataManager
    }
}

public enum CoreDataManagerInjectionMap {
    public private(set) static var coreDataManager: CoreDataManagerProtocol = defaultmanager()

    public static func reset() {
        coreDataManager = defaultmanager()
    }

    public static func set(to manager: CoreDataManagerProtocol) {
        coreDataManager = manager
    }

    private static func defaultmanager() -> CoreDataManagerProtocol {
        CoreDataManager()
    }
}
