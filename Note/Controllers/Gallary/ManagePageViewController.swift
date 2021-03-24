//
//  ManagePageViewController.swift
//  Note
//
//  Created by Александр on 20.02.2021.
//  Copyright © 2021 lancelap. All rights reserved.
//

import UIKit

class ManagePageViewController: UIPageViewController {
  var currentIndex: Int!
    
    var imageArray = [UIImage]()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self

    if let viewController = viewPhotoCommentController(currentIndex ?? 0) {
      let viewControllers = [viewController]

      setViewControllers(viewControllers,
                         direction: .forward,
                         animated: false,
                         completion: nil)
    }
  }
  
  func viewPhotoCommentController(_ index: Int) -> PhotoCommentViewController? {
    guard
      let storyboard = storyboard,
      let page = storyboard
        .instantiateViewController(withIdentifier: "PhotoCommentViewController")
        as? PhotoCommentViewController
      else {
        return nil
    }
    page.image = imageArray[index]
    page.photoIndex = index
    return page
  }
}

//MARK: - UIPageViewControllerDataSource
extension ManagePageViewController: UIPageViewControllerDataSource {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController)
      -> UIViewController? {
    if let viewController = viewController as? PhotoCommentViewController,
      let index = viewController.photoIndex,
      index > 0 {
        return viewPhotoCommentController(index - 1)
    }
    
    return nil
  }
  
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController)
      -> UIViewController? {
    if let viewController = viewController as? PhotoCommentViewController,
      let index = viewController.photoIndex,
      (index + 1) < imageArray.count {
        return viewPhotoCommentController(index + 1)
    }
    
    return nil
  }
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return imageArray.count
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentIndex ?? 0
  }

}

