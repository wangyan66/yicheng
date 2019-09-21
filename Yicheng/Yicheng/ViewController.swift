//
//  ViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/2/26.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    private let cellidentifier="collectionViewCell"
    let screenh = UIScreen.main.bounds.size.height
    let screenw = UIScreen.main.bounds.size.width
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as! WYCollectionViewCell
        cell.imageView.image=UIImage(named: "manuel-cosentino-691602-unsplash")
        return cell
        //return cell;
    }
    //flow delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenw-34)/2, height: 116*2)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        let frame : CGRect = self.view.frame
        //        let margin  = (frame.width - 90 * 3) / 6.0
        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6) // margin between cells
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: (screenw-17)/2, height: 116)
//        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1)
//        flowLayout.minimumLineSpacing = 0.0;
//        flowLayout.minimumInteritemSpacing = 0.0;
        collectionView.dataSource=self;
        collectionView.delegate=self;
        collectionView.register(UINib(nibName: "WYCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:cellidentifier)
        
    }


}

