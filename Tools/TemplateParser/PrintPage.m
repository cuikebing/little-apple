 //
//  PrintPage.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "PrintPage.h"
#import "TemplateGlobal.h"
#import "PrintObj.h"
#import <objc/runtime.h>
#import "FileObj.h"
#import "ImageFrame.h"
@implementation PrintPage
 
@synthesize printObjs;    
@synthesize name;
@synthesize type;
@synthesize width ;
@synthesize height ;
@synthesize maxEditWidth ;
@synthesize maxEditHeight ;

 


- (void)dealloc {
    
    [printObjs release];    
    [name release];
    
    [super dealloc];
}

- (id)init
{	
    self = [super init];	
	
	if (self)
	{        
		printObjs = [[NSMutableArray alloc] init];
        name = [[NSString alloc] init];
	}
	
	return self;
}

- (void) parseString:(NSString *)pageStr pageNum:(NSInteger)pageNum verId:(NSInteger)versionId {
      
    if ([pageStr length] == 0) {
        return;
    }
    NSInteger start, end;
    
    end = [pageStr rangeOfString:kRIGHTBRACKET].location - 1;
    start = [pageStr rangeOfString:kLEFTBRACKET 
                           options:NSBackwardsSearch range:NSMakeRange(0, end)].location + 1;
    NSString *infoStr = [pageStr substringWithRange:NSMakeRange(start, end - start)];
    NSArray *arrInfo = [infoStr componentsSeparatedByString:kCOMMA];
    
    self.width = [[arrInfo objectAtIndex:0]floatValue];
    self.height = [[arrInfo objectAtIndex:1]floatValue];
    self.maxEditWidth = [[arrInfo objectAtIndex:2]floatValue];
    self.maxEditHeight = [[arrInfo objectAtIndex:3]floatValue];
    
    start = [pageStr rangeOfString:kRIGHTBRACKET].location + 1;
    end = [pageStr rangeOfString:kEQUAL].location;
    self.name = [pageStr substringWithRange:NSMakeRange(start, end - start)];
    
    start = [pageStr rangeOfString:kEQUAL].location + 2;
    end = [pageStr rangeOfString:kRIGHTBRACKET options:NSBackwardsSearch].location ;
    
    NSString *strContent = [pageStr substringWithRange:NSMakeRange(start, end - start)];
    if ([strContent length] == 0) {
        return;
    }
    
    NSArray *arrObj = [strContent componentsSeparatedByString:kSEMICOLON];
    
    for (int i = 0; i < [arrObj count]; i ++) {
     
        NSString *strObj = [arrObj objectAtIndex:i];        
        NSInteger typeLocation = [strObj rangeOfString:kEQUAL].location;
        NSString *strType = [strObj substringWithRange:NSMakeRange(0, typeLocation)];        
        Class myclass = NSClassFromString(strType);
        id obj = [[myclass alloc] init];
        //obj.pageIndex = pageNum;
        NSString *strContent = [strObj substringFromIndex:typeLocation];
        strContent = contentInBracket(strContent);
        [obj deserialize:strContent verId:versionId];
        
        NSString* className = [NSString stringWithUTF8String: class_getName([obj class])];
        if ([className isEqualToString:@"ImageFrame"]) {
            ImageFrame *imgFrame = obj;
            NSRange range = NSMakeRange(0, imgFrame.filePath.length);
            if (range.length != 0) {
             imgFrame.filePath = [imgFrame.filePath stringByReplacingOccurrencesOfString:@".swf" withString:@".svg" options:NSBackwardsSearch range:range];
            }
        } else if ([className isEqualToString:@"FileObj"]) {
            FileObj *fileObj = obj; 
            NSRange range = NSMakeRange(0, fileObj.filePath.length);
            if (range.length != 0) {
                fileObj.filePath = [fileObj.filePath stringByReplacingOccurrencesOfString:@".swf" withString:@".svg" options:NSBackwardsSearch range:range];    
            }            
        }
        
        [self.printObjs addObject:obj];
        [obj release];
    }
}

- (NSString *) saveToString {
    
    NSString *str;
    
    str = [NSString stringWithFormat:kLEFTBRACKET];
    str = [str stringByAppendingFormat:@"%f", self.width];
    str = [str stringByAppendingString:kCOMMA];
    str = [str stringByAppendingFormat:@"%f", self.height];
    str = [str stringByAppendingString:kCOMMA];
    str = [str stringByAppendingFormat:@"%f", self.maxEditWidth];
    str = [str stringByAppendingString:kCOMMA];
    str = [str stringByAppendingFormat:@"%f", self.maxEditHeight];
    str = [str stringByAppendingString:kRIGHTBRACKET];
    
    str = [str stringByAppendingString:self.name];
    str = [str stringByAppendingString:kEQUAL];
    str = [str stringByAppendingString:kLEFTBRACKET];
    for (int i = 0; i < [self.printObjs count]; i ++) {
        if (i != 0) {
            str = [str stringByAppendingString:kSEMICOLON];
        }
        PrintObj *prtObj = [self.printObjs objectAtIndex:i];
        NSString* className = [NSString stringWithUTF8String: class_getName([prtObj class])];
       
        str = [str stringByAppendingString:className];
        str = [str stringByAppendingString:kEQUAL];
        str = [str stringByAppendingString:kLEFTBRACKET];
        str = [str stringByAppendingString:[prtObj serialize]];
        str = [str stringByAppendingString:kRIGHTBRACKET];
        
    }
    str = [str stringByAppendingString:kRIGHTBRACKET];
  
    return str;
}
-(void) Pt2Pixel {
    
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.height];
    self.maxEditWidth = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.maxEditWidth];
    self.maxEditHeight = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.maxEditHeight];
    
    for (int i = 0; i < [self.printObjs count]; i ++) {
         PrintObj *prtObj = [self.printObjs objectAtIndex:i];
        [prtObj Pt2Pixel];
    }
}
-(void) Pixel2Pt {
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.height];
    self.maxEditWidth = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.maxEditWidth];
    self.maxEditHeight = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.maxEditHeight];
    for (int i = 0; i < [self.printObjs count]; i ++) {
        PrintObj *prtObj = [self.printObjs objectAtIndex:i];
        [prtObj Pixel2Pt];
    }
}

-(void)up:(PrintObj *)printObj {
        
    if (printObj != nil) {
        NSInteger nObjCnt = [self.printObjs count];
        for (int i = 0; i < nObjCnt; i++) {
            PrintObj *pObj = [self.printObjs objectAtIndex:i];
            if (pObj == printObj) {
                if (i < nObjCnt + 1) {
                    [self.printObjs exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                    break;
                }
            }
        }
    }
}

-(void)down:(PrintObj *)printObj {
    if (printObj != nil) {
        NSInteger nObjCnt = [self.printObjs count];
        for (int i = 0; i < nObjCnt; i++) {
            PrintObj *pObj = [self.printObjs objectAtIndex:i];
            if (pObj == printObj) {
                if (i > 0) {
                    [self.printObjs exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                    break;
                }
            }
        }
    }
}

-(void)deletePrintObj:(NSUInteger)index {
    [self.printObjs removeObjectAtIndex:index];       
}
    
@end


