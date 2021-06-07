//import Foundation
//
//final class CallStation {
//    var userList: Set<User> = []
//    var callsList: [Call] = []
//    var usersCallsList: Dictionary<User, Array<Call>>  = [:]
//}
//
//extension User: Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//extension CallStation: Station {
//    func users() -> [User] {
//        Array(userList)
//    }
//
//    func add(user: User) {
//        userList.insert(user)
//    }
//
//    func remove(user: User) {
////        self.userList = self.userList.filter{ $0 != user }
//        userList.remove(user)
//    }
//
//    func execute(action: CallAction) -> CallID? {
//        switch action {
//
//        case let .start(from: transmitter, to: reciever):
//
//            if !userList.contains(transmitter) {
//                return nil
//            }
//
//            if !userList.contains(reciever) {
//                let call = Call(id: transmitter.id, incomingUser: reciever, outgoingUser: transmitter, status: .ended(reason: .error))
//                callsList.append(call)
//
//                usersCallsList[call.incomingUser]?.append(call)
//                usersCallsList[call.outgoingUser]?.append(call)
//
//                return call.id
//            }
//
//            if currentCall(user: transmitter) != nil {
//                let call = Call(id: transmitter.id, incomingUser: reciever, outgoingUser: transmitter, status: .ended(reason: .userBusy))
//                callsList.append(call)
//
//                usersCallsList[call.incomingUser]?.append(call)
//                usersCallsList[call.outgoingUser]?.append(call)
//
//                return call.id
//            }
//
//            if transmitter.id != reciever.id {
//                let call = Call(id: transmitter.id, incomingUser: reciever, outgoingUser: transmitter, status: .calling)
//                callsList.append(call)
//
//                usersCallsList[call.incomingUser]?.append(call)
//                usersCallsList[call.outgoingUser]?.append(call)
//
//                return call.id
//            }
//        case let .answer(from: transmitter):
//
//            let incomingCall = currentCall(user: transmitter)
//            if incomingCall != nil {
//
//                if users().contains(transmitter) {
//                    let call = Call(id: incomingCall?.id ?? transmitter.id, incomingUser: transmitter, outgoingUser: incomingCall?.outgoingUser ?? transmitter, status: .talk)
//                    callsList.removeFirst()
//                    callsList.append(call)
//                    return call.id
//                } else {
//                    let call = Call(id: incomingCall?.id ?? transmitter.id, incomingUser: transmitter, outgoingUser: incomingCall?.outgoingUser ?? transmitter, status: .ended(reason: .error))
//                    callsList.removeFirst()
//                    callsList.append(call)
//                    return nil
//                }
//            }
//
//        case let .end(from: transmitter):
//
//            let incomingCall = currentCall(user: transmitter)
//            if incomingCall != nil {
//                if incomingCall?.status == CallStatus.talk {
//                    let call = Call(id: incomingCall?.id ?? transmitter.id, incomingUser: transmitter, outgoingUser: incomingCall?.outgoingUser ?? transmitter, status: .ended(reason: .end))
//                    callsList.removeFirst()
//                    callsList.append(call)
//
//                    return call.id
//                }
//
//                if incomingCall?.status == CallStatus.calling {
//                    let call = Call(id: incomingCall?.id ?? transmitter.id, incomingUser: transmitter, outgoingUser: incomingCall?.outgoingUser ?? transmitter, status: .ended(reason: .cancel))
//                    callsList.removeFirst()
//                    callsList.append(call)
//
//                    return call.id
//                }
//            }
//        }
//        return nil
//    }
//
//    func calls() -> [Call] {
//        callsList
//    }
//
//    func calls(user: User) -> [Call] {
//        if usersCallsList[user] != nil {
//            let arr = usersCallsList[user]!
//            return arr
//        }
//        return []
//    }
//
//    func call(id: CallID) -> Call? {
//        for (index, call) in callsList.enumerated() {
//               if id == call.id   {
//                   callsList.remove(at: index)
//                   return call
//               }
//           }
//           return nil
//    }
//
//    func currentCall(user: User) -> Call? {
//        for (index, call) in callsList.enumerated() {
//            if call.status == CallStatus.ended(reason: .end) ||
//                call.status == CallStatus.ended(reason: .error) {
//                callsList.remove(at: index)
//                break
//            }
//
//            if call.status == CallStatus.ended(reason: .cancel)   {
//                callsList.remove(at: index)
//                break
//            }
//
//            if call.outgoingUser == user || call.incomingUser == user {
//                return call
//            }
//        }
//        return nil
//    }
//}

import Foundation

final class CallStation {
    var usersList: [User] = []
    var callsList: [Call] = []
    var currentCalls: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return self.usersList
    }
    
    func add(user: User) {
        if !self.usersList.contains(user) {
            self.usersList.append(user)
        }
    }
    
    func remove(user: User) {
        if let index = self.usersList.firstIndex(of: user) {
            self.usersList.remove(at: index)
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(from, to):
            var call: Call! = nil
            
            if !self.usersList.contains(from) && !self.usersList.contains(to) {
                return nil
            } else if !self.usersList.contains(from) || !self.usersList.contains(to) {
                call = Call(id: UUID(), incomingUser: to, outgoingUser: from, status: .ended(reason: .error))
            } else if self.currentCalls.contains(where: {$0.incomingUser == from || $0.incomingUser == to || $0.outgoingUser == from || $0.outgoingUser == to}) {
                call = Call(id: UUID(), incomingUser: to, outgoingUser: from, status: .ended(reason: .userBusy))
            } else {
                call = Call(id: UUID(), incomingUser: to, outgoingUser: from, status: .calling)
                self.currentCalls.append(call)
            }

            self.callsList.append(call)
            return call.id
            
        case let .answer(from):
            for call in self.currentCalls {
                if call.incomingUser == from {
                    var newCall: Call! = nil
                    
                    newCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .talk)
                    
                    if let index = self.currentCalls.firstIndex(where: {$0.id == call.id}) {
                        if !self.users().contains(call.incomingUser) || !self.users().contains(call.outgoingUser) {
                            self.currentCalls.remove(at: index)
                        } else {
                            self.currentCalls[index] = newCall
                        }
                    }
                    if let index = self.callsList.firstIndex(where: {$0.id == call.id}) {
                        if !self.users().contains(call.incomingUser) || !self.users().contains(call.outgoingUser) {
                            newCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
                            self.callsList[index] = newCall
                            return nil
                        } else {
                            self.callsList[index] = newCall
                            return newCall.id
                        }
                    }
                }
            }
            return nil
        case let .end(from):
            if let call = self.currentCall(user: from) {
                var newReason: CallEndReason! = nil
                
                if call.status == .calling {
                    newReason = .cancel
                } else {
                    newReason = .end
                }
                
                let newCall: Call = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: newReason))
                
                if let index = self.currentCalls.firstIndex(where: {$0.id == call.id}) {
                    self.currentCalls.remove(at: index)
                }
                if let index = self.callsList.firstIndex(where: {$0.id == call.id}) {
                    self.callsList[index] = newCall
                }
                return newCall.id
            }
        }
        return nil
    }
    
    func calls() -> [Call] {
        return self.callsList
    }
    
    func calls(user: User) -> [Call] {
        var result: [Call] = []
        for call in self.callsList {
            if call.incomingUser == user || call.outgoingUser == user {
                result.append(call)
            }
        }
        return result
    }
    
    func call(id: CallID) -> Call? {
        for call in self.callsList {
            if call.id == id {
                return call
            }
        }
        return nil
    }
    
    func currentCall(user: User) -> Call? {
        for call in self.currentCalls {
            if call.incomingUser == user || call.outgoingUser == user {
                return call
            }
        }
        return nil
    }
}
