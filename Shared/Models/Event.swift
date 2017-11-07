//
//  Event.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 11/7/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import UIKit

enum EventType : String {
    case commitCommentEvent
    case createEvent
    case deleteEvent
    case deploymentEvent
    case deploymentStatusEvent
    case downloadEvent
    case followEvent
    case forkEvent
    case forkApplyEvent
    case gistEvent
    case gollumEvent
    case installationEvent
    case installationRepositoriesEvent
    case issueCommentEvent
    case issuesEvent
    case labelEvent
    case marketplacePurchaseEvent
    case memberEvent
    case membershipEvent
    case milestoneEvent
    case organizationEvent
    case orgBlockEvent
    case pageBuildEvent
    case projectCardEvent
    case projectColumnEvent
    case projectEvent
    case publicEvent
    case pullRequestEvent
    case pullRequestReviewEvent
    case pullRequestReviewCommentEvent
    case pushEvent
    case releaseEvent
    case repositoryEvent
    case statusEvent
    case teamEvent
    case teamAddEvent
    case watchEvent
}

class Event {

    var id: String?
    var type: EventType?
    var actor: User?
    
    required init(from decoder: Decoder) throws {
        try self.decode(decoder: decoder)
    }
    
}
extension Event: Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case id
        case type
        case actor
    }
    
    func decode(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        if let typeString = try? container.decode(String.self, forKey: .type) {
           type = EventType(rawValue: typeString.firstLowercased)
        }
        if let user = try? container.decode(User.self, forKey: .actor) {
            self.actor = user
        }

        
    }
    
}
