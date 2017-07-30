//
//  SelectionViewController.swift
//  CoreMLSample
//
//  Created by LiXiang on 2017/7/30.
//  Copyright © 2017年 LiXiang. All rights reserved.
//

import UIKit
import Photos

class SelectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var assets: PHFetchResult<PHAsset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.register(SelectionCell.self, forCellWithReuseIdentifier: "SelectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        assets = PHAsset.fetchAssets(with: .image, options: nil)
        if let assets = assets {
            collectionView.scrollToItem(at: IndexPath(item: assets.count - 1, section: 0), at: .bottom, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let assets = assets {
            return assets.count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("aaaaaa")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        let phAsset = assets?.object(at: indexPath.row)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .exact
        guard let asset = phAsset else {
            return UICollectionViewCell();
        }
        let _ = PHImageManager.default().requestImage(for: asset,
                                                            targetSize: CGSize(width:200, height: 200),
                                                            contentMode: .aspectFill,
                                                            options: options) { (image, anyObj) in
                                                                DispatchQueue.main.async {
                                                                    cell.imageView.image = image
                                                                }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let phAsset = assets?.object(at: indexPath.row)
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        guard let asset = phAsset else {
            return
        }
        let _ = PHImageManager.default().requestImage(for: asset,
                                                      targetSize: CGSize(width:227, height: 227),
                                                      contentMode: .aspectFill,
                                                      options: options) { (image, anyObj) in
                                                        let sb = UIStoryboard(name: "Main", bundle: nil)
                                                        let vc = sb.instantiateViewController(withIdentifier: "RecogizeViewController") as! RecogizeViewController
                                                        vc.image = image
                                                        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

