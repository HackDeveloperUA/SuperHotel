//
//  ASDetailsViewController.m
//  Hotel
//
//  Created by MD on 30.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASDetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
@interface ASDetailsViewController ()

@end

@implementation ASDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.labelName.text    = self.hotel.name;
    self.labelAddress.text = self.hotel.address;
    self.labelStars.text   = [NSString stringWithFormat:@"Rating : %.2f",self.hotel.stars];
    self.labelSuitesAvailability.text = [NSString stringWithFormat:@"Free rooms : %d",[self.hotel.suitesAvailabilityArray count]];
    self.labelDistance.text = [NSString stringWithFormat:@"Distance : %.2f", _hotel.distance];
    
    UIImage* placeholder = [UIImage imageNamed:@"placeholder.png"];
    self.imageView.layer.cornerRadius = 13;
     self.imageView.layer.masksToBounds = YES;
    [self.imageView setImageWithURL:[NSURL URLWithString:_hotel.imageString] placeholderImage:placeholder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
