# resend-kit

`resend-kit` is a small SwiftPM package for the Resend API.

It uses:
- `swift-openapi-generator` for generated client/types
- `swift-openapi-runtime`
- `swift-openapi-async-http-client`
- `AsyncHTTPClient`

## Structure

- `Sources/ResendKit/openapi.yaml`
  The OpenAPI document used for code generation.
- `Sources/ResendKit/openapi-generator-config.yaml`
  Generator configuration.
- `Sources/ResendKit/ResendClient.swift`
  Thin handwritten facade over the generated client.
- `Sources/ResendKit/Middlewares/ResendAPIKeyMiddleware.swift`
  Bearer auth middleware.

## Usage

Add the package as a dependency:

```swift
.package(url: "https://github.com/the-braveknight/resend-kit", branch: "main")
```

Then depend on `ResendKit`:

```swift
.product(name: "ResendKit", package: "resend-kit")
```

Example:

```swift
import ResendKit

let client = try ResendClient(apiKey: "<api-key>")

let request = Components.Schemas.SendEmailRequest(
    from: "Acme <noreply@example.com>",
    to: .case1("user@example.com"),
    subject: "Hello",
    text: "Sent from resend-kit"
)

let response = try await client.sendEmail(request)
print(response.id)
```

## Notes

- The package currently targets the production Resend API.
- The public entrypoint is `ResendClient`.
- Generated types are exposed through `Components.Schemas`.
- The upstream spec includes binary attachment content that `swift-openapi-generator` currently warns about and skips.

## Development

Build locally with:

```bash
swift build
```
