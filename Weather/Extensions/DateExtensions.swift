//
//  DateExtensions.swift
//  Weather
//
//  Created by Tim Pyshnov on 02.07.2021.
//

import Foundation

extension String {

    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }

}

extension Date {

    var weekday: Weekday? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return Weekday(rawValue: weekday)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var dayWithMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(from: self)
    }

}

enum Weekday: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

extension Weekday: CustomStringConvertible {

    var description: String {
        switch self {
        case .monday: return "Пн"
        case .sunday: return "Вс"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        }
    }

}
