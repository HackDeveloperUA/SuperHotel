//
//  ASMainTableViewController.m
//  Hotel
//
//  Created by MD on 29.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASMainTableViewController.h"
#import "ASDetailsViewController.h"
#import "ASHotel.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ASCustomCellMainTable.h"


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
    self.arrayHotels = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.indicator startAnimating];
        [self simpleJsonParsing2];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.indicator stopAnimating];

        });
    });
    

    [self.segmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Parsing

-(ASHotel*) putDataInObject:(id) data {
    
    ASHotel *hotel       = [[ASHotel alloc]init];
    
    hotel.identifier     = [[data valueForKey:@"id"] doubleValue];
    hotel.name           = [data  valueForKey:@"name"];
    hotel.address        = [data  valueForKey:@"address"];
    hotel.stars          = [[data valueForKey:@"stars"] doubleValue];
    hotel.imageString    = [data valueForKey:@"image"];
    hotel.distance       = [[data valueForKey:@"distance"] doubleValue];
    NSString* tmpFreeRooms =  [data  valueForKey:@"suites_availability"];
    hotel.suitesAvailabilityArray  = [tmpFreeRooms componentsSeparatedByString:@":"];
    
    return hotel;
}


-(void) printAllHotelInArray:(NSArray*) array{
    
    
        
        for (id obj in array) {
            
            if ([obj isKindOfClass:[ASHotel class]]) {
                NSLog(@"Description = %@",[obj description]);
            }
        }
    
}

- (void)simpleJsonParsing:(NSString*) requestString
{

   // NSString *requestString = @"https://dl.dropboxusercontent.com/u/109052005/1/0777.json";
   // NSString *requestString = @"https://dl.dropboxusercontent.com/s/5mssly9c1z78oqu/hotelList.json";

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
    NSError *error;

    id dataForHotel = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
   
    ASHotel *hotel = [self putDataInObject:dataForHotel];
    [self.arrayHotels addObject:hotel];
    self.sortingArrayHotels = self.arrayHotels;

    [self printAllHotelInArray:self.arrayHotels];
 

}

- (void)simpleJsonParsing2
{
    
    
    NSString *requestString = @"https://dl.dropboxusercontent.com/s/pvqqh5crbrc8sqi/hotelList3.json";

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
    
    NSError *error;
    NSDictionary *arrayJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSMutableArray* arr = [NSMutableArray new];
    
    for (NSDictionary *dict in arrayJSON)
    {
      NSString *requestStringJSON = [dict  valueForKey:@"id"];
      [arr addObject:requestStringJSON];
        
    }
    NSLog(@"arr = %@",arr);
    
    for (NSString* str in arr) {
        [self simpleJsonParsing:str];
    }
    
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ASDetailsViewController *vc2 = (ASDetailsViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"ASDetailsViewController"];
    
    ASHotel* obj = [self.sortingArrayHotels objectAtIndex:indexPath.row];
    vc2.hotel = obj;
    
    [self.navigationController pushViewController:vc2 animated:YES];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return [self.arrayHotels count];
    return [self.sortingArrayHotels count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell layoutIfNeeded];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:CellIdentifier];
        // cell.contentMode = UIViewContentModeScaleAspectFit;;

    }
    

    NSString* urlPhoto   = (NSString*)[[self.sortingArrayHotels objectAtIndex:indexPath.row]image];
    NSURL*    url        = [[NSURL alloc]initWithString:urlPhoto];
    UIImage* placeholder = [UIImage imageNamed:@"placeholder.png"];

    cell.textLabel.text       = [[self.sortingArrayHotels objectAtIndex:indexPath.row]name];
    cell.detailTextLabel.text = (NSString*)[[self.sortingArrayHotels objectAtIndex:indexPath.row]address];
   // cell.imageView.image = placeholder;
     cell.imageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
    [cell.imageView setImageWithURL:url placeholderImage:placeholder];
    //[cell.imageView setNeedsDisplay];
    
    cell.imageView.layer.cornerRadius = 17;
    cell.imageView.layer.masksToBounds = YES;
    
    
    //cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    */
    
    
    static NSString *CellIdentifier = @"customCell";
    
    ASCustomCellMainTable *cell = (ASCustomCellMainTable *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ASCustomCellMainTable alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSString* urlPhoto   = (NSString*)[[self.sortingArrayHotels objectAtIndex:indexPath.row]imageString];
    NSURL*    url        = [[NSURL alloc]initWithString:urlPhoto];
    UIImage* placeholder = [UIImage imageNamed:@"placeholder.png"];

    cell.name.text = [[self.sortingArrayHotels objectAtIndex:indexPath.row]name];
    cell.address.text = (NSString*)[[self.sortingArrayHotels objectAtIndex:indexPath.row]address];
   
    cell.image.layer.cornerRadius = 20;
    cell.image.layer.masksToBounds = YES;
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
    [cell.image setImageWithURL:url placeholderImage:placeholder];

    
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
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

            [self.indicator stopAnimating];
            self.operation = nil;
            
            
        });
    }];
    [self.operation start];
    
}



-(NSArray*) generateSectionFromArray:(NSArray*) array {
    
    
    NSArray* sortingArray = [NSMutableArray array];

    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSSortDescriptor *sortByFreeRooms = [[NSSortDescriptor alloc] initWithKey:@"suitesAvailabilityArray.@count" ascending:NO];


    if (self.segmentControl.selectedSegmentIndex == ASSortedDistance) {
        
       sortingArray = [array sortedArrayUsingDescriptors:@[sortByDistance]];
    }else
     {
        sortingArray = [array sortedArrayUsingDescriptors:@[sortByFreeRooms]];
     }
    
    return sortingArray;
}





- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
   
    [self.operation cancel];
     self.operation = nil;
    
    [self generateSectionsInBackgroundFromArray:self.arrayHotels];

}



@end
