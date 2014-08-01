//
//  Text.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrintObj.h"

@class ParaContour;

@interface ParaContourString : NSObject {
    NSString *str;
}
@property(nonatomic, retain) NSString *str;

@end
/**
 * 文字
 * 序列化：{类型名称}=({变量名称}={变量值},{变量名称}={变量值},...,paraContour=({ParaContour}))
 */
@interface Text : PrintObj{
    
	/**
	 * 文字颜色
	 */
	NSInteger color;
	/**
	 * 字体
	 */
	NSString *fontName;
	/**
	 * 字号
	 */
	NSUInteger fontSize;
	/**
	 * 0：常规   2：粗体  3：斜体  4：粗斜体
	 */
	NSUInteger fontStyle;
	/**
	 * 行间距
	 */
    CGFloat lineSpace;
	/**
	 * 字轮廓
	 */
	ParaContour *paraContour;
	/**
	 * 字间距
	 */
	CGFloat spacing;
	/**
	 * 文本
	 */
	NSString *text;
	/**
	 * 1:靠左  2：居中 3：靠右
	 */
	NSUInteger typeset;
    
    
    ParaContourString *paraContourStr;
}

@property (nonatomic, assign) NSInteger color;
@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, assign) NSUInteger fontStyle;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, copy) ParaContour *paraContour;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) NSUInteger typeset;
@property (nonatomic, copy)ParaContourString *paraContourStr;

- (void)deserialize:(NSString *)strObj verId:(NSInteger)versionId;
- (NSString *)serialize;
-(void) Pt2Pixel;
-(void) Pixel2Pt;
@end

