//
//  ParaContour.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
 
/**
 * 字轮廓/文字区域的描述
 */
@interface ParaContour : NSObject {
    CGFloat width;
    CGFloat height;
    
    /*! 包含多个单行段落 */
    NSMutableArray *paras;
}

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSMutableArray *paras;

 
-(void) parseString:(NSString *)str verId:(NSUInteger)versionId;
-(NSString *) saveToString;
-(void) Pt2Pixel;
-(void) Pixel2Pt;

@end
