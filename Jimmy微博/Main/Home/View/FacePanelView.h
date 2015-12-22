//
//  FacePanelView.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/21.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface FacePanelView : UIView <UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    FaceView *_faceView;
    UIPageControl *_pageControl;
}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate;

@end
