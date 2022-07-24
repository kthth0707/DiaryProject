//
//  Singleton.swift
//  DiaryProject
//
//  Created by TH on 2022/07/24.
//

import Foundation

class Singleton {
    public static var singleton = Singleton()
    
    private init() { }
    
    func dateToString(date: Date, type: String) -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = type
        formmater.locale = Locale(identifier: "ko-KR")
        return formmater.string(from: date)
    }
    
    
}
