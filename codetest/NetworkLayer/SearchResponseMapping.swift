import Foundation

final class SearchResponseMapper: ResponseMapper<SearchItem>, ResponseMapperProtocol {
    
    static func process(_ obj: AnyObject?) throws -> SearchItem {
        
        return try process(obj, parse: { json in
            let artistId = json["artistId"] as? String
            let artistName = json["artistName"] as? String
            
            if let artistId = artistId, let artistName = artistName {
                return SearchItem(artistId: artistId, artistName: artistName)
            }
            return nil
        })
    }
}
