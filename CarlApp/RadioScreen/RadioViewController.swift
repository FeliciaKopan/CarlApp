//
//  RadioViewController.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 24.09.2024.
//

import UIKit
import AVFoundation

class RadioViewController: UIViewController {

    private let applicationsScreenView = ApplicationsScreenView()
    private let imageView: UIImage
    private let backgroundColor: UIColor
    private var player: AVPlayer?
    private let radioURL: URL

    init(imageView: UIImage, backgroundColor: UIColor, radioURL: URL) {
        self.imageView = imageView
        self.backgroundColor = backgroundColor
        self.radioURL = radioURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        startRadio()
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
            description: "Now playing",
            name: "Classic FM",
            iconImage: UIImage(named: "stopRadio") ?? UIImage(),
            buttonText: "Stop",
            backgroundColor: backgroundColor,
            buttonColor: .lightGray,
            buttonLabelColor: .black
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stopRadio))
        applicationsScreenView.cancelView.addGestureRecognizer(tapGesture)
    }

    private func startRadio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to activate audio session: \(error)")
        }

        player = AVPlayer(url: radioURL)
        player?.play()
    }

    @objc private func stopRadio() {
        player?.pause()
        player = nil
        dismiss(animated: true, completion: nil)
    }
}
