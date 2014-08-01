//
//  FPODPoint.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum tagPointType {
    POD_TT_PRIM_NONE = 0,
    POD_TT_PRIM_LINE,
    POD_TT_PRIM_QSPLINE,
    POD_TT_PRIM_CSPLINE
} PointType;

/*! 文字编辑区域一个字的点的描述 */ 
@interface FPODPoint : NSObject {
    CGFloat x;
    CGFloat y;
    PointType  type;
}

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) PointType  type;
 
 
-(void) parseString:(NSString *)str verId:(NSUInteger) versionId;
-(NSString *) saveToString;

-(void) Pt2Pixel;
-(void) Pixel2Pt;

@end