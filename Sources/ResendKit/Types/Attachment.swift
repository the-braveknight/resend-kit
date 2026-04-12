#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public struct Attachment: Codable, Hashable, Sendable {
    /// Content of an attached file.
    public let content: Data?
    /// Name of attached file.
    public let filename: String?
    /// Path where the attachment file is hosted
    public var path: String?
    /// Optional content type for the attachment, if not set it will be derived from the filename property
    public var contentType: String?
    /// Content ID for embedding inline images using cid references (e.g., cid:image001).
    public var contentId: String?
    
    /// Creates a new `Attachment`.
    ///
    /// - Parameters:
    ///   - content: Content of an attached file.
    ///   - filename: Name of attached file.
    ///   - path: Path where the attachment file is hosted
    ///   - contentType: Optional content type for the attachment, if not set it will be derived from the filename property
    ///   - contentId: Content ID for embedding inline images using cid references (e.g., cid:image001).
    public init(
        content: Data?,
        filename: String?,
        path: String? = nil,
        contentType: String? = nil,
        contentId: String? = nil
    ) {
        self.content = content
        self.filename = filename
        self.path = path
        self.contentType = contentType
        self.contentId = contentId
    }
    
    private enum CodingKeys: String, CodingKey {
        case content
        case filename
        case path
        case contentType = "content_type"
        case contentId = "content_id"
    }
}
