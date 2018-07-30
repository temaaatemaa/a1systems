//
//  MinRouteFinder.h
//  1asystems
//
//  Created by Artem Zabludovsky on 28.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZAMRoute;
@class ZAMPoint;

NS_ASSUME_NONNULL_BEGIN

@interface MinRouteFinder : NSObject

- (ZAMRoute *)getMinimalRouteFromPoint:(ZAMPoint *)fromPoint toPoint:(ZAMPoint *)toPoint inAllRoutes:(NSArray <ZAMRoute *> *)allRoutes;

@end

NS_ASSUME_NONNULL_END
