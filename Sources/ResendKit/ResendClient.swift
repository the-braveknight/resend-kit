#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import AsyncHTTPClient
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

public struct ResendClient: Sendable {
    private let client: Client

    public init(httpClient: HTTPClient = .shared, apiKey: String) throws {
        self.client = try Client(
            serverURL: Servers.Server1.url(),
            transport: AsyncHTTPClientTransport(
                configuration: AsyncHTTPClientTransport.Configuration(
                    client: httpClient
                )
            ),
            middlewares: [
                ResendAPIKeyMiddleware(apiKey: apiKey)
            ]
        )
    }
    
    public func sendEmail(_ email: Components.Schemas.SendEmailRequest) async throws -> Components.Schemas.SendEmailResponse {
        let input = Operations.PostEmails.Input(body: .json(email))
        let response = try await client.postEmails(.init(body: .json(email)))
        return try response.ok.body.json
    }
}
