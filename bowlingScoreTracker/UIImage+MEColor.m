//
//  UIImage+MEColor.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/27/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//
//  Grabbed from ioscodesnippet
//  http://ioscodesnippet.com/2011/08/22/creating-a-placeholder-uiimage-dynamically-with-color/

#import "UIImage+MEColor.h"

@implementation UIImage (MEColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
