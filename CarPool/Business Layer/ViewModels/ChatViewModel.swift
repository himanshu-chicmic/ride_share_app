//
//  ChatViewModel.swift
//  CarPool
//
//  Created by Himanshu on 8/10/23.
//

import Foundation
import Combine
import SwiftUI

class ChatViewModel: ObservableObject {
    
    // MARK: instance variables
    
    var baseViewModel = BaseViewModel.shared
    
    private var cancellables: AnyCancellable?
    
    @Published var chatData: [Chat] = []
    @Published var chatDataSingle: Chat?
    @Published var chatMessages: [Message] = []
    
    @Published var openChatView: Bool = false
    @Published var openChatViewFromDetails: Bool = false
    @Published var openChatViewFromPublished: Bool = false
    
    init() {
        createChatApiCall(httpMethod: .GET, requestType: .chatRooms, data: [:])
    }
    
    // MARK: methods
    
    func resetData() {
        chatData = []
        chatMessages = []
    }
    
    func createChatApiCall(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any], chatViewFromDetails: Bool = true) {
        // call createApiRequest in ApiManager class
        cancellables = ApiManager.shared.apiRequestCall(httpMethod: httpMethod, data: data, requestType: requestType)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            // switch completion to handle failure and success
            switch completion {
            case .failure(let error):
                // show failure info in form of toast
                self.baseViewModel.toastMessageBackground = .red
                self.baseViewModel.toastMessage = error.localizedDescription
                print("ERROR: \(error)")
            case .finished:
                // show success info in form of toast
                print("success")
            }
        } receiveValue: { [weak self] response in
            self?.handleChatResponse(response: response, httpMethod: httpMethod, requestType: requestType, data: data, chatViewFromDetails: chatViewFromDetails)
        }
    }
    
    func handleChatResponse(response: ChatData, httpMethod: HttpMethod, requestType: RequestType, data: [String: Any], chatViewFromDetails: Bool) {
        if httpMethod == .GET {
            if requestType == .chatMessages {
                chatMessages = response.messages ?? []
                chatMessages.reverse()
            }
            if requestType == .chatRooms {
                chatData = response.chats ?? []
                chatData.reverse()
            }
        } else {
            if response.code == 422 || response.code == 201, let id = response.chat?.id {
                for chat in chatData {
                    if chat.id == id {
                        chatDataSingle = chat
                        break
                    }
                }
                createChatApiCall(httpMethod: .GET, requestType: .chatMessages, data: ["id": id])
                if chatViewFromDetails {
                    openChatViewFromDetails.toggle()
                } else {
                    openChatViewFromPublished.toggle()
                }
            }
            if requestType == .chatMessages, let id = data[Constants.JsonKeys.id] {
                createChatApiCall(httpMethod: .GET, requestType: .chatMessages, data: ["id": id])
            }
        }
    }
}
