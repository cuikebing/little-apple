//
//  GroupObj.h
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrintObj.h"
 

/**
 * 序列化：{类型名称}=（{变量名称}={变量值},{变量名称}={变量值},...,children=(+{第几层组} {PrintObj}）
 */
@interface GroupObj : PrintObj{
    
    NSMutableArray *m_PrintObj; //PrintObj
    
}

@property (nonatomic, copy) NSMutableArray *m_PrintObj;

-(void)deserialize:(NSString *)strObj verId:(NSInteger)versionId;

@end
