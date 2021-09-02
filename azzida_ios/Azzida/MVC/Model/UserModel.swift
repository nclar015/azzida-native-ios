//
//  UserModel.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 17/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class UserModel : NSObject{
    
    var Id = 0
    var FirstName = ""
    var LastName = ""
    var UserPassword = ""
    var UserEmail = ""
    var Skills = ""
    var DeviceId = ""
    var DeviceType = ""
    var GoogleEmail = ""
    var FaceBookEmail = ""
    var CreatedDate = ""
    var ModifyDate = ""
    var IsActive = ""
    var RoleId = 0
    var ProfilePicture = ""
    var EmailType = ""
    var UserName = ""
    var Image = UIImage()
    var UserRatingAvg = Double()
    var Balance = 0
    var RefCode = ""
    var accountNumber = ""
    var ListerJobData = JSON()
    
    var FilterDistance = 0
    var FilterPrice = 0
    var FilterMaxPrice = ""
    var FilterMinPrice = ""
    var receivedAmount = 0.0
    var azzidaVerified = false
    var reportStatus = ""
    var FilterCategory : [String] = []
    
    var JobTypeProfile = ""
    var JobType = ""
    var JobTypeCategory = ""
    
    var currantlat: CLLocationDegrees!
    var currantlong:CLLocationDegrees!

    var CategoryArr : [String] = []

    var DisputeImage = UIImage()
    var DisputeAmount = ""
    var DisputeJobId = 0
    var DisputeReason = ""
    var DisputePostAssociate = ""
    var DisputeDescription = ""
    
    var ManuallyLocation = ""
    var ManuallyLocationTop = ""
    
    var UserMainActivity = ""
    var UserMainActivityVC = UIViewController()
    var stripeAccId = ""
    var nationalStatus = ""
    var globalStatus = ""
    var sexOffenderStatus = ""
    var ssnTraceStatus = ""
    var candidateId = ""
    var photoDelete = "false"
    var provider = ""
    static  let userModel : UserModel = UserModel()
    
}


