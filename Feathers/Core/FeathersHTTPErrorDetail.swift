//
//  FeathersHTTPErrorDetail.swift
//  Feathers
//

import Foundation

/// Parsed Feathers / HTTP error payload preserved from 4xx/5xx responses.
public struct FeathersHTTPErrorDetail: LocalizedError, Equatable, Sendable {
    public let statusCode: Int
    public let name: String?
    public let message: String
    public let responseBody: String?

    public init(
        statusCode: Int,
        name: String?,
        message: String,
        responseBody: String?
    ) {
        self.statusCode = statusCode
        self.name = name
        self.message = message
        self.responseBody = responseBody
    }

    public var errorDescription: String? {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if let name, !trimmed.isEmpty {
            return "\(name): \(trimmed) (HTTP \(statusCode))"
        }
        if !trimmed.isEmpty {
            return "\(trimmed) (HTTP \(statusCode))"
        }
        return "HTTP \(statusCode)"
    }

    public static func make(statusCode: Int, data: Data?) -> FeathersHTTPErrorDetail {
        let raw = data.flatMap { String(data: $0, encoding: .utf8) }
        if let data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            return make(statusCode: statusCode, json: json, responseBody: raw)
        }
        let fallback = FeathersNetworkError(statusCode: statusCode)?.errorMessage ?? "HTTP \(statusCode)"
        return FeathersHTTPErrorDetail(
            statusCode: statusCode,
            name: nil,
            message: raw?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? raw! : fallback,
            responseBody: raw
        )
    }

    public static func make(
        statusCode: Int,
        json: [String: Any],
        responseBody: String? = nil
    ) -> FeathersHTTPErrorDetail {
        let name = json["name"] as? String
        let message = (json["message"] as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedMessage: String
        if let message, !message.isEmpty {
            resolvedMessage = message
        } else if let responseBody, !responseBody.isEmpty {
            resolvedMessage = responseBody
        } else {
            resolvedMessage = FeathersNetworkError(statusCode: statusCode)?.errorMessage ?? "HTTP \(statusCode)"
        }
        let raw = responseBody ?? (try? String(data: JSONSerialization.data(withJSONObject: json), encoding: .utf8))
        return FeathersHTTPErrorDetail(
            statusCode: statusCode,
            name: name,
            message: resolvedMessage,
            responseBody: raw
        )
    }

    /// Walk `AnyFeathersError` / `FeathersNetworkError.underlying` chains for a parsed HTTP detail.
    public static func first(in error: Error) -> FeathersHTTPErrorDetail? {
        if let detail = error as? FeathersHTTPErrorDetail {
            return detail
        }
        if let feathersError = error as? AnyFeathersError {
            return first(in: feathersError.error)
        }
        if let networkError = error as? FeathersNetworkError {
            switch networkError {
            case .underlying(let inner):
                return first(in: inner)
            default:
                return nil
            }
        }
        return nil
    }

    /// Event/log fields for replication failures.
    public static func eventFields(for error: Error, maxBodyLength: Int = 500) -> [String: Any] {
        var fields: [String: Any] = [
            "error": summary(for: error)
        ]
        if let detail = first(in: error) {
            fields["statusCode"] = detail.statusCode
            if let name = detail.name, !name.isEmpty {
                fields["feathersName"] = name
            }
            if !detail.message.isEmpty {
                fields["feathersMessage"] = detail.message
            }
            if let body = detail.responseBody, !body.isEmpty {
                fields["responseBody"] = body.count > maxBodyLength
                    ? String(body.prefix(maxBodyLength)) + "…"
                    : body
            }
        } else if let feathersError = error as? AnyFeathersError,
                  let networkError = feathersError.error as? FeathersNetworkError {
            fields["feathersCode"] = String(describing: networkError)
        }
        return fields
    }

    public static func summary(for error: Error) -> String {
        if let detail = first(in: error) {
            return detail.errorDescription ?? detail.message
        }
        if let feathersError = error as? AnyFeathersError {
            return feathersError.error.description
        }
        return error.localizedDescription
    }
}
