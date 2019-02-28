//
//  MovieGridViewController.swift
//  FlixApp
//
//  Created by user148140 on 2/28/19.
//  Copyright © 2019 user148140. All rights reserved.
//

import UIKit

// Added UICollectionViewController, UICollectionViewDelegate protocols (Step 1)
class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Created an outlet for CollectionView (Step 0)
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Create a property called movie which is a dictionary and optional !
    // Copied from the main view controller (moviesViewController); every controller needs this property
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create layout object to configure the layout of the grid
        // Cast it as UICollectionViewFlowLayout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Control line space between the rows
        layout.minimumLineSpacing = 4
        
        // Control vertical line spacing (space between items)
        layout.minimumInteritemSpacing = 4
        
        // Control width: equally divide the width space by 3
        // let width = view.frame.size.width / 3 = It's same as the width of the phone / 3
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3 // multiplied minimumInteritemSPacing by the number of inter-spaces between items
        layout.itemSize = CGSize(width: width, height: width * 3 / 2) // height can be configured differently
        
        
        // Set collection view delegate & datasource = self (Step 3)
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
        
        // Requesting Network Snippet
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")! // Used a different URL to load similar movie list
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                // After you get data from API, tell collection view to reload data
                self.collectionView.reloadData()
                
                print(self.movies)
            }
        }
        task.resume()
    }
    
    // functions required by UICollectionViewDataSource and UICollectionViewDelegate Protocols (Step 2)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count // set how many items to return equal to movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell // Set deque method with String MovieGridCell IndexPath = indexPath and cast as MovieGridCell
        
        // Index movie list from indexPath.item
        let movie = movies[indexPath.item]
        
        // URL for posterView copied from the main swift view controller file
        // ** In main storyboard, set the imageView properties setting to AspectFill & clip to bound
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell // include return cell 
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
