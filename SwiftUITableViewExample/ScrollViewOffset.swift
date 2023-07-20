import SwiftUI
import Combine

struct ScrollViewOffsetView: View {
    
    // Properties
    @State private var text: String = ""
    @State private var messages: [Int] = (0...3).compactMap({ Int($0) })
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .white
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    // View
    var body: some View {
        NavigationView {

            // тут надо было 0
            VStack(alignment: .center, spacing: 0) {
                ScrollViewReader { reader in
                    ScrollView {
                        // Для того что бы бы нормальный навигатион бар
                        Color.clear.frame(height: 1)

                        VStack(spacing: 0) {
                            ForEach(messages, id: \.self) { value in
                                // Message Cell
                                HStack {
                                    Spacer()
                                    Text("Item \(value)")
                                    Spacer()
                                }
                                .frame(height: 100)
                                .background(color(fraction: Double(value) / 100))
                                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15, style: .continuous))
                                .contextMenu {
                                    Button("Replace") {
                                        withAnimation {
                                            if let idx = messages.firstIndex(where: { $0 == value }) {
                                                messages.remove(at: idx)
                                            }
                                        }
                                    }
                                }
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .padding(15)
                                .id(value)
                            }
                        }
                        .onChange(of: messages.count) { newValue in
                            // при изменении скрол до последнего
                            withAnimation {
                                reader.scrollTo(messages[messages.count - 1])
                            }
                        }
                        .onAppear {
                            // При появлении скрол до последнего
                            reader.scrollTo(messages[messages.count - 1])
                        }
                        .background(
                            GeometryReader { proxy in
                                Color.clear.onAppear { print(proxy.size.height) }
                            }
                        )
                    }
                    .background {
                        Color.cyan
                    }
                }
                .onTapGesture {
                    UIApplication.hideKeyboard()
                }

                VStack {
                    TextField("Placeholder", text: $text)
                        .background(Color.white)
                        .padding()

                    Spacer()
                }
                .frame(height: 100)
                .background(Color.red)
            }
            .navigationTitle("Messanger")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add number") {
                        withAnimation {
                            messages.append(Int.random(in: 500...700))
                        }
                    }
                }
            }
            // Это надо поднимать
            .offset(y: -keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.default, value: keyboard.currentHeight)

        }
    }
    
    // Methods
    func color(fraction: Double) -> Color {
        Color(red: fraction, green: 1 - fraction, blue: 0.5)
    }
}

struct ScrollViewOffsetView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewOffsetView()
    }
}

extension UIApplication {
    
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class KeyboardResponder: ObservableObject {
   private var notificationCenter: NotificationCenter
   @Published private(set) var currentHeight: CGFloat = 0

   init(center: NotificationCenter = .default) {
       notificationCenter = center
       notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
   }

   deinit {
       notificationCenter.removeObserver(self)
   }

   @objc func keyBoardWillShow(notification: Notification) {
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           currentHeight = keyboardSize.height
       }
   }

   @objc func keyBoardWillHide(notification: Notification) {
       currentHeight = 0
   }
}

extension ScrollView {
    private typealias PaddedContent = ModifiedContent<Content, _PaddingLayout>
    
    func fixFlickering() -> some View {
        GeometryReader { geo in
            ScrollView<PaddedContent>(axes, showsIndicators: showsIndicators) {
                content.padding(geo.safeAreaInsets) as! PaddedContent
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
