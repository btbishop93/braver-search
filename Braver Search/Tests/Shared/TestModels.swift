import Foundation

struct TestMessage: Codable {
    let type: String
    let enabled: Bool?
}

struct TestSettings: Codable {
    let enabled: Bool
    let searchUrl: String
} 