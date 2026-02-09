import Foundation

final class DependencyContainer {
    // Instâncias compartilhadas (singletons do container)
    lazy var repository: ShortenedURLRepositoryProtocol = ShortenedURLRepository()
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    
    // Factory methods para criar dependências
    func makeShortenedURLService() -> ShortenedURLServiceProtocol {
        return ShortenedURLService(networkManager: networkManager)
    }
    
    func makeShortenedURLUseCase() -> ShortenedURLUseCaseProtocol {
        let service = makeShortenedURLService()
        let mapper = ShortenedURLMapper()
        return ShortenedURLUseCase(service: service, mapper: mapper)
    }
}

// Singleton do container (ou pode ser injetado no SceneDelegate)
extension DependencyContainer {
    static let shared = DependencyContainer()
}

