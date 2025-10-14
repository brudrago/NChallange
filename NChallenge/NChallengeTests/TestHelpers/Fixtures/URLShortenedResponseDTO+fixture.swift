@testable import NChallenge

extension URLShortenedResponseDTO {
    static func fixture(
        alias: String = "123",
        link: LinksDTO = .fixture(),
    ) -> Self {
        .init(
            alias: alias,
            links: link
        )
    }
}

extension LinksDTO {
    static func fixture(
        selfURL: String = "https://www.google.com",
        short: String = "https://tinyurl.com/y2y77777"
    ) -> Self {
        .init(
            selfURL: selfURL,
            short: short
        )
    }
}
