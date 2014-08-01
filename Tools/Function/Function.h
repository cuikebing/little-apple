//
//  Function.h
//  Common
//  Global function
//
//  Created by ckb on 10-5-12.
//  Copyright 2010 Founder International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointPath.h" 


bool FGRectFromString(NSString *str, CGRect *rect);
bool FGPointFromString(NSString *str, CGPoint *point);

void ShowAlertMsg(NSString *showContent);
void ShowAlertMsgWithCancle(NSString *showContent);
NSString *CurrTimeFormat(NSString *title);
NSString *GetFormatSize(float size);
UIImage *newImageNotCached(NSString *filepath);
CGPathRef GetSVGClipPath(NSString *filepath);
void gzipUnpack(NSString *srcPath ,NSString* desPath);
UIViewController*getEditorInstance();
UIColor *Int2UIColor();
NSInteger UIColor2Int();

CGPathRef PointPath2CGPathRef(PointPath *path);
PointPath *CGPathRef2PointPath(CGPathRef ref);
CGPathRef Frame2CGPathRef(CGRect frame);

UIImage *reSizeImage(UIImage *image ,CGSize reSize);