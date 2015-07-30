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

@property (strong,nonatomic) NSString* imageString;
@property (strong,nonatomic) NSArray*  suitesAvailabilityArray;



@end
