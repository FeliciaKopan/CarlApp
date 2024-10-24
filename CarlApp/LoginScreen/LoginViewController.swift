//
//  LoginViewController.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 17.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        loginButton.backgroundColor = .gray
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emailTextField, constraints: [
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ])

        view.addSubview(passwordTextField, constraints: [
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ])

        view.addSubview(loginButton, constraints: [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: "Login failed: \(error.localizedDescription)")
                return
            }
            guard let uid = authResult?.user.uid else { return }
            self.fetchUserData(for: uid)
        }
    }

    private func fetchUserData(for uid: String) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")

        usersRef.whereField("uid", isEqualTo: uid).getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                self?.showAlert(message: "Failed to fetch user data.")
                return
            }

            guard let document = snapshot?.documents.first else {
                self?.showAlert(message: "User not found. Please contact support.")
                return
            }

            let userID = document.documentID
            let userData = document.data()
            if let applications = userData["applications"] as? [String: Any], !applications.isEmpty {
                self?.navigateToHomeScreen(for: userID)
            } else {
                self?.createDefaultApplications(for: userID)
            }
        }
    }

    private func createDefaultApplications(for userID: String) {
        let db = Firestore.firestore()
        let applicationsRef = db.collection("users").document(userID).collection("applications")

        applicationsRef.getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error fetching applications: \(error)")
                self?.showAlert(message: "Failed to fetch applications.")
                return
            }

            if let documents = snapshot?.documents, !documents.isEmpty {
                self?.navigateToHomeScreen(for: userID)
                return
            }

            let defaultApplications: [[String: Any]] = [
                ["name": "Music",
                 "musicName": "Song Name",
                 "musicUrl": "music-url",
                 "singer": "Singer name",
                 "type": "music",
                 "row": 0,
                 "column": 0
                ],
                ["name": "RadioFM",
                 "radioUrl": "http://ice-the.musicradio.com/ClassicFMMP3",
                 "type": "radio",
                 "row": 0,
                 "column": 1
                ],
                ["name": "Radio",
                 "radioUrl": "http://ice-the.musicradio.com/ClassicFMMP3",
                 "type": "radio",
                 "row": 1,
                 "column": 0
                ],
                ["name": "Google",
                 "appIcon": "https://cdn.icon-icons.com/icons2/729/PNG/512/google_icon-icons.com_62736.png",
                 "appstoreUrl": "https://apps.apple.com/us/app/google/id284815942",
                 "appUrl": "https://www.google.com/",
                 "type": "socialMediaApp",
                 "row": 1,
                 "column": 1
                ]
            ]

            for application in defaultApplications {
                applicationsRef.addDocument(data: application) { error in
                    if let error = error {
                        print("Error adding application: \(error)")
                        self?.showAlert(message: "Failed to add default applications.")
                        return
                    }
                }
            }
            self?.navigateToHomeScreen(for: userID)
        }
    }

    private func navigateToHomeScreen(for userID: String) {
        let homeVC = HomeScreenViewController(userID: userID)
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter both email and password.")
            return
        }

        signInUser(email: email, password: password)
    }
}
