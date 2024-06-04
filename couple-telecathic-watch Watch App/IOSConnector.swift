//
//  IOSConnector.swift
//  couple-telecathic-watch Watch App
//
//  Created by Liefran Satrio Sim on 04/06/24.
//

import Foundation
import WatchConnectivity

class IOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    func sendMessageToIOS(){
        if session.isReachable{
            session.sendMessage(["data": "Hi gaes"], replyHandler: nil)
        }else{
            print("Session in not reachable")
        }
    }
}
