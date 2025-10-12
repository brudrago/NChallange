import Foundation

struct URLShortenedResponse: Decodable {
    let alias: String
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case alias
        case links = "_links"
    }
}

struct Links: Decodable {
    let selfURL: String
    let short: String
    
    enum CodingKeys: String, CodingKey {
        case selfURL = "self"
        case short
    }
}
