//
//  ZoomImageView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/16.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "ZoomImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
#import "UIView+UIViewController.h"

@implementation ZoomImageView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initTip];
        
        [self _creatGifView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initTip];
        
        [self _creatGifView];
    }
    return self;
}

#pragma mark - 添加手势
- (void)_initTip {
    
    //01、开启响应
    self.userInteractionEnabled = YES;
    
    //02、创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_zoomInAction)];
    
    [self addGestureRecognizer:tap];
    
}

- (void)_zoomInAction {
    
    if ([self.delegate respondsToSelector:@selector(imageViewWillZoomIn:)]) {
        [self.delegate imageViewWillZoomIn:self];
    }
    
    //01、添加 scrollView 和 fullImageView
    [self _creatSubviews];
    
    //02、转换坐标，设置 fullImageView 的frame
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    //    //04、添加缩小手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOutAction)];
    [_scrollView addGestureRecognizer:tap];

    
    //03、添加缩放动画
    [UIView animateWithDuration:0.4 animations:^{
        _fullImageView.frame = _scrollView.frame;
        
    }completion:^(BOOL finished) {

        [self _loadFullImage];
    }];
    
//    //04、添加缩小手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOutAction)];
//    [_fullImageView addGestureRecognizer:tap];
    
    //05、添加长按保存图片
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
    [_fullImageView addGestureRecognizer:longPress];
}

- (void)saveImage:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"保存图片" message:@"是否保存当前图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        
        [alertView show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        UIImageWriteToSavedPhotosAlbum(_fullImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存成功");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    hud.labelText = @"保存成功";
    [hud hide:YES afterDelay:1];
}


- (void)zoomOutAction {
    [_hud hide:YES];
    
    if ([self.delegate respondsToSelector:@selector(imageViewWillZoomOut:)]) {
        [self.delegate imageViewWillZoomOut:self];
    }
    
    _scrollView.backgroundColor = [UIColor clearColor];

    [UIView animateWithDuration:0.4 animations:^{
        
        _scrollView.contentOffset = CGPointZero;
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
    }];
    
}

#pragma mark - 下载图片
- (void)_loadFullImage {
    if (_fullUrlString != nil) {
        
        //设置进度条
        _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        
        //        //01、直接设置图片，无网络请求过程
        //        NSURL *url = [NSURL URLWithString:_fullUrlString];
        //        [_fullImageView sd_setImageWithURL:url];
        
        //02、使用 NSURLSession 获取网络图片
        [self _downloadFullImageSession];
        
        //03、使用 NSURLConnection 获取网络图片
//        [self _downloadFullImageConnection];
        
    }

}


#pragma mark - NSURLSession 获取图片
- (void)_downloadFullImageSession {
    
    NSURL *url = [NSURL URLWithString:_fullUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    //初始化 _fullImageData
    _fullImageData = [[NSMutableData alloc]init];
    
    //获取文件大小
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *httpHeader = [httpResponse allHeaderFields];
    _dataLength = [[httpHeader objectForKey:@"Content-Length"] floatValue];
    NSLog(@"%@", httpHeader);
    
    completionHandler(NSURLSessionResponseAllow);
    
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [_fullImageData appendData:data];
    
    CGFloat progress = _fullImageData.length/_dataLength;
    
    _hud.progress = progress;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    //隐藏进度条
    [_hud hide:YES];
    
    UIImage *image = [UIImage imageWithData:_fullImageData];
    _fullImageView.image = image;
    
    [self setFrameForLongImage:image];
    
    [self showGifImageView];
    
    _fullImageData = nil;
    
}

#pragma mark - NSURLConnection 获取图片
- (void)_downloadFullImageConnection {
    
    NSURL *url = [NSURL URLWithString:_fullUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    
    //        [connection start];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //初始化 _fullImageData
    _fullImageData = [[NSMutableData alloc]init];
    
    //获取文件大小
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *httpHeader = [httpResponse allHeaderFields];
    _dataLength = [[httpHeader objectForKey:@"Content-Length"] floatValue];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_fullImageData appendData:data];
    
    CGFloat progress = _fullImageData.length/_dataLength;
    
    _hud.progress = progress;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //隐藏进度条
    [_hud hide:YES];
    
    UIImage *image = [UIImage imageWithData:_fullImageData];
    _fullImageView.image = image;
    
    [self setFrameForLongImage:image];
    
    [self showGifImageView];
    
    _fullImageData = nil;
}

#pragma mark - 判断是否为长图，设置长图尺寸
- (void)setFrameForLongImage:(UIImage *)image {
    //长图处理
    //图片在屏幕上显示宽/高 ==  图片的宽/图片的高
    CGFloat length = image.size.height/image.size.width* kScreenWidth;
    
    if (length > kScreenHeight) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
            _scrollView.showsVerticalScrollIndicator = YES;
        }];
        
    }

}

#pragma mark - 判断是否为gif图片
- (void)showGifImageView {
    //显示gif
    if (_gifImageView.hidden == NO) {
        
        //方法一：用webview显示
        
//        UIWebView *webView = [[UIWebView alloc]initWithFrame:_scrollView.bounds];
//        
//        [webView loadData:_fullImageData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//        [_scrollView addSubview:webView];
        
        //方法二：用底层方法
        _fullImageView.image = [UIImage sd_animatedGIFWithData:_fullImageData];
        
        //方法三：底层接口实现原理
        //获取图片源
//        CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)_fullImageData, nil);
//        
//        //获取图片个数
//        size_t count = CGImageSourceGetCount(imageSourceRef);
//        
//        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
//        for (int i = 0; i < count; i++) {
//            //从图片源中获取每张图片
//            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, i, nil);
//            
//            UIImage *image = [UIImage imageWithCGImage:imageRef];
//            
//            [imageArray addObject:image];
//            
//            CGImageRelease(imageRef);
//
//        }
        
        //播放多张图片01：imageView.animationImages
//        _fullImageView.animationImages = imageArray;
//        _fullImageView.animationDuration = imageArray.count * 0.1;
//        [_fullImageView startAnimating];
        
        //播放多张图片02：
//        UIImage *animatImage = [UIImage animatedImageWithImages:imageArray duration:imageArray.count * 0.1];
//        _fullImageView.image = animatImage;
//        
//        CFRelease(imageSourceRef);
        
    }
    
}

#pragma mark - 添加 scrollView 和 fullImageView
- (void)_creatSubviews {
    
    //01、创建 scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    //设置放大倍数
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    
    [self.window addSubview:_scrollView];
    
    //02、创建 fullImageView
    _fullImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    _fullImageView.userInteractionEnabled = YES;
    
    _fullImageView.image = self.image;
    
    
    [_scrollView addSubview:_fullImageView];
}

- (void)_creatGifView {
    
    _gifImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    _gifImageView.image = [UIImage imageNamed:@"timeline_gif"];
    
    _gifImageView.hidden = YES;
    
    [self addSubview:_gifImageView];
    
}

#pragma mark - ScrollViewDelegate
//返回要缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _fullImageView;
}

@end
