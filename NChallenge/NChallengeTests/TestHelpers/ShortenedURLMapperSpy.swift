import Foundation
@testable import NChallenge

final class ShortenedURLMapperSpy: ShortenedURLMapProtocol {
    private(set) var lastDTO: URLShortenedResponseDTO?
    private(set) var mapCallCount = 0
    var responseToBeReturned: ShortenedURL?
    
    func map(_ dto: URLShortenedResponseDTO) -> ShortenedURL {
        lastDTO = dto
        mapCallCount += 1
        
        if let response = responseToBeReturned {
            return response
        }
        
        return ShortenedURL.fixture(
            alias: dto.alias,
            originalURL: dto.links.selfURL,
            shortURL: dto.links.short
        )
    }
}
