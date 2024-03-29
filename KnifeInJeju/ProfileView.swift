//
//  ProfileView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

struct ProfileView: View {
    @State private var showEdit = false
    
    let name = "제주에칼이"
    let tag = "# 코딩 # 스타트업 "
    let rolemodelNumber = "42"
    let rolemodel = "롤모델"
    let answerNumber = "29"
    let answer = "답변수"
    let introduce = "스타트업, 코딩 질문 환영해요!\n포스트 방문하셔서 저희 서비스도 많은 관심 부탁드려요ㅎㅎ"
    
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    ZStack{
                        Button(action: {
                            self.showEdit = true
                        }, label: {
                            Image("setting")
                                .resizable()
                                .scaledToFit()
                                .frame(width:30, height: 30)
                                .symbolRenderingMode(.palette)
                                .foregroundColor(.orange)
                        }).offset(x: 160)
                            .sheet(isPresented: self.$showEdit){
                                EditView()
                            }
                    }
                    Image("userDefault")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    Text(name)
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(tag)
                        .font(.caption)
                        .bold()
                    Spacer()
                }
                HStack{
                    Button(action: {
                        //action
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 180, height: 55)
                            Spacer()
                            Text(rolemodelNumber)
                                .bold()
                                .font(.system(size: 18))
                                .foregroundColor(Color.orange)
                                .frame(width: 70, height: 45, alignment: .top)
                            Spacer()
                            Text(rolemodel)
                                .font(.system(size: 14))
                                .foregroundColor(Color.orange)
                                .frame(width: 70, height: 45, alignment: .bottom)
                        }
                        
                        
                    })
                    Button(action: {
                        //action
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 180, height: 55)
                            Text(answerNumber)
                                .bold()
                                .font(.system(size: 18))
                                .foregroundColor(Color.orange)
                                .frame(width: 70, height: 45, alignment: .top)
                            Text(answer)
                                .font(.system(size: 14))
                                .foregroundColor(Color.orange)
                                .frame(width: 70, height: 45, alignment: .bottom)
                        }
                    })
                }.padding(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 365, height: 130)
                        Text(introduce)
                            .font(.system(size: 13))
                            .frame(width: 360, height: 110,alignment: .topLeading)
                            .padding(.init(top: 15, leading: 20, bottom: 0, trailing: 0))
                            .lineSpacing(2)
                        Divider()
                            .padding(.init(top: -5, leading: 10, bottom: 0, trailing: 10))
                            .padding()
                        Spacer()
                        VStack{
                            HStack{
                                Image("instagram")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.leading)
                                Text("instagram.com/jeju.knife")
                                    .font(.system(size: 15))
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        UIApplication.shared.open(URL(string: "https://www.instagram.com/appledeveloperacademy.postech/?hl=ko")!)
                                    }
                            }
                            HStack{
                                Image("facebook")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.leading)
                                Text("facebook.com/jeju_knife")
                                    .font(.system(size: 15))
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        UIApplication.shared.open(URL(string: "https://ko-kr.facebook.com/")!)
                                    }
                            }
                        }.padding(.init(top: 55, leading: -165, bottom: 0, trailing: 0))
                    }
                    Button(action: {
                        //action
                    }, label: {
                        Image("california")
                            .resizable()
                            .frame(width: 365, height: 160)
                            .cornerRadius(10)
                    })
                    Divider()
                        .padding()
                        .foregroundColor(.white)
                    Button(action: {
                        //action
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 365, height: 150)
                            VStack{
                                Spacer()
                                Text("Q.미술 입시는 어떻게 하셨나요?")
                                    .padding(.init(top: 20, leading: -140, bottom: 0, trailing: 0))
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                Text("저는 미술을 꿈꾸고 있는 중학교 2학년이에요!. 지방에 거주하고 있는 지라 미술관련 정보를 얻기 힘들고 대다수가 수도권에 있는 ..더보기")
                                    .multilineTextAlignment(.leading)
                                    .padding(.init(top: 5, leading: 27, bottom: 0, trailing: 25))
                                    .lineSpacing(5)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                HStack{
                                    Image("randomProfile")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .clipShape(Circle())
                                    VStack{
                                        Text("Suryeon Kim")
                                            .foregroundColor(.black)
                                            .bold()
                                            .font(.system(size: 12))
                                        Text("19분전")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10))
                                            .padding(.init(top: 0, leading: -35, bottom: 0, trailing: 0))
                                    }
                                    HStack{
                                        Image("bookmark")
                                            .resizable()
                                            .frame(width: 18, height: 20)
                                            .scaledToFit()
                                            .foregroundColor(.yellow)
                                        Image("heart")
                                            .resizable()
                                            .frame(width: 18, height: 20)
                                            .scaledToFit()
                                            .foregroundColor(.pink)
                                            .offset(x: 3)
                                        Text("54")
                                            .foregroundColor(.pink)
                                            .bold()
                                            .font(.system(size: 15))
                                        Spacer()
                                    }.padding(.init(top: 5, leading: 110, bottom: 0, trailing: 0))
                                }.frame(width: 320, height: 20)
                                    .padding(.init(top: 10, leading: 0, bottom: 20, trailing: 0))
                                Spacer()
                            }
                        }
                    })
                    Spacer(minLength: 25)
                    Button(action: {
                        //action
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 365, height: 150)
                            VStack{
                                Spacer()
                                Text("Q.미술 입시는 어떻게 하셨나요?")
                                    .padding(.init(top: 20, leading: -140, bottom: 0, trailing: 0))
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                Text("저는 미술을 꿈꾸고 있는 중학교 2학년이에요!. 지방에 거주하고 있는 지라 미술관련 정보를 얻기 힘들고 대다수가 수도권에 있는 ..더보기")
                                    .multilineTextAlignment(.leading)
                                    .padding(.init(top: 5, leading: 27, bottom: 0, trailing: 25))
                                    .lineSpacing(5)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                HStack{
                                    Image("randomProfile")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .clipShape(Circle())
                                    VStack{
                                        Text("Suryeon Kim")
                                            .foregroundColor(.black)
                                            .bold()
                                            .font(.system(size: 12))
                                        Text("19분전")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10))
                                            .padding(.init(top: 0, leading: -35, bottom: 0, trailing: 0))
                                    }
                                    HStack{
                                        Image("bookmark")
                                            .resizable()
                                            .frame(width: 18, height: 20)
                                            .scaledToFit()
                                            .foregroundColor(.yellow)
                                        Image("heart")
                                            .resizable()
                                            .frame(width: 18, height: 20)
                                            .scaledToFit()
                                            .foregroundColor(.pink)
                                            .offset(x: 3)
                                        Text("54")
                                            .foregroundColor(.pink)
                                            .bold()
                                            .font(.system(size: 15))
                                        Spacer()
                                    }.padding(.init(top: 5, leading: 110, bottom: 0, trailing: 0))
                                }.frame(width: 320, height: 20)
                                    .padding(.init(top: 10, leading: 0, bottom: 20, trailing: 0))
                                Spacer()
                            }
                        }
                    })
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
