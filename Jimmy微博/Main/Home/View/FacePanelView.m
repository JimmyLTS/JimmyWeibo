//
//  FacePanelView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/21.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "FacePanelView.h"

@implementation FacePanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatSubviews];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate {
    
    _faceView.delegate = delegate;
}

- (void)_creatSubviews {
    //01 faceView 创建完毕之后，faceView的frame会计算好
    _faceView = [[FaceView alloc]initWithFrame:CGRectZero];
    _faceView.backgroundColor = [UIColor clearColor];
    
    //02 ScrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_faceView.width, _faceView.height);
    
    //子视图超出父视图不裁剪
    _scrollView.clipsToBounds = NO;
    _scrollView.delegate = self;
    
//    _scrollView.contentInset = UIEdgeInsetsZero;
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    
    //03 pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _scrollView.bottom, kScreenWidth, 20)];
    _pageControl.numberOfPages = _faceView.pageNumber;
    _pageControl.currentPage = 0;
    //禁止掉自动设置size
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_pageControl];
    
    self.height = _scrollView.height + _pageControl.height;
    self.width = kScreenWidth;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
}

@end
