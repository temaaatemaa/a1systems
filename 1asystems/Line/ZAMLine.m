//
//  ZAMLine.m
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "ZAMLine.h"
#import "ZAMPoint.h"
#import <math.h>

@implementation ZAMLine

- (instancetype)initWithFirstPoint:(ZAMPoint *)firstPoint withSecondPoint:(ZAMPoint *)secondPoint
{
    self = [super init];
    if (self) {
        _firstPoint = firstPoint;
        _secondPoint = secondPoint;
    }
    return self;
}

- (BOOL)isLineFor:(ZAMPoint *)point andOtherPoint:(ZAMPoint *)otherPoint
{
    if (([point isEqual:_firstPoint])&&([otherPoint isEqual:_secondPoint]))
    {
        return YES;
    }
    if (([point isEqual:_secondPoint])&&([otherPoint isEqual:_firstPoint]))
    {
        return YES;
    }
    return NO;
}

- (NSNumber *)distance
{
    return [ZAMLine distanceBetween:_firstPoint withSecondPoint:_secondPoint];
}

+ (NSNumber *)distanceBetween:(ZAMPoint *)firstPoint withSecondPoint:(ZAMPoint *)secondPoint
{
    double distance = sqrt(pow(firstPoint.x - secondPoint.x, 2.0) + pow(firstPoint.y - secondPoint.y, 2.0));
    return @(distance);
}

+ (NSArray <ZAMPoint *> *)getAllPointsFromLines:(NSArray <ZAMLine *> *)lines
{
    NSMutableArray <ZAMPoint *> *allPointsMutableArray = [NSMutableArray new];
    for (ZAMLine *line in lines)
    {
        [allPointsMutableArray addObject:line.firstPoint];
        [allPointsMutableArray addObject:line.secondPoint];
    }
    NSArray <ZAMPoint *> *allPointsArray = [allPointsMutableArray copy];
    return allPointsArray;
}

@end
