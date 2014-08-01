//
//  PublicUtility.h
//  OfficeAutomation
//
//  Created by liweiwei on 12-4-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


/*!
 @function 创建提示对话框
 @discussion 创建提示对话框
*/

#import <Foundation/Foundation.h>
#define LoadStringMUI(key) NSLocalizedString(key, nil)
@class MBProgressHUD;

@interface PublicUtility : NSObject {
    MBProgressHUD *HUDView;
}

+(PublicUtility*)GetUtility;
@property (nonatomic, retain) MBProgressHUD *HUDView;

/*!
 @method showHUDViewWithString
 @abstract 显示提示框
 @discussion 显示提示框
 @param sender 提示框需要在sender上面显示
 @param str 提示框显示的文字
 */
- (void)showHUDViewWithString:(id)sender str:(NSString *)str;
/*!
 @method hiddenHUDView
 @abstract 隐藏提示框
 @discussion 隐藏提示框
 */
- (void)hiddenHUDView ;
@end
