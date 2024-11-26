//
//  NetworkConfigSettingPage.swift
//  Shortcap
//
//  Created by choijunios on 11/26/24.
//

import SwiftUI

import DataSource
import DSKit
import Util

struct NetworkConfigSettingView: View {
    
    @Injected private var networkConfigController: NetworkConfigController
    
    @State private var inputText: String = "http://"
    @State private var presentAlert: Bool = false
    
    private var onSuccess: (() -> ())?
    
    init(onSuccess: (() -> Void)?) {
        
        self.onSuccess = onSuccess
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack(spacing: 5) {
                
                TextField("baseURL 입력", text: $inputText)
                
                Button {
                    
                    self.submitBaseURL()
                    
                } label: {
                    
                    Text("입력")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(DSColors.primary10.swiftUIColor)
                        }
                    
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(DSColors.gray10.swiftUIColor)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            Spacer()
        }
        .alert("BaseURL오류", isPresented: $presentAlert) {
            Button("다시 입력하기") {
                self.inputText = "http://"
            }
        } message: {
            Text("BaseURL이 형식에 어긋납니다.")
        }
    }
    
    private func submitBaseURL() {
        
        do {
            
            try networkConfigController
                .requestChangeBaseURL(baseURL: inputText)
            
            self.onSuccess?()
            
        } catch {
            
            self.presentAlert = true
        }
    }
}

#Preview {
    NetworkConfigSettingView {
        
    }
}
