//
//  JSONReader.m
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "JSONReader.h"

#import "ZAMRoute.h"
#import "ZAMLine.h"
#import "ZAMPoint.h"

@implementation JSONReader

- (NSData *)getJSONData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"json"
                                         withExtension:@"json"];
    return [NSData dataWithContentsOfURL:url];
}

- (NSDictionary *)parseJSONToDictionary
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[self getJSONData] options:0 error:nil];
    return dict;
}

- (NSArray <ZAMRoute *>*)parseJSONDictionaryToRouteArray:(NSDictionary *)dictionary
{
    NSArray *features = dictionary[@"response_data"][@"features"][@"features"];
    
    NSMutableArray <ZAMRoute *> *routesArray = [NSMutableArray new];
    for (NSDictionary *feature in features)
    {
        if ([feature[@"properties"][@"system"][@"entityType"] isEqualToString:@"Route"])
        {
            NSDictionary *geometry = feature[@"geometry"];
            NSArray *coordinates = geometry[@"coordinates"];
            
            NSMutableArray <ZAMLine *> *linesArray = [NSMutableArray new];
            ZAMPoint *previousPoint;
            for (NSArray *coordinate in coordinates)
            {
                ZAMPoint *point = [[ZAMPoint alloc]initWithX:((NSNumber *)coordinate[0]).floatValue withY:((NSNumber *)coordinate[1]).floatValue];
                
                if (previousPoint)
                {
                    ZAMLine *line = [[ZAMLine alloc] initWithFirstPoint:previousPoint withSecondPoint:point];
                    [linesArray addObject:line];
                }
                previousPoint = point;
            }
            ZAMRoute *route = [[ZAMRoute alloc] initWithLinesArray:linesArray];
            [routesArray addObject:route];
        }
    }
    
    return [routesArray copy];
}
@end
