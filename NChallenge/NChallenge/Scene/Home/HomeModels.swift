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
        struct Request {}
        
        struct Response {
            let shortenedURLs: [ShortenedURL]
        }
        
        struct ViewModel {
            let shortenedURLs: [ShortenedURL]
        }
    }
    
    enum Error {
        struct Request {}
        
        struct Response {
            let message: String
        }
        
        struct ViewModel {
            let message: String
        }
    }
}
