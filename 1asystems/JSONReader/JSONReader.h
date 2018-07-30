//
//  JSONReader.h
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZAMRoute;


NS_ASSUME_NONNULL_BEGIN

@interface JSONReader : NSObject

- (NSDictionary *)parseJSONToDictionary;
- (NSArray <ZAMRoute *>*)parseJSONDictionaryToRouteArray:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
