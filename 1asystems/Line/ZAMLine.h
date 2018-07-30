//
//  ZAMLine.h
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZAMPoint;


NS_ASSUME_NONNULL_BEGIN

@interface ZAMLine : NSObject


@property (nonatomic, readonly, strong) ZAMPoint *firstPoint;
@property (nonatomic, readonly, strong) ZAMPoint *secondPoint;

@property (nonatomic, readonly, strong) NSNumber *distance;

- (instancetype)initWithFirstPoint:(ZAMPoint *)firstPoint withSecondPoint:(ZAMPoint *)secondPoint;

- (BOOL)isLineFor:(ZAMPoint *)point andOtherPoint:(ZAMPoint *)otherPoint;

+ (NSNumber *)distanceBetween:(ZAMPoint *)firstPoint withSecondPoint:(ZAMPoint *)secondPoint;
+ (NSArray <ZAMPoint *> *)getAllPointsFromLines:(NSArray <ZAMLine *> *)lines;


@end

NS_ASSUME_NONNULL_END
