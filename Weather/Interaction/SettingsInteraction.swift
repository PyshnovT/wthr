import UIKit

class SettingsInteraction: Interaction {

    var completion: (() -> ())?
    var onCancel: (() -> ())?
    var onSettings: (() -> ())?

    func follow() {

        let Settings = AppConstants.Strings.Alerts.Settings.self

        let message = Settings.message
        let settingsTitle = Settings.settings
        let cancelTitle = Settings.cancel

        let goToSettingsAlert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)

        goToSettingsAlert.addAction(UIAlertAction(title: settingsTitle, style: .default, handler: { (action: UIAlertAction) in

            DispatchQueue.main.async {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                    self.onSettings?()
                }
            }

        }))

        goToSettingsAlert.addAction(UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: { (action) in
            DispatchQueue.main.async {
                self.onCancel?()
                self.completion?()
            }
        }))

        UIApplication.visibleViewContoller?.present(goToSettingsAlert, animated: true)
    }

}

