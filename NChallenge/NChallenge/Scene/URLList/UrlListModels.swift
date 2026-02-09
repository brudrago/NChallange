import Foundation

enum UrlListModels {
    enum DisplayList {
        struct Request {}
        
        struct Response {
            let shortenedURLs: [ShortenedURL]
        }
        
        struct ViewModel {
            let shortenedURLs: [ShortenedURL]
        }
    }
}
