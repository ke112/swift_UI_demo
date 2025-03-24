import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "确定") -> some View {
        let localizedError = error.wrappedValue?.localizedDescription ?? ""
        return alert(isPresented: .constant(error.wrappedValue != nil)) {
            Alert(
                title: Text("错误"),
                message: Text(localizedError),
                dismissButton: .default(Text(buttonTitle)) {
                    error.wrappedValue = nil
                }
            )
        }
    }

    func loading(_ isLoading: Bool) -> some View {
        ZStack {
            self
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                LoadingView()
            }
        }
    }
}
