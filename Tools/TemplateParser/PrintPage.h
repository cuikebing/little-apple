//
//  PrintPage.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PrintObj;

/**
 * 打印页
 * 序列化：（{页面宽}，{页面高}，{最大编辑区宽}，{最大编辑区高}）{页面名称}=（{PrintObj};{PrintObj};...）
 */
@interface PrintPage : NSObject { 
    
    NSMutableArray *printObjs; //PrintObj
    NSString *name;
    /**
	 * 0：内页
	 * 1：封面
	 * 2：封底
	 * 3：封面-封底
	 */
    NSUInteger type;
    CGFloat width;
    CGFloat height;
    CGFloat maxEditWidth;
    CGFloat maxEditHeight;
}

@property (nonatomic, copy) NSMutableArray *printObjs;
@property(nonatomic, retain) NSString *name;
@property NSUInteger type;
@property CGFloat width;
@property CGFloat height;
@property CGFloat maxEditWidth;
@property CGFloat maxEditHeight;

- (void) parseString:(NSString *)pageStr pageNum:(NSInteger)pageNum verId:(NSInteger)versionId;
- (NSString *) saveToString;
-(void) Pt2Pixel;
-(void) Pixel2Pt;

-(void)up:(PrintObj *)printObj;
-(void)down:(PrintObj *)printObj;
-(void)deletePrintObj:(NSUInteger)index;

@end

