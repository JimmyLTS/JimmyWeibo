//
//  TabBarButton.h
//  时光网
//
//  Created by imac on 15/10/31.
//  Copyright © 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarButton : UIButton

@property (nonatomic, copy)NSString *normalImageName;
@property (nonatomic, copy)NSString *highlightImageName;
@property (nonatomic, copy)NSString *selectImageName;
@property (nonatomic, copy)NSString *normalTitleColorName;
@property (nonatomic, copy)NSString *hightlightTitleColorName;

@end
