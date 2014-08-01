//
//  Image.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerialAndDeserial.h"

@class ImageFrame;
/**
 * 	 	
 */
@interface Image : SerialAndDeserial {
    CGFloat angle;
    /**
	 * 在编辑器中用的是相片的小图，此变量表示小图和原图的像素缩放比
	 */
	CGFloat simpleScale;
    /**
	 * 1：前台用户创建 2：后台用户创建
	 */
	NSUInteger type;
    NSString *filePath;
     /**
	 * 0：无
	 * 1：老照片
	 * 2：黑白
	 * 3：增强
	 * 4：皮肤美白
     * 5:
     * 6:
	 */
	NSUInteger effect;
    CGFloat width;
    CGFloat height;
    CGFloat y;
    CGFloat x;    
}
@property (nonatomic, assign) CGFloat simpleScale;
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, assign) NSUInteger effect;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat angle;

-(void) Pt2Pixel;
-(void) Pixel2Pt;

-(void) setImageFrame:(CGRect)frame;
@end

