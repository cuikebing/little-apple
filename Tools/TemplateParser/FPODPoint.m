//
//  FPODPoint.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "FPODPoint.h"
#import "TemplateGlobal.h"

@implementation FPODPoint

@synthesize x;
@synthesize y;
@synthesize type;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
 
-(NSString *) saveToString {
    NSString *dst;
    dst = float2string(self.x);
    NSString *tmp;
    tmp = float2string(self.y);
    dst = [dst stringByAppendingString:tmp];
    
    dst = [dst stringByAppendingFormat:@"%d", self.type];
    return dst;
}

-(void) parseString:(NSString *)str verId:(NSUInteger) versionId {
    
    if ([str length] == 0) {
        return;
    }
    
    if (versionId == 0) {
        ;
    } else {
        NSArray* arrStr = [str componentsSeparatedByString:kCOMMA];
        self.x = [[arrStr objectAtIndex:0] floatValue];
        self.y = [[arrStr objectAtIndex:1] floatValue];
        self.type = [[arrStr objectAtIndex:2] intValue];
    }
}

-(void) Pt2Pixel {
    self.x = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.x];
    self.y = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.y];
}
-(void) Pixel2Pt {
    self.x = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.x];
    self.y = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.y];

}
@end
