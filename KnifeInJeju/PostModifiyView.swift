//
//  PostModifiyView.swift
//  KnifeInJeju
//
//  Created by 정지혁 on 2022/04/08.
//

import SwiftUI

struct PostModifiyView: View {
    @State var title: String = ""
    @State var content: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("제목을 작성해주세요.")
                .font(.subheadline)
            ZStack {
                RoundRectangle()
                    .frame(height: 42)
                TextField("제목을 입력해주세요.", text: $title)
                    .padding(10)
            }
            
            Text("내용을 작성해주세요.")
                .font(.subheadline)
                .padding(.top, 40)
            ZStack(alignment: .topLeading) {
                RoundRectangle()
                    .frame(height: 125)
                TextField("내용을 입력해주세요.", text: $content)
                    .padding(10)
            }
            
            Text("사진을 업로드해주세요.")
                .font(.subheadline)
                .padding(.top, 40)
            Text("프로필에 보일 사진을 첨부해주세요.")
                .font(.caption)
                .foregroundColor(.secondary)
            RoundRectangle()
                .frame(height: 160)
            
            Spacer()
            
            Button(action: {}) {
                Text("수정하기")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(.orange)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

struct PostModifiyView_Previews: PreviewProvider {
    static var previews: some View {
        PostModifiyView()
            .previewDevice("iPhone 13 Pro Max")
    }
}
