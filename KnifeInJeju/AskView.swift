//
//  AskView.swift
//  KnifeInJeju
//
//  Created by 이채민 on 2022/04/08.
//

import SwiftUI

struct AskView: View {

    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var text: String = ""
    @State var tag: String = ""
    @State private var showSheet = false
    @State var image = UIImage()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Group {
                    Text("제목을 작성해주세요").font(.headline)
                    TextField("제목을 입력해주세요", text: $title)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 30))
                        .frame(height: 50)
                        .background(Color.white)
                        .textFieldStyle(PlainTextFieldStyle())
                        .cornerRadius(10)
                }
                    
                Spacer()
                
                Group {
                    Text("질문 내용을 작성해주세요").font(.headline)
                    TextField("질문 내용을 입력해주세요", text: $text)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 100, trailing: 30))
                        .frame(height: 150)
                        .background(Color.white)
                        .textFieldStyle(PlainTextFieldStyle())
                        .cornerRadius(10)
                }
                    
                Spacer()
                
                Group {
                    Text("질문 키워드").font(.headline)
                    TextField("질문 관련 키워드를 입력해주세요", text: $tag)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 30))
                        .frame(height: 50)
                        .background(Color.white)
                        .textFieldStyle(PlainTextFieldStyle())
                        .cornerRadius(10)
                    
                    Text(changeToHashTag(_:tag))
                        .foregroundColor(Color.orange)
                        .bold()
                }
                
                Spacer()
                
                Group {
                    Text("사진을 업로드해주세요").font(.headline)
                    Text("질문에 필요한 사진을 첨부해주세요").font(.callout)
                    
                    ZStack {
                        Text("+")
                            .font(.headline)
                            .frame(width: 200, height: 100, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        Image(uiImage: self.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 70, alignment: .center)
                            .cornerRadius(10)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showSheet = true
                    }
                    .sheet(isPresented: $showSheet) {
                        ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
                    }
                    
                }
                
                Spacer()
                
                Group {
                    Text("제출 시 유의사항\n1. 해당 첨부파일은 관리자에게 전송되어 검토 과정을 거치게 됩니다.\n2. 개인 정보에 해당하는 내용은 지워서 첨부하여 주시기 바랍니다.").font(.footnote)
                }
                
            }.padding()
            
        }
        .navigationTitle("질문하기")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("완료") {
                    dismiss()
                    NavigationUtil.popToRootView()
                }
            }
        }
        .accentColor(Color(UIColor.systemOrange))

    }
    
}

func changeToHashTag(_ text: String) -> String {
    let words = text.split(separator: " ")
    var output: String = ""
    for word in words {
        output = output + " #" + String(word)
    }
    return output
}

//struct AskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AskView()
//    }
//}
