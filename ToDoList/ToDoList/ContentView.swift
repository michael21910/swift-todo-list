//
//  ContentView.swift
//  ToDoList
//
//  Created by Tsuen Hsueh on 2021/9/13.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: ToDoListItem.getAllToDoListItems())
    var items: FetchedResults<ToDoListItem>
    
    @State var text: String = ""
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("New to dos")) {
                    HStack {
                        TextField("Enter new to dos...", text: $text)
                        Button(action: {
                            if !text.isEmpty {
                                let newItem = ToDoListItem(context: context)
                                newItem.name = text
                                newItem.createdAt = Date()
                                
                                do {
                                    try context.save()
                                }
                                catch {
                                    print(error)
                                }
                                text = ""
                            }
                        }, label: {
                            Text("Save")
                        })
                    }
                }
                Section {
                    ForEach(items) { toDoListItem in
                        VStack(alignment: .leading) {
                            Text(toDoListItem.name!).font(.headline)
                            Text("\(toDoListItem.createdAt!)")
                        }
                    }.onDelete(perform: { indexSet in
                        guard let index = indexSet.first else {
                            return
                        }
                        let itemToDelete = items[index]
                        context.delete(itemToDelete)
                        do {
                            try context.save()
                        }
                        catch {
                            print(error)
                        }
                    })
                }
            }
            .navigationTitle("To Do List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
