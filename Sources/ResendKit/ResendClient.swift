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
    
    public func send(
        email: Components.Schemas.SendEmailRequest,
        idempotencyKey: String? = nil
    ) async throws -> Components.Schemas.SendEmailResponse {
        let request = Operations.PostEmails.Input(headers: .init(idempotencyKey: idempotencyKey), body: .json(email))
        let response = try await client.postEmails(request)
        return try response.ok.body.json
    }
    
    public func send(
        emails: [Components.Schemas.SendEmailRequest],
        idempotencyKey: String? = nil
    ) async throws -> Components.Schemas.CreateBatchEmailsResponse {
        let request = Operations.PostEmailsBatch.Input(headers: .init(idempotencyKey: idempotencyKey), body: .json(emails))
        let response = try await client.postEmailsBatch(request)
        return try response.ok.body.json
    }

    public func listEmails(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListEmailsResponse {
        let response = try await client.getEmails(
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getEmail(
        id: String
    ) async throws -> Components.Schemas.Email {
        let response = try await client.getEmailsEmailId(
            path: .init(emailId: id)
        )
        return try response.ok.body.json
    }

    public func updateEmail(
        id: String
    ) async throws -> Components.Schemas.UpdateEmailOptions {
        let response = try await client.patchEmailsEmailId(
            path: .init(emailId: id)
        )
        return try response.ok.body.json
    }

    public func cancelScheduledEmail(
        id: String
    ) async throws -> Components.Schemas.Email {
        let response = try await client.postEmailsEmailIdCancel(
            path: .init(emailId: id)
        )
        return try response.ok.body.json
    }

    public func listEmailAttachments(
        emailID: String,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListAttachmentsResponse {
        let response = try await client.getEmailsEmailIdAttachments(
            path: .init(emailId: emailID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getEmailAttachment(
        emailID: String,
        attachmentID: String
    ) async throws -> Components.Schemas.RetrievedAttachment {
        let response = try await client.getEmailsEmailIdAttachmentsAttachmentId(
            path: .init(emailId: emailID, attachmentId: attachmentID)
        )
        return try response.ok.body.json
    }

    public func listReceivedEmails(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListReceivedEmailsResponse {
        let response = try await client.getEmailsReceiving(
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getReceivedEmail(
        id: String
    ) async throws -> Components.Schemas.GetReceivedEmailResponse {
        let response = try await client.getEmailsReceivingEmailId(
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
        let response = try await client.getEmailsReceivingEmailIdAttachments(
            path: .init(emailId: emailID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getReceivedEmailAttachment(
        emailID: String,
        attachmentID: String
    ) async throws -> Components.Schemas.RetrievedAttachment {
        let response = try await client.getEmailsReceivingEmailIdAttachmentsAttachmentId(
            path: .init(emailId: emailID, attachmentId: attachmentID)
        )
        return try response.ok.body.json
    }

    public func listDomains(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListDomainsResponse {
        let response = try await client.getDomains(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createDomain(
        _ request: Components.Schemas.CreateDomainRequest
    ) async throws -> Components.Schemas.CreateDomainResponse {
        let response = try await client.postDomains(body: .json(request))
        return try response.created.body.json
    }

    public func getDomain(
        id: String
    ) async throws -> Components.Schemas.Domain {
        let response = try await client.getDomainsDomainId(path: .init(domainId: id))
        return try response.ok.body.json
    }

    public func updateDomain(
        id: String,
        _ request: Components.Schemas.UpdateDomainOptions
    ) async throws -> Components.Schemas.UpdateDomainResponseSuccess {
        let response = try await client.patchDomainsDomainId(path: .init(domainId: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteDomain(
        id: String
    ) async throws -> Components.Schemas.DeleteDomainResponse {
        let response = try await client.deleteDomainsDomainId(path: .init(domainId: id))
        return try response.ok.body.json
    }

    public func verifyDomain(
        id: String
    ) async throws -> Components.Schemas.VerifyDomainResponse {
        let response = try await client.postDomainsDomainIdVerify(path: .init(domainId: id))
        return try response.ok.body.json
    }

    public func listAPIKeys(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListApiKeysResponse {
        let response = try await client.getApiKeys(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createAPIKey(
        _ request: Components.Schemas.CreateApiKeyRequest
    ) async throws -> Components.Schemas.CreateApiKeyResponse {
        let response = try await client.postApiKeys(body: .json(request))
        return try response.created.body.json
    }

    public func deleteAPIKey(
        id: String
    ) async throws -> Components.Schemas.DeleteApiKeyResponse {
        let response = try await client.deleteApiKeysApiKeyId(path: .init(apiKeyId: id))
        return try response.ok.body.json
    }

    public func listTemplates(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListTemplatesResponseSuccess {
        let response = try await client.getTemplates(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createTemplate(
        _ request: Components.Schemas.CreateTemplateRequest
    ) async throws -> Components.Schemas.CreateTemplateResponseSuccess {
        let response = try await client.postTemplates(body: .json(request))
        return try response.created.body.json
    }

    public func getTemplate(
        id: String
    ) async throws -> Components.Schemas.Template {
        let response = try await client.getTemplatesId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func updateTemplate(
        id: String,
        _ request: Components.Schemas.UpdateTemplateOptions
    ) async throws -> Components.Schemas.UpdateTemplateResponseSuccess {
        let response = try await client.patchTemplatesId(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteTemplate(
        id: String
    ) async throws -> Components.Schemas.RemoveTemplateResponseSuccess {
        let response = try await client.deleteTemplatesId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func publishTemplate(
        id: String
    ) async throws -> Components.Schemas.PublishTemplateResponseSuccess {
        let response = try await client.postTemplatesIdPublish(path: .init(id: id))
        return try response.ok.body.json
    }

    public func duplicateTemplate(
        id: String
    ) async throws -> Components.Schemas.DuplicateTemplateResponseSuccess {
        let response = try await client.postTemplatesIdDuplicate(path: .init(id: id))
        return try response.ok.body.json
    }

    @available(*, deprecated)
    public func listAudiences() async throws -> Components.Schemas.ListAudiencesResponseSuccess {
        let response = try await client.getAudiences()
        return try response.ok.body.json
    }

    @available(*, deprecated)
    public func createAudience(
        _ request: Components.Schemas.CreateAudienceOptions
    ) async throws -> Components.Schemas.CreateAudienceResponseSuccess {
        let response = try await client.postAudiences(body: .json(request))
        return try response.created.body.json
    }

    @available(*, deprecated)
    public func getAudience(
        id: String
    ) async throws -> Components.Schemas.GetAudienceResponseSuccess {
        let response = try await client.getAudiencesId(path: .init(id: id))
        return try response.ok.body.json
    }

    @available(*, deprecated)
    public func deleteAudience(
        id: String
    ) async throws -> Components.Schemas.RemoveAudienceResponseSuccess {
        let response = try await client.deleteAudiencesId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listContacts(
        segmentID: String? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListContactsResponseSuccess {
        let response = try await client.getContacts(
            query: .init(segmentId: segmentID, limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func createContact(
        _ request: Components.Schemas.CreateContactOptions
    ) async throws -> Components.Schemas.CreateContactResponseSuccess {
        let response = try await client.postContacts(body: .json(request))
        return try response.created.body.json
    }

    public func getContact(
        id: String
    ) async throws -> Components.Schemas.GetContactResponseSuccess {
        let response = try await client.getContactsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func updateContact(
        id: String,
        _ request: Components.Schemas.UpdateContactOptions
    ) async throws -> Components.Schemas.UpdateContactResponseSuccess {
        let response = try await client.patchContactsId(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteContact(
        id: String
    ) async throws -> Components.Schemas.RemoveContactResponseSuccess {
        let response = try await client.deleteContactsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listBroadcasts(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListBroadcastsResponseSuccess {
        let response = try await client.getBroadcasts(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createBroadcast(
        _ request: Components.Schemas.CreateBroadcastOptions
    ) async throws -> Components.Schemas.CreateBroadcastResponseSuccess {
        let response = try await client.postBroadcasts(body: .json(request))
        return try response.created.body.json
    }

    public func getBroadcast(
        id: String
    ) async throws -> Components.Schemas.GetBroadcastResponseSuccess {
        let response = try await client.getBroadcastsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func updateBroadcast(
        id: String,
        _ request: Components.Schemas.UpdateBroadcastOptions
    ) async throws -> Components.Schemas.UpdateBroadcastResponseSuccess {
        let response = try await client.patchBroadcastsId(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteBroadcast(
        id: String
    ) async throws -> Components.Schemas.RemoveBroadcastResponseSuccess {
        let response = try await client.deleteBroadcastsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func sendBroadcast(
        id: String,
        _ request: Components.Schemas.SendBroadcastOptions? = nil
    ) async throws -> Components.Schemas.SendBroadcastResponseSuccess {
        let response = try await client.postBroadcastsIdSend(path: .init(id: id), body: request.map { .json($0) })
        return try response.ok.body.json
    }

    public func listWebhooks(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListWebhooksResponse {
        let response = try await client.getWebhooks(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createWebhook(
        _ request: Components.Schemas.CreateWebhookRequest
    ) async throws -> Components.Schemas.CreateWebhookResponse {
        let response = try await client.postWebhooks(body: .json(request))
        return try response.created.body.json
    }

    public func getWebhook(
        id: String
    ) async throws -> Components.Schemas.GetWebhookResponse {
        let response = try await client.getWebhooksWebhookId(path: .init(webhookId: id))
        return try response.ok.body.json
    }

    public func updateWebhook(
        id: String,
        _ request: Components.Schemas.UpdateWebhookRequest
    ) async throws -> Components.Schemas.UpdateWebhookResponse {
        let response = try await client.patchWebhooksWebhookId(path: .init(webhookId: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteWebhook(
        id: String
    ) async throws -> Components.Schemas.DeleteWebhookResponse {
        let response = try await client.deleteWebhooksWebhookId(path: .init(webhookId: id))
        return try response.ok.body.json
    }

    public func listSegments(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListSegmentsResponseSuccess {
        let response = try await client.getSegments(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createSegment(
        _ request: Components.Schemas.CreateSegmentOptions
    ) async throws -> Components.Schemas.CreateSegmentResponseSuccess {
        let response = try await client.postSegments(body: .json(request))
        return try response.created.body.json
    }

    public func getSegment(
        id: String
    ) async throws -> Components.Schemas.GetSegmentResponseSuccess {
        let response = try await client.getSegmentsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func deleteSegment(
        id: String
    ) async throws -> Components.Schemas.RemoveSegmentResponseSuccess {
        let response = try await client.deleteSegmentsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listTopics(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListTopicsResponseSuccess {
        let response = try await client.getTopics(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createTopic(
        _ request: Components.Schemas.CreateTopicOptions
    ) async throws -> Components.Schemas.CreateTopicResponseSuccess {
        let response = try await client.postTopics(body: .json(request))
        return try response.created.body.json
    }

    public func getTopic(
        id: String
    ) async throws -> Components.Schemas.GetTopicResponseSuccess {
        let response = try await client.getTopicsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func updateTopic(
        id: String,
        _ request: Components.Schemas.UpdateTopicOptions
    ) async throws -> Components.Schemas.UpdateTopicResponseSuccess {
        let response = try await client.patchTopicsId(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteTopic(
        id: String
    ) async throws -> Components.Schemas.RemoveTopicResponseSuccess {
        let response = try await client.deleteTopicsId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listContactProperties(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListContactPropertiesResponseSuccess {
        let response = try await client.getContactProperties(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createContactProperty(
        _ request: Components.Schemas.CreateContactPropertyOptions
    ) async throws -> Components.Schemas.CreateContactPropertyResponseSuccess {
        let response = try await client.postContactProperties(body: .json(request))
        return try response.created.body.json
    }

    public func getContactProperty(
        id: String
    ) async throws -> Components.Schemas.GetContactPropertyResponseSuccess {
        let response = try await client.getContactPropertiesId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func updateContactProperty(
        id: String,
        _ request: Components.Schemas.UpdateContactPropertyOptions
    ) async throws -> Components.Schemas.UpdateContactPropertyResponseSuccess {
        let response = try await client.patchContactPropertiesId(path: .init(id: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteContactProperty(
        id: String
    ) async throws -> Components.Schemas.RemoveContactPropertyResponseSuccess {
        let response = try await client.deleteContactPropertiesId(path: .init(id: id))
        return try response.ok.body.json
    }

    public func listContactSegments(
        contactID: String,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListContactSegmentsResponseSuccess {
        let response = try await client.getContactsContactIdSegments(
            path: .init(contactId: contactID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func addContactToSegment(
        contactID: String,
        segmentID: String
    ) async throws -> Components.Schemas.AddContactToSegmentResponseSuccess {
        let response = try await client.postContactsContactIdSegmentsSegmentId(
            path: .init(contactId: contactID, segmentId: segmentID)
        )
        return try response.ok.body.json
    }

    public func removeContactFromSegment(
        contactID: String,
        segmentID: String
    ) async throws -> Components.Schemas.RemoveContactFromSegmentResponseSuccess {
        let response = try await client.deleteContactsContactIdSegmentsSegmentId(
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
        let response = try await client.getContactsContactIdTopics(
            path: .init(contactId: contactID),
            query: .init(limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func updateContactTopics(
        contactID: String,
        _ request: Components.Schemas.UpdateContactTopicsOptions
    ) async throws -> Components.Schemas.UpdateContactTopicsResponseSuccess {
        let response = try await client.patchContactsContactIdTopics(
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
        let response = try await client.getLogs(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func getLog(
        id: String
    ) async throws -> Components.Schemas.Log {
        let response = try await client.getLogsLogId(path: .init(logId: id))
        return try response.ok.body.json
    }

    public func listAutomations(
        status: String? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListAutomationsResponse {
        let response = try await client.getAutomations(
            query: .init(
                status: status.flatMap(Operations.GetAutomations.Input.Query.StatusPayload.init(rawValue:)),
                limit: limit,
                after: after,
                before: before
            )
        )
        return try response.ok.body.json
    }

    public func createAutomation(
        _ request: Components.Schemas.CreateAutomationRequest
    ) async throws -> Components.Schemas.CreateAutomationResponse {
        let response = try await client.postAutomations(body: .json(request))
        return try response.created.body.json
    }

    public func getAutomation(
        id: String
    ) async throws -> Components.Schemas.Automation {
        let response = try await client.getAutomationsAutomationId(path: .init(automationId: id))
        return try response.ok.body.json
    }

    public func updateAutomation(
        id: String,
        _ request: Components.Schemas.PatchAutomationRequest
    ) async throws -> Components.Schemas.PatchAutomationResponse {
        let response = try await client.patchAutomationsAutomationId(path: .init(automationId: id), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteAutomation(
        id: String
    ) async throws -> Components.Schemas.DeleteAutomationResponse {
        let response = try await client.deleteAutomationsAutomationId(path: .init(automationId: id))
        return try response.ok.body.json
    }

    public func stopAutomation(
        id: String
    ) async throws -> Components.Schemas.StopAutomationResponse {
        let response = try await client.postAutomationsAutomationIdStop(path: .init(automationId: id))
        return try response.ok.body.json
    }

    public func listAutomationRuns(
        automationID: String,
        status: String? = nil,
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListAutomationRunsResponse {
        let response = try await client.getAutomationsAutomationIdRuns(
            path: .init(automationId: automationID),
            query: .init(status: status, limit: limit, after: after, before: before)
        )
        return try response.ok.body.json
    }

    public func getAutomationRun(
        automationID: String,
        runID: String
    ) async throws -> Components.Schemas.AutomationRun {
        let response = try await client.getAutomationsAutomationIdRunsRunId(
            path: .init(automationId: automationID, runId: runID)
        )
        return try response.ok.body.json
    }

    public func listEvents(
        limit: Int? = nil,
        after: String? = nil,
        before: String? = nil
    ) async throws -> Components.Schemas.ListEventsResponse {
        let response = try await client.getEvents(query: .init(limit: limit, after: after, before: before))
        return try response.ok.body.json
    }

    public func createEvent(
        _ request: Components.Schemas.CreateEventRequest
    ) async throws -> Components.Schemas.CreateEventResponse {
        let response = try await client.postEvents(body: .json(request))
        return try response.created.body.json
    }

    public func sendEvent(
        _ request: Components.Schemas.SendEventRequest
    ) async throws -> Components.Schemas.SendEventResponse {
        let response = try await client.postEventsSend(body: .json(request))
        return try response.accepted.body.json
    }

    public func getEvent(
        identifier: String
    ) async throws -> Components.Schemas.Event {
        let response = try await client.getEventsIdentifier(path: .init(identifier: identifier))
        return try response.ok.body.json
    }

    public func updateEvent(
        identifier: String,
        _ request: Components.Schemas.UpdateEventRequest
    ) async throws -> Components.Schemas.UpdateEventResponse {
        let response = try await client.patchEventsIdentifier(path: .init(identifier: identifier), body: .json(request))
        return try response.ok.body.json
    }

    public func deleteEvent(
        identifier: String
    ) async throws -> Components.Schemas.RemoveEventResponse {
        let response = try await client.deleteEventsIdentifier(path: .init(identifier: identifier))
        return try response.ok.body.json
    }
}
