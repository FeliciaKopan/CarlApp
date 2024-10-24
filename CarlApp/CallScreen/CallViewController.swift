//
//  CallViewController.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 20.09.2024.
//

import UIKit

class CallViewController: UIViewController {

    private let applicationsScreenView = ApplicationsScreenView()
    private var countdownTimer: Timer?
    private var countdownValue = 3
    private var isCallAnswered = false

    private let phoneNumber: String
    private let personImage: UIImage?
    private let personName: String

    init(phoneNumber: String, personImage: UIImage?, personName: String) {
        self.phoneNumber = phoneNumber
        self.personImage = personImage
        self.personName = personName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        startCountdown()
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
            personImage: personImage ?? UIImage(),
            appIcon: nil,
            description: "You are calling",
            name: personName,
            iconImage: UIImage(named: "logo1") ?? UIImage(),
            buttonText: "Cancel",
            backgroundColor: .clear,
            buttonColor: .red,
            buttonLabelColor: .white
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelOrHangUp))
        applicationsScreenView.cancelView.addGestureRecognizer(tapGesture)
    }

    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc private func updateCountdown() {
        if countdownValue > 0 {
            applicationsScreenView.descriptionLabel.text = "In \(countdownValue) second\(countdownValue == 1 ? "" : "s") calling"
            applicationsScreenView.cancelLabel.text = "Cancel"
            countdownValue -= 1
        } else {
            countdownTimer?.invalidate()
            applicationsScreenView.descriptionLabel.text = "You are calling"
            applicationsScreenView.cancelLabel.text = "Hang up"
            callPhoneNumber(phoneNumber)
        }
    }

    @objc private func cancelOrHangUp() {
        if isCallAnswered {
            dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    private func callPhoneNumber(_ number: String) {
        if let phoneURL = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Device cannot make a call or invalid phone number")
        }
    }
}
