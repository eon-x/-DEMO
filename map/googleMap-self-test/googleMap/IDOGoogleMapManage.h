//
//  IDOGoogleMapManage.h
//  googleMap
//
//  Created by xiongze on 2019/11/25.
//  Copyright © 2019 xiongze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDOGoogleMapManage : NSObject

/// 添加地图
/// @param latitude 经度
/// @param longitude 纬度
/// @param zoom 展示大小
- (UIView *)addMapWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude zoom:(float)zoom;

/// 添加线段
/// @param lineArray 线段数组，数组里面为 {@"lat":@"44.134271", @"lng":@"9.685005"} 字典
- (void)addMapLineWithArray:(NSArray *)lineArray;

/// 设置线段颜色，各产品需求不同，这里只做示例，后期按需求修改
/// @param lineColorArray 线段颜色数组，应该和线段数据梳理相同，数组里面为 {@"elevation":@"88.30000305175781"} 字典
- (void)addMapLineColorWithArray:(NSArray *)lineColorArray;

/// 添加一个公里牌标记
/// @param position 经纬度
/// @param title 默认展示文本，通常为1、2、3...
/// @param sTitle 点击之后显示的气泡文本，传空不显示
- (GMSMarker *)makeGMSMarkerWithPoint:(CLLocationCoordinate2D)position title:(NSString *)title showTitle:(NSString *)sTitle;


/// 添加一个icon标记
/// @param position 经纬度
/// @param image image对象
/// @param sTitle 点击之后显示的气泡文本，传空不显示
- (GMSMarker *)makeImageMarkerWithPoint:(CLLocationCoordinate2D)position image:(UIImage *)image showTitle:(NSString *)sTitle;

/// 添加一个新的定位点
/// @param position 经纬度
- (void)addNewPointWithLocation:(CLLocationCoordinate2D)position;

/// 轨迹点数组
@property (nonatomic,strong)NSMutableArray *trackArray;

@end

NS_ASSUME_NONNULL_END


/*

谷歌地图划线由线段数组GMSPolyline 和颜色数组spans 组成；
每添加一个线段就会有一个颜色


*/
