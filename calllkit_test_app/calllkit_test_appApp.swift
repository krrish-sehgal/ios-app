import SwiftUI
import CallKit

@main
struct CallKitTestApp2: App {
    
    // Initialize AppDelegateHandler for custom logic
    @UIApplicationDelegateAdaptor(AppDelegateHandler.self) var appDelegateHandler

    var body: some Scene {
        WindowGroup {
            // Pass appDelegateHandler to ContentView
            ContentView(appDelegateHandler: appDelegateHandler)
        }
    }
}

// Custom App Delegate Handler for CallKit Logic
class AppDelegateHandler: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print("App Launched")
        return true
    }

    func reloadCallDirectoryExtension() {
        let extensionIdentifier = "personal.calllkit-test-app.callkit-test-ext" // Replace with your actual extension identifier
        
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: extensionIdentifier) { error in
            if let err = error as NSError? {
                // Set a flag indicating the reload attempt failed
                self.setLastAttemptToUpdateFailedKey(failed: true)
                
                if let cdError = error as? CXErrorCodeCallDirectoryManagerError {
                    var debugString = ""
                    var seriousError = false

                    // Handle specific CallKit errors
                    switch cdError.code {
                    case .unknown:
                        debugString = "Unknown error"
                    case .noExtensionFound:
                        debugString = "No extension found"
                    case .loadingInterrupted:
                        debugString = "Loading interrupted"
                        seriousError = true
                    case .entriesOutOfOrder:
                        debugString = "Entries out of order"
                        seriousError = true
                    case .duplicateEntries:
                        debugString = "Duplicate entries"
                        seriousError = true
                    case .maximumEntriesExceeded:
                        debugString = "Maximum entries exceeded"
                    case .extensionDisabled:
                        debugString = "Extension disabled"
                    case .currentlyLoading:
                        debugString = "Currently loading"
                    case .unexpectedIncrementalRemoval:
                        debugString = "Unexpected incremental removal"
                    @unknown default:
                        debugString = "Unknown error code"
                    }

                    print("CallKit Error: \(debugString)")
                    
                    if seriousError {
                        print("A serious error occurred: \(debugString)")
                        // Handle serious errors here if needed
                    }
                } else {
                    print("Failed to reload extension: \(err.localizedDescription)")
                }
            } else {
                print("Successfully reloaded Call Directory Extension.")
                self.setLastAttemptToUpdateFailedKey(failed: false)
            }
        }
    }
    
    /// Helper function to simulate saving the reload status (you can replace this with actual persistence logic).
    private func setLastAttemptToUpdateFailedKey(failed: Bool) {
        print("Set reload status to: \(failed ? "Failed" : "Successful")")
        // Add persistence logic here if necessary, e.g., UserDefaults or CoreData
    }
}
