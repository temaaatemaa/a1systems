//
//  ZAMPoint.m
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "ZAMPoint.h"

@implementation ZAMPoint

- (instancetype)initWithX:(CGFloat)x withY:(CGFloat)y
{
    self = [super init];
    if (self)
    {
        _x = x;
        _y = y;
    }
    return self;
}


- (BOOL)isEqual:(id)object
{
    ZAMPoint *otherPoint = object;
    if (self.x == otherPoint.x)
    {
        if (self.y == otherPoint.y)
        {
            return YES;
        }
    }
    return NO;
}
@end
