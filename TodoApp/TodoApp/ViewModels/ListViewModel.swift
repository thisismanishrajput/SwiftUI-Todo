//
//  ListViewModel.swift
//  TodoApp
//
//  Created by ankur jain on 06/04/23.
//

import Foundation

class ListViewModel:ObservableObject {
    @Published var items: [ItemModel] = []{
        didSet {
            saveItems()
        }
    }
        
    let itemKey: String  = "items_list"
    
    init(){
        getItems()
    }
    
    func getItems(){
        guard let data = UserDefaults.standard.data(forKey: itemKey)else {return}
        guard  let savedItems = try? JSONDecoder().decode([ItemModel].self, from:data)else {return}
        self.items = savedItems
    }
    
    func deleteItem(indexSet: IndexSet){
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(indexSet: IndexSet, to: Int){
        items.move(fromOffsets: indexSet, toOffset: to)
    }
    
    func addItem(title:String){
        let newItem = ItemModel(title: title, isCompleted: false)
        items.append(newItem)
    }
    
    func updateItem (item: ItemModel){
       if let index = items.firstIndex(where:{ $0.id == item.id}){
           items[index] = item.updateCompletion()
        }
    }
    
    func saveItems() {
        let defaults = UserDefaults.standard
        
        if let encodedData = try? JSONEncoder().encode(items){
            defaults.self.set(encodedData, forKey: itemKey)
        }
    }
}
