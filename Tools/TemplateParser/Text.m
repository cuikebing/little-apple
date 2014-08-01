//
//  Text.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "Text.h"
#import "TemplateGlobal.h"
#import "ParaContour.h"

@implementation ParaContourString
@synthesize str;
@end

@implementation Text

@synthesize color;
@synthesize fontName;
@synthesize fontSize;
@synthesize fontStyle;
@synthesize lineSpace ;
@synthesize paraContour;
@synthesize spacing;
@synthesize text;
@synthesize typeset;
@synthesize paraContourStr;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        paraContour = nil;
        paraContourStr = nil;
    }
    
    return self;
}

- (void)dealloc {
    if (paraContour) {
        [paraContour release];
    }
    [super dealloc];
}
 
- (void)deserialize:(NSString *)strObj verId:(NSInteger)versionId {
    if ([strObj length] == 0) {
        return;
    }
    [super deserialize:strObj verId:versionId];
       
    NSInteger paraIndex = [strObj rangeOfString:kPARACONTOUR].location;
    
    if (paraIndex != NSNotFound) {
        paraContourStr = [[ParaContourString alloc]init];
        self.paraContourStr.str = [NSString stringWithString:
                                           contentInBracket([strObj substringFromIndex:paraIndex])];        
    }
    paraContour = nil;

    /*! not deseriallize now */
//    NSInteger paraIndex = [strObj rangeOfString:kPARACONTOUR].location;
//    NSString *paraContourStr = [strObj substringFromIndex:paraIndex];
//    paraContour = [[ParaContour alloc]init];
//    NSString *strContent = contentInBracket(paraContourStr);
//    [paraContour parseString:strContent verId:versionId];
}

- (NSString *)serialize {
    NSString *str = [super serialize];    
    if (self.paraContour) {
        str = [str stringByAppendingString:kPARACONTOUREQUAL];
        str = [str stringByAppendingString:kLEFTBRACKET];
        str = [str stringByAppendingString:[self.paraContour saveToString]];
        str = [str stringByAppendingString:kRIGHTBRACKET];
    }
    if (self.paraContourStr.str) {
        str = [str stringByAppendingString:kPARACONTOUREQUAL];
        str = [str stringByAppendingString:kLEFTBRACKET];
        str = [str stringByAppendingString:self.paraContourStr.str];
        str = [str stringByAppendingString:kRIGHTBRACKET];
    }
 
    return  str;
}

-(void) Pt2Pixel {
    [super Pt2Pixel];
    self.lineSpace = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.lineSpace];
    self.spacing = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.spacing];
    if (self.paraContour) {
        [self.paraContour Pt2Pixel];
    }
}
-(void) Pixel2Pt {
    [super Pixel2Pt];
    self.lineSpace = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.lineSpace];
    self.spacing = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.spacing];
    if (self.paraContour) {
        [self.paraContour Pixel2Pt];
    }
}
@end
