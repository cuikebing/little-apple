//
//  OnePara.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "OnePara.h"
#import "CharContour.h"
#import "TemplateGlobal.h"

@implementation OnePara

@synthesize width;   
@synthesize oneParaChars;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        oneParaChars = [[NSMutableArray alloc]init];
    }
    
    return self;
}
- (void)dealloc {
    [oneParaChars release];
    [super dealloc];
}
-(NSString *) saveToString {
    NSString *dst;
    dst = float2string(self.width);    
    for (int i = 0; i < [self.oneParaChars count]; i ++) {
        if (i != 0) {
            dst = [dst stringByAppendingString:kCHARCONTOURFLAG];
        }      
        
        dst = [dst stringByAppendingString:kLEFTBRACKET];
        dst = [dst stringByAppendingString:[[self.oneParaChars objectAtIndex:i] saveToString]];
        dst = [dst stringByAppendingString:kRIGHTBRACKET];
    }
    return dst;
}
-(void) parseString:(NSString *)str verId:(NSUInteger)versionId {
    
    if ([str length] == 0) {
        return;
    }
    
    NSString *subStr = nil;
    if (versionId == 0) {
        ;
    } else {
        NSRange range = [str rangeOfString:kCOMMA];
        int firstDot = range.location;
        if (firstDot != NSNotFound) {            
            NSString *tmpStr = [str substringWithRange:NSMakeRange(0, firstDot - 1)];
            self.width = [tmpStr floatValue];            
            subStr = [str substringFromIndex:(firstDot+1)];
        }
    }
    
    NSString *strSplit = kCHARCONTOURFLAG;
    if (versionId == 0) {
        strSplit = kCHARCONTOUR;
    }
    if (subStr) {
            
        NSArray *arrCharContour = [subStr componentsSeparatedByString:strSplit];
        for (int i = 0; i < [arrCharContour count]; i ++) {
            NSString *strTemp = [arrCharContour objectAtIndex:i];
        
            NSString *strCharContour= contentInBracket(strTemp);
            CharContour* charContour = [[CharContour alloc]init ];
            [charContour parseString:strCharContour verId:1];        
            [self.oneParaChars addObject:charContour];
            [charContour release];
        }
    }
    
}

-(void) Pt2Pixel {
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.width];
    for (int i = 0; i < [self.oneParaChars count]; i ++) {
        [[self.oneParaChars objectAtIndex:i] Pt2Pixel];
    }
}
-(void) Pixel2Pt {
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.width];
    for (int i = 0; i < [self.oneParaChars count]; i ++) {
        [[self.oneParaChars objectAtIndex:i] Pixel2Pt];
    }
}

@end
