//
//  FCollectionReference.swift
//  iChat
//
//  Created by Erman Sahin Tatar on 8/7/18.
//  Copyright © 2018 Erman Sahin Tatar. All rights reserved.
//


import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}


