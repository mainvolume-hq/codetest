//
//  MasterViewController.swift
//  codetest
//
//  Created by mainvolume on 12/14/16.
//  Copyright © 2016 mainvolume. All rights reserved.
//

import UIKit

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}


class MasterViewController: UITableViewController, UISearchBarDelegate {
    
    var detailViewController: DetailViewController? = nil
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    
    var data = [SearchItem]()
    var filtered:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkLayerConfiguration.setup()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        searchBar.delegate = self
        
    }
    
    func performSearch(search:String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let searchOp = SearchOperation(searchFor: search)
        
        searchOp.success = { [unowned self] item in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if item.count > 0 {
                self.data = item
            } else {
                self.showNoContentAlert()
            }
            //swift 3
            DispatchQueue.main.async{ [unowned self] in
                self.searchActive = false
                self.tableView.reloadData()
            }
            
        }
        
        searchOp.failure = {[unowned self] error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.searchActive = false
            print(error.localizedDescription)
        }
        
        NetworkQueue.shared.addOperation(searchOp)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func showNoContentAlert() {
        let alert = UIAlertController(title: "Alert", message: "No items found", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true) { [unowned self] in
            self.searchBar.text = ""
            self.searchBar.becomeFirstResponder()
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = data[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - SearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = true
        searchBar.resignFirstResponder()
        let ss = searchBar.text?.replace(target: " ", withString:"+")
        if searchActive {
            self.performSearch(search: ss!)
        }
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dataObject = data[indexPath.row]
        dataObject.configureWithCell(cell: cell)
        return cell
    }
    
}

