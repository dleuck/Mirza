//
//  View+.swift
//  
//
//  Created by Daniel Leuck on 2023/03/12.
//

import SwiftUI

public extension View {
    func hspace(_ size: Double) -> some View { Spacer().frame(width: size) }
    func vspace(_ size: Double) -> some View { Spacer().frame(height: size) }
    
    #if(iOS)
    func detectOrientation(_ orientation: Binding<UIDeviceOrientation>) -> some View {
        modifier(DetectOrientation(orientation: orientation))
    }
    #endif
    
    var isPad: Bool {
        #if(iOS)
            return UIDevice.current.userInterfaceIdiom == .pad
        #else
            return false
        #endif
    }
    
    var isPhone: Bool {
        #if(iOS)
            return UIDevice.current.userInterfaceIdiom == .phone
        #else
            return false
        #endif
    }
    
    var isMac: Bool {
        return (!isPad && !isPhone) ? true : false
    }
}


