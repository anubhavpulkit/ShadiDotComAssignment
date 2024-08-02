//
//  UserViewModel.swift
//  ShadiDotComAssignment
//
//  Created by Anubhav Singh on 29/07/24.
//

import Foundation
import CoreData
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var acceptedUsers: [User] = []
    @Published var rejectedUsers: [User] = []
    private var cancellables = Set<AnyCancellable>()
    private let persistenceController = PersistenceController.shared
    private let serverURL = "https://yourserver.com/api/syncUsers"

    init() {
        fetchUsers()
        loadStoredUsers()
    }

    func fetchUsers() {
        guard let url = URL(string: "https://randomuser.me/api/?results=10") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching users: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                self.users = response.results
                self.saveUsersToLocalDatabase(response.results)
            })
            .store(in: &cancellables)
    }

    func loadStoredUsers() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            let loadedUsers = results.map { User(from: $0) }
            self.users = loadedUsers
            self.acceptedUsers = loadedUsers.filter { $0.status == "Member Accepted" }
            self.rejectedUsers = loadedUsers.filter { $0.status == "Member Declined" }
        } catch {
            print("Failed to fetch stored users: \(error)")
        }
    }

    private func saveUsersToLocalDatabase(_ users: [User]) {
        let context = persistenceController.container.viewContext
        users.forEach { user in
            let userEntity = UserEntity(context: context)
            userEntity.id = user.id
            userEntity.status = user.status ?? ""
        }

        do {
            try context.save()
        } catch {
            print("Failed to save users: \(error)")
        }
    }

    func acceptUser(_ user: User) {
        updateStatus(for: user, with: "Member Accepted")
    }

    func declineUser(_ user: User) {
        updateStatus(for: user, with: "Member Declined")
    }

    private func updateStatus(for user: User, with status: String) {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", user.id)

        do {
            let results = try context.fetch(fetchRequest)
            let userEntity: UserEntity
            if let existingUser = results.first {
                userEntity = existingUser
            } else {
                userEntity = UserEntity(context: context)
                userEntity.id = user.id
            }
            userEntity.status = status
            userEntity.nameFirst = user.name.first
            userEntity.gender = user.gender
            userEntity.pictureLarge = user.picture.large
            userEntity.dobAge = Int16(user.dob.age)
            userEntity.phoneNum = user.phone

            try context.save()

            if let index = users.firstIndex(where: { $0.id == user.id }) {
                users[index].status = status
                if status == "Member Accepted" {
                    acceptedUsers.append(users[index])
                } else {
                    rejectedUsers.append(users[index])
                }
            }
        } catch {
            print("Failed to update user status: \(error)")
        }
    }

    func syncData() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status != %@", "")

        do {
            let unsyncedUsers = try context.fetch(fetchRequest)
            let usersToSync = unsyncedUsers.map { userEntity in
                [
                    "id": userEntity.id ?? "",
                    "status": userEntity.status ?? ""
                ]
            }
            guard !usersToSync.isEmpty else {
                return
            }

            guard let url = URL(string: serverURL) else {
                print("Invalid server URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonData = try JSONSerialization.data(withJSONObject: usersToSync, options: [])
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error syncing data: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received from server")
                    return
                }

                do {
                    if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let success = responseJSON["success"] as? Bool, success {
                        self.markUsersAsSynced(unsyncedUsers)
                    } else {
                        print("Failed to sync data with server")
                    }
                } catch {
                    print("Failed to parse server response: \(error.localizedDescription)")
                }
            }.resume()

        } catch {
            print("Failed to fetch unsynced users: \(error)")
        }
    }

    private func markUsersAsSynced(_ users: [UserEntity]) {
        let context = persistenceController.container.viewContext

        users.forEach { userEntity in
            userEntity.status = "Synced"
        }

        do {
            try context.save()
        } catch {
            print("Failed to mark users as synced: \(error)")
        }
    }
}
