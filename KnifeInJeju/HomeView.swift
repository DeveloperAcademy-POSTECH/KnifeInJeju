//
//  HomeView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: PostModifiyView(),
                    label: {
                        Text("전문가 테스트 버튼")
                            .navigationTitle("프로필 수정")
                    }
                )
                NavigationLink(
                    destination: CertifyView(),
                    label: {
                        Text("포스트 수정 테스트 버튼")
                    }
                )
                Text("홈")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
