//
//  FileObj.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "FileObj.h"

@implementation FileObj


@synthesize filePath;
@synthesize fileType;
@synthesize reversalType;
@synthesize vreversalType;
@synthesize scale;
@synthesize dbId;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
 
