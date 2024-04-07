//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/25/24.
//

import Foundation

extension CoinGecko {

    public enum TimeComponentOptions: String, Codable {
        case day
        case year
        case month
        case minute
        case week

        public init?(component: Calendar.Component) {
            switch component {
            case .day:
                self = .day
            case .year:
                self = .year
            case .month:
                self = .month
            case .minute:
                self = .minute
            case .weekOfYear, .weekOfMonth:
                self = .week
            default:
                return nil
            }
        }

        public var calendarComponent: Calendar.Component {
            switch self {
            case .day:
                return .day
            case .year:
                return .year
            case .month:
                return .month
            case .minute:
                return .minute
            case .week:
                return .weekOfYear
            }
        }
        
        public var span: String {
            switch self {
            case .day:
                return "days"
            case .year:
                return "years"
            case .month:
                return "months"
            case .minute:
                return "minutes"
            case .week:
                return "weeks"
            }
        }

        public var frequency: String {
            switch self {
            case .day:
                return "daily"
            case .year:
                return "yearly"
            case .month:
                return "monthly"
            case .minute:
                return "minutely"
            case .week:
                return "weekly"
            }
        }
    }

    public struct TimeComponent: Codable {
        private let codableComponent: TimeComponentOptions
        public var component: Calendar.Component {
            codableComponent.calendarComponent
        }
        public var span: String {
            codableComponent.span
        }
        public var frequency: String {
            codableComponent.frequency
        }
        public let value: Int

        public init?(component: Calendar.Component, value: Int) {
            guard let codableComponent = TimeComponentOptions(component: component) else {
                return nil
            }
            self.codableComponent = codableComponent
            self.value = value
        }
    }

}

extension Calendar.Component {
    var span: String? {
        switch self {
        case .day:
            return "days"
        case .year:
            return "years"
        case .month:
            return "months"
        case .minute:
            return "minutes"
        case .weekOfYear, .weekOfMonth:
            return "weeks"
        default:
            return nil
        }
    }

    var frequency: String? {
        switch self {
        case .day:
            return "daily"
        case .year:
            return "yearly"
        case .month:
            return "monthly"
        case .minute:
            return "minutely"
        case .weekOfYear, .weekOfMonth:
            return "weekly"
        default:
            return nil
        }
    }
}
