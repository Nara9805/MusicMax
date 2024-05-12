//
//  PlayerController.swift
//  MusicMaxx
//
//  Created by Smart Castle M1A2009 on 16.04.2024.
//

import UIKit
import AVFoundation

class PlayerController: UIViewController {
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?

    let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "free-icon-font-play-3917517 (1)"), for: .normal)
        button.addTarget(PlayerController.self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Title"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(PlayerController.self, action: #selector(progressSliderValueChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(artistImageView)
        view.addSubview(playButton)
        view.addSubview(titleLabel)
        view.addSubview(progressSlider)
        
        // Layout constraints
        artistImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        artistImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        artistImageView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        artistImageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        playButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        progressSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20).isActive = true
        progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // Load music
        if let url = Bundle.main.url(forResource: "song", withExtension: "mp3") {
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
    @objc func playButtonTapped() {
        if let player = player {
            if player.rate == 0 {
                player.play()
                playButton.setImage(UIImage(named: "free-icon-font-pause-3917542"), for: .normal)
            } else {
                player.pause()
                playButton.setImage(UIImage(named: "free-icon-font-play-3917517 (1)"), for: .normal)
            }
        }
    }
    
    @objc func progressSliderValueChanged() {
        if let player = player {
            let value = progressSlider.value
            let duration = CMTimeGetSeconds(playerItem!.duration)
            let seekTime = CMTime(seconds: duration * Double(value), preferredTimescale: 1000)
            player.seek(to: seekTime)
        }
    }
}

