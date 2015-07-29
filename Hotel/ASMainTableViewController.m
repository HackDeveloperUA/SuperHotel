//
//  ASMainTableViewController.m
//  Hotel
//
//  Created by MD on 29.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASMainTableViewController.h"
#import "ASHotel.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ASMainTableViewController ()

@end

@implementation ASMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self simpleJsonParsing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 @property (assign,nonatomic) double id;
 @property (strong,nonatomic) NSString* name;
 @property (strong,nonatomic) NSString* address;
 
 @property (assign,nonatomic) double stars;
 @property (assign,nonatomic) double distance;
 @property (strong,nonatomic) NSArray* suitesAvailability;
 
 
 
 */
/*
 "id": 40611,
 "name": "Belleclaire Hotel",
 "address": "250 West 77th Street, Manhattan",
 "stars": 3.0,
 "distance": 100.0,
 "suites_availability": "1:44:21:87:99:34"
 
 */
#pragma mark - Parsing

- (void)simpleJsonParsing
{
    NSString *requestString = @"https://dl.dropboxusercontent.com/u/109052005/1/0777.json";
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
    
    NSError *error;
    NSDictionary *arrayJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSMutableArray* arr = [NSMutableArray new];
    
    for (NSDictionary *dict in arrayJSON)
    {
        ASHotel *hotel       = [[ASHotel alloc]init];
        
        hotel.identifier     = [[dict valueForKey:@"id"] doubleValue];
        hotel.name           = [dict  valueForKey:@"name"];
        hotel.address        = [dict  valueForKey:@"address"];
        hotel.stars          = [[dict valueForKey:@"stars"] doubleValue];
        hotel.distance       = [[dict valueForKey:@"distance"] doubleValue];
        hotel.suitesAvailabilityString = [dict  valueForKey:@"suites_availability"];
        
        [arr addObject:hotel];
    }
    //self.arrayDoctors = arr;
    
    
    NSLog(@"This is arrrr !!!! %@",arr);
    
    for (ASHotel* obj in arr) {
        NSLog(@"\n------------");
        NSLog(@"Identifier    = %f",obj.identifier);
        NSLog(@"Name          = %@",obj.name);
        NSLog(@"Address       = %@",obj.address);
        NSLog(@"Stars         = %f",obj.stars);
        NSLog(@"Distance      = %f",obj.distance);
        NSLog(@"Suites_availability = %@",obj.suitesAvailabilityString);
    }
    
    
}





@end
