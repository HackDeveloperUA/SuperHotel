//
//  ASCustomCellMainTable.h
//  Hotel
//
//  Created by MD on 30.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCustomCellMainTable : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;


@end
