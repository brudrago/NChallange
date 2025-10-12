import Foundation

enum HomeModels {
    enum ShortenUrl {
        struct Request {
            let url: String
        }
        struct Response {
            let shortenURL: ShortenedURL
        }
        struct ViewModel {
            let shortenURL: ShortenedURL
        }
    }
    
    enum DisplayList {
        struct Request {
            // Request vazio para buscar todas as URLs
        }
        struct Response {
            let shortenedURLs: [ShortenedURL]
        }
        struct ViewModel {
            let shortenedURLs: [ShortenedURL]
        }
    }
}
