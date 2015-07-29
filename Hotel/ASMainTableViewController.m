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


@end



@implementation ASMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicatorView.center = self.view.center;
    self.indicator       = indicatorView;
   
    [self.view addSubview:self.indicator];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.indicator startAnimating];
        [self simpleJsonParsing];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.indicator stopAnimating];

        });
    });
    
    ////////
    
    //[self simpleJsonParsing];
    [self.segmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    self.sortingArrayHotels = [NSArray arrayWithArray:arr];
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

    //return [self.arrayHotels count];
    return [self.sortingArrayHotels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:CellIdentifier];
    }
    
    
    //cell.textLabel.text       = [[self.arrayHotels objectAtIndex:indexPath.row]name];
    //cell.detailTextLabel.text = [[self.arrayHotels objectAtIndex:indexPath.row]address];
    //cell.imageView.image = [UIImage imageNamed:@"flower.png"];
    
    cell.textLabel.text       = [[self.sortingArrayHotels objectAtIndex:indexPath.row]name];
   // cell.detailTextLabel.text = [[self.sortingArrayHotels objectAtIndex:indexPath.row]address];
   
    //NSString* str = [NSString stringWithFormat:@"%d",(NSInteger)[[self.sortingArrayHotels objectAtIndex:indexPath.row]distance]];
    //cell.detailTextLabel.text = str;
    NSString* str = [[[self.sortingArrayHotels objectAtIndex:indexPath.row] valueForKeyPath:@"suitesAvailabilityArray.@count"] stringValue];
    NSLog(@"str = %@",str);
    cell.detailTextLabel.text = str;

    //cell.detailTextLabel.text = [[self.sortingArrayHotels objectAtIndex:indexPath.row] valueForKeyPath:@"suitesAvailabilityArray.@count"];
    
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Sorting Array


-(void) generateSectionsInBackgroundFromArray:(NSArray*) array  {
    
    
    [self.operation cancel];
    
    __weak ASMainTableViewController* weakSelf = self;
    
    self.operation = [NSBlockOperation blockOperationWithBlock:^{
        
        [self.indicator startAnimating];
        
        weakSelf.sortingArrayHotels = [NSArray array];
        [weakSelf.tableView reloadData];
        
        NSArray* sortingArray = [weakSelf generateSectionFromArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            weakSelf.sortingArrayHotels = sortingArray;
            [weakSelf.tableView reloadData];
            [self.indicator stopAnimating];
            self.operation = nil;
        });
    }];
    [self.operation start];
    
}



-(NSArray*) generateSectionFromArray:(NSArray*) array {
    
    
    NSArray* sortingArray = [NSMutableArray array];
    
   // NSSortDescriptor* sortByDistance    = [NSSortDescriptor sortDescriptorWithKey:@"distance"  ascending:YES];
  //  NSSortDescriptor* sortByFreeRooms   = [NSSortDescriptor sortDescriptorWithKey:@"name"   ascending:YES];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"suitesAvailabilityArray.@count" ascending:YES];



    if (self.segmentControl.selectedSegmentIndex == ASSortedDistance) {
        
       sortingArray = [array sortedArrayUsingDescriptors:@[sd]];
    }else
     {
        //sortByDistance  = nil;
        sortingArray = [array sortedArrayUsingDescriptors:@[sd2]];
     }
    return sortingArray;
}






- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
   
    [self.operation cancel];
    self.operation = nil;
    
   // [self generateSectionsInBackgroundFromArray:self.arrayStudents withFilter:self.searchBar.text];
    [self generateSectionsInBackgroundFromArray:self.arrayHotels];

}



@end
