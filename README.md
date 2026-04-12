# ResendKit

`ResendKit` is a SwiftPM package for the [Resend](https://resend.com) API.

It uses:
- `swift-openapi-generator`
- `swift-openapi-runtime`
- `swift-openapi-async-http-client`
- `AsyncHTTPClient`

The package keeps the official Resend OpenAPI document in `Sources/ResendKit/openapi.yaml` and layers a curated `ResendClient` API on top of the generated client.

## Install

```swift
.package(url: "https://github.com/the-braveknight/resend-kit", branch: "main")
```

Then add:

```swift
.product(name: "ResendKit", package: "resend-kit")
```

## Basic Usage

```swift
import ResendKit

let client = try ResendClient(apiKey: "re_xxxxxxxxx")

let request = Components.Schemas.SendEmailRequest(
    from: "Acme <onboarding@resend.dev>",
    to: .case2(["delivered@resend.dev"]),
    subject: "Hello",
    text: "Sent from ResendKit"
)

let response = try await client.send(email: request)
print(response.id ?? "")
```

## Attachments

`Components.Schemas.Attachment` is overridden to use `ResendKit.Attachment`, which stores `content` as `Data`.

When encoded to JSON, `Data` is encoded as a base64 string, matching Resend's documented attachment format.

```swift
import Foundation
import ResendKit

let pdfData = try Data(contentsOf: pdfURL)

let attachment = Attachment(
    content: pdfData,
    filename: "invoice.pdf",
    contentType: "application/pdf"
)

let request = Components.Schemas.SendEmailRequest(
    from: "Acme <onboarding@resend.dev>",
    to: .case2(["delivered@resend.dev"]),
    subject: "Receipt for your payment",
    text: "Thanks for the payment",
    attachments: [attachment]
)

let client = try ResendClient(apiKey: "re_xxxxxxxxx")
_ = try await client.send(email: request)
```

## API Shape

The public entrypoint is `ResendClient`.

Examples:
- `send(email:)`
- `send(emails:)`
- `listEmails(limit:after:before:)`
- `getEmail(id:)`
- `cancelScheduledEmail(id:)`
- `listDomains(limit:after:before:)`
- `createDomain(_:)`
- `listAPIKeys(limit:after:before:)`
- `createTemplate(_:)`
- `listWebhooks(limit:after:before:)`
- `listAutomations(status:limit:after:before:)`

Generated schema types remain available under `Components.Schemas`.

## Note About `updateEmail`

`updateEmail(id:)` is intentionally limited by the official Resend OpenAPI document.

The current upstream spec models `PATCH /emails/{email_id}` without a request body, so this package does not invent one or patch the official spec just to make that endpoint more ergonomic.

In other words:
- this package follows Resend's official OpenAPI file as-is
- we do not modify the official Resend spec to change the `updateEmail` contract

## Development

Build locally with:

```bash
swift build
```
