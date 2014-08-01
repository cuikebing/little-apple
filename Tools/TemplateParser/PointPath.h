//
//  PointPath.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 文字编辑区域一个字的路径描述 */
@interface PointPath : NSObject {
    CGFloat width;
    CGFloat height;
    NSMutableArray *pointArray;
}

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSMutableArray *pointArray;

 
-(void) parseString:(NSString *)str verId:(NSUInteger)versionId;
-(NSString *) saveToString;
-(void) Pt2Pixel;
-(void) Pixel2Pt;

@end

