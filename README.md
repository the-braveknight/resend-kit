# ResendKit

`ResendKit` is a Swift Package Manager client for the [Resend](https://resend.com) API.

It combines:

- Resend's official OpenAPI document
- generated transport and schema code from `swift-openapi-generator`
- a curated `ResendClient` facade with flat Swift methods such as `send(email:)`, `listDomains(...)`, and `createWebhook(_:)`

The package is intentionally generator-backed. The goal is to stay aligned with Resend's published API contract while still exposing a public API that is usable from normal Swift code.

## Goals

- Track Resend's official OpenAPI spec instead of maintaining a separate handwritten API description
- Keep generated operation details out of the public API where possible
- Expose a single entrypoint, `ResendClient`
- Preserve access to generated schema types under `Components.Schemas`
- Use small targeted overrides only when the generated result is not practical

## Installation

Add the package:

```swift
.package(url: "https://github.com/the-braveknight/resend-kit", from: "0.1.0")
```

Then add the product to your target:

```swift
.product(name: "ResendKit", package: "resend-kit")
```

## Requirements

- Swift 6.2
- macOS 13+
- iOS 16+

## Quick Start

```swift
import ResendKit

let client = try ResendClient(apiKey: "re_xxxxxxxxx")

let request = Components.Schemas.SendEmailRequest(
    from: "Acme <onboarding@resend.dev>",
    to: .case2(["delivered@resend.dev"]),
    subject: "Hello",
    text: "Sent from ResendKit"
)

try await client.send(email: request)
```

## Attachments

Resend documents attachment `content` as a base64 string in JSON. In Swift, the most natural type for that is `Data`.

This package overrides the generated `Attachment` schema with a handwritten Swift type mainly because `swift-openapi-generator` does not support `type: string` with `format: binary` as an object property in this schema shape.

That override also gives the package a better public Swift representation for Resend attachments:

- `Components.Schemas.Attachment` resolves to `ResendKit.Attachment`
- `Attachment.content` is `Data`
- when encoded with `JSONEncoder`, `Data` becomes base64 automatically

That matches Resend's documented API usage.

Example:

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

try await client.send(email: request)
```

## What Is Generated vs Handwritten

There are two layers in this package.

### Handwritten layer

- [Sources/ResendKit/ResendClient.swift](Sources/ResendKit/ResendClient.swift)
- [Sources/ResendKit/Middlewares/ResendAPIKeyMiddleware.swift](Sources/ResendKit/Middlewares/ResendAPIKeyMiddleware.swift)
- [Sources/ResendKit/Types/Attachment.swift](Sources/ResendKit/Types/Attachment.swift)

This layer is responsible for:

- authentication middleware
- the public `ResendClient` API
- targeted schema customization where needed

### Generated layer

Generated code is produced by the SwiftPM plugin from:

- [Sources/ResendKit/openapi.yaml](Sources/ResendKit/openapi.yaml)
- [Sources/ResendKit/openapi-generator-config.yaml](Sources/ResendKit/openapi-generator-config.yaml)

At build time, `swift-openapi-generator` creates the `Client`, `Operations`, and `Components` types used internally by `ResendClient`.

## Project Structure

```text
Sources/ResendKit/
├── openapi.yaml
├── openapi-generator-config.yaml
├── ResendClient.swift
├── Middlewares/
│   └── ResendAPIKeyMiddleware.swift
└── Types/
    └── Attachment.swift
```

### File responsibilities

- `openapi.yaml`
  - local copy of Resend's official OpenAPI document used for code generation
- `openapi-generator-config.yaml`
  - generator settings, including the `Attachment` type override
- `ResendClient.swift`
  - curated facade over the generated client
- `ResendAPIKeyMiddleware.swift`
  - injects the `Authorization` header for API requests
- `Types/Attachment.swift`
  - custom schema replacement for attachment content as `Data`

## Official Spec Reference

This package is based on Resend's official OpenAPI definition.

Upstream source:

- `https://github.com/resend/resend-openapi`

Local copy used for generation:

- [Sources/ResendKit/openapi.yaml](Sources/ResendKit/openapi.yaml)

The intent is to follow the official Resend contract rather than invent a separate API model.

## Generator Configuration

The package uses:

- `swift-openapi-generator`
- `swift-openapi-runtime`
- `swift-openapi-async-http-client`
- `AsyncHTTPClient`

The current customization is intentionally small. The main override is:

- schema `Attachment` mapped to `ResendKit.Attachment`

This keeps most of the API generated, while working around the generator's binary-property limitation and allowing a better Swift representation for attachments.

## Endpoint Coverage

`ResendClient` currently wraps the official spec surface that is present in this package, including:

- emails
- email attachments
- received emails
- domains
- API keys
- templates
- audiences
- contacts
- broadcasts
- webhooks
- segments
- topics
- contact properties
- logs
- automations
- events

Generated schema types remain available directly under `Components.Schemas`.

## Note About `updateEmail`

`updateEmail(id:)` is intentionally limited by the official Resend OpenAPI document.

The current Resend spec models `PATCH /emails/{email_id}` without a request body. This package does not patch or redefine that endpoint locally just to create a more ergonomic method signature.

That is deliberate:

- this package follows the official Resend spec as its source of truth
- we do not modify the upstream API contract to invent a different `updateEmail` request shape

## Design Notes

- `ResendClient` is the intended public entrypoint
- generated schema types are still available when you need full fidelity with the OpenAPI document
- `typeOverrides` should be used sparingly; `Attachment` is overridden because the generator does not support the binary schema shape cleanly here, and `Data` is the right Swift type for Resend's base64 attachment content

This keeps the package practical to use without turning it into a completely handwritten SDK.
