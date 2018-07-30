//
//  ZAMRoute.m
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "ZAMRoute.h"
#import "ZAMLine.h"

@implementation ZAMRoute

- (instancetype)initWithLinesArray:(NSArray<ZAMLine *> *)linesArray
{
    self = [super init];
    if (self)
    {
        _linesArray = linesArray;
    }
    return self;
}

+ (NSArray <ZAMLine *> *)getAllLinesFromRoutes:(NSArray <ZAMRoute *> *)routes
{
    NSMutableArray <ZAMLine *> *allLinesMutableArray = [NSMutableArray new];
    for (ZAMRoute *route in routes)
    {
        [allLinesMutableArray addObjectsFromArray:route.linesArray];
    }
    NSArray <ZAMLine *> *allLinesArray = [allLinesMutableArray copy];
    return allLinesArray;
}

@end
