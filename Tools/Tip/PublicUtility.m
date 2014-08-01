//
//  PublicUtility.m
//  OfficeAutomation
//
//  Created by liweiwei on 12-4-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PublicUtility.h"
#import "MBProgressHUD.h"

@implementation PublicUtility
@synthesize HUDView;
+(PublicUtility*)GetUtility
{
	static PublicUtility* publicUtility = nil;
	if(publicUtility == nil) {
		publicUtility = [PublicUtility alloc];
	}
	return publicUtility;
}

-(void)dealloc
{
    if (!HUDView) {
        [self hiddenHUDView];
    }
	[super dealloc];
}


- (void)showHUDViewWithString:(id)sender str:(NSString *)str {
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
        UIViewController *ctl = (UIViewController *)sender;

		if (!HUDView) {
			HUDView = [[MBProgressHUD alloc] initWithView:ctl.view];
		}
    
   // HUDView.center = ctl.view.center;
    HUDView.customString = str;
	HUDView.animationType = MBProgressHUDAnimationFade ;
	HUDView.mode = MBProgressHUDModeNSString;
	[ctl.view addSubview:HUDView];
    [HUDView show:YES];
	
	[self performSelector:@selector(hiddenHUDView) withObject:nil afterDelay:3];
}


- (void)hiddenHUDView {

	if (HUDView) {
		[HUDView hide:YES];
		[HUDView removeFromSuperview];
		[HUDView release];
		HUDView = nil;
	}
}
@end
