import CoreData

extension NSEntityDescription {
    
    static let SyncIsAlwaysCompleteObjectKey:String = "sync.isAlwaysCompleteObject"
    static let SyncIsAlwaysCompleteObjectKeyValue = "YES";
    static let SyncIsAlwaysCompleteObjectKeyAlternativeValue = "true";

    
    /**
     Finds the relationships for the current entity.
     - returns The list of relationships for the current entity.
     */
    func sync_relationships() -> [NSRelationshipDescription] {
        var relationships = [NSRelationshipDescription]()
        for propertyDescription in properties {
            if let relationshipDescription = propertyDescription as? NSRelationshipDescription {
                relationships.append(relationshipDescription)
            }
        }

        return relationships
    }

    /// Finds the attributes for the current entity.
    ///
    /// - Returns: An array of attributes for the current entity.
    func sync_attributes() -> [NSAttributeDescription] {
        var attributes = [NSAttributeDescription]()
        for propertyDescription in properties {
            if let attributeDescription = propertyDescription as? NSAttributeDescription {
                attributes.append(attributeDescription)
            }
        }

        return attributes
    }

    /**
     Finds the parent for the current entity, if there are many parents nil will be returned.
     - returns The parent relationship for the current entity
     */
    func sync_parentEntity() -> NSRelationshipDescription? {
        return sync_relationships().filter { $0.destinationEntity?.name == name && !$0.isToMany }.first
    }
    
    /**
    Looks for the isAlwaysCompleteObject flag on the current entity.
     A complete object is an object that is ALWAYS fully represented in the JSON dictionary.
     This means that parameters that are nil (not the JSON object NULL) are treated as parameters that are empty.
     These parameters will be set to nil in CoreData for this object.
    - returns The value of sync.isAlwaysCompleteObject from userInfo
    */
    var isAlwaysCompleteObject: Bool {
        get {
            let value = self.userInfo?[NSEntityDescription.SyncIsAlwaysCompleteObjectKey] as? String
            
            let isAlwaysCompleteObject = (value != nil &&
                (value == NSEntityDescription.SyncIsAlwaysCompleteObjectKeyValue || value == NSEntityDescription.SyncIsAlwaysCompleteObjectKeyAlternativeValue))
            
            return isAlwaysCompleteObject
        }
    }
    
}
