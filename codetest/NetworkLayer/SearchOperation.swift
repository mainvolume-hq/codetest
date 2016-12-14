import Foundation

internal enum ResponseMapperError: Error {
    case invalid
    case missingAttribute
}

public class SearchOperation: ServiceOperation {
    
    private let request: SearchRequest
    
    public var success: (([SearchItem]) -> Void)?
    public var failure: ((NSError) -> Void)?
    
    public init(searchFor:String) {
        request = SearchRequest(searchItems: searchFor)
        super.init()
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    //TODO responce mapper
    //TODO types
    private func handleSuccess(_ response: AnyObject?) {
        do {
            
            let ss = response as? Dictionary<String, AnyObject>
            let arr = ss?["results"] as! NSArray
            var items = [SearchItem]()
            
            for i in arr {
                
                guard let json = i as? [String: AnyObject] else { throw ResponseMapperError.invalid }
                guard let theKind = json["kind"] as? String else { throw ResponseMapperError.invalid }
                
                if theKind == "song" {
                    let z = SearchItem(item: json)
                    items.append(z)
                }
            }
        
            self.success?(items)
            self.finish()
        } catch {
            handleFailure(NSError.cannotParseResponse())
        }
    }
    
    private func handleFailure(_ error: NSError) {
        self.failure?(error)
        self.finish()
    }
}
