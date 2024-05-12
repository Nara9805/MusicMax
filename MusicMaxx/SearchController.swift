//
//  SearchController.swift
//  MusicMaxx
//
//  Created by Smart Castle M1A2009 on 14.04.2024.
//

import UIKit
import AVFoundation
import Disk

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var player: AVPlayer?
    var timer: Timer?
    var searchData = [SearchResultModel]()
    var musicData = [SavedMusicModel]()
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        searchController.definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        definesPresentationContext = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        collectionView.register(MusicRowCell.self, forCellWithReuseIdentifier: "cellId")
        
        
    }
    
    var savedMusic = [SavedMusicModel]()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search text:\(searchText)")
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            Service.shared.searchMusic(searchTerm: searchText) { (res, err) in
                
                if let err = err {
                    print("Failed to fetch apps:", err)
                    return
                }
                if var retrievedMedia = try? Disk.retrieve("Folder/media.json", from: .documents, as: [SavedMusicModel].self) {
                    self.savedMusic = retrievedMedia
                }
                
                self.searchData = res?.tracks.items ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MusicRowCell
        cell.configure(searchData[indexPath.item])
        if let _ = savedMusic.first(where: { $0.title == searchData[indexPath.item].title && $0.avatarUrl == searchData[indexPath.item].artworkUrl }) {
            cell.likeButton.setImage(UIImage(resource: .blackheart), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(resource: .heart), for: .normal)
        }
        
//        cell.
        
        (searchData[indexPath.item], forKey: "Likes")
        UserDefaults.standard.synchronize()
        
        //        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = searchData[indexPath.item].id {
            //            playMusicById(id)
            findMusicById(id, title: searchData[indexPath.item].title ?? "",
                          artist: searchData[indexPath.item].user?.name ?? "",
                          imageUrl: searchData[indexPath.item].artworkUrl ?? "")
        }
    }
    
    func findMusicById(_ id: Int, title: String, artist: String, imageUrl: String) {
        Service.shared.playMusic(id: id) { res, err in
            if let err = err {
                print("Failed to fetch apps:", err)
                return
            }
            
            
            guard let playData = res?.audio?.filter { $0.type == "mp3" }.first,
            let url = URL(string: playData.url)
            else { return }
            
            // Save music metadata to retrieve later
            let musicMetadata = SavedMusicModel(title: title, playURL: url, avatarUrl: imageUrl, artistName: artist) // Replace "Title" with actual title
            //            self.savedMusic.append(musicMetadata)
            
            // Save music file
            self.saveMusic(musicMetadata)
            
            // Play music
            self.playMusic(url)
        }
        
    }
    
    //    func playMusicById(_ id: Int) {
    //        Service.shared.playMusic(id: id) { res, err in
    //            if let err = err {
    //                print("Failed to fetch apps:", err)
    //                return
    //            }
    //
    //
    //            guard let playData = res?.audio?.filter { $0.type == "mp3" }.first,
    //            let url = URL(string: playData.url)
    //            else { return }
    //
    //            self.playMusic(url)
    //
    //        }
    //
    //    }
    
    func playMusic(_ url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
        
    }
    
    func saveMusic(_ metadata: SavedMusicModel) {
        if var retrievedMedia = try? Disk.retrieve("Folder/media.json", from: .documents, as: [SavedMusicModel].self) {
            if let _ = retrievedMedia.first(where: { $0.playURL == metadata.playURL }) {
                return
            }
            retrievedMedia.insert(metadata, at: 0)
            try? Disk.save(retrievedMedia, to: .documents, as: "Folder/media.json")
        } else {
            let medias: [SavedMusicModel] = [metadata]
            try? Disk.save(medias, to: .documents, as: "Folder/media.json")
        }
        
            
            //        // Get the document directory URL
            //        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            //            print("Documents directory not found.")
            //            return
            //        }
            //
            //        // Create the destination file URL with the provided title
            //        let destinationUrl = documentsDirectoryURL.appendingPathComponent("_start_" + imageURl + "_end_" + title + ".mp3")
            //        print(destinationUrl)
            //
            //        // Check if the file already exists at the destination URL
            //        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            //            print("The file already exists at path")
            //        } else {
            //            // Download the music file asynchronously
            //            URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
            //                guard let location = location, error == nil else {
            //                    print("Failed to download music:", error?.localizedDescription ?? "Unknown error")
            //                    return
            //                }
            //                do {
            //                    // Move the downloaded file to the destination URL
            //                    try FileManager.default.moveItem(at: location, to: destinationUrl)
            //                    print("File moved to documents folder")
            //                } catch {
            //                    print("Failed to move file:", error.localizedDescription)
            //                }
            //            }.resume()
            //        }
        
    }
}
                                     
        
