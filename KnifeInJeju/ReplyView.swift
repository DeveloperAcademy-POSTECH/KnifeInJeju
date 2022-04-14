//
//  ReplyView.swift
//  KnifeInJeju
//
//  Created by 이채민 on 2022/04/11.
//

import SwiftUI

struct ReplyView: View {
    
    @State var title: String = "미술 입시는 어떻게 하셨나요?"
    @State var text: String = "저는 미술을 꿈꾸고 있는 중학교 2학년아에요! 지방에 거주하고 있는지라 미술 관련 정보를 얻기 힘들고 대다수가 수도권에 있는 친구들에게 해당할 법한 이야기라 공감하기가 쉽지 않네요"
    @State var answer: String = ""
    
    var body: some View {
            
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        Text("답변하실 질문입니다").font(.headline)
                        
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.body)
                                .padding()
                            Divider()
                                .padding(.horizontal)
                            Text(text)
                                .font(.callout)
                                .padding()
                        }
                        .frame(height: 200)
                        .background(Color.white)
                        .cornerRadius(10)
                        
                    }
                    .padding(.bottom, 5)
                    Spacer()
                    Group {
                        Text("답변 내용을 작성해주세요").font(.headline)
                        TextField("답변 내용을 입력해주세요", text: $answer)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 100, trailing: 30))
                            .frame(height: 140)
                            .background(Color.white)
                            .textFieldStyle(PlainTextFieldStyle())
                            .cornerRadius(10)
                    }
                    .padding(.top, 5)
                    Spacer()
                    
                    Group {
                        Text("제출 시 유의사항\n1. 해당 첨부파일은 관리자에게 전송되어 검토 과정을 거치게 됩니다.\n2. 개인 정보에 해당하는 내용은 지워서 첨부하여 주시기 바랍니다.").font(.footnote)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer()
                        Text("답변하기")
                            .font(.headline)
                            .padding()
                        Spacer()
                        Button("완료") {
                            
                        }
                        }
                        .padding()
                    }
                }
                .padding()
            }

        .accentColor(Color(UIColor.systemOrange))
    }
}

struct ReplyView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyView()
    }
}
