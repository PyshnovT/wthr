//
//  DeniedViewController.swift
//  Weather
//
//  Created by Tim Pyshnov on 03.07.2021.
//

import UIKit

class DeniedViewController: UIViewController {

    let locationService: LocationServiceProtocol

    var onLocationEnable: (() -> Void)?

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views

    @IBOutlet weak var enableLocationButton: UIButton!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        enableLocationButton.backgroundColor = AppConstants.Color.gray

        registerNotifications()
    }

    // MARK: - Notifications

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppWillEnterForeground(note:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    // MARK: - Actions

    @objc private func handleAppWillEnterForeground(note: Notification) {
        if locationService.locationStatus != .denied {
            onLocationEnable?()
        }
    }

    @IBAction func handleEnableLocationTap(_ sender: Any) {
        SettingsInteraction().follow()
    }

}
