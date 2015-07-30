//
//  ASMainTableViewController.h
//  Hotel
//
//  Created by MD on 29.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ASMainTableViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic)  UIActivityIndicatorView* indicator;

@property (strong, nonatomic)  NSOperation*     operation;

@property (strong, nonatomic)  NSMutableArray* arrayHotels;
@property (strong, nonatomic)  NSMutableArray* sortingArrayHotels;


- (IBAction)segmentControlAction:(UISegmentedControl *)sender;

@end
