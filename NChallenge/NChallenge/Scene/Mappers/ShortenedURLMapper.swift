import Foundation

protocol ShortenedURLMapProtocol {
    func map(_ dto: URLShortenedResponseDTO) -> ShortenedURL
}

struct ShortenedURLMapper: ShortenedURLMapProtocol {
    func map(_ dto: URLShortenedResponseDTO) -> ShortenedURL {
        return ShortenedURL(
            alias: dto.alias,
            originalURL: dto.links.selfURL,
            shortURL: dto.links.short
        )
    }
}
