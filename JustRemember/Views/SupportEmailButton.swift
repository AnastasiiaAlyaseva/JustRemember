import SwiftUI

struct SupportEmailButton: View {
    @Environment(\.openURL) var openUrl
    @State private var supportEmailAlert = false
    
    private let supportEmail = SupportEmail(
        toAddress: AppConstatns.developerEmail,
        subject: "Support Email",
        message: "Describe your issues or share your ideas with us!"
    )
    
    var body: some View {
        Button {
            supportEmail.sendEmail(openUrl: openUrl, completion: { result in
                supportEmailAlert = !result
            })
        } label: {
            HStack{
                Text("Support Email")
                    .font(.subheadline)
            }
        }
        .alert(isPresented: $supportEmailAlert) {
            Alert(
                title: Text("Email error"),
                message: Text("An error occurred while trying to send the support email."),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
}

struct SupportEmailButton_Previews: PreviewProvider {
    static var previews: some View {
        SupportEmailButton()
    }
}
