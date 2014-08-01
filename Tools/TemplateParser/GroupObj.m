//
//  GroupObj.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "GroupObj.h"

@implementation GroupObj

@synthesize m_PrintObj; 

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)deserialize:(NSString *)strObj verId:(NSInteger)versionId {
    NSLog(@"GroupObj");
}

@end
