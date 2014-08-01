//
//  CharContour.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
 

/*! 文字编辑区域一个字的描述 */
@interface CharContour : NSObject{
 
    /*! 包含多个简单路径 */
    NSMutableArray *singlePaths;
}
 
@property (nonatomic, copy) NSMutableArray *singlePaths;

-(NSString *) saveToString; 
-(void) parseString:(NSString *)str verId:(NSUInteger)versionId;
 
-(void) Pt2Pixel;
-(void) Pixel2Pt;

@end