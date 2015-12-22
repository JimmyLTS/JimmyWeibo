//
//  FaceView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/21.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

#define item_width (kScreenWidth/7.0) //单个表情占的宽度
#define item_height 45 //单个表情占的区域高度
#define face_height 30 //表情图片的宽度
#define face_width 30 //表情图片的高度

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initData];
    }
    return self;
}

- (NSInteger)pageNumber {
    return _pageArray.count;
}

- (void)_initData {
    
    //二维数组，存放4个一维数组
    _pageArray = [[NSMutableArray alloc]init];
    
    //01、先把表情信息读取到一维数组
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    //02、把一维数组数据导入到二维数组
    
    //一页的表情个数
    NSInteger countOfOnePage = 28;
    //页数
    NSInteger pageNumber = emoticons.count/countOfOnePage;
    if (emoticons.count%countOfOnePage != 0) {
        pageNumber+=1;
    }
    
    for (int i = 0; i < pageNumber; i++) {
        NSRange range = NSMakeRange(countOfOnePage * i, countOfOnePage);
        
        NSInteger sub = emoticons.count - i*28;
        if (sub < 28) {
            //最后一页表情的个数
            range = NSMakeRange(countOfOnePage * i, sub);
        }
        
        NSArray *array2D = [emoticons subarrayWithRange:range];
        
        [_pageArray addObject:array2D];
        
    }
    
    self.height = item_height * 4;
    self.width = kScreenWidth * pageNumber;
    
    //03、放大表情视图
    //创建放大镜背景视图
    _magnifierView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 92)];
    _magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
    _magnifierView.backgroundColor = [UIColor clearColor];
    _magnifierView.hidden = YES;
    
    [self addSubview:_magnifierView];
    
    //放大镜中的表情
    UIImageView *faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_magnifierView.width-face_width)/2, 15, face_width, face_height)];
    faceImageView.backgroundColor = [UIColor clearColor];
    faceImageView.tag = 100;
    [_magnifierView addSubview:faceImageView];
    
}

- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < _pageArray.count; i++) {
        
        //存放一页表情数据
        NSArray *item2D = _pageArray[i];
        for (int j = 0; j < item2D.count; j++) {
            
            //01 表情信息字典，拿出表情
            NSDictionary *item = item2D[j];
            NSString *imgName = item[@"png"];
            UIImage *image = [UIImage imageNamed:imgName];
            
            //02 计算表情坐标
            NSInteger row = j/7; //第几行
            NSInteger column = j%7; //第几列
            
            CGFloat x = column * item_width + (item_width - face_width)/2 + kScreenWidth * i;
            CGFloat y = row*item_height + (item_height-face_height)/2;
            
            CGRect imgFrame = CGRectMake(x, y, face_width, face_height);
            
            //03 绘制表情
            [image drawInRect:imgFrame];
            
        }
    }
    
}

- (void)touchFace:(CGPoint)point {
    //1、计算第几页
    NSInteger page = point.x / kScreenWidth;
    
    //2、计算出是某一页的第几行、第几列
    NSInteger row = (point.y - (item_height - face_height)/2)/item_height;
    
    NSInteger column = (point.x - ((item_width - face_width)/2 + page * kScreenWidth))/item_width;
    
    //3、安全纠正
    if (column > 6) {
        column = 6;
    }
    if (column < 0) {
        column = 0;
    }
    if (row < 0) {
        row = 0;
    }
    if (row > 3) {
        row = 3;
    }
    
    //4、通过行列计算出是哪个表情
    
    NSArray *item2D = [_pageArray objectAtIndex:page];
    NSInteger index = row*7+column;
    
    if (index >= item2D.count) {
        return;
    }
    
    //5、取得表情
    NSDictionary *item = [item2D objectAtIndex:index];
    //表情图片名字 001.png
    NSString *imageName = [item objectForKey:@"png"];
    //表情名字
    NSString *faceName = [item objectForKey:@"chs"];
    
    if (![_selectedFaceName isEqualToString:faceName]) {
        _selectedFaceName = faceName;
        NSLog(@"表情名字%@", faceName);
        
        CGFloat x = column * item_width + page * kScreenWidth + item_width/2;
        CGFloat y = row * item_height + item_height/2;
        
        _magnifierView.center = CGPointMake(x, 0);
        _magnifierView.bottom = y;
        
        UIImageView *faceImgView = (UIImageView *)[_magnifierView viewWithTag:100];
        faceImgView.image = [UIImage imageNamed:imageName];
    }
}

#pragma mark - UITouch 方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_magnifierView setHidden:NO];
    
    //ScrollView 禁止滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        scrollView.scrollEnabled = NO;
    }
    
    //取得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //处理，根据x、y来计算是哪个表情
    [self touchFace:point];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_magnifierView setHidden:YES];
    
    //取消ScrollView禁止滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    
    //取得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
    
    if ([self.delegate respondsToSelector:@selector(faceDidSelect:)]) {
        [self.delegate faceDidSelect:_selectedFaceName];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //取得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
}

@end


