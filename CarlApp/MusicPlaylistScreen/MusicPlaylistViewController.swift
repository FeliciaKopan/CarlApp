//
//  MusicPlaylistScreenViewController.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 26.09.2024.
//

import UIKit
import MediaPlayer
import MusicKit

class MusicPlaylistViewController: UIViewController {

    private let applicationsScreenView = ApplicationsScreenView()
    private let imageView: UIImage
    private let backgroundColor: UIColor
    private let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    private var playlistID: String
    private var currentTrackIndex = 0

    init(imageView: UIImage, backgroundColor: UIColor, playlistID: String) {
        self.imageView = imageView
        self.backgroundColor = backgroundColor
        self.playlistID = playlistID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        connectAndPlayMusic()
    }

    func requestAppleMusicPermissions() {
        let authorizationStatus = MPMediaLibrary.authorizationStatus()
        if authorizationStatus == .notDetermined {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    print("Apple Music Access Granted")
                } else {
                    print("Apple Music Access Denied")
                }
            }
        } else if authorizationStatus == .authorized {
            print("Apple Music Access Already Granted")
        } else {
            print("Apple Music Access Denied")
        }
    }

    func requestMusicAuthorization() async throws {
        let status = await MusicAuthorization.request()
        if status == .authorized {
            print("User is authorized to access Apple Music")
        } else {
            print("User denied access to Apple Music")
        }
    }

    func checkAppleMusicSubscription() async throws -> Bool {
        let subscription = try await MusicSubscription.current
        return subscription.canPlayCatalogContent
    }

    func playAppleMusicPlaylist(playlistID: String) async throws {
        let musicPlayer = SystemMusicPlayer.shared

        let request = MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: MusicItemID(playlistID))
        let response = try await request.response()

        if let playlist = response.items.first {
            musicPlayer.queue = [playlist]
            try await musicPlayer.play()
        } else {
            print("Playlist not found")
        }
    }

    private func setupViews() {
        view.backgroundColor = .black

        applicationsScreenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applicationsScreenView, constraints: [
            applicationsScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            applicationsScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            applicationsScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            applicationsScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        applicationsScreenView.configure(
            personImage: nil,
            appIcon: imageView,
            description: "Now Playing",
            name: "Music Playlist",
            iconImage: UIImage(named: "logo3") ?? UIImage(),
            buttonText: "Stop",
            backgroundColor: backgroundColor,
            buttonColor: .lightGray,
            buttonLabelColor: .black
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stopMusic))
        applicationsScreenView.cancelView.addGestureRecognizer(tapGesture)
    }

    private func connectAndPlayMusic() {
        Task {
            do {
                try await requestMusicAuthorization()
                let isSubscribed = try await checkAppleMusicSubscription()

                if isSubscribed {
                    try await playAppleMusicPlaylist(playlistID: playlistID)
                } else {
                    print("User is not subscribed to Apple Music")
                }
            } catch {
                print("Failed to play Apple Music: \(error)")
            }
        }
    }

    @objc private func stopMusic() {
        SystemMusicPlayer.shared.stop()
        dismiss(animated: true, completion: nil)
    }
}
