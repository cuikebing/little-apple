//
//  OnePara.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-9-29.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


/*! 文字编辑区域一行的描述 */
@interface OnePara : NSObject {
    CGFloat width;
    
    /*! 包含多个字轮廓 */
    NSMutableArray *oneParaChars;
}

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, copy) NSMutableArray *oneParaChars;

-(void) parseString:(NSString *)str verId:(NSUInteger)versionId;
-(NSString *) saveToString;
-(void) Pt2Pixel;
-(void) Pixel2Pt;

@end
