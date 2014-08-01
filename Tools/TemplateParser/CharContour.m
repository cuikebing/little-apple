//
//  CharContour.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "CharContour.h"
#import "PointPath.h"
#import "TemplateGlobal.h"

@implementation CharContour
    
@synthesize singlePaths;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        singlePaths = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)dealloc {
    [singlePaths release];	
    [super dealloc];
}
-(NSString *) saveToString {
    NSString *dst = [[[NSString alloc ]init]autorelease];
    for (int i = 0; i < [self.singlePaths count]; i ++) {
        if (i != 0) {
            dst = [dst stringByAppendingString:kPOINTPATHFLAG];
        }
        dst = [dst stringByAppendingString: kLEFTBRACKET];
        dst = [dst stringByAppendingString:[[self.singlePaths objectAtIndex:i] saveToString]];
        dst = [dst stringByAppendingString: kRIGHTBRACKET];        
    }
    return dst;
}
 
-(void) parseString:(NSString *)str verId:(NSUInteger)versionId {
    if ([str length] == 0) {
        return;
    }
    NSString *strSplit = kPOINTPATHFLAG;
    if (versionId == 0) {
        ;
    }
    
    NSArray *arrPointPath = [str componentsSeparatedByString:strSplit];
    for (int i = 0; i < [arrPointPath count]; i ++) {
        NSString *strTemp = [arrPointPath objectAtIndex:i];
        NSString *strPointPath = contentInBracket(strTemp);
        PointPath* pointPath = [[PointPath alloc]init ];
        [pointPath parseString:strPointPath verId:versionId];
        [self.singlePaths addObject:pointPath]; 
        [pointPath release];
    }
}

-(void) Pt2Pixel {
    for (int i = 0; i < [self.singlePaths count]; i ++) {
        [[self.singlePaths objectAtIndex:i] Pt2Pixel];
    }
}
-(void) Pixel2Pt {
    for (int i = 0; i < [self.singlePaths count]; i ++) {
        [[self.singlePaths objectAtIndex:i] Pixel2Pt];
    }
}

@end
