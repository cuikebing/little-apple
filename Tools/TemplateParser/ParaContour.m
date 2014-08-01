//
//  ParaContour.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "ParaContour.h"
#import "OnePara.h"
#import "TemplateGlobal.h"

@implementation ParaContour

@synthesize width;
@synthesize height;    
@synthesize paras;

 
 
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        paras = [[NSMutableArray alloc]init];
    }
    
    return self;
}
- (void)dealloc {
    [paras release];
    [super dealloc];
}
 
-(NSString *) saveToString {
    
    NSString *dst;
    dst = float2string(self.width);
    NSString *tmp;
    tmp = float2string(self.height);
    
    dst = [dst stringByAppendingString:tmp];
      
    for (int i = 0; i < [self.paras count]; i ++) {
        if (i != 0) {
            dst = [dst stringByAppendingString:kONEPARAFLAG];
        }      
        
        dst = [dst stringByAppendingString:kLEFTBRACKET];
        dst = [dst stringByAppendingString:[[self.paras objectAtIndex:i] saveToString]];
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
            range = [subStr rangeOfString:kCOMMA];
            int secondDot = range.location;
            tmpStr = [subStr substringToIndex:secondDot];
            self.height = [tmpStr floatValue];
            subStr = [str substringFromIndex:(firstDot + secondDot + 1)];
        }
    }
    
    NSString *strSplit = kONEPARAFLAG;
    if (versionId == 0) {
//        strSplit = @"+OnePara";
    }
    
    if (subStr) {
        NSArray *arrCharContour = [subStr componentsSeparatedByString:strSplit];
        for (int i = 0; i < [arrCharContour count]; i ++) {
            NSString *strTemp = [arrCharContour objectAtIndex:i];
            
            NSString *strOnePara= contentInBracket(strTemp);
            OnePara* onePara = [[OnePara alloc]init ];
            [onePara parseString:strOnePara verId:1];        
            [self.paras addObject:onePara];
            [onePara release];
        }
    }
}

-(void) Pt2Pixel {
   
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.height];
     for (int i = 0; i < [self.paras count]; i ++) {
         [[self.paras objectAtIndex:i] Pt2Pixel];
     }
}
-(void) Pixel2Pt {
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.height];
    for (int i = 0; i < [self.paras count]; i ++) {
        [[self.paras objectAtIndex:i] Pixel2Pt];
    }
}

@end
