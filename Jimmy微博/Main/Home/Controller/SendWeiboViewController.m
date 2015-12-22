//
//  SendWeiboViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/18.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "MMDrawerController.h"
#import "ThemeManager.h"
#import "NetworkService.h"
#import "UIViewExt.h"
#import "TabBarButton.h"
#import "FacePanelView.h"
#import "UIProgressView+AFNetworking.h"

@interface SendWeiboViewController () {
    UITextView *_textView; //文本编辑栏
    ZoomImageView *_imageView; //图片
    UIView *_toolView; //工具栏
    
    UIProgressView *_progressView; //发送进度
    FacePanelView *_facePanel;
}

@end

@implementation SendWeiboViewController

- (void)viewWillAppear:(BOOL)animated {
    [_textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[ThemeManager shareManager]getThemeColor:@"More_Item_color"];
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"发送微博";
    //创建导航栏按钮
    [self _creatNavItems];
    //创建文本输入框
    [self _creatTextView];
    
    [self _creatEditView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark - 创建导航栏按钮
- (void)_creatNavItems {
    
    UIImage *leftImage = [[ThemeManager shareManager]getThemeImage:@"button_icon_close"];
    UIImage *rightImage = [[ThemeManager shareManager]getThemeImage:@"button_icon_ok"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(okAction)];
}

#pragma mark - 创建文本输入框和ImageView
- (void)_creatTextView {
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _textView.backgroundColor = [UIColor lightGrayColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:20];
    
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [self.view addSubview:_textView];
    
    _imageView = [[ZoomImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _imageView.top = _textView.bottom + 5;
    _imageView.layer.borderWidth = 1;
    _imageView.delegate = self;
    _imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_imageView];
    _imageView.hidden = YES;
}

#pragma mark - 创建工具栏
- (void)_creatEditView {
    
    _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 64 - 50, kScreenWidth, 50)];
    
    _toolView.backgroundColor = [UIColor clearColor];
    CGFloat buttonWidth = kScreenWidth/5;
    for (int i = 1;i < 6; i++) {
        TabBarButton *editButton = [[TabBarButton alloc]initWithFrame:CGRectZero];
        if (i == 1) {
            editButton.frame = CGRectMake(0, 0, buttonWidth, 50);
            editButton.normalImageName = @"compose_toolbar_1";
            [_toolView addSubview:editButton];
        }else if (i>1){
            editButton.frame = CGRectMake(buttonWidth * (i - 1), 0, buttonWidth, 50);
            editButton.normalImageName = [NSString stringWithFormat:@"compose_toolbar_%i", i+1];
            [_toolView addSubview:editButton];

        }
        editButton.tag = i*10;
        [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:_toolView];
    
    
    //4 . 表情面板
    
    _facePanel = [[FacePanelView alloc] initWithFrame:CGRectZero];
    [_facePanel setFaceViewDelegate:self];
    _facePanel.top = kScreenHeight - 64;
    [self.view addSubview:_facePanel];
    
}

#pragma mark - 编辑按钮点击事件
- (void)editButtonAction:(TabBarButton *)editButton {
 
    if (editButton.tag == 10) {
        [self _selectPhoto];
    }else if (editButton.tag == 50) {
        if (_textView.isFirstResponder) {
            
            [_textView resignFirstResponder];
            [self _showFacePanel];
        }else{
            [self _hideFacePanel];
            [_textView becomeFirstResponder];
            
        }
    }
}

#pragma mark - 导航栏按钮点击事件
//取消
- (void)closeAction {
    [_textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发送微博
- (void)okAction {
    
    if (_textView.text.length > 0) {
        
        NSURLSessionDataTask *task = [NetworkService sendWeibo:_textView.text image:_imageView.image block:^(id result, NSURLResponse *response, NSError *error) {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        
        //进度显示
        if (_progressView == nil) {
            
            _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            _progressView.frame = CGRectMake(0, 0,kScreenWidth, 20);
            
            _progressView.progress = 0.0;
            
            [self.view addSubview:_progressView];
            
        }
        
        
        [_progressView setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask *)task animated:YES];
        
    }
    
}

#pragma mark - 表情面板处理
- (void)_showFacePanel{
    [UIView animateWithDuration:0.3 animations:^{
        
        _facePanel.bottom = kScreenHeight-64;
        _toolView.bottom = _facePanel.top;
        
    }];
    
    
}
- (void)_hideFacePanel{
    
    [UIView animateWithDuration:0.3 animations:^{
        _facePanel.top = kScreenHeight-64;
        
    }];
    
    
}

- (void)faceDidSelect:(NSString *)faceName{
    
    NSString *text = _textView.text;
    NSString *newText = [NSString stringWithFormat:@"%@%@",text,faceName];
    _textView.text = newText;
    
    
}


#pragma mark - 选择图片
- (void)_selectPhoto {
    
    UIAlertController *selectAction = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _photoPicker:NO];
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _photoPicker:YES];
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [selectAction addAction:actionPhoto];
    [selectAction addAction:actionCamera];
    [selectAction addAction:actionCancel];
    
    [self presentViewController:selectAction animated:YES completion:nil];
}

- (void)_photoPicker:(BOOL)isCamera {
    
    UIImagePickerControllerSourceType sourceType;
    
    if (isCamera) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
        BOOL isCameraAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        
        if (!isCameraAvailable) {
            NSLog(@"相机不可用");
            return;
        }
        
    }else {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//UIImagePickerController 代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    //00 弹出视图控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //01 得到图片
    _imageView.hidden = NO;
    _imageView.image = image;
}


#pragma mark - ZoomImageViewDelegate 
//图片将要放大
- (void)imageViewWillZoomIn:(ZoomImageView *)imageView {
    [_textView resignFirstResponder];
}

//图片将要缩小
- (void)imageViewWillZoomOut:(ZoomImageView *)imageView {
    [_textView becomeFirstResponder];
}

#pragma mark - keyBoardShow 改变工具栏位置
- (void)keyBoardShow:(NSNotification *)notification {
    
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect frame = [value CGRectValue];
    
    _toolView.bottom = frame.origin.y - 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
