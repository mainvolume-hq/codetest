//
//  DetailViewController.swift
//  codetest
//
//  Created by mainvolume on 12/14/16.
//  Copyright © 2016 mainvolume. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var artWorkImage: UIImageView!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        artWorkImage.layer.cornerRadius  = artWorkImage.frame.size.width/2
        artWorkImage.layer.masksToBounds = true
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let details = self.detailItem {
            for ui in self.view.subviews {
                ui.alpha = 1.0
            }
 
            if let artistName = self.lblArtistName,
                let trackName = self.lblTrackName,
                let albumName = self.lblAlbum,
                let releaseDate = self.lblReleaseDate,
                let artwork = self.artWorkImage,
                let price = self.lblPrice {
                artwork.image = details.albumArt
                
                artistName.text = "Artist: " + details.artistName
                trackName.text = "Track: " + details.trackName
                albumName.text = "Album: " + details.collectionName
                let s = details.releaseDate
                let startIndex = s.index(s.startIndex, offsetBy: 10)
                releaseDate.text = "Release Date: " + details.releaseDate.substring(to: startIndex)
                price.text = "Price: $" + "\(details.trackPrice)"
            }
            
        } else {
            for ui in self.view.subviews {
                ui.alpha = 0.0
            }
        }
    }
    
    var detailItem: SearchItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
}

