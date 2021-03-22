//
//  Manager.swift
//  MobDevLab1
//
//  Created by Dima on 26.02.2021.
//

import Foundation
import UIKit

final class Manager {
    static let shared = Manager()
}
extension Manager {
    public func getText<T>(_ textName: String, type: T.Type) -> T? where T : Decodable{
        if let filePath = Bundle.main.path(forResource: textName, ofType: "txt") {
            do {
                let text = try String(contentsOfFile: filePath)
                let jsonData = text.data(using: .utf8)!
                let json = try! JSONDecoder().decode(type.self, from: jsonData)
                return json
            } catch {
                print("No such file")
            }
        }
        return nil
    }
    public func getImage (_ fileName: NSString) -> UIImage?{
        let name = fileName.deletingPathExtension
        let type = fileName.pathExtension
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
}


