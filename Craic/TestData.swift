//
//  TestData.swift
//  Craic
//
//  Created by Denis Fortuna on 8/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

class TestData {
    
    private init() {}
    static let shared = TestData()
    var firestore = FirebaseService.shared
 
    let ballet1 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/ballet.jpg?alt=media&token=846d5a3b-28f8-4c80-9531-ecd5875c5c17"
    
    let ballet2 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/ballet2.jpg?alt=media&token=87712ade-cc5e-4952-b52b-38832c0b9367"
    
    let clown1 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/clown.jpeg?alt=media&token=ccf6f6fd-131f-489d-a0a8-1c7207a54135"
    
    let clown2 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/clown3.jpg?alt=media&token=0808fb12-a875-4507-bd08-b220a6a0878c"
    
    let clown3 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/clowns.jpg?alt=media&token=6ca52d05-e60b-4c0f-ace1-f1f674e7902c"
    
    let kids = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/kids.jpeg?alt=media&token=2062b540-65ec-4a5e-906c-6ab20a314686"
    
    let magician = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/magician.jpg?alt=media&token=b09d211f-3d17-4281-9a5c-b9b45fe4e8c8"
    
    let magician2 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/magician.jpg?alt=media&token=b09d211f-3d17-4281-9a5c-b9b45fe4e8c8"
    
    let orchestra = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/orchestra.jpg?alt=media&token=e78be608-c54a-412d-a6db-ad67427e971b"
    
    let orchestra2 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/orchestra2.jpg?alt=media&token=ba141822-1a33-4b4c-9805-bb9794120f07"
    
    let solo = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/orchestra2.jpg?alt=media&token=ba141822-1a33-4b4c-9805-bb9794120f07"
    
    let solo2 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/solo2.jpg?alt=media&token=fd41df9b-aef4-4288-b775-b3cee1e00447"
    
    let solo3 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/solo3.jpg?alt=media&token=1296643a-c3a2-4002-8686-0e8761d46f41"
    
    let standUp = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/standUp.jpg?alt=media&token=9d6fd666-7bf9-4e96-b3d0-232723f22ecc"
    
    let standUp2 = "https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/standUp2.jpg?alt=media&token=ba822add-797a-4c03-894e-4ebdd4d71213"
    
    lazy var pictures = [ ballet1, ballet2, clown1, clown2, clown3, kids, magician, magician2, orchestra, orchestra2, solo, solo2, solo3, standUp, standUp2]
                     
    lazy var venueData: [(id: String, name: String)] = [(id: "1DEBA8E0-EB64-4E17-A889-95B380024502",
                                                         name: "Teatro Leopoldo Fróes"),
                                                        (id: "704EA401-2E77-45B8-8B8E-AC299CBEE140",
                                                         name: "Teatro Arthur Azevedo"),
                                                        (id: "9533EB56-0C7A-4F80-B438-FB2527025BDF",
                                                         name: "hahaha"),
                                                        (id: "A8C4350E-D862-4082-9EBE-D492FF13C7A1",
                                                         name: "Teatro Flávio Império"),
                                                        (id: "E2741B0E-A961-4AE9-A3DA-34D7726B2922",
                                                         name: "Teatro João Caetano"),
                                                        (id: "E8F1C9F5-814A-4DD6-89A0-EDD12AD84179",
                                                         name: "Teatro Paulo Eiró"),
                                                        (id: "F1E1E871-C116-4006-BC3F-EFC67CC0DA69",
                                                         name: "Teatro Cacilda Becker"),
                                                        (id: "F78362A2-AB6B-4472-BD81-B1199E5849A0",
                                                         name: "Teatro Alfredo Mesquita")]
    
    func getEvent(eventID: String, mainPicture: String, hostID: String, eventName: String, hostName: String, eventDate: String, eventNumericDate: Int, eventTime: String) -> [String: AnyObject] {
        let event1 =
            ["id": eventID,
         "name": eventName,
         "images": ["0": mainPicture,
                    "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/reddish.png?alt=media&token=01ac0811-d3cb-40e9-9d71-a83a8a45b6af",
                    "2":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/reddish.png?alt=media&token=01ac0811-d3cb-40e9-9d71-a83a8a45b6af",
                    "3":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/reddish.png?alt=media&token=01ac0811-d3cb-40e9-9d71-a83a8a45b6af",
                    "4":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/reddish.png?alt=media&token=01ac0811-d3cb-40e9-9d71-a83a8a45b6af",
                    "5":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/reddish.png?alt=media&token=01ac0811-d3cb-40e9-9d71-a83a8a45b6af",
            ],
         "category": "Musical",
         "description": "This is just a event test. In hac habitasse platea dictumst. Nulla scelerisque fermentum lorem. Nunc ultricies quam ut felis cursus, in vehicula purus posuere. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed luctus, libero id convallis porttitor, ex nisl varius orci, eget auctor lorem libero sit amet diam. Vivamus consectetur justo vel mollis dapibus.",
         "phone":"1234-5678",
         "address":"Av. Paulista, 1804 - Bela Vista, São Paulo - SP",
         "latitude":"",
         "longitude":"",
         "city":"Sao Paulo",
         "email":"",
         "website":"",
         "hostID": hostID,
         "hostName": hostName,
         "hostProfileImage":"",
         "price": "R$ 100",
         "date": eventDate,
         "numericDate": eventNumericDate,
         "time": eventTime,
         "attendees": 0] as [String : AnyObject]
        
        return event1
    }
    
    func formatEvents() {
        
        let dummyNames = [ "ballet1", "ballet2", "clown1", "clown2", "clown3", "kids", "magician", "magician2", "orchestra", "orchestra2", "solo", "solo2", "solo3", "standUp", "standUp2"]
        
        var formatedEvents = [Event]()
        for picture in pictures {
            let index = pictures.firstIndex(of: picture) as! Int
            let dName = dummyNames[index]
            
            let eventID = UUID().uuidString
            let day = Array(1...30).randomElement()!  //i wanna get notified if this fails
            let month = Array(8...12).randomElement()! //same here ;)
            let dateString = "\(day)-\(month)-2020"
            let dateNumeral = Int("2020\(month)\(day)")! //and here too
            let dummyName = "An awesome night at the \(dName)"
            let eventTime = "\(Array(8...20).randomElement()!)h"
            let hostID = venueData.randomElement()!.id
            let hostName = venueData.randomElement()!.name
            
            let eventData = getEvent(eventID: eventID,
                                 mainPicture: picture,
                                 hostID: hostID,
                                 eventName: dummyName,
                                 hostName: hostName,
                                 eventDate: dateString,
                                 eventNumericDate: dateNumeral,
                                 eventTime: eventTime)
            
            let event = Event(with: eventData)!
            formatedEvents.append(event)
        }
        addEventsToDatabase(events: formatedEvents)
    }
    
    private func addEventsToDatabase(events: [Event]) {
        for event in events {
            firestore.create(for: event, in: .event) { (result) in
                switch result {
                case .success(_):
                    print("Event Add ", event.id, " ", event.name, "******************")
                    self.updateVenue(venueID: event.hostID)
                case .failure(_):
                    print("FAIL ", event.id, " ", event.name, "******************")
                }
            }
        }
    }
    
    private func updateVenue(venueID: String) {
        firestore.updateMergeData(objectID: venueID,
                                  in: .venue,
                                  dataToUpdate: ["hasEvents": true]) { (result) in
                                    switch result {
                                    case .success(_):
                                        print("Venue UPDATED ", venueID, " ", "******************")
                                    case .failure(_):
                                        print("FAIL ", venueID, " ", "******************")
                                    }
        }
    }
    
//VENUES
    //************************************************************************************************************
    //************************************************************************************************************
    //Teatro Alfredo Mesquita
    //Av. Santos Dumont, 1.770, Santana. Zona Norte. | tel. 2221-3657
    //De 1/2 a 1/3. Sexta e sábado, às 21h, domingo, às 19h. Gratuito. 10 anos.
    
    let venue1 =
    ["name": "Teatro Alfredo Mesquita",
     "images": ["0":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Alfredo_Mesquita_cover.jpg?alt=media&token=dd962d68-5e17-4f59-93b6-a5bd804c9f1c",
          "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Alfredo_Mesquita_profile.jpg?alt=media&token=0ee11d87-1e0c-453c-9053-30b96da69ad3"] ,
    "category": "Arts",
    "description": "This Is a Fake Profile.     Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam tristique ornare purus, gravida iaculis nibh hendrerit vel. Sed eu erat in justo rutrum gravida at in lectus.",
    "isFollowing": false,
    "phone": "2221-3657",
    "address": "Av. Santos Dumont, 1.770, Santana. Zona Norte. Sao Paulo, Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "Sexta e sábado, às 21h, domingo, às 19h.",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    
    //Teatro Arthur Azevedo
    //Av. Paes de Barros, 955, Mooca, Zona Leste | tel. Tel. 2605-8007.
    //De 1/2 a 1/3. Sexta e sábado, às 19h. R$ 30. 10 anos.
    
    let venue2 =
    ["name": "Teatro Arthur Azevedo",
     "images": ["0":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Arthur_Azevedo_cover.jpg?alt=media&token=12842204-ceda-438c-9093-afbcb576587e",
          "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Arthur_Azevedo_profile.jpg?alt=media&token=91c3335e-9c0b-4b6c-b4ca-da3a124982a5"] ,
    "category": "Arts",
    "description": """
        This Is a Fake Profile.     Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam tristique ornare purus, gravida iaculis nibh hendrerit vel. Sed eu erat in justo rutrum gravida at in lectus.
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam tristique ornare purus, gravida iaculis nibh hendrerit vel. Sed eu erat in justo rutrum gravida at in lectus.
        """,
    "isFollowing": false,
    "phone": "2605-8007",
    "address": "Av. Paes de Barros, 955, Mooca, Zona Leste. Sao Paulo, Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "Sexta e sábado, às 19h.",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    
    
    //Teatro Cacilda Becker
    // Rua Tito, 295, Lapa. Zona Oeste. | tel. 3864-4513. 4/2. Terça, às 21h. R$ 30 12 anos.
    //https://www.prefeitura.sp.gov.br/cidade/upload/20091021tetaro_cacilda_becker_foto_sylvia_masini_004_1534346119.jpg

    
    let venue3 =
    ["name": "Teatro Cacilda Becker",
     "images": ["0":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Cacilda_Becker_cover.jpg?alt=media&token=c3cc40d6-b584-43dc-82d9-fde16eb9f467",
          "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Cacilda_Becker_profile.jpg?alt=media&token=9a00e0b7-d014-493e-97b3-ed1485305892"] ,
    "category": "Arts",
    "description": """
    This Is a Fake Profile.     Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    """,
    "isFollowing": false,
    "phone": "3864-4513",
    "address": "Rua Tito, 295, Lapa. Zona Oeste. Sao Paulo, Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "Mon - Friday 10:00 to 17:00",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    
    //Teatro Décio de Almeida Prado
    //R. Lopes Neto, 206 - Itaim Bibi. Zona Oeste.| tel. 3079-3438. 7/2. Quinta, às 21h. Gratuito. Livre.
    
    let venue4 =
    ["name": "Teatro Décio de Almeida Prado",
     "images": ["0":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Décio_de_Almeida_Prado_cover.jpg?alt=media&token=f249442d-685e-4958-92d8-6924ce7928be",
          "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Décio_de_Almeida_Prado_profile.jpg?alt=media&token=8ebf0838-25e4-4bc5-883e-24912478a533"] ,
    "category": "Arts",
    "description": """
    This Is a Fake Profile.     Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    """,
    "isFollowing": false,
    "phone": "3079-3438",
    "address": "R. Lopes Neto, 206 - Itaim Bibi. Zona Oeste. Sao Paulo, Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "Mon - Friday 10:00 to 17:00",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    
    //Teatro Flávio Império
    //R. Prof. Alves Pedroso, 600, Cangaiba | Tel. 2621-2719. 28 e 29/2. Sexta e sábado, às 20h. Gratuito. 14 anos.
    
    let venue5 =
    ["name": "Teatro Flávio Império",
     "images": ["0":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Flávio_Império_cover.jpg?alt=media&token=a14ddce1-68bb-4eb5-8a6e-c5fa53f403ee",
          "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Flávio_Império_profile.jpg?alt=media&token=87f04e0d-08d0-4978-9c2c-617916241886"],
    "category": "Arts",
    "description": """
    This Is a Fake Profile.
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    """,
    "isFollowing": false,
    "phone": "2621-2719",
    "address": "R. Prof. Alves Pedroso, 600, Cangaiba. Sao Paulo, Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "Sexta e sábado, às 20h.",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    
    
    //Teatro João Caetano
    //Rua Borges Lagoa, 650, Vila Clementino. Próximo da estação Santa Cruz do metrô. Zona Sul. |
    //tel. 5573-3774 e 5549-1744. De 1 a 16/2. Sábado e domingo, às 19h. R$30. 14 anos

    let venue6 =
    ["name": "Teatro João Caetano",
     "images": ["0":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/João_Caetano_cover.jpg?alt=media&token=9daf59ab-b871-434a-b3b6-6098d432cbc0",
          "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/João_Caetano_profile.jpg?alt=media&token=aa18efd1-15fd-41b2-a272-33d326de23f3"],
    "category": "Arts",
    "description": """
    This Is a Fake Profile.
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum 🕺🕺🕺, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam 🌞.
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, 🍻🍹 nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    """,
    "isFollowing": false,
    "phone": "5573-3774, 5549-1744",
    "address": "Rua Borges Lagoa, 650, Vila Clementino. Zona Sul. Sao Paulo, Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "Sábado e domingo, às 19h",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    
    //Teatro Leopoldo Fróes - sem foto
    //Rua Antonio Bandeira, 114 - Santo Amaro - Sao Paulo, (11) 5541-7057
    
    let venue7 =
    ["name": "Teatro Leopoldo Fróes",
     "images": ["0":"aa"] ,
    "category": "Arts",
    "description": """
    This Is a Fake Profile.
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    """,
    "isFollowing": false,
    "phone": "5541-7057",
    "address": "Rua Antonio Bandeira, 114 - Santo Amaro - Sao Paulo. Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    
    
    //Teatro Paulo Eiró
    // Av. Adolfo Pinheiro, No 765 - Alto da Boa Vista - Santo Amaro, (11) 5686-8440

    let venue8 =
    ["id": "E8F1C9F5-814A-4DD6-89A0-EDD12AD84179",
    "name": "Teatro Paulo Eiró",
     "images": ["0":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Paulo_Eiró_cover.jpg?alt=media&token=b92c33b9-d6b1-4c54-a851-66026ef6c0ba",
          "1":"https://firebasestorage.googleapis.com/v0/b/project4-7d2de.appspot.com/o/Paulo_Eiró_profile.jpg?alt=media&token=18f35de4-0641-4f6a-8a4f-d0c5c5cff59b"] ,
    "category": "Arts",
    "description": """
    This Is a Fake Profile.
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper, odio a vehicula lobortis, purus nunc ultricies dui, sed sollicitudin ipsum erat aliquam metus. Aliquam .
    """,
    "isFollowing": false,
    "phone": "5686-8440",
    "address": "Av. Adolfo Pinheiro, No 765 - Alto da Boa Vista - Santo Amaro, Sao Paulo, Brazil",
    "latitude": "",
    "longitude": "",
    "city": "Sao Paulo",
    "email": "",
    "website": "",
    "openingHours": "Mon - Friday 10:00 to 17:00",
    "hasEvents": false,
    "hasFollowers": false] as [String : AnyObject]
    //************************************************************************************************************
    //************************************************************************************************************
    func text() {
            guard let venueAA = Venue(with: venue8) else {
                print("iii saiu dinovo")
                return
            }
            firestore.create(for: venueAA,
                            in: .venue) { (result) in
                                switch result {
                                case .success(_):
                                    print("fooooi ", venueAA.name," ", venueAA.id)
                                case .failure(_):
                                    print("deu merda .... ", venueAA.name)
                                }
            }
    }
}
