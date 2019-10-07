import UIKit

protocol AppCodable: JSONCodable {
    init(json: [String: Any])
}

extension AppCodable {
    
    init(json: [String: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        self = try! JSONDecoder().decode(Self.self, from: jsonData)
    }
}

protocol JSONCodable: Codable {}

extension JSONCodable {
    static func getObjectFromJSONFile<T: Codable>(fileName: String,
                                                  forKey key: String? = nil, fileType: String? = nil) -> T? {
        var dataModel: T?
        let decoder = JSONDecoder()
        if let jsonFilePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonFilePath))
                if let dicKey = key {
                    if let dataDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        guard let itemData = dataDic[dicKey] else { return nil }
                        let jsonItemData = try JSONSerialization.data(withJSONObject: itemData, options: [])
                        dataModel = try decoder.decode(T.self, from: jsonItemData)
                    }
                } else {
                    dataModel = try decoder.decode(T.self, from: jsonData)
                }
            } catch {
                print("JSON Serialization of \(T.self) failed")
            }
        }
        return dataModel
    }    
}

extension Array: JSONCodable where Element: JSONCodable {}
extension Dictionary: JSONCodable where Value: JSONCodable, Key: Encodable & Decodable {}
