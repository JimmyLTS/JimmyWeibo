//
//  FaceView.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/21.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

- (void)faceDidSelect:(NSString *)faceName;

@end

@interface FaceView : UIView {
    
    NSMutableArray *_pageArray; //二维数组
    NSString *_selectedFaceName; //选中的表情名字
    UIImageView *_magnifierView; //放大镜视图
    
}

@property (nonatomic,weak)id<FaceViewDelegate> delegate;
@property (nonatomic,readonly)NSInteger pageNumber;

@end
