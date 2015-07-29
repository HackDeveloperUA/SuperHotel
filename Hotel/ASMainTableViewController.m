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



typedef NS_ENUM(NSInteger, ASSortedSegment) {
    ASSortedDistance  = 0,
    ASSortedFreeRooms = 1,

};



@interface ASMainTableViewController ()

@property (strong, nonatomic) NSArray* arrayHotels;
@property (strong, nonatomic) UIActivityIndicatorView* indicator;
@end



@implementation ASMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = self.view.center;
    self.indicator = indicatorView;
    [self.view addSubview:self.indicator];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* Код, который должен выполниться в фоне */
        [self.indicator startAnimating];
        [self simpleJsonParsing];

        dispatch_async(dispatch_get_main_queue(), ^{
            /* Код, который выполниться в главном потоке */
            [self.tableView reloadData];
            [self.indicator stopAnimating];

        });
    });
    
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
        NSString* tmpFreeRooms =  [dict  valueForKey:@"suites_availability"];
        hotel.suitesAvailabilityArray  = [tmpFreeRooms componentsSeparatedByString:@":"];
       
        [arr addObject:hotel];
    }
    self.arrayHotels = arr;
    
    
    NSLog(@"This is arrrr !!!! %@",arr);
    
    for (ASHotel* obj in arr) {
        NSLog(@"\n------------");
        NSLog(@"Identifier    = %d",(NSInteger)obj.identifier);
        NSLog(@"Name          = %@",obj.name);
        NSLog(@"Address       = %@",obj.address);
        NSLog(@"Stars         = %f",obj.stars);
        NSLog(@"Distance      = %f",obj.distance);
        NSLog(@"Suites_availabilityArray = %@",obj.suitesAvailabilityArray);
    }
 

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrayHotels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text       = [[self.arrayHotels objectAtIndex:indexPath.row]name];
    cell.detailTextLabel.text = [[self.arrayHotels objectAtIndex:indexPath.row]address];
   
    //cell.imageView.image = [UIImage imageNamed:@"flower.png"];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}






- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    [self.operation cancel];
    self.operation = nil;
    
   // [self generateSectionsInBackgroundFromArray:self.arrayStudents withFilter:self.searchBar.text];

}



@end
