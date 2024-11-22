import SwiftUI

struct ContentView: View {
    var appDelegateHandler: AppDelegateHandler // Reference to AppDelegateHandler
    
    var body: some View {
        VStack {
            Text("Welcome to the App")
                .font(.largeTitle)
                .padding()
            Text("This is the ContentView.")
                .padding()
            
            Button(action: {
                appDelegateHandler.reloadCallDirectoryExtension()
            }) {
                Text("Reload Call Directory Extension")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appDelegateHandler: AppDelegateHandler()) // Pass a dummy instance for preview
    }
}
