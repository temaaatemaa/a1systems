//
//  NSArray+Unique.m
//  1asystems
//
//  Created by Artem Zabludovsky on 28.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "NSArray+Unique.h"

@implementation NSArray(Unique)

+ (NSArray *)makeArrayUnique:(NSArray *)array
{
    NSArray *unique = [NSSet setWithArray:array].allObjects;
    return unique;
}

@end
