//
//  FileObj.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrintObj.h"

/**
 * 文件对象-代表嵌入到当前文档中的对象
 * 有以下分类：
 * 2. 图片
 * 1. 装饰元件
 * 0. 背景
 */
@interface FileObj : PrintObj {
	/**
	 * 1.正常  -1.垂直翻转
	 */
	NSUInteger vreversalType;
    /**
	 * 1.正常  -1：水平翻转
	 */
	NSUInteger reversalType;
    NSUInteger dbId;
    NSUInteger scale; //新加属性
	/**
	 * 0: 背景
	 * 1: 装饰原件
	 * 2: image
	 * 3：装饰相框
	 */
	NSUInteger fileType;
    NSString *filePath;

    
}


@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, assign) NSUInteger fileType;
@property (nonatomic, assign) NSUInteger reversalType;
@property (nonatomic, assign) NSUInteger vreversalType;
@property (nonatomic, assign) NSUInteger scale;
@property (nonatomic, assign) NSUInteger dbId;

@end

