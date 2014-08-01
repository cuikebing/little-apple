//
//  PointPath.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "PointPath.h"
#import "FPODPoint.h"
#import "TemplateGlobal.h"

@implementation PointPath
 
@synthesize width ;
@synthesize height ;
@synthesize pointArray;    
 

 

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        pointArray = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)dealloc {
    [pointArray release];
    [super dealloc];
}
 
-(NSString *) saveToString {
    NSString *dst;
    dst = float2string(self.width);
   
    NSString *tmp;
    tmp = float2string(self.height);
    
    dst = [dst stringByAppendingString:tmp];
    
    for (int i = 0; i < [self.pointArray count]; i ++) {
        if (i != 0) {
            dst = [dst stringByAppendingString:kPOINTFLAG];
        }         
        
        dst = [dst stringByAppendingString:kLEFTBRACKET];        
        dst = [dst stringByAppendingString:[[self.pointArray objectAtIndex:i] saveToString]];      
        dst = [dst stringByAppendingString:kRIGHTBRACKET];
    }
    return dst;
}
-(void) parseString:(NSString *)str verId:(NSUInteger)versionId {
    
    if ([str length] == 0) {
        return;
    }
    NSString *subStr = nil;
    BOOL hasWidth = NO;
    
    if (versionId == 0) {
        ;
    } else {
        NSRange range = [str rangeOfString:kCOMMA];
        int firstDot = range.location;
        if (firstDot != NSNotFound) {            
            NSString *tmpStr = [str substringWithRange:NSMakeRange(0, firstDot - 1)];
            self.width = [tmpStr floatValue];
            
            subStr = [str substringFromIndex:(firstDot+1)];
            range = [subStr rangeOfString:kCOMMA];
            int secondDot = range.location;
            tmpStr = [subStr substringToIndex:secondDot];
            self.height = [tmpStr floatValue];
            subStr = [str substringFromIndex:(firstDot + secondDot + 1)];
            hasWidth = YES;
        }
    }
    
    NSString *strSplit = kPOINTFLAG;
    if (versionId == 0) {
        ;
    }
    
    if (subStr) {
        NSArray *arrPoint = [subStr componentsSeparatedByString:strSplit];
        for (int i = 0; i < [arrPoint count]; i ++) {
            NSString *strTemp = [arrPoint objectAtIndex:i];
            strTemp = contentInBracket(strTemp);
            FPODPoint* point = [[FPODPoint alloc]init ];
            [point parseString:strTemp verId:1];
            [self.pointArray addObject:point];
            [point release];
        }
        
        if (!hasWidth) {
            int xMax = 0;
            int yMax = 0;
            
            for (int i = 0; i < [arrPoint count]; i ++) {
                FPODPoint *point = [arrPoint objectAtIndex:i];
                if (point.x > xMax) {
                    xMax = point.x;
                }
                if (point.y > yMax) {
                    yMax = point.y;
                }            
            }
            self.width = xMax + 10;
            self.height = yMax + 10;
        }
    } 
}

-(void) Pt2Pixel {
     
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.height];
    for (int i = 0; i < [self.pointArray count]; i ++) {
        [[self.pointArray objectAtIndex:i] Pt2Pixel];
    }
}
-(void) Pixel2Pt {
    
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.height];
    for (int i = 0; i < [self.pointArray count]; i ++) {
        [[self.pointArray objectAtIndex:i] Pixel2Pt];
    }
}
@end
