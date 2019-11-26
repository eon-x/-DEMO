//
//  GaoDeTestVC.h
//  googleMap
//
//  Created by xiongze on 2019/11/25.
//  Copyright © 2019 xiongze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseGDMap.h"

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface GaoDeTestVC : UIViewController

@property (nonatomic, strong) ExerciseGDMap *gdMapView;//高德地图

@end

NS_ASSUME_NONNULL_END
