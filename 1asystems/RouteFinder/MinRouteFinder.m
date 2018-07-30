//
//  MinRouteFinder.m
//  1asystems
//
//  Created by Artem Zabludovsky on 28.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "MinRouteFinder.h"
#import "ZAMPoint.h"
#import "ZAMLine.h"
#import "ZAMRoute.h"
#import "NSArray+Unique.h"

static NSUInteger const InfValue = 999999;

@implementation MinRouteFinder

- (ZAMRoute *)getMinimalRouteFromPoint:(ZAMPoint *)fromPoint toPoint:(ZAMPoint *)toPoint inAllRoutes:(NSArray <ZAMRoute *> *)allRoutes
{
    NSArray <ZAMLine *> *allLinesArray = [ZAMRoute getAllLinesFromRoutes:allRoutes];
    NSArray <ZAMPoint *> *allPointsArray = [ZAMLine getAllPointsFromLines:allLinesArray];
    
    allPointsArray = [NSArray makeArrayUnique:allPointsArray];
    allPointsArray = [self putFromPoint:fromPoint toFirstObjectInArray:allPointsArray];
    
    NSUInteger countOfPoints = [allPointsArray count];
    
    
    /*
     ##################################
     #      алгоритм Дейкстры         #
     ##################################
     */
    double a[countOfPoints][countOfPoints];
    
    for (int i = 0; i < countOfPoints; i++)
    {
        a[i][i] = 0;
        for (int j = i + 1; j < countOfPoints; j++) {
            a[i][j] = InfValue;
            a[j][i] = InfValue;
            ZAMPoint *firstPoint = allPointsArray[i];
            ZAMPoint *secondPoint = allPointsArray[j];
            for (ZAMLine *line in allLinesArray)
            {
                if ([line isLineFor:firstPoint andOtherPoint:secondPoint])
                {
                    a[i][j] = line.distance.doubleValue;
                    a[j][i] = line.distance.doubleValue;
                }
            }
        }
    }
    double d[countOfPoints]; // минимальное расстояние
    int v[countOfPoints];
    int minindex;
    double min;
    double temp;
    
    for (int i = 0; i < countOfPoints; i++)
    {
        d[i] = InfValue;
        v[i] = 1;
    }
    
    d[0] = 0;

    do {
        minindex = InfValue;
        min = InfValue;
        for (int i = 0; i<countOfPoints; i++)
        {
            if ((v[i] == 1) && (d[i]<min))
            {
                min = d[i];
                minindex = i;
            }
        }

        if (minindex != InfValue)
        {
            for (int i = 0; i<countOfPoints; i++)
            {
                if (a[minindex][i] > 0)
                {
                    temp = min + a[minindex][i];
                    if (temp < d[i])
                    {
                        d[i] = temp;
                    }
                }
            }
            v[minindex] = 0;
        }
    } while (minindex < InfValue);


    int ver[countOfPoints];
    int end = @([allPointsArray indexOfObject:toPoint]).intValue;
    ver[0] = end;
    int k = 1;
    double weight = d[end];
    
    while (end > 0)
    {
        for(int i=0; i<countOfPoints; i++)
            if (a[end][i] != InfValue)
            {
                double temp = weight - a[end][i];
                if (fabs(temp - d[i]) < 0.01)
                {
                    weight = temp;
                    end = i;
                    ver[k] = i;
                    k++;
                }
            }
    }

    NSMutableArray *minDistanseRoute = [NSMutableArray new];
    for (int i = k-1; i>=0; i--)
    {
        [minDistanseRoute addObject:allPointsArray[ver[i]]];
    }
    
    NSMutableArray <ZAMLine *> *minRouteLines = [NSMutableArray new];
    for (int i = 0; i < minDistanseRoute.count - 1; i++)
    {
        ZAMLine *line = [[ZAMLine alloc] initWithFirstPoint:minDistanseRoute[i] withSecondPoint:minDistanseRoute[i+1]];
        [minRouteLines addObject:line];
    }

    return [[ZAMRoute alloc]initWithLinesArray:[minRouteLines copy]];
}

- (NSArray <ZAMPoint *> *)putFromPoint:(ZAMPoint *)fromPoint toFirstObjectInArray:(NSArray <ZAMPoint *> *)array
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    ZAMPoint *oldFirstPoint = [mutableArray firstObject];
    NSUInteger oldIndexForFromPoint = [mutableArray indexOfObject:fromPoint];
    [mutableArray replaceObjectAtIndex:oldIndexForFromPoint withObject:oldFirstPoint];
    [mutableArray replaceObjectAtIndex:0 withObject:fromPoint];
    return [mutableArray copy];
}

@end
