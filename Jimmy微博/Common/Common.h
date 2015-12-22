//
//  Common.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#ifndef Common_h
#define Common_h


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//SDK Jimmy微博
#define kAppKey @"2453186634"
#define kAppSecret @"ad4ec294a3ccad031a852bbb2ef5877a"
#define kAppRedirectURI @"http://blog.sina.com.cn"

//Jimmy微博2
//#define kAppKey @"2765980707"
//#define kAppSecret @"9151c97342fe2316740fe5ed2f75c991"
//#define kAppRedirectURI @"http://open.weibo.com"


// ThemeManager NotificationName
#define kThemeChangeNotification @"kThemeChangeNotification"
#define ThemeNameKey @"ThemeNameKey"  //用来将主题存到userDefaults


//微博接口
#define unread_count @"remind/unread_count.json"  //未读消息
#define home_timeline @"statuses/home_timeline.json"  //微博列表
#define comments  @"comments/show.json"   //评论列表
#define send_update @"statuses/update.json"  //发微博(不带图片)
#define send_upload @"statuses/upload.json"  //发微博(带图片)
#define geo_to_address @"location/geo/geo_to_address.json"  //查询坐标对应的位置
#define nearby_pois @"place/nearby/pois.json" // 附近商圈
#define nearby_timeline  @"place/nearby_timeline.json" //附近动态

#define BASEURL  @"https://api.weibo.com/2/"
#define BaseUrl @"https://api.weibo.com/2/"


//微博字体
#define FontSize_Weibo(isDetail) isDetail?18:16  //微博字体
#define FontSize_ReWeibo(isDetail) isDetail?16:14 //转发微博字体



//手机版本
#define ios7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define ios8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

//identify
#define kWeiboCell @"WeiboCell"
#define kDetailCell @"DetailCell"


#endif /* Common_h */
