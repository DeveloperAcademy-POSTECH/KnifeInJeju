//
//  LogView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

struct LogView: View {
    
    @State private var questionQase: QuestionCase = .toMe
    @State private var onlyBookMark = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                titleHeader
                
                CustomPicker(questionCase: $questionQase)
            }
            .background(.background)
            
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 0)
                    list
                    Spacer().frame(height: 0)
                }
                .padding(.horizontal, 17)
            }
            .background(Color(.systemGray6))
        }
    }
    
    private var titleHeader: some View {
        HStack {
            Text("질문 보관함")
                .font(.title2.weight(.bold))
            Spacer()
            
            HStack {
                Image(systemName: onlyBookMark ? "bookmark.fill" : "bookmark")
                    .foregroundColor(onlyBookMark ? .yellow : .black)
                Text("북마크 모아보기")
            }
            .font(.footnote)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color(.systemGray4))
            )
            .onTapGesture {
                onlyBookMark.toggle()
            }

        }
        .padding(.horizontal, 17)
        .padding(.top, 20)
    }
    
    private var list: some View {
        ForEach(0..<4) { index in
            CardView(title: "미술 입시 어떻게 하셨어요?",
                     text: "저는 미술을 꿈꾸고 있는 중학교 2학년이에요!. 지방에 거주하고 있는지라 미술관련 정보를 얻기 힘들고 대다수가 수도권에 있는 친구들에게 해당할 법한 이야기라 공감하기가 쉽지 않네요.. ",
                     isBookmarked: .constant(false),
                     isHearted: .constant(false),
                     isAnswered: .constant(false),
                     tags: ["study", "game"],
                     userName: "Yaehoon Kim",
                     userPictureName: "")
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}

struct CardView: View {
    var title: String
    var text: String
    @Binding var isBookmarked: Bool
    @Binding var isHearted: Bool
    @Binding var isAnswered: Bool
    var tags: [String]
    var userName: String
    var userPictureName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header
            
            HStack(spacing: 5) {
                ForEach(tags, id: \.self) { tag in
                    TagView(text: tag)
                }
            }
            
            main
            
            Divider()
            
            footer
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }
    
    private var header: some View {
        HStack(spacing: 12) {
            Text("Q.")
                .fontWeight(.heavy)
            Text(title)
                .lineLimit(1)
            
            Spacer()
            
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
            Image(systemName: isHearted ? "heart.fill" : "heart")
        }
        .font(.headline.bold())
    }
    
    private var main: some View {
        HStack(alignment: .top) {
            Image("")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 64, height: 64)
                .cornerRadius(12)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5))
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                )
            
            Text(text)
                .font(.footnote)
                .frame(height: 64)
                .foregroundColor(.gray)
        }
    }
    
    private var footer: some View {
        HStack {
            UserView(name: userName, pictureName: userPictureName)
            
            Spacer()
            
            if isAnswered {
                Button {
                    print("내용보기")
                } label: {
                    Text("내용보기")
                        .foregroundColor(.white)
                }
                .buttonStyle(CardButtonStyle(color: .orange))
            } else {
                Button {
                    print("거절")
                } label: {
                    Text("거절하기")
                }
                .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
                
                Button {
                    print("답변")
                } label: {
                    Text("답변하기")
                        .foregroundColor(.white)
                }
                .buttonStyle(CardButtonStyle(color: .orange))
            }
        }
    }
}

struct UserView: View {
    
    var name: String
    var pictureName: String
    
    var body: some View {
        HStack {
            Image(pictureName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 28, height: 28)
                .clipShape(Circle())
                .background(
                    ZStack {
                        Circle().fill(Color(.systemGray5))
                        Image(systemName: "photo")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
            
            Text(name)
                .font(.footnote.bold())
        }
    }
}


struct TagView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption.bold())
            .padding(.vertical, 3)
            .padding(.horizontal, 8)
            .background(
                Capsule()
                    .fill(Color(.systemGray5))
            )
    }
}

enum QuestionCase: String {
    case toMe
    case toOther
    
    var id: String {
        self.rawValue
    }
}

struct CustomPicker: View {
    
    @Binding var questionCase: QuestionCase
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("받은 질문")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.timingCurve(0.16, 1, 0.3, 1)) {
                            questionCase = .toMe
                        }
                    }
                Text("보낸 질문")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.timingCurve(0.16, 1, 0.3, 1)) {
                            questionCase = .toOther
                        }
                    }
            }
            .font(.footnote.bold())
            
            GeometryReader { geo in
                Rectangle()
                    .frame(width: geo.size.width / 2, height: 4)
                    .frame(maxWidth: .infinity,
                           alignment: questionCase == .toMe ? .leading : .trailing)
            }
            .frame(height: 5)
        }
    }
}

struct CardButtonStyle: ButtonStyle {
    
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption.weight(.semibold))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
            )
            .scaleEffect(configuration.isPressed ? 0.92: 1)
            .animation(.spring())
    }
}

/*
 CardView(title: "미술 입시 어떻게 하셨어요?",
          text: "저는 미술을 꿈꾸고 있는 중학교 2학년이에요!. 지방에 거주하고 있는지라 미술관련 정보를 얻기 힘들고 대다수가 수도권에 있는 친구들에게 해당할 법한 이야기라 공감하기가 쉽지 않네요.. ",
          isBookmarked: .constant(false),
          isHearted: .constant(false),
          isAnswered: .constant(false),
          tags: ["study", "game"],
          userName: "Yaehoon Kim",
          userPictureName: "")
*/
