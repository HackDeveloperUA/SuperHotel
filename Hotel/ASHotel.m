//
//  ASHotel.m
//  Hotel
//
//  Created by MD on 29.07.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASHotel.h"

@implementation ASHotel

- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"\n------------\n\nName: %@;\n Address: %@;\n Stars: %f;\n Image: %@;\n Distance: %f\n\n\n",
                                   self.name,  self.address,
                                   self.stars, self.imageString,
                                   self.distance];
    return descriptionString;
    
}

@end
