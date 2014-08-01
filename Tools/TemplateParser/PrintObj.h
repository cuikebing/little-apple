//
//  PrintObj.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerialAndDeserial.h"

/**
 * 打印对象
 * 
 * 序列化：{类型名称}=({变量名称}={变量值},{变量名称}={变量值},...)
 */
@interface PrintObj : SerialAndDeserial {
    
    CGFloat width;
    bool selected;
    CGFloat height;
    bool editable;
    /**
	 * 角度
	 */
	CGFloat angle;
    NSUInteger alpha;
    CGFloat y;
	CGFloat x;
	
//	/**
//	 * 左上角坐标
//	 */
//	CGPoint position;

    
}  

@property (nonatomic) NSUInteger alpha;
@property (nonatomic)CGFloat angle;
@property (nonatomic)bool editable;
@property (nonatomic)CGFloat height;
//@property (nonatomic)CGPoint position;
@property (nonatomic)bool selected;
@property (nonatomic)CGFloat width;
@property (nonatomic)CGFloat x;
@property (nonatomic)CGFloat y;

-(void) Pt2Pixel;
-(void) Pixel2Pt;


@end

