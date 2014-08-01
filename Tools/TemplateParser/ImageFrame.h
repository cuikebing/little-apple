//
//  ImageFrame.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrintObj.h"

@class CharContour;
@class Image;

/**
 * 图像的裁剪路径
 * 
 * 序列化：{类型名称}=({变量名称}={变量值},{变量名称}={变量值},...,clipPath=({CharContour}),
 * image=({Image}))
 */
@interface ImageFrame : PrintObj{
   	/**
	 * 1:正常   -1：垂直翻转
	 */
	NSUInteger vreversalType;
    /**
	 * 1：正常   -1：水平翻转
	 */
	NSUInteger reversalType;
    /**
	 * 0:矩形占位符  1：圆角矩形占位符 2：圆形占位符（左侧拖拽图片相当于矩形占位符+图片：placeholderType=0）
	 */
	NSUInteger placeholderType;
    NSUInteger sourceType; //新加属性
    /**
	 * 相框文件的路径
	 */
	NSString *filePath;
    CGFloat fileHeight;    
	CGFloat fileWidth;
    /**
	 * 相框文件相对于相框的坐标
	 */
   	CGFloat fileY;
	CGFloat fileX;
	/**
	 * 描边的颜色
	 */
	NSUInteger strokeClr;
    /**
	 * 描边的粗细，像素单位
	 */
	NSUInteger stroke;
    
    Image *image;
	/**
	 * 裁剪路径
	 */
	CharContour *clipPath;
}

@property (nonatomic, copy) CharContour *clipPath;
@property (nonatomic, assign) CGFloat fileHeight;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, assign) CGFloat fileWidth;
@property (nonatomic, assign) CGFloat fileX;
@property (nonatomic, assign) CGFloat fileY;
@property (nonatomic, assign) NSUInteger placeholderType;
@property (nonatomic, assign) NSUInteger reversalType;
@property (nonatomic, assign) NSUInteger stroke;
@property (nonatomic, assign) NSUInteger strokeClr;
@property (nonatomic, assign) NSUInteger vreversalType;
@property (nonatomic, retain) Image *image;

- (void) deserialize:(NSString *)strObj verId:(NSInteger)versionId;
- (NSString *)serialize;
-(void) Pt2Pixel;
-(void) Pixel2Pt;
-(BOOL) imageExist:(Image *)img;

-(BOOL) addImage:(Image *)img;
-(BOOL) addImageMemory:(Image *)img;
-(BOOL) replaceImage:(Image *)img;

-(void) resizeImage:(CGSize)newSize;
@end

