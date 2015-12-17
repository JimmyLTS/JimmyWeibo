//
//  UIView+UIViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    
    while (next) {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

@end
