//
//  ZAMRoute.h
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZAMLine;


NS_ASSUME_NONNULL_BEGIN

@interface ZAMRoute : NSObject


@property (nonatomic, copy) NSArray<ZAMLine *> *linesArray;

- (instancetype)initWithLinesArray:(NSArray *)linesArray;

+ (NSArray <ZAMLine *> *)getAllLinesFromRoutes:(NSArray <ZAMRoute *> *)routes;


@end

NS_ASSUME_NONNULL_END
