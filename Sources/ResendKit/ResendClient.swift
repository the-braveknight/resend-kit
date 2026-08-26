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
    
    @discardableResult
    public func send(
        email: Components.Schemas.SendEmailRequest,
        idempotencyKey: String? = nil
    ) async throws -> Components.Schemas.SendEmailResponse {
        let request = Operations.EmailsSend.Input(headers: .init(idempotencyKey: idempotencyKey), body: .json(email))
        let response = try await client.emailsSend(request)
        return try response.ok.body.json
    }
    
    @discardableResult
    public func send(
        emails: [Components.Schemas.SendEmailRequest],
        idempotencyKey: String? = nil
    ) async throws -> Components.Schemas.CreateBatchEmailsResponse {
        let request = Operations.EmailsSendBatch.Input(headers: .init(idempotencyKey: idempotencyKey), body: .json(emails))
        let response = try await client.emailsSendBatch(request)
        return try response.ok.body.json
    }

    public func listEmails(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListEmailsResponse {
        let response = try await client.emailsList(
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getEmail(
        id: String
    ) async throws -> Components.Schemas.Email {
        let response = try await client.emailsGet(
            path: .init(emailId: id)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func updateEmail(
        id: String
    ) async throws -> Components.Schemas.UpdateEmailOptions {
        let response = try await client.emailsUpdate(
            path: .init(emailId: id)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func cancelScheduledEmail(
        id: String
    ) async throws -> Components.Schemas.Email {
        let response = try await client.emailsCancel(
            path: .init(emailId: id)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func shareEmail(
        id: String,
        _ request: Components.Schemas.ShareEmailOptions? = nil
    ) async throws -> Components.Schemas.ShareEmailResponse {
        let response = try await client.emailsShare(
            path: .init(emailId: id),
            body: request.map { .json($0) }
        )
        return try response.ok.body.json
    }

    public func listEmailAttachments(
        emailID: String,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListAttachmentsResponse {
        let response = try await client.emailsListAttachments(
            path: .init(emailId: emailID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getEmailAttachment(
        emailID: String,
        attachmentID: String
    ) async throws -> Components.Schemas.RetrievedAttachment {
        let response = try await client.emailsGetAttachment(
            path: .init(emailId: emailID, attachmentId: attachmentID)
        )
        return try response.ok.body.json
    }

    public func listReceivedEmails(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListReceivedEmailsResponse {
        let response = try await client.emailsListReceiving(
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getReceivedEmail(
        id: String
    ) async throws -> Components.Schemas.GetReceivedEmailResponse {
        let response = try await client.emailsGetReceiving(
            path: .init(emailId: id)
        )
        return try response.ok.body.json
    }

    public func listReceivedEmailAttachments(
        emailID: String,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListAttachmentsResponse {
        let response = try await client.emailsListReceivingAttachments(
            path: .init(emailId: emailID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getReceivedEmailAttachment(
        emailID: String,
        attachmentID: String
    ) async throws -> Components.Schemas.RetrievedAttachment {
        let response = try await client.emailsGetReceivingAttachment(
            path: .init(emailId: emailID, attachmentId: attachmentID)
        )
        return try response.ok.body.json
    }

    public func getEmailMetrics(
        startDate: String? = nil,
        endDate: String? = nil,
        timezone: String? = nil,
        granularity: Operations.EmailsMetrics.Input.Query.GranularityPayload? = nil,
        metrics: [Operations.EmailsMetrics.Input.Query.MetricsPayloadPayload]? = nil,
        dimensions: [Operations.EmailsMetrics.Input.Query.DimensionsPayloadPayload]? = nil,
        domainIDs: [String]? = nil,
        emailIDs: [String]? = nil,
        broadcastIDs: [String]? = nil
    ) async throws -> Components.Schemas.GetEmailsMetricsResponse {
        let response = try await client.emailsMetrics(
            query: .init(
                startDate: startDate,
                endDate: endDate,
                timezone: timezone,
                granularity: granularity,
                metrics: metrics,
                dimensions: dimensions,
                domainId: domainIDs,
                emailId: emailIDs,
                broadcastId: broadcastIDs
            )
        )
        return try response.ok.body.json
    }

    public func listDomains(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListDomainsResponse {
        let response = try await client.domainsList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createDomain(
        _ request: Components.Schemas.CreateDomainRequest
    ) async throws -> Components.Schemas.CreateDomainResponse {
        let response = try await client.domainsCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getDomain(
        id: String
    ) async throws -> Components.Schemas.Domain {
        let response = try await client.domainsGet(path: .init(domainId: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateDomain(
        id: String,
        _ request: Components.Schemas.UpdateDomainOptions
    ) async throws -> Components.Schemas.UpdateDomainResponseSuccess {
        let response = try await client.domainsUpdate(path: .init(domainId: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteDomain(
        id: String
    ) async throws -> Components.Schemas.DeleteDomainResponse {
        let response = try await client.domainsRemove(path: .init(domainId: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func verifyDomain(
        id: String
    ) async throws -> Components.Schemas.VerifyDomainResponse {
        let response = try await client.domainsVerify(path: .init(domainId: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func claimDomain(
        _ request: Components.Schemas.CreateDomainClaimRequest
    ) async throws -> Components.Schemas.DomainClaim {
        let response = try await client.domainsCreateClaim(body: .json(request))
        switch response {
        case .ok(let ok):
            return try ok.body.json
        default:
            return try response.created.body.json
        }
    }

    public func getDomainClaim(
        domainID: String
    ) async throws -> Components.Schemas.DomainClaim {
        let response = try await client.domainsGetClaim(path: .init(domainId: domainID))
        return try response.ok.body.json
    }

    @discardableResult
    public func verifyDomainClaim(
        domainID: String
    ) async throws -> Components.Schemas.DomainClaim {
        let response = try await client.domainsVerifyClaim(path: .init(domainId: domainID))
        return try response.ok.body.json
    }

    public func listAPIKeys(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListApiKeysResponse {
        let response = try await client.apiKeysList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createAPIKey(
        _ request: Components.Schemas.CreateApiKeyRequest
    ) async throws -> Components.Schemas.CreateApiKeyResponse {
        let response = try await client.apiKeysCreate(body: .json(request))
        return try response.created.body.json
    }

    @discardableResult
    public func updateAPIKey(
        id: String,
        _ request: Components.Schemas.UpdateApiKeyRequest
    ) async throws -> Components.Schemas.UpdateApiKeyResponse {
        let response = try await client.apiKeysUpdate(path: .init(apiKeyId: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteAPIKey(
        id: String
    ) async throws -> Components.Schemas.DeleteApiKeyResponse {
        let response = try await client.apiKeysRemove(path: .init(apiKeyId: id))
        return try response.ok.body.json
    }

    public func listOAuthGrants(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListOAuthGrantsResponse {
        let response = try await client.oauthListGrants(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func revokeOAuthGrant(
        id: String
    ) async throws -> Components.Schemas.RevokeOAuthGrantResponse {
        let response = try await client.oauthRevokeGrant(path: .init(oauthGrantId: id))
        return try response.ok.body.json
    }

    public func listTemplates(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListTemplatesResponseSuccess {
        let response = try await client.templatesList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createTemplate(
        _ request: Components.Schemas.CreateTemplateRequest
    ) async throws -> Components.Schemas.CreateTemplateResponseSuccess {
        let response = try await client.templatesCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getTemplate(
        id: String
    ) async throws -> Components.Schemas.Template {
        let response = try await client.templatesGet(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateTemplate(
        id: String,
        _ request: Components.Schemas.UpdateTemplateOptions
    ) async throws -> Components.Schemas.UpdateTemplateResponseSuccess {
        let response = try await client.templatesUpdate(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteTemplate(
        id: String
    ) async throws -> Components.Schemas.RemoveTemplateResponseSuccess {
        let response = try await client.templatesRemove(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func publishTemplate(
        id: String
    ) async throws -> Components.Schemas.PublishTemplateResponseSuccess {
        let response = try await client.templatesPublish(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func duplicateTemplate(
        id: String
    ) async throws -> Components.Schemas.DuplicateTemplateResponseSuccess {
        let response = try await client.templatesDuplicate(path: .init(id: id))
        return try response.ok.body.json
    }

    @available(*, deprecated)
    public func listAudiences() async throws -> Components.Schemas.ListAudiencesResponseSuccess {
        let response = try await client.audiencesList()
        return try response.ok.body.json
    }

    @available(*, deprecated)
    @discardableResult
    public func createAudience(
        _ request: Components.Schemas.CreateAudienceOptions
    ) async throws -> Components.Schemas.CreateAudienceResponseSuccess {
        let response = try await client.audiencesCreate(body: .json(request))
        return try response.created.body.json
    }

    @available(*, deprecated)
    public func getAudience(
        id: String
    ) async throws -> Components.Schemas.GetAudienceResponseSuccess {
        let response = try await client.audiencesGet(path: .init(id: id))
        return try response.ok.body.json
    }

    @available(*, deprecated)
    @discardableResult
    public func deleteAudience(
        id: String
    ) async throws -> Components.Schemas.RemoveAudienceResponseSuccess {
        let response = try await client.audiencesRemove(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listContacts(
        segmentID: String? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListContactsResponseSuccess {
        let response = try await client.contactsList(
            query: .init(segmentId: segmentID, limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func createContact(
        _ request: Components.Schemas.CreateContactOptions
    ) async throws -> Components.Schemas.CreateContactResponseSuccess {
        let response = try await client.contactsCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getContact(
        id: String
    ) async throws -> Components.Schemas.GetContactResponseSuccess {
        let response = try await client.contactsGet(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateContact(
        id: String,
        _ request: Components.Schemas.UpdateContactOptions
    ) async throws -> Components.Schemas.UpdateContactResponseSuccess {
        let response = try await client.contactsUpdate(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteContact(
        id: String
    ) async throws -> Components.Schemas.RemoveContactResponseSuccess {
        let response = try await client.contactsRemove(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listContactImports(
        status: String? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListContactImportsResponseSuccess {
        let response = try await client.contactsListImports(
            query: .init(
                status: status.flatMap(Operations.ContactsListImports.Input.Query.StatusPayload.init(rawValue:)),
                limit: limit,
                after: after,
                before: before
            )
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func createContactImport(
        _ body: OpenAPIRuntime.MultipartBody<Components.Schemas.CreateContactImportOptions>
    ) async throws -> Components.Schemas.CreateContactImportResponseSuccess {
        let response = try await client.contactsCreateImport(body: .multipartForm(body))
        return try response.created.body.json
    }

    public func getContactImport(
        id: String
    ) async throws -> Components.Schemas.GetContactImportResponseSuccess {
        let response = try await client.contactsGetImport(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listBroadcasts(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListBroadcastsResponseSuccess {
        let response = try await client.broadcastsList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createBroadcast(
        _ request: Components.Schemas.CreateBroadcastOptions
    ) async throws -> Components.Schemas.CreateBroadcastResponseSuccess {
        let response = try await client.broadcastsCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getBroadcast(
        id: String
    ) async throws -> Components.Schemas.GetBroadcastResponseSuccess {
        let response = try await client.broadcastsGet(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateBroadcast(
        id: String,
        _ request: Components.Schemas.UpdateBroadcastOptions
    ) async throws -> Components.Schemas.UpdateBroadcastResponseSuccess {
        let response = try await client.broadcastsUpdate(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteBroadcast(
        id: String
    ) async throws -> Components.Schemas.RemoveBroadcastResponseSuccess {
        let response = try await client.broadcastsRemove(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func sendBroadcast(
        id: String,
        _ request: Components.Schemas.SendBroadcastOptions? = nil
    ) async throws -> Components.Schemas.SendBroadcastResponseSuccess {
        let response = try await client.broadcastsSend(path: .init(id: id), body: request.map { .json($0) })
        return try response.ok.body.json
    }

    @discardableResult
    public func cancelBroadcast(
        id: String
    ) async throws -> Components.Schemas.CancelBroadcastResponseSuccess {
        let response = try await client.broadcastsCancel(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listBroadcastRecipients(
        id: String,
        type: Operations.BroadcastsRecipients.Input.Query._TypePayload,
        email: String? = nil,
        bounceType: Operations.BroadcastsRecipients.Input.Query.BounceTypePayload? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListBroadcastRecipientsResponseSuccess {
        let response = try await client.broadcastsRecipients(
            path: .init(id: id),
            query: .init(
                _type: type,
                email: email,
                bounceType: bounceType,
                limit: limit,
                after: after,
                before: before
            )
        )
        return try response.ok.body.json
    }

    public func listBroadcastClickedLinks(
        id: String,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListBroadcastClickedLinksResponseSuccess {
        let response = try await client.broadcastsListClickedLinks(
            path: .init(id: id),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func listWebhooks(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListWebhooksResponse {
        let response = try await client.webhooksList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createWebhook(
        _ request: Components.Schemas.CreateWebhookRequest
    ) async throws -> Components.Schemas.CreateWebhookResponse {
        let response = try await client.webhooksCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getWebhook(
        id: String
    ) async throws -> Components.Schemas.GetWebhookResponse {
        let response = try await client.webhooksGet(path: .init(webhookId: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateWebhook(
        id: String,
        _ request: Components.Schemas.UpdateWebhookRequest
    ) async throws -> Components.Schemas.UpdateWebhookResponse {
        let response = try await client.webhooksUpdate(path: .init(webhookId: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteWebhook(
        id: String
    ) async throws -> Components.Schemas.DeleteWebhookResponse {
        let response = try await client.webhooksRemove(path: .init(webhookId: id))
        return try response.ok.body.json
    }

    public func listWebhookEvents(
        webhookID: String,
        limit: Int? = nil,
        after: String? = nil
    ) async throws -> Components.Schemas.ListWebhookEventsResponse {
        let response = try await client.webhooksListEvents(
            path: .init(webhookId: webhookID),
            query: .init(limit: limit, after: after)
        )
        return try response.ok.body.json
    }

    public func getWebhookEvent(
        webhookID: String,
        eventID: String
    ) async throws -> Components.Schemas.GetWebhookEventResponse {
        let response = try await client.webhooksGetEvent(
            path: .init(webhookId: webhookID, eventId: eventID)
        )
        return try response.ok.body.json
    }

    public func listWebhookEventAttempts(
        webhookID: String,
        eventID: String,
        limit: Int? = nil,
        after: String? = nil
    ) async throws -> Components.Schemas.ListWebhookEventAttemptsResponse {
        let response = try await client.webhooksListEventAttempts(
            path: .init(webhookId: webhookID, eventId: eventID),
            query: .init(limit: limit, after: after)
        )
        return try response.ok.body.json
    }

    public func listSegments(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListSegmentsResponseSuccess {
        let response = try await client.segmentsList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createSegment(
        _ request: Components.Schemas.CreateSegmentOptions
    ) async throws -> Components.Schemas.CreateSegmentResponseSuccess {
        let response = try await client.segmentsCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getSegment(
        id: String
    ) async throws -> Components.Schemas.GetSegmentResponseSuccess {
        let response = try await client.segmentsGet(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateSegment(
        id: String,
        _ request: Components.Schemas.UpdateSegmentOptions
    ) async throws -> Components.Schemas.UpdateSegmentResponseSuccess {
        let response = try await client.segmentsUpdate(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteSegment(
        id: String
    ) async throws -> Components.Schemas.RemoveSegmentResponseSuccess {
        let response = try await client.segmentsRemove(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listTopics(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListTopicsResponseSuccess {
        let response = try await client.topicsList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createTopic(
        _ request: Components.Schemas.CreateTopicOptions
    ) async throws -> Components.Schemas.CreateTopicResponseSuccess {
        let response = try await client.topicsCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getTopic(
        id: String
    ) async throws -> Components.Schemas.GetTopicResponseSuccess {
        let response = try await client.topicsGet(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateTopic(
        id: String,
        _ request: Components.Schemas.UpdateTopicOptions
    ) async throws -> Components.Schemas.UpdateTopicResponseSuccess {
        let response = try await client.topicsUpdate(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteTopic(
        id: String
    ) async throws -> Components.Schemas.RemoveTopicResponseSuccess {
        let response = try await client.topicsRemove(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listContactProperties(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListContactPropertiesResponseSuccess {
        let response = try await client.contactPropertiesList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createContactProperty(
        _ request: Components.Schemas.CreateContactPropertyOptions
    ) async throws -> Components.Schemas.CreateContactPropertyResponseSuccess {
        let response = try await client.contactPropertiesCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getContactProperty(
        id: String
    ) async throws -> Components.Schemas.GetContactPropertyResponseSuccess {
        let response = try await client.contactPropertiesGet(path: .init(id: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateContactProperty(
        id: String,
        _ request: Components.Schemas.UpdateContactPropertyOptions
    ) async throws -> Components.Schemas.UpdateContactPropertyResponseSuccess {
        let response = try await client.contactPropertiesUpdate(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteContactProperty(
        id: String
    ) async throws -> Components.Schemas.RemoveContactPropertyResponseSuccess {
        let response = try await client.contactPropertiesRemove(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listContactSegments(
        contactID: String,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListContactSegmentsResponseSuccess {
        let response = try await client.contactsListSegments(
            path: .init(contactId: contactID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func addContactToSegment(
        contactID: String,
        segmentID: String
    ) async throws -> Components.Schemas.AddContactToSegmentResponseSuccess {
        let response = try await client.contactsAddSegment(
            path: .init(contactId: contactID, segmentId: segmentID)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func removeContactFromSegment(
        contactID: String,
        segmentID: String
    ) async throws -> Components.Schemas.RemoveContactFromSegmentResponseSuccess {
        let response = try await client.contactsRemoveSegment(
            path: .init(contactId: contactID, segmentId: segmentID)
        )
        return try response.ok.body.json
    }

    public func listContactTopics(
        contactID: String,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.GetContactTopicsResponseSuccess {
        let response = try await client.contactsListTopics(
            path: .init(contactId: contactID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func updateContactTopics(
        contactID: String,
        _ request: Components.Schemas.UpdateContactTopicsOptions
    ) async throws -> Components.Schemas.UpdateContactTopicsResponseSuccess {
        let response = try await client.contactsUpdateTopics(
            path: .init(contactId: contactID),
            body: .json(request)
        )
        return try response.ok.body.json
    }

    public func listLogs(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListLogsResponse {
        let response = try await client.logsList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func getLog(
        id: String
    ) async throws -> Components.Schemas.Log {
        let response = try await client.logsGet(path: .init(logId: id))
        return try response.ok.body.json
    }

    public func listAutomations(
        status: String? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListAutomationsResponse {
        let response = try await client.automationsList(
            query: .init(
                status: status.flatMap(Operations.AutomationsList.Input.Query.StatusPayload.init(rawValue:)),
                limit: limit,
                after: after,
                before: before
            )
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func createAutomation(
        _ request: Components.Schemas.CreateAutomationRequest
    ) async throws -> Components.Schemas.CreateAutomationResponse {
        let response = try await client.automationsCreate(body: .json(request))
        return try response.created.body.json
    }

    public func getAutomation(
        id: String
    ) async throws -> Components.Schemas.Automation {
        let response = try await client.automationsGet(path: .init(automationId: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateAutomation(
        id: String,
        _ request: Components.Schemas.PatchAutomationRequest
    ) async throws -> Components.Schemas.PatchAutomationResponse {
        let response = try await client.automationsUpdate(path: .init(automationId: id), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteAutomation(
        id: String
    ) async throws -> Components.Schemas.DeleteAutomationResponse {
        let response = try await client.automationsRemove(path: .init(automationId: id))
        return try response.ok.body.json
    }

    @discardableResult
    public func duplicateAutomation(
        id: String
    ) async throws -> Components.Schemas.DuplicateAutomationResponse {
        let response = try await client.automationsDuplicate(path: .init(automationId: id))
        return try response.created.body.json
    }

    @discardableResult
    public func stopAutomation(
        id: String
    ) async throws -> Components.Schemas.StopAutomationResponse {
        let response = try await client.automationsStop(path: .init(automationId: id))
        return try response.ok.body.json
    }

    public func listAutomationRuns(
        automationID: String,
        status: String? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListAutomationRunsResponse {
        let response = try await client.automationsListRuns(
            path: .init(automationId: automationID),
            query: .init(status: status, limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getAutomationRun(
        automationID: String,
        runID: String
    ) async throws -> Components.Schemas.AutomationRun {
        let response = try await client.automationsGetRun(
            path: .init(automationId: automationID, runId: runID)
        )
        return try response.ok.body.json
    }

    public func listEvents(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListEventsResponse {
        let response = try await client.eventsList(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    @discardableResult
    public func createEvent(
        _ request: Components.Schemas.CreateEventRequest
    ) async throws -> Components.Schemas.CreateEventResponse {
        let response = try await client.eventsCreate(body: .json(request))
        return try response.created.body.json
    }

    @discardableResult
    public func sendEvent(
        _ request: Components.Schemas.SendEventRequest
    ) async throws -> Components.Schemas.SendEventResponse {
        let response = try await client.eventsSend(body: .json(request))
        return try response.accepted.body.json
    }

    public func getEvent(
        identifier: String
    ) async throws -> Components.Schemas.Event {
        let response = try await client.eventsGet(path: .init(identifier: identifier))
        return try response.ok.body.json
    }

    @discardableResult
    public func updateEvent(
        identifier: String,
        _ request: Components.Schemas.UpdateEventRequest
    ) async throws -> Components.Schemas.UpdateEventResponse {
        let response = try await client.eventsUpdate(path: .init(identifier: identifier), body: .json(request))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteEvent(
        identifier: String
    ) async throws -> Components.Schemas.RemoveEventResponse {
        let response = try await client.eventsRemove(path: .init(identifier: identifier))
        return try response.ok.body.json
    }

    public func listSuppressions(
        origin: Operations.SuppressionsList.Input.Query.OriginPayload? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListSuppressionsResponseSuccess {
        let response = try await client.suppressionsList(
            query: .init(origin: origin, limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    @discardableResult
    public func createSuppression(
        _ request: Components.Schemas.CreateSuppressionOptions
    ) async throws -> Components.Schemas.CreateSuppressionResponseSuccess {
        let response = try await client.suppressionsAdd(body: .json(request))
        return try response.created.body.json
    }

    @discardableResult
    public func addSuppressions(
        _ request: Components.Schemas.BatchAddSuppressionsOptions
    ) async throws -> Components.Schemas.BatchAddSuppressionsResponseSuccess {
        let response = try await client.suppressionsBatchAdd(body: .json(request))
        return try response.created.body.json
    }

    @discardableResult
    public func removeSuppressions(
        _ request: Components.Schemas.BatchRemoveSuppressionsOptions
    ) async throws -> Components.Schemas.BatchRemoveSuppressionsResponseSuccess {
        let response = try await client.suppressionsBatchRemove(body: .json(request))
        return try response.ok.body.json
    }

    public func getSuppression(
        idOrEmail: String
    ) async throws -> Components.Schemas.GetSuppressionResponseSuccess {
        let response = try await client.suppressionsGet(path: .init(suppression: idOrEmail))
        return try response.ok.body.json
    }

    @discardableResult
    public func deleteSuppression(
        idOrEmail: String
    ) async throws -> Components.Schemas.RemoveSuppressionResponseSuccess {
        let response = try await client.suppressionsRemove(path: .init(suppression: idOrEmail))
        return try response.ok.body.json
    }
}
