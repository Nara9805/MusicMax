//
//  MediaController.swift
//  MusicMaxx
//
//  Created by Smart Castle M1A2009 on 14.04.2024.
//

import UIKit
import AVFoundation
import Disk
import Kingfisher


class MediaController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var player: AVPlayer?
    var musicData = [SavedMusicModel]()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllSavedMusic()
    }
    
    func setupCollectionView() {
        collectionView.register(MusicRowCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func getAllSavedMusic() {
        musicData.removeAll()
        if var retrievedMedia = try? Disk.retrieve("Folder/media.json", from: .documents, as: [SavedMusicModel].self) {
            self.musicData = retrievedMedia
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    func remove(_ metadata: SavedMusicModel, from directory: Disk) throws {
        do {
            var url = try? Disk.retrieve("Folder/media.json", from: .documents, as: [SavedMusicModel].self)
            if let index = url?.firstIndex(where: { $0.playURL == metadata.playURL}) {
                url?.remove(at: index)
            }
            try? Disk.save(url, to: .documents, as: "Folder/media.json")
//            try FileManager.default.removeItem(at: url)
//        } catch {
//            throw error
            }
        }
//        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            do {
//                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil)
//                for url in fileURLs {
//                    // Assuming you've saved the title of the music in its filename
//                    let fileName = url.lastPathComponent //imageURl + "_z_" + title + ".mp3"
//
//                    let components = fileName.components(separatedBy: "_end_")
//                    if components.count == 2 {
//                        let imageURL = components[0]
//                        let title = (components[1] as NSString).deletingPathExtension // Remove ".mp3" extension
//                        musicData.append(SavedMusicModel(title: title, playURL: url, avatarUrl: imageURL))
//                    } else {
//                        print("Invalid file name format: \(fileName)")
//                    }
//                    
////                    musicData.append(SavedMusicModel(title: title, playURL: url, avatarUrl: nil))
//                }
//            } catch {
//                print("Error while enumerating files:", error.localizedDescription)
//            }
//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MusicRowCell
        cell.configure(musicData[indexPath.item])
        
//        cell.contentImageView.kf.setImage(with: URL(string: musicData[indexPath.item].avatarUrl ?? ""))
//        cell.nameLabel.text = musicData[indexPath.item].title
//        cell.descLabel.text = musicData[indexPath.item].artistName
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
            musicData.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playMusic(musicData[indexPath.item].playURL)
    }
    func playMusic(_ url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}

