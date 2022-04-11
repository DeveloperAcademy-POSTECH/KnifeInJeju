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
    
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("제목을 작성해주세요.")
                .font(.subheadline)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 42)
                TextField("제목을 입력해주세요.", text: $title)
                    .padding(10)
            }
            
            Text("내용을 작성해주세요.")
                .font(.subheadline)
                .padding(.top, 40)
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
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
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 160)
                Button(action: {
                    self.showImagePicker.toggle()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(width: 120, height: 120)
                        .padding(20)
                        
                        Image(systemName: "paperclip")
                            .resizable()
                            .foregroundColor(.orange)
                            .frame(width: 30, height: 30)
                        
                        image?.resizable().frame(width: 120, height: 120).cornerRadius(20.0)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(sourceType: .photoLibrary) { image in
                            self.image = Image(uiImage: image)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("수정하기")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(.orange)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGray6))
        .navigationTitle("포스트 수정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PostModifiyView_Previews: PreviewProvider {
    static var previews: some View {
        PostModifiyView()
            .previewDevice("iPhone 13 Pro Max")
    }
}
