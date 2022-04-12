//
//  CardView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/07.
//

import SwiftUI

struct CardView: View {
    @State private var showCardDetailView = false
    
    @Binding var question: Question
    @ObservedObject var loginUserVM: LoginUserViewModel
    let saveQuestion: () -> Void
    
    private var questionCase: QuestionCase {
        if loginUserVM.user.id == question.to.id {
            return .toMe
        } else if loginUserVM.user.id == question.from.id {
            return .byMe
        } else {
            return .other
        }
    }
    
    private var bookmarked: Bool {
        loginUserVM.checkBookmarked(question)
    }
    
    private var hearted: Bool {
        loginUserVM.checkHearted(question)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header()
            
            main
            
            Divider()
            
            footer
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background)
        )
        .opacity(question.isAnswered && questionCase == .toMe ? 0.6 : 1)
        .onTapGesture {
            showCardDetailView = true
        }
        .sheet(isPresented: $showCardDetailView) {
            cardDetail
        }
    }
    
    private var cardDetail: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Group {
                Capsule()
                    .fill(.gray.opacity(0.5))
                    .frame(width: 60, height: 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    Spacer()
                    
                    Button {
                        showCardDetailView = false
                    } label: {
                        Text("취소")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
                
                UserHeaderView(user: question.from, date: question.date)
                    .padding(.bottom, 10)
            }
            
            HStack {
                header(font: .headline.bold())
                
                Spacer()
                
                if questionCase != .toMe {
                    bookmarkButton
                    heartButton
                }
                
            }
            
            tags
            
            Divider()
                .padding(.vertical, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(question.pictures, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 260, height: 260)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(8)
                    }
                }
            }
            
            Text(question.text)
                .font(.footnote)
            
            Divider()
                .padding(.top, 56)
                .padding(.vertical, 4)
            
            if let answer = question.answer {
                VStack(alignment: .leading) {
                    UserHeaderView(user: question.to, date: question.date)
                    Text(answer)
                        .font(.footnote)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemGray6))
                )
            }
            
            Spacer()
        }
        .padding(17)
    }
    
    private func header(font: Font = .subheadline) -> some View {
        HStack(spacing: 6) {
            Text("Q.")
            Text(question.title)
                .lineLimit(1)
            
            Spacer()
        }
        .font(font)
    }
    
    private var tags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(question.tags, id: \.self) { tag in
                    TagView(text: tag)
                }
            }
        }
    }
    
    private var main: some View {
        Text(question.text)
            .font(.caption)
            .frame(height: 64)
            .foregroundColor(.gray)
    }
    
    private var footer: some View {
        HStack {
            
            UserHeaderView(user: questionCase == .toMe ? question.from : question.to, date: question.date)
            
            Spacer()
            
            if question.isAnswered {
                
                if questionCase == .byMe {
                    
                    bookmarkButton
                    
                    heartButton
                    
                } else if questionCase == .toMe {
                    
                    answeredLabel
                    
                } else if questionCase == .other {
                    
                    bookmarkButton
                    
                    heartButton
                    
                }
            } else {
                
                if questionCase == .byMe {
                    
                    cancelButton
                    
                } else if questionCase == .toMe {
                    
                    rejectButton
                    
                    answerButton
                    
                }
            }
        }
    }
    
    private var answeredLabel: some View {
        Button {
            showCardDetailView = true
        } label: {
            Label("답변 완료", systemImage: "checkmark.circle.fill")
                .foregroundColor(.orange)
                .font(.headline.bold())
        }
        .buttonStyle(.plain)
    }
    
    private var answerButton: some View {
        Button {
            print("답변")
        } label: {
            Text("답변하기")
                .foregroundColor(.white)
        }
        .buttonStyle(CardButtonStyle(color: .orange))
    }
    
    private var rejectButton: some View {
        Button {
            withAnimation(.spring()) {
                question.isRejected = true
                saveQuestion()
            }
        } label: {
            Text("거절하기")
        }
        .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation(.spring()) {
                question.isRejected = true
                saveQuestion()
            }
        } label: {
            Text("취소하기")
        }
        .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
    }
    
    private var bookmarkButton: some View {
        Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
            .padding(.horizontal, 2)
            .foregroundColor(bookmarked ? .yellow : .primary)
            .onTapGesture {
                withAnimation(.spring()) {
                    if bookmarked {
                        loginUserVM.removeBookmark(question: question)
                    } else {
                        loginUserVM.addBookmark(question: question)
                    }
                }
            }
    }
    
    private var heartButton: some View {
        HStack {
            Image(systemName: hearted ? "heart.fill" : "heart")
                .padding(.horizontal, 2)
            Text("\(question.heartCount)")
        }
        .foregroundColor(hearted ? .red : .primary)
        .onTapGesture {
            withAnimation(.spring()){
                if hearted {
                    let isRemoved = loginUserVM.removeHearted(question: question)
                    if isRemoved {
                        question.heartCount -= 1
                        saveQuestion()
                    }
                } else {
                    loginUserVM.addHearted(question: question)
                    question.heartCount += 1
                    saveQuestion()
                }
            }
        }
    }
    
}

struct UserHeaderView: View {
    
    var user: User
    var date: Date
    
    var body: some View {
        HStack {
            Image(uiImage: user.profilePicture )
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
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.footnote.bold())
                
                Text(date.string())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

extension Date {
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
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
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}



