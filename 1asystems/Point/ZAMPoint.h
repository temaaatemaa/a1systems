//
//  ZAMPoint.h
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ZAMPoint : NSObject

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (instancetype)initWithX:(CGFloat)x withY:(CGFloat)y;

@end

NS_ASSUME_NONNULL_END
