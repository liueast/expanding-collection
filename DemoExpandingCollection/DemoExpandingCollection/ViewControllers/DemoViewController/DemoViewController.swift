//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class DemoViewController: ExpandingViewController {
  
  typealias ItemInfo = (imageName: String, title: String)
  private var cellsIsOpen = [Bool]()
  private let items: [ItemInfo] = [("item0", "Boston"),("item1", "New York"),("item2", "San Francisco"),("item3", "Washington")]
  
  @IBOutlet weak var pageLabel: UILabel!
}

// MARK: life cicle

extension DemoViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerCell()
    fillCellIsOpeenArry()
    addGestureToView(collectionView!)
    configureNavBar()
  }
}

// MARK: Helpers 

extension DemoViewController {
  
  private func registerCell() {
    let nib = UINib(nibName: String(DemoCollectionViewCell), bundle: nil)
    collectionView?.registerNib(nib, forCellWithReuseIdentifier: String(DemoCollectionViewCell))
  }
  
  private func fillCellIsOpeenArry() {
    for _ in 0..<items.count {
      cellsIsOpen.append(false)
    }
  }
  
  private func getViewController() -> ExpandingTableViewController {
    let storyboard = UIStoryboard(storyboard: .Main)
    let toViewController: DemoTableViewController = storyboard.instantiateViewController()
    return toViewController
  }
  
  private func configureNavBar() {
    navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
  }
}

/// MARK: Gesture

extension DemoViewController {
  
  private func addGestureToView(toView: UIView) {
    let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .Up
    }
    
    let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .Down
    }
    toView.addGestureRecognizer(gesutereUp)
    toView.addGestureRecognizer(gesutereDown)
  }

  func swipeHandler(sender: UISwipeGestureRecognizer) {
    let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
    guard case let cell as DemoCollectionViewCell = collectionView?.cellForItemAtIndexPath(indexPath) else {
      return
    }
    
    // double swipe Up transition
    if cell.isOpened == true && sender.direction == .Up {
      pushToViewController(getViewController())
      
      if case let rightButton as AnimatingBarButton = navigationItem.rightBarButtonItem {
        rightButton.animationSelected(true)
      }
    }
    
    let open = sender.direction == .Up ? true : false
    cell.cellIsOpen(open)
    cellsIsOpen[indexPath.row] = cell.isOpened
  }
}

// MARK: UIScrollViewDelegate 

extension DemoViewController {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    pageLabel.text = "\(currentIndex)/\(items.count)"
  }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {
  
  func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    guard case let cell as DemoCollectionViewCell = cell else {
      return
    }
    let index = indexPath.row % 4
    let info = items[index]
    cell.backgroundImageView?.image = UIImage(named: info.imageName)
    cell.customTitle.text = info.title
    cell.cellIsOpen(cellsIsOpen[indexPath.row], animated: false)
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard case let cell as DemoCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) else {
      return
    }
    if currentIndex != indexPath.row { return }
    
    if cell.isOpened == false {
      cell.cellIsOpen(true)
    } else {
      pushToViewController(getViewController())
      
      if case let rightButton as AnimatingBarButton = navigationItem.rightBarButtonItem {
        rightButton.animationSelected(true)
      }
    }
  }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCellWithReuseIdentifier(String(DemoCollectionViewCell), forIndexPath: indexPath)
  }
}

