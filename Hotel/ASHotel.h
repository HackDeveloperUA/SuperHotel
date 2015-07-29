//
//  ASHotel.h
//  Hotel
//
//  Created by MD on 29.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASHotel : NSObject

@property (assign,nonatomic) double identifier;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* address;

@property (assign,nonatomic) double stars;
@property (assign,nonatomic) double distance;

//@property (strong,nonatomic) NSString* suitesAvailabilityString;
@property (strong,nonatomic) NSArray*  suitesAvailabilityArray;



@end
/*
 "id": 40611,
 "name": "Belleclaire Hotel",
 "address": "250 West 77th Street, Manhattan",
 "stars": 3.0,
 "distance": 100.0,
 "suites_availability": "1:44:21:87:99:34"

*/