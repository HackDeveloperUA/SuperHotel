//
//  ASDetailsViewController.h
//  Hotel
//
//  Created by MD on 30.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHotel.h"

@interface ASDetailsViewController : UIViewController

@property (strong,nonatomic) ASHotel* hotel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelStars;
@property (weak, nonatomic) IBOutlet UILabel *labelSuitesAvailability;

@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@end
