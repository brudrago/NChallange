import Foundation

struct URLShortenedResponseDTO: Decodable {
    let alias: String
    let links: LinksDTO
    
    enum CodingKeys: String, CodingKey {
        case alias
        case links = "_links"
    }
}

struct LinksDTO: Decodable {
    let selfURL: String
    let short: String
    
    enum CodingKeys: String, CodingKey {
        case selfURL = "self"
        case short
    }
}
