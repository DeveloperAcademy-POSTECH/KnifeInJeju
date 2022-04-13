//
//  ProfileEditView.swift
//  KnifeInJeju
//
//  Created by seungyeon oh on 2022/04/11.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var changeProfileImage = false
    @State var openCameraRoll = false
    @State var imageSelected = UIImage()
    @State var name: String = ""
    @State var tag: String = ""
    @State var detail: String = ""
    
    var body: some View {
        NavigationView{
            ScrollView() {
                ZStack {
                    Color(UIColor.systemGray6)
                        .ignoresSafeArea()
                    VStack{
                        HStack{
                            Text(" ")
                                .navigationBarTitle("프로필 수정", displayMode: .inline)
                                .toolbar{
                                    ToolbarItem(placement: .navigationBarLeading){
                                        Button(action: {
                                            self.presentationMode.wrappedValue
                                                .dismiss()
                                        }, label: {
                                            Text("취소")
                                                .foregroundColor(Color.black)
                                        })
                                    }
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .navigationBarTrailing){
                                        Button(action: {
                                            self.presentationMode.wrappedValue
                                                .dismiss()
                                        }, label: {
                                            Text("완료")
                                                .foregroundColor(Color.orange)
                                        })
                                    }
                                }
                        }
                        ZStack{
                            Button(action: {
                                changeProfileImage = true
                                openCameraRoll = true
                                
                            }, label: {
                                if changeProfileImage{
                                    Image(uiImage: imageSelected)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                    
                                }else{
                                    Image("userDefault")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                }
                            })
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                        }.sheet(isPresented: $openCameraRoll){
                            ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
                        }
                        VStack(alignment: .leading, spacing:-10) {
                            Text("이름")
                                .padding(15)
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(height: 42)
                                    .padding(10)
                                TextField("이름을 입력해주세요.", text: $name)
                                    .padding(20)
                            }
                            Text("태그")
                                .padding(15)
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(height: 42)
                                    .padding(10)
                                TextField("#태그", text: $tag)
                                    .padding(20)
                            }
                            Text("상세 설명")
                                .padding(15)
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(height: 84)
                                    .padding(10)
                                TextEditor(text: $detail)
                                .padding(20)}
                            Button(action: {
                                //action
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.orange)
                                        .frame(height: 50)
                                        .padding(15)
                                    Text("전문가 인증하기")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            })
                            Text("링크")
                                .padding(15)
                            Button(action: {
                                //action
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(height: 84)
                                        .padding(10)
                                    Image("linked")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                        .padding(.init(top: -25, leading: -170, bottom: 0, trailing: 0))
                                    Image("linked")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                        .padding(.init(top: 35, leading: -170, bottom: 0, trailing: 0))
                                }
                            })
                            Group{
                                Text("포스트 수정하기")
                                    .padding(15)
                                Button(action: {
                                    //action
                                }, label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .frame(height: 84)
                                            .padding(10)
                                        Image("appleDev")
                                            .resizable()
                                            .frame(width: 365, height: 160)
                                            .cornerRadius(10)
                                        Image("edit")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)
                                            .opacity(0.8)
                                        Text("애플 디벨로퍼 아카데미 MC1")
                                            .bold()
                                            .frame(width: 345, height: 140, alignment: .bottomLeading)
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                    }
                                })}
                        }
                    }
                }
            }
        }
    }
}
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}

