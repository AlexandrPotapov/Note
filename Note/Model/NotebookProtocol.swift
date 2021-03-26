import Foundation

protocol Notebook {
    func getList() -> [Note]
    func add(_ note: Note)
    func remove(with uid: String)
    func update(by notes: [Note])
    func save()
    func load()
}
