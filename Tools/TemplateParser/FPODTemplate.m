//
//  FPODTemplate.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-26.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "FPODTemplate.h"
#import "PrintPage.h"
#import "TemplateGlobal.h"
#import <objc/runtime.h> 
#import "ImageFrame.h"
#import "Image.h"
#import "FCFileAccess.h"
#import "Function.h"
#import "CommonDef.h"

@implementation FPODDataParser
@synthesize versionId;
@synthesize templatePath;

- (NSInteger)getVersionId:(NSString *)str {
   NSRange range = [str rangeOfString:kCOLON];
    if (range.location != NSNotFound) {
        NSString *strHeader = [[NSString alloc] initWithString:[str substringToIndex:range.location]];
        range = [strHeader rangeOfString:kLEFTBRACKET];
        NSUInteger verIndex = range.location;
        
        if (verIndex != NSNotFound) {
            self.versionId = [[strHeader substringToIndex:verIndex] intValue];
        }        
        [strHeader release];
    } else {
        range.location = 0;
    }
    return range.location;
}

- (PrintPage *) parseOnePage: (NSString *)strPage pageIndex:(NSInteger)index {
    PrintPage *page = [[[PrintPage alloc ]init]autorelease];    
    [page parseString:strPage pageNum:index verId:self.versionId];
    return page;
}
@end

@implementation FPODTemplateParser
 
@synthesize printPageArray;
@synthesize dicOffsetDict;
@synthesize dicLengthDict;
@synthesize uPageCount;
@synthesize srcString;
 

- (void)dealloc {
    [printPageArray release];
    [dicOffsetDict release];
    [dicLengthDict release];
    [super dealloc];
}

- (id)init
{	
    self = [super init];	
	
	if (self)
	{ 
        uPageCount = 0;
        printPageArray = [[NSMutableArray alloc] init];
        dicOffsetDict = [[NSMutableDictionary alloc] init];
        dicLengthDict = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void) parseTemplate: (NSString*)strFileName {
   
    NSError *error = nil;
    self.templatePath = [strFileName stringByDeletingLastPathComponent];
    NSString *txtContent = [NSString stringWithContentsOfFile:strFileName encoding:NSUTF8StringEncoding error:&error];
    assert(txtContent);
    self.srcString = [NSString stringWithString:txtContent];
    [self parseTemplateString];
    
}
- (void) parseTemplateString {
     
    NSRange range;    
   
    /*! get version info */
    NSInteger nStartPos = [self getVersionId:self.srcString];
    
    NSUInteger nOffset = 0;
    
    /*! get page offset */
    nOffset = nStartPos + 3;
    NSString *strSubFile = [self.srcString substringFromIndex:nOffset];
   
    
    do {
        if ([strSubFile length] > 0) {
            
            range = [strSubFile rangeOfString:kPAGEFLAG];
            if (range.location != NSNotFound) {
                uPageCount ++;      
                NSString *indexKey = [[NSString alloc] initWithFormat:@"%d", uPageCount];
                [dicOffsetDict setObject:[NSNumber numberWithInteger: nOffset] forKey: indexKey];
                [dicLengthDict setObject:[NSNumber numberWithInteger: range.location] forKey: indexKey];
                nOffset += range.location;
                nOffset += 1;   // jump "|"                        
                [indexKey release];             
                strSubFile = [strSubFile substringFromIndex:range.location + 1];
            } else { 
                    uPageCount ++;
                    NSString *indexKey = [[NSString alloc] initWithFormat:@"%d", uPageCount];
                    [dicOffsetDict setObject:[NSNumber numberWithInteger: nOffset] forKey: indexKey];
                    [dicLengthDict setObject:[NSNumber numberWithInteger: ([self.srcString length] - nOffset)] forKey: indexKey];
                    
                    [indexKey release];   
                break;         
            }
        } else {
                break;
            }
    } while (strSubFile);   
 
    [self parsePages];
   }

- (void) parsePages {
    /*! parse pages */
    for (int i = 0; i < uPageCount; i ++) {
        NSString *pageString =  [self getPageString:i + 1]; 
        PrintPage *page = [self parseOnePage:pageString pageIndex:i + 1];
        [self.printPageArray addObject:page];
    }  
} 

- (NSString *) getPageString: (NSInteger)index {
    
    NSString *indexKey = [NSString stringWithFormat:@"%d", index];
    NSNumber* number = [dicOffsetDict objectForKey: indexKey];
    int nTmpOffset = [number intValue];
    number = [dicLengthDict objectForKey: indexKey];
    int nTmpLength = [number intValue];        
    NSString *pageString = [self.srcString substringWithRange:NSMakeRange(nTmpOffset, nTmpLength)];
    
    /*保存page文件*/
    NSString *strPageName = [NSString stringWithString:self.templatePath];
    NSString *strName = [NSString stringWithFormat:@"%d.txt", index];
    strPageName = [strPageName stringByAppendingPathComponent:strName];
    NSMutableData *writer = [[NSMutableData alloc] init]; 
    [writer appendData:[pageString dataUsingEncoding:NSUTF8StringEncoding]]; 
    [writer writeToFile:strPageName atomically:YES];
    [writer release];
    //end
    
    return pageString;    
}


- (void) saveTemplate: (NSString *)strFileName {
    [self saveTemplateToString];
    NSMutableData *writer = [[NSMutableData alloc] init]; 
    [writer appendData:[dstString dataUsingEncoding:NSUTF8StringEncoding]]; 
    [writer writeToFile:strFileName atomically:YES];
    [writer release];    
}

- (void) saveTemplateToString { 
    dstString = [NSString stringWithFormat:@"%d", self.versionId];
    dstString = [dstString stringByAppendingString:@"():"];  
    dstString = [dstString stringByAppendingString:kLEFTBRACKET];
    [self savePrintPages];    
    dstString = [dstString stringByAppendingString:kRIGHTBRACKET];
}

- (void) savePrintPages{
 /*!保存多页*/    
    for (int i = 0; i < [self.printPageArray count]; i ++) {
        if (i != 0) {
            dstString = [dstString stringByAppendingString: kPAGEFLAG];
        }
        
        PrintPage *page = [self getPrintPage:i];
        NSString *strPage = [page saveToString];
        dstString = [dstString stringByAppendingString:strPage];      
    }
}

- (PrintPage *) getPrintPage:(NSInteger)pageIndex {
    return [self.printPageArray  objectAtIndex:pageIndex];    
}

- (void) fillPhotos:(NSMutableArray *)imageArray curPageIndex:(NSInteger)pageIndex {
    NSInteger index = 0;
    NSInteger imgCnt = imageArray.count;
    
    if (imgCnt == 0) {
        return;
    }
    NSInteger i = 1;
    for (PrintPage *prtPage in self.printPageArray) {
        if (i == pageIndex) {
            continue;
        }
        for (PrintObj *prtObj in prtPage.printObjs) {
            NSString* className = [NSString stringWithUTF8String: class_getName([prtObj class])];
            if ([className isEqualToString:@"ImageFrame"]) {
                
                ImageFrame *imgFrame = (ImageFrame *)prtObj;
                Image *img = (Image *)[imageArray objectAtIndex:index];
                if ([imgFrame addImage:img] == YES) {
                    index ++;
                }
                if (index == imgCnt) {
                    return;
                }
            }
        }
        i ++;
    }
    
}

@end
 
@implementation FPODPageParser

@synthesize curPageIndex;
@synthesize pageObj; 

 
- (id) initWithPath:(NSString *)workPath {
        self = [super init];
        if (self) {
            pageObj = nil;
            templatePath = [[FCFileAccess getSharedInstance]GetWorkTemplatePath:workPath]; 
            [templatePath retain];
            
            NSString *pageFileName = [[FCFileAccess getSharedInstance]GetPageFilePath:self.templatePath
                                                                            pageIndex:0];
            NSError *error = nil;    
            NSString *txtContent = [NSString stringWithContentsOfFile:pageFileName encoding:NSUTF8StringEncoding error:&error];
            if (txtContent != nil) {
                [self getVersionId:txtContent];
            }
            
        }
        return self;
    
}
-(void)dealloc {
    [templatePath release];
    if (pageObj) {
        [pageObj release];
        pageObj = nil;
    }
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self) {
        pageObj = nil;
    }
    return self;
}

- (PrintPage *) parsePage: (NSInteger)pageIndex {
    
    if (pageObj) {
        [pageObj release];
        pageObj = nil;
    }
    pageIndex ++;
    self.curPageIndex = pageIndex;
    NSString *pageFileName = [[FCFileAccess getSharedInstance]GetPageFilePath:self.templatePath
                                pageIndex:pageIndex];
     NSLog(@"open --- %@", pageFileName);
    NSError *error = nil;    
    NSString *txtContent = [NSString stringWithContentsOfFile:pageFileName encoding:NSUTF8StringEncoding error:&error];
    
    assert(txtContent);
     
    self.pageObj = [self parseOnePage:txtContent pageIndex:pageIndex];

    return self.pageObj;
}

- (void)savePage {
    
    NSString *pageString = [self.pageObj saveToString];
    
    NSString *pageFileName = [[FCFileAccess getSharedInstance]GetPageFilePath:self.templatePath
                                                                    pageIndex:self.curPageIndex];
    NSLog(@"save --- %@", pageFileName);
    NSMutableData *writer = [[NSMutableData alloc] init]; 
    [writer appendData:[pageString dataUsingEncoding:NSUTF8StringEncoding]]; 
    [writer writeToFile:pageFileName atomically:YES];
    [writer release];
    
}

- (BOOL) fillPhotos:(NSMutableArray *)imageArray guid:(NSMutableArray *)guidArray {
    
    BOOL res = NO;
     
    NSInteger imgCnt = imageArray.count;
    
    if (imgCnt == 0) {
        return res;
    }
    
    for (PrintObj *prtObj in self.pageObj.printObjs) {
        NSString* className = [NSString stringWithUTF8String: class_getName([prtObj class])];
        if ([className isEqualToString:@"ImageFrame"]) {
            
            ImageFrame *imgFrame = (ImageFrame *)prtObj;
            UIImage *uImg = (UIImage *)[imageArray objectAtIndex:0];
            NSString *guid = (NSString *)[guidArray objectAtIndex:0];
            
            Image *img = [[FCFileAccess getSharedInstance]CopyPhoto2SandBox:uImg guid:guid];
            
            if ([imgFrame addImageMemory:img] == YES) {
                [imageArray removeObject:uImg];
                [guidArray removeObject:guid];
                res = YES;
            }
            
            if (imageArray.count == 0) {
                break;
            }
        } 
    }
    
    return res;
}
    
    @end
