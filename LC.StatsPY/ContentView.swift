import SwiftUI
import WebKit

struct ContentView: View {
    @State private var selectedItem: MenuItem?

    var menuItems: [MenuItem] = [
        MenuItem(name: "Аналитическая Сводка", link: "https://datalens.yandex.ru/1sz7xgsnx5dyp-monitoring-mobile"),
        MenuItem(name: "Активность", link: "#", subItems: [
            MenuItem(name: "Подразделения", link: "https://datalens.yandex.ru/mdkc0onkisv8a-monitoring-aktivnost-podrazdeleniy?state=28e3b83e56"),
            MenuItem(name: "Пользователи МИС", link: "https://datalens.yandex.ru/vmuyrh83u67yj-monitoring-aktivnost-polzovateley-mis"),
        ]),
        MenuItem(name: "Структура", link: "#", subItems: [
            MenuItem(name: "Структура ПО", link: "https://datalens.yandex.ru/kbicva0ddy6k8-monitoring-struktura-po"),
            MenuItem(name: "Реверс-структура", link: "https://datalens.yandex.ru/qhpu2u18otj8e-monitoring-revers-struktura-po?state=7cbc6b9d56"),
        ]),
        MenuItem(name: "Нагрузка", link: "#", subItems: [
            MenuItem(name: "Суточная", link: "https://datalens.yandex.ru/riuuli6arg5qf-monitoring-nagruzka-sutochnaya?state=f360e0aa56"),
            MenuItem(name: "Общая", link: "https://datalens.yandex.ru/nemzugt5zzeyb-monitoring-nagruzka"),
            MenuItem(name: "Ресурсы", link: "https://datalens.yandex.ru/tkwvy9lw788ah-monitoring-resursy?state=d44e055d56")
        ]),
    ]

    @State private var expandedItems: Set<String> = []

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(menuItems.indices, id: \.self) { index in
                        let item = menuItems[index]
                        DisclosureGroup(isExpanded: expandedState(for: item), content: {
                            ForEach(item.subItems ?? [], id: \.self) { subItem in
                                NavigationLink(destination: BrowserView(url: subItem.link), tag: subItem, selection: $selectedItem) {
                                    Text(subItem.name)
                                        .padding(.leading, 20)
                                }
                            }
                        }) {
                            NavigationLink(destination: BrowserView(url: item.link), tag: item, selection: $selectedItem) {
                                Text(item.name)
                            }
                            .onTapGesture {
                                selectedItem = item
                                toggleExpansion(for: item)
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            }
            .navigationBarTitle("", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = UIColor.clear
                nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
                nc.navigationBar.shadowImage = UIImage()
            })
            .navigationBarItems(leading: Text("Мониторинг v.3.3")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            )
            .onOpenURL { url in
                if let matchingItem = menuItems.first(where: { $0.link == url.absoluteString }) {
                    selectedItem = matchingItem
                    toggleExpansion(for: matchingItem)
                }
            }
            .onAppear {
                if let defaultItem = menuItems.first(where: { $0.name == "Аналитическая Сводка" }) {
                    selectedItem = defaultItem
                    toggleExpansion(for: defaultItem)
                }
            }

            // Remove navigation bar from the right frame
            BrowserView(url: selectedItem?.link ?? menuItems.first?.link ?? "")
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .scaledToFit()

        }
    }

    func expandedState(for item: MenuItem) -> Binding<Bool> {
        Binding(
            get: {
                expandedItems.contains(item.name)
            },
            set: { newValue in
                if let firstSubItem = item.subItems?.first {
                    if newValue {
                        expandedItems.insert(item.name)
                    } else {
                        expandedItems.remove(item.name)
                    }
                    selectedItem = firstSubItem
                }
            }
        )
    }


    func toggleExpansion(for item: MenuItem) {
        expandedState(for: item).wrappedValue.toggle()
    }

    struct NavigationConfigurator: UIViewControllerRepresentable {
        var configure: (UINavigationController) -> Void = { _ in }

        func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
            UIViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
            if let nc = uiViewController.navigationController {
                self.configure(nc)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}

struct MenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var link: String
    var subItems: [MenuItem]?

    init(name: String, link: String, subItems: [MenuItem]? = nil) {
        self.name = name
        self.link = link
        self.subItems = subItems
    }
}

struct BrowserView: View {
    let url: String

    var body: some View {
        if let validURL = URL(string: url) {
            WebView(request: URLRequest(url: validURL))
                .navigationBarHidden(true)
        } else {
            Text("Ссылка некорректна")
                .foregroundColor(.red)
        }
    }
}



struct WebView: UIViewRepresentable {
    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}
