//
//  ContentView.swift
//  KnifeInJeju
//
//  Created by 정지혁 on 2022/04/05.
//

import SwiftUI

struct ContentView: View {
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
                .tabItem {
                    Label {
                        Text("검색")
                    } icon: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            
            LogView()
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 Pro Max")
    }
}
