//
//  MyCollectionViewController.swift
//  MyAlbum
//
//  Created by SonicLiam on 2021/12/21.
//

import UIKit

private let reuseIdentifier = "collectionCell"

class MyAlbumViewController: UICollectionViewController {
    var pictures = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyAlbumViewCell
        cell.imageview.image = pictures[indexPath.row]
        return cell
    }

}
