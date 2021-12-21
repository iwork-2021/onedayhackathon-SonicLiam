//
//  PicTableViewController.swift
//  MyAlbum
//
//  Created by SonicLiam on 2021/12/21.
//

import UIKit

class PicturesTableViewController: UITableViewController {
    var pictures = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pictures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PicturesTableViewCell
        cell.imageview.image = pictures[indexPath.row]
        cell.image = pictures[indexPath.row]
        //cell.
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = self.pictures[indexPath.row]
        let imageCrop = image.getCropRatio()
        
        return tableView.frame.width * imageCrop
    }
     

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ImageViewController
        controller.loadViewIfNeeded()
        let cell = sender as! PicturesTableViewCell
        controller.imageView.image = cell.image
    }
    

}

extension UIImage{
    func getCropRatio()->CGFloat{
        return CGFloat(self.size.height/self.size.width)
    }
}
