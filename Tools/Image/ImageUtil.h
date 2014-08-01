//
//  ImageUtil.h
//  ImageProcessing
//
//  Created by lihaifeng on 11-8-5.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

@interface ImageUtil : NSObject 

+ (UIImage*)processImage:(UIImage*)inImage withColorMatrix:(const float*)f;
+ (UIImage*)bopo:(UIImage*)inImage;
+ (UIImage*)scanLine:(UIImage*)inImage; 

+ (CGSize)sizeAfterRotate:(CGSize)srcSize rotation:(NSInteger)rotation;
+ (CGSize)sizeForRotatedImage:(UIImage *)imageToRotate rotation:(NSInteger)rotation;
+ (UIImage *)rotatedImage:(UIImage *)imageToRotate rotation:(NSInteger)rotation;

@end
