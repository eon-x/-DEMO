//
//  GoogleTestVC.h
//  googleMap
//
//  Created by xiongze on 2019/11/25.
//  Copyright © 2019 xiongze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseGoogleMap.h"

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface GoogleTestVC : UIViewController

@property (nonatomic, strong) ExerciseGoogleMap *googleMapView;

@end

NS_ASSUME_NONNULL_END
