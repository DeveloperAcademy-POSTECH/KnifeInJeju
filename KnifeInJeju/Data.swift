//
//  Question.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/07.
//

import Foundation
import SwiftUI

struct Question: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var text: String
    var picturesData: [Data] = []
    var from: User
    var to: User
    var date: Date
    var answer: String?
    var isRejected = false
    var heartCount = 0
    var tags: [String]
    
    var isAnswered: Bool {
        return answer != nil
    }
    
    var pictures: [UIImage] {
        get {
            picturesData.map{ UIImage(data: $0) ?? UIImage() }
        } set {
            picturesData = newValue.map{ $0.getData() }
        }
    }
    
    init(title: String, text: String, picture: [UIImage], from: User, to: User, tags: [String] ) {
        self.title = title
        self.text = text
        self.picturesData = picture.map { $0.getData() }
        self.from = from
        self.to = to
        self.date = Date()
        self.tags = tags
    }
    
    // 더미 데이터용 init ( 하트 수와 질문 날짜를 해당 객체를 만들 때 지정해주기 위해 )
    init(title: String, text: String, from: User, to: User, date: Date, answer: String? = nil, heartCount: Int, tags: [String]) {
        self.title = title
        self.text = text
        self.from = from
        self.to = to
        self.date = date
        self.answer = answer
        self.heartCount = heartCount
        self.tags = tags
    }
}

struct User: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    private var profilePictureData: Data?
    var roleModels: [User] = []
    var links: [String] = []
    var tags: [String] = []
    var introduction: String?
    var questions: [Question] = []
    var bookmarkedQuestions: [Question] = []
    var heartedQuestions: [Question] = []
    
    var profilePicture: UIImage {
        get {
            UIImage(data: profilePictureData ?? Data()) ?? UIImage()
        } set {
            profilePictureData = newValue.getData()
        }
    }
}

extension Question {
    static let dummyData = [
        
        Question(title: "미술 입시 어떻게 하셨어요?",
                 text: "저는 미술을 꿈꾸고 있는 중학교 2학년이에요!. 지방에 거주하고 있는지라 미술관련 정보를 얻기 힘들고 대다수가 수도권에 있는 친구들에게 해당할 법한 이야기라 공감하기가 쉽지 않네요..",
                 from: User.dummyData[1],
                 to: User.dummyLoginUserData,
                 date: Date(),
                 heartCount: 24,
                 tags: ["study", "university"]),
        
        Question(title: "영감은 보통 어떻게 받으시나요?",
                 text: "평소에 OO님의 작품활동을 정말 즐겁게 보고 있습니다. 다름이 아니라 저도 예술 관련 직종에서 일하고 있는데 영감을 떠올리기가 보통 어려운게 아니더라고요.. 그래서 비교적 다작하시는 분의 생각이나 작품에 임하는 마인드에 대해 여쭤보고 싶다는 생각이 들었습니다.",
                 from: User.dummyData[3],
                 to: User.dummyLoginUserData,
                 date: Date(),
                 heartCount: 12,
                 tags: ["study", "art"]),
        
        Question(title: "대학생활은 어떠신가요?",
                 text: "저도 곧 선배님과 같은 학교에 들어가게 될 고등학교 3학년이에요. 다가올 학교생활에 대한 기대가 커서 빨리 다양한 학교 정보에 대해 알고 싶어요.. 혹시 대학생활 하시면서 이건 꼭 알아야 한다라는 꿀팁같은 게 있으면 공유해주실 수 있으실까요??",
                 from: User.dummyData[0],
                 to: User.dummyLoginUserData,
                 date: Date(),
                 answer: "저희 학교의 경우 다채로운 동아리가 강점이에요. 학교에 들어오시게 되면 여러 가지 동아리를 체험해볼 수 있는 2주간의 기간이 주어지는 데 편하게 선배들 눈치보지 말고 다양한 활동을 체험해 보면서 앞으로 있을 대학생활을 그려보세요",
                 heartCount: 4,
                 tags: ["university"]),
        
        Question(title: "미술쪽으로 진로를 변경해보고 싶은데 용기가 안나요",
                 text: "저도 OO님처럼 나만의 창작세계를 펼쳐보고 싶다는 동경이 있어요.. 그치만 현실적으로 어려운 가정환경이나 지금까지 배워온 것들을 버리고 새로운 길로 가야한다는 생각에 두려움이 강한데 이겨낼 수 있는 방법이 있을까요??",
                 from: User.dummyData[2],
                 to: User.dummyLoginUserData,
                 date: Date(),
                 heartCount: 0,
                 tags: ["art", "mind"]),
        
        Question(title: "장미 허브에 진드기가 났는데 어떻게 하는게 좋을까요?",
                 text: "평소에 유튜브로 식물관련해서 좋은 정보 많이 챙겨가고 있는 한 구독자에요. 다름이 아니라 제가 키우는 장미 허브에 진드기가 일주일 전부터 생기기 시작했어요.. 일일히 제거한다든가 햇빛이 잘 드는 자리에 두어봤는데도 완전히 제거하는 게 쉽지 않네요.. 지지난번에 올리신 브이로그에서 진드기로 곤역을 겪으신 적이 있다는 경험을 말씀하신게 떠올라서 질문드려요.",
                 from: User.dummyLoginUserData,
                 to: User.dummyData[0],
                 date: Date(),
                 answer: "잎진드기가 심각하게 번식한 잎사귀, 줄기, 가지 등은 즉시 제거하세요. 식물에서 떨어진 낙엽을 줍고 심각하게 손상된 잎사귀는 제거하세요. 근처에 있는 식물들에게 잎진드기가 옮는 걸 방지할 수 있습니다. 제거한 잎사귀와 낙엽은 비닐봉투에 넣은 후 밀봉해서 쓰레기통에 버리거나 불에 태우세요.",
                 heartCount: 14,
                 tags: ["plant"]),
        
        Question(title: "영어 공부를 위한 미드 좀 추천해주세요!",
                 text: "유튜브에서 본 인터뷰로는 정말로 미드를 통해서 영어 회화 실력을 올린게 사실인가요??? 그렇다면 어떤 미드가 좋을 지 추천해주실 수 있으실까요..?",
                 from: User.dummyLoginUserData,
                 to: User.dummyData[3],
                 date: Date(),
                 answer: "<프렌즈> <셜록> <그레이 아나토미>는 미드로 영어 공부하는 이들에게 유용하기로 꽤 유명하죠. 제가 영어 공부를 하면서 한창 불꽃을 태우며 몰입했던 작품은 바로 <위기의 주부들>이에요. 내용도 재미있고 일상에서 자주 사용하는 말이 많이 나와 도움이 됐죠.",
                 heartCount: 6,
                 tags: ["English","Drama"]),
        
        Question(title: "협업에 관하여 궁금한게 있어요",
                 text: "그동안 개인전만 열다 이번에 처음으로 단체전을 열게 된 인디 작가입니다. 나름대로 타인들에게 조언을 해줄 수 있을만큼 성장했다고 생각했는데 다양한 사람들과 의견공유를 하며 새로운 작품을 만들어나가는게 쉽지 않네요.. 전문적인 팀을 꾸려서 큰 프로젝트를 여러번 진행해오신 OO님에게 조언을 듣고 싶어 질문 남겨봐요",
                 from: User.dummyLoginUserData,
                 to: User.dummyData[1],
                 date: Date(),
                 heartCount: 0,
                 tags: ["art", "mind"]),
        
        Question(title: "어떤 전등을 쓰고 계신가요??",
                 text: "어제 출연하신 예능 잘 봤어요! 집들이 하실 때 파란색 전등이 되게 예뻐서 기억에 남아서 질문 드려봐요.. 혹시 어떤 모델인지 알려주실 수 있으신가요??",
                 from: User.dummyLoginUserData,
                 to: User.dummyData[2],
                 date: Date(),
                 heartCount: 6,
                 tags: ["interior"])
    ]
}

extension User {
    static let dummyLoginUserData = User(name: "seoyeon Gang")
    
    static let dummyData = [
            User(name: "Cho"),
            User(name: "hojong Kang"),
            User(name: "sohi Han"),
            User(name: "Minju Lee")
    ]
}

public class Storage {
    
    static let databaseAllQuestionURL = "Database_All_Questions.json"
    static let loginUserURL = "LoginUser.json"
    
    private init() { }
    
    enum Directory {
        case documents
        case caches
        
        var url: URL {
            let path: FileManager.SearchPathDirectory
            switch self {
            case .documents:
                path = .documentDirectory
            case .caches:
                path = .cachesDirectory
            }
            return FileManager.default.urls(for: path, in: .userDomainMask).first!
        }
    }
    
    static func store<T: Encodable>(_ obj: T, to directory: Directory, as fileName: String) {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        print("---> save to here: \(url)")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(obj)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch let error {
            print("---> Failed to store msg: \(error.localizedDescription)")
        }
    }
    
    static func retrive<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print("---> Failed to decode msg: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func remove(_ fileName: String, from directory: Directory) {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("---> Failed to remove msg: \(error.localizedDescription)")
        }
    }
    
    static func clear(_ directory: Directory) {
        let url = directory.url
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for content in contents {
                try FileManager.default.removeItem(at: content)
            }
        } catch {
            print("---> Failed to clear directory ms: \(error.localizedDescription)")
        }
    }
}

extension UIImage {
    func getData() -> Data {
        guard let data: Data = self.jpegData(compressionQuality: 0.5) ?? self.pngData() else { return Data() }
        return data
    }
}
