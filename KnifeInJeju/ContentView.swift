//
//  ContentView.swift
//  KnifeInJeju
//
//  Created by 정지혁 on 2022/04/05.
//

import SwiftUI

struct ContentView: View {
    @StateObject var mainUser = MainUserViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label {
                        Text("홈")
                    } icon: {
                        Image(systemName: "house.fill")
                    }
                }
            
            SearchView()
                .environmentObject(mainUser)
                .tabItem {
                    Label {
                        Text("검색")
                    } icon: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            
            LogView()
                .environmentObject(mainUser)
                .tabItem {
                    Label {
                        Text("보관함")
                    } icon: {
                        Image(systemName: "list.bullet.rectangle.fill")
                    }
                }
            
            ProfileView()
                .tabItem {
                    Label {
                        Text("프로필")
                    } icon: {
                        Image(systemName: "person.fill")
                    }
                }
        }
        .accentColor(.orange)
        .font(.headline)
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
