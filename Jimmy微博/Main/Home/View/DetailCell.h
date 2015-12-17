//
//  DetailCell.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "WXLabel.h"

@interface DetailCell : UITableViewCell<WXLabelDelegate>

@property (nonatomic, strong)CommentModel *commentModel;

@property (weak, nonatomic) IBOutlet UILabel *commentUserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentUserHdImageView;
@property (nonatomic, strong) WXLabel *commentTextLabel;

@end
