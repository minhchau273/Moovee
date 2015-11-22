//
//  ViewController.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner
import Parse
import SWRevealViewController
import RealmSwift

protocol MovieSelectionDelegate: class {
  func movieSelected(id: Int)
}

class HomeViewController: UIViewController {
  
  @IBOutlet weak var menuButton: UIBarButtonItem!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var typeSegment: UISegmentedControl!
  
  @IBOutlet weak var noFavoriteLabel: UILabel!
  
  weak var delegate: MovieSelectionDelegate?
  
  var popularMovies = [Movie]()
  var mostRatedMovies = [Movie]()
  
  var currentSegment = SegmentType.Popular
  var popularPage = 1
  var mostRatedPage = 1
  
  var loadingView: UIActivityIndicatorView!
  
  // MARK: - Main funcitons
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Realm path: \(Realm.Configuration.defaultConfiguration)")
    
    setLogoAsTitle()
    configMenuSide()
    addFooterView()
    requestData(withLoadMore: false)
  }
  
  func setLogoAsTitle() {
    let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    logo.image = UIImage(named: "Logo")
    logo.contentMode = .ScaleAspectFit
    navigationItem.titleView = logo
  }
  
  func configMenuSide() {
    if let revealViewController = revealViewController() {
      menuButton.target = revealViewController
      menuButton.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
    }
  }
  
  func requestData(withLoadMore withLoadMore: Bool) {
    var type = ListType.Popular
    var page = 1
    
    switch currentSegment {
    case .Popular:
      type = ListType.Popular
      page = withLoadMore ? ++popularPage : popularPage
    case .MostRated:
      type = ListType.MostRated
      page = withLoadMore ? ++mostRatedPage : mostRatedPage
    case .Favorite:
      if moviesBasedOnSegment(currentSegment).count == 0 {
        collectionView.hidden = true
        noFavoriteLabel.hidden = false
      }
      return
    }
    
    MovieClient.getMovies(type, page: page) { (movies, error) -> () in
      if let movies = movies {
        switch self.currentSegment {
        case .Popular:
          for movie in movies {
            self.popularMovies.append(movie)
          }
        case .MostRated:
          for movie in movies {
            self.mostRatedMovies.append(movie)
          }
        case .Favorite:
          // TODO: Handle favorite list
          // do nothing
          break
        }
        self.collectionView.hidden = false
        self.noFavoriteLabel.hidden = true
        self.collectionView.reloadData()
        self.loadingView.hidden = true
        SwiftSpinner.hide()
      }
    }
  }
  
  func addFooterView() {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
    loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    loadingView.center = footerView.center
    footerView.addSubview(loadingView)
    collectionView.addSubview(footerView)
  }
  
  func moviesBasedOnSegment(segment: SegmentType) -> [Movie] {
    switch segment {
    case .Popular: return popularMovies
    case .MostRated: return mostRatedMovies
      // TODO: Handle favorite list
    case .Favorite: return Movie.allFavorites
    }
  }
  
  @IBAction func onSegmentChanged(sender: UISegmentedControl) {
    // TODO: Handle favorite list
    guard let selectedSegmentType = SegmentType(rawValue: sender.selectedSegmentIndex) else {
      return
    }
    currentSegment = selectedSegmentType
    
    // In each segment, when switch from another segment,
    // if app hasn't requested more movies yet (still at page 1),
    // scoll to top of collection view
    // Example:
    // In Popular segment, app has requested to page 3
    // <=> The table view is at the ~50th row
    // When switch to Most rated segment,
    // if this segment is still at page 1, scroll to top
    if (currentSegment == .Popular && popularPage == 1) || (currentSegment == .MostRated && mostRatedPage == 1) {
      if moviesBasedOnSegment(currentSegment).count > 0 {
        // Scroll collection view to top
        collectionView.contentOffset = CGPointMake(0, 0 - self.collectionView.contentInset.top)
      }
    }
    
    requestData(withLoadMore: false)
    collectionView.reloadData()
  }
  
}

// MARK: - Collection View

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width = (self.view.bounds.width - 30) / 2
    let height = width * 1.6
    return CGSize(width: width, height: height)
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return moviesBasedOnSegment(currentSegment).count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
    
    loadDataToCollectionView(moviesBasedOnSegment(currentSegment), cell: cell, indexPath: indexPath)
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let selectedMovie = moviesBasedOnSegment(currentSegment)[indexPath.row]
    delegate?.movieSelected(selectedMovie.id)
    
    if let detailVC = delegate as? DetailsViewController, detailNavigationController = detailVC.navigationController {
      splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
    }
  }
  
  func loadDataToCollectionView(movies: [Movie], cell: MovieCell, indexPath: NSIndexPath) {
    cell.movie = movies[indexPath.row]
    if currentSegment != .Favorite && indexPath.row == movies.count - 1 {
      loadingView.startAnimating()
      loadingView.hidden = false
      requestData(withLoadMore: true)
    }
  }
  
}
