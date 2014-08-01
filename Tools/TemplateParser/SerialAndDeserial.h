//
//  SerialAndDeserial.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-15.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerialAndDeserial : NSObject

- (void)deserialize:(NSString *)strObj verId:(NSInteger)versionId;
- (NSString *)serialize;

@end
