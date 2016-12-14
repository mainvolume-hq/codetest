
import Foundation
import UIKit



public class SearchItem: ParsedItem {

    
    public let artistName: String
    public let collectionName: String
    public let trackName: String
    public let artworkUrl: String
    public let trackPrice: NSNumber
    public let releaseDate: String
    public var albumArt : UIImage
    
    public var imageView:UIImageView!
    
    public init(item:[String: AnyObject] ) {
        
        
        artistName = item["artistName"] as! String
        collectionName = item["collectionName"] as! String
        trackName = item["trackName"] as! String
        artworkUrl = item["artworkUrl100"] as! String
        trackPrice = item["trackPrice"] as! NSNumber
        releaseDate = item["releaseDate"] as! String
        
        albumArt = UIImage(named: "placeholder")!
        
        self.downloadImageFrom(link: artworkUrl)
    }
    
    func downloadImageFrom(link:String) {
        let linkHiRes = link.replace(target: "100x100", withString: "400x400") //hireshack
        URLSession.shared.dataTask( with: NSURL(string:linkHiRes)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data { self.albumArt = UIImage(data: data)! }
                if self.imageView != nil {
                    self.imageView.image = self.albumArt
                }
            }
        }).resume()
    }
    
    func configureWithCell(cell:UITableViewCell) {
        self.imageView = cell.imageView
        cell.textLabel?.text = self.artistName
        cell.detailTextLabel?.text = self.trackName
        cell.imageView?.image = self.albumArt
        cell.setSelected(true, animated: true)
        cell.setNeedsLayout()
    }

}
