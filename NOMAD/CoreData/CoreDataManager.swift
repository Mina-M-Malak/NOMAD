//
//  CoreDataManager.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import CoreData

class CoreDataManager{
    
    public static let shared : CoreDataManager = CoreDataManager()
    
    private init(){}
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NOMAD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context : NSManagedObjectContext!{
        return persistentContainer.viewContext
    }
    
    //MARK:- Save CoreData
    private func saveContext(){
        if context.hasChanges{
            do{
                try context.save()
            }
            catch let error{
                print("Can't save context:",error)
            }
        }
    }
    
    //MARK:- Delete CoreData
     func delete(_ obj: NSManagedObject?) {
        guard let deleteObjc = obj else { return }
        context.delete(deleteObjc)
        print("Deleted Succesed")
        saveContext()
    }
    
    func delete(_ obj: [NSManagedObject]?) {
        guard let deleteObjc = obj else { return }
        deleteObjc.forEach({context.delete($0)})
        print("Deleted Succesed")
        saveContext()
    }
    
    //MARK:- Add Item
    func addProductToCart(product: Product){
        guard !editCartItem(product: product) else { return }
        let productCD: ProductCD! = NSEntityDescription.insertNewObject(forEntityName: "ProductCD", into: context) as? ProductCD
        
        productCD.id = product.id
        productCD.name = product.name
        productCD.desc = product.description
        productCD.image = product.image
        productCD.barcode = product.barcode
        productCD.price = product.retailPrice
        productCD.quantity = Int16(product.quantity ?? 1)
        
        saveContext()
    }
    
    //MARK:- Get Items
    func getCartItems()->([Product]?,[ProductCD]?){
        do{
            if let items = try context.fetch(ProductCD.fetchRequest()) as? [ProductCD]{
                var cartItems: [Product] = []
                for item in items{
                    let cartItem = Product(id: item.id ?? "", name: item.name ?? "", description: item.desc ?? "", image: item.image ?? "", barcode: item.barcode ?? "", retailPrice: item.price , quantity: Int(item.quantity))
                    cartItems.append(cartItem)
                }
                return (cartItems,items)
            }
            return (nil,nil)
        }
        catch let error{
            
            print("Can't Get items",error)
            return (nil,nil)
        }
    }
    
    //MARK:- Edit Item
    func editCartItem(product: Product,isPlus: Bool = true) -> Bool{
        let products = getCartItems().1
        guard let item = products?.first(where: {$0.id == product.id}) else { return false }
        if isPlus{
            item.quantity += 1
        }
        else{
            item.quantity -= 1
        }
        saveContext()
        return true
    }
    
    //MARK:- Delete Items From CoreData
    func removeProduct(product: Product){
        do{
            let items = try context.fetch(ProductCD.fetchRequest()) as! [ProductCD]
            delete(items.filter({$0.id == product.id}))
        }
        catch let err {
            print("Error on creating/updating order", err)
            return
        }
    }
    
    //MARK:- Delete Items From CoreData
    func removeAllItems(){
        do{
            let items = try context.fetch(ProductCD.fetchRequest()) as! [ProductCD]
            delete(items)
        }
        catch let err {
            print("Error on creating/updating order", err)
            return
        }
    }
}
