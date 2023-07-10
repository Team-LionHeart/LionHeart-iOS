//
//  Font.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/10.
//

import UIKit

public enum Font {
    
    public enum PretendardType {
        case head1, head2, head3, head4, subHead1, subHead2, title1, title2, body1, body2M, body2R, body3M, body3R, body4, body5B, body5M, caption
        
        var Wight: Font.Weight {
            switch self {
            case .body5B: return ._700
            case .head1, .head2, .head3, .head4, .title1, .title2: return ._600
            case .subHead2, .body1, .body2M, .body3M, .body5M, .caption: return ._500
            case .subHead1, .body2R, .body3R, .body4: return ._400
            }
        }
        
        var Size: CGFloat {
            switch self {
            case .head1: return Font.Size._28.rawValue
            case .head2: return Font.Size._24.rawValue
            case .head3, .body1: return Font.Size._20.rawValue
            case .head4, .subHead1: return Font.Size._18.rawValue
            case .subHead2, .title1, .body2M, .body2R: return Font.Size._16.rawValue
            case .title2, .body3M, .body3R: return Font.Size._14.rawValue
            case .body4: return Font.Size._12.rawValue
            case .body5B, .body5M: return Font.Size._9.rawValue
            case .caption: return Font.Size._8.rawValue
                
            }
        }
    }
    
    public enum Name: String {
        case pretendard = "Pretendard"
    }
    
    public enum Size: CGFloat {
        case _8 = 8
        case _9 = 9
        case _12 = 12
        case _14 = 14
        case _16 = 16
        case _18 = 18
        case _20 = 20
        case _24 = 24
        case _28 = 28
    }

    public enum Weight: String {
        case _400 = "Regular"
        case _500 = "Medium"
        case _600 = "SemiBold"
        case _700 = "Bold"

        var real: UIFont.Weight {
            switch self {
            case ._400:
                return .regular
            case ._500:
                return .medium
            case ._600:
                return .semibold
            case ._700:
                return .bold
            }
        }
    }

    public struct PretendardFont {
        private let _name: Name
        private let _weight: Weight

        init(name: Name, weight: Weight) {
            self._name = name
            self._weight = weight
        }

        var name: String {
            "\(_name.rawValue)-\(_weight.rawValue)"
        }

        var `extension`: String {
            "ttf"
        }
    }
    

    public static func registerFonts() {
        pretendardFonts.forEach { font in
            Font.registerFont(fontName: font.name, fontExtension: font.extension)
        }
    }
}

extension Font {
    static var pretendardFonts: [PretendardFont] {
        [
            PretendardFont(name: .pretendard, weight: ._400),
            PretendardFont(name: .pretendard, weight: ._500),
            PretendardFont(name: .pretendard, weight: ._600),
            PretendardFont(name: .pretendard, weight: ._700)
        ]
    }

   static func registerFont(fontName: String, fontExtension: String) {
        guard let fontURL = Bundle(identifier: "com.Lionheart.LionHeart-iOS")?.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            debugPrint("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
            return
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

