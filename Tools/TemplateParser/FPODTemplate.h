//
//  FPODTemplate.h
//  Adding Properties to Classes
//
//  Created by lyr on 12-9-26.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>  
@class PrintPage;

@interface FPODDataParser : NSObject {
    NSInteger versionId;
    
    //模板路径
    NSString *templatePath;
}

@property (nonatomic, assign) NSInteger versionId;
@property (nonatomic, retain) NSString *templatePath;

- (NSInteger)getVersionId:(NSString *)str ;
- (PrintPage *) parseOnePage: (NSString *)strPage pageIndex:(NSInteger)index;

@end

@interface FPODTemplateParser : FPODDataParser {
      //模板包含页数
    NSUInteger uPageCount;
    
    /*!PrintPage array*/
    NSMutableArray *printPageArray; 
    
    /*!page stream info dict*/
    NSMutableDictionary *dicOffsetDict;
    NSMutableDictionary *dicLengthDict;

    //模板文件内存
    NSString *srcString;
    NSString *dstString;
}

@property (nonatomic, copy) NSMutableArray *printPageArray;
@property (nonatomic, copy) NSMutableDictionary *dicOffsetDict;
@property (nonatomic, copy) NSMutableDictionary *dicLengthDict;
@property (nonatomic, assign) NSUInteger uPageCount;
@property (nonatomic, retain)NSString *srcString;

- (void) parseTemplate: (NSString *)strFileName;
- (void) parseTemplateString;
- (void) parsePages;

- (void) saveTemplate: (NSString *)strFileName;
- (void) saveTemplateToString;
- (void) savePrintPages;

- (NSString *) getPageString:(NSInteger)index;
- (PrintPage *) getPrintPage:(NSInteger)pageIndex;

- (void) fillPhotos:(NSMutableArray *)imageArray curPageIndex:(NSInteger)pageIndex;

@end


@interface FPODPageParser : FPODDataParser {       
    PrintPage *pageObj;
    NSInteger curPageIndex;
}

@property(nonatomic, assign)   NSInteger curPageIndex;
@property(nonatomic, retain) PrintPage *pageObj; 

- (id) initWithPath:(NSString *)workPath;
- (PrintPage *) parsePage: (NSInteger)pageIndex;
- (void)savePage;
- (BOOL) fillPhotos:(NSMutableArray *)imageArray guid:(NSMutableArray *)guid;

@end
