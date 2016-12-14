import Foundation

class NetworkLayerConfiguration {
    
    class func setup() {
        // Backend Configuration
        let url = URL(string: "https://itunes.apple.com")!
        let conf = BackendConfiguration(baseURL: url)
        BackendConfiguration.shared = conf
        
        // Network Queue
        NetworkQueue.shared = NetworkQueue()
    }
}
