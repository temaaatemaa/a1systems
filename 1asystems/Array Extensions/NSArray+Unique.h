//
//  NSArray+Unique.h
//  1asystems
//
//  Created by Artem Zabludovsky on 28.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray(Unique)

+ (NSArray *)makeArrayUnique:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
