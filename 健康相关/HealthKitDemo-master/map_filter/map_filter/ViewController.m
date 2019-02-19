//
//  ViewController.m
//  map_filter
//
//  Created by zqwl001 on 16/8/3.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>
#import "showView.h"
@implementation NSArray (LJWExtension)

- (LJWArrayMap)map{
    LJWArrayMap map = ^id(LJWItemMap itemMap){
        
        NSMutableArray *items = @[].mutableCopy;
        for (id item in self) {
            NSLog(@"item %@", item);
            [items addObject:itemMap(item)];
        }
        
        return items;
    };
    return map;
}
- (LJWArrayFilter)filter{
    LJWArrayFilter filter = ^(LJWItemFilter itemFilter){
        NSMutableArray *items = @[].mutableCopy;
        for (id item in self) {
            if (itemFilter(item)) {
                [items addObject:item];
            }
        }
        return items;
    };
    return filter;
}

// 重写setter方法保证block不会被外部修改实现。
-(void)setFilter:(LJWArrayFilter)filter{}
- (void)setMap:(LJWArrayMap)map{}

//- (LJWArrayFilter)filter{
//}

@end

@interface ViewController ()
@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic, strong) showView *showView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSArray <NSNumber *> * numbers = @[@1, @3, @4, @44, @43, @86, @12];
//    NSArray *result = numbers.filter(^BOOL(NSNumber *number){
//        return number.doubleValue > 20;
//    });
//   NSArray *result2 = result.map(^id(NSNumber *number) {
//        return[NSString  stringWithFormat:@"string %g", number.doubleValue];
//    });
//        NSLog(@"result %@", result2);

    
    
    
     
    self.showView = [showView loadView];
    self.showView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.showView];
    [self.showView.btn addTarget:self action:@selector(writeStepNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.healthStore = [[HKHealthStore alloc] init];
  
    NSLog(@"%d",[HKHealthStore isHealthDataAvailable]);
    // 判读是否有权限
    if ([HKHealthStore isHealthDataAvailable]){
     // 请求权限
        
        // 分享类型
        /*
         
         HealthKit对象主要分为2类：特征和样本。特征对象代表一些基本不变的数据。包括用户的生日、血型和生理性别。你的应用不能保存特征数据。用户必须通过健康应用来输入或者修改这些数据。
         
         ************* HKObjectType 含有一些样本类型 ****************
         
         1.  类别样本。这种样本代表一些可以被分为有限种类的数据。在iOS8.0中，只有一种类别样本，睡眠分析。更多信息，参见HKCategorySample Class Reference。
         
         2.  数量样本。这种样本代表一些可以存储为数值的数据。数量样本是HealthKit中最常见的数据类型。这些包括用户的身高和体重，还有一些其他数据，例如行走的步数，用户的体温和脉搏率。更多信息，参见HKQuantitySample Class Reference。
         
         3.  Correlation。这种样本代表复合数据，包含一个或多个样本。在iOS8.0中，HealthKit使用correlation来代表食物和血压。在创建书屋或者血压数据时，你应该使用correlation。更多信息，参见 HKCorrelation Class Reference。
         
         4.  Workout。Workout代表某些物理活动，像跑步、游泳，甚至游戏。Workout通常有类型、时长、距离、和消耗能量这些属性。你还可以为一个workout关联许多详细的样本。不像correlation，这些样本是不包含在workout里的。但是，它们可以通过workout获取到。更多信息，
         
         *********** 向HealthKit 存储中添加样本 ********************
         
         你的应用可以创建新的样本，并添加到HealthKit存储中。对所有样本类型来说，大致的过程都是类似的，但是又有一些不同。
         
         1.  在 HealthKit Constants Reference 中找到正确的类型标识符。
         
         2.  使用类型标识符创建一个匹配的 HKObjectType 子类。有一些便捷的方法，参见  HKObjectType Class Reference。
         
         3.  使用对象类型，创建一个匹配的 HKSample 子类。
         
         4.  使用 saveObject:withCompletion: 方法将对象保存到HealthKit 存储中。
        
         对于数量样本，你必须创建一个 HKQuantity  类的实例。数量的单位必须和类型标识符文档中描述的可用单位相关。例如，HKQuantityTypeIdentifierHeight 文档中说明它使用长度单位，因此，你的数量必须使用厘米、米、英尺、英寸或者其他长度单位。
         
         对于类别样本，它的值必须和类型标识符文档中描述的枚举值相关。例如， HKCategoryTypeIdentifierSleepAnalysis 文档中说明它使用 HKCategoryValueSleepAnalysis 枚举值。因此你在创建样本时必须从这个枚举中传递一个值。
         
         对于correlation，你必须先创建correlation包含的所有样本。correlation的类型标识符描述了它可以包含的类型和对象的数量。不要把被包含的对象存进HealthKit。它们是以correlation的一部分存储的。
         
         workout和其他类型的样本有些不同。首先，创建 HKWorkoutType 实例并不需要指定类型标识符。所有的workout都是用同样的类型标识符。第二，对于每个workout你都需要提供一个 HKWorkoutActivityType 值。这个值定义了workout中执行的活动的类型。最后，当workout保存到HealthKit后，你可以给workout关联额外的样本。这些样本提供了workout的详细信息。
         
         *********** 读取HealthKit数据 ********************
         读取HealthKit数据
         HealthKit提供了许多方法来读取数据。
         
         1.  直接方法调用。HealthKit提供了直接读取特征数据的方法。这些方法只能用于读取特征数据。
             HKHealthStore
         
         2.  样本查询。这是使用最多的查询。使用样本查询来读取任何类型的样本数据。当你想要对结果进行排序或者限制返回的样本总数时，样本查询就特别有用。
             HKSampleQuery
         
         3.  观察者查询。这是一个长时间运行的查询，它会检测HealthKit存储，并在匹配到的样本发生变化时通知你。如果当存储发生变化时你想得到通知，就使用观察者查询。你可以让这些查询在后台执行。
             HKObserverQuery
         
         4.  锚定对象查询。用这种查询来搜索添加进存储的项。当锚定查询第一次执行时，会返回存储中所有匹配的样本。在接下来的执行中，只会返回上一次执行之后添加的项目。通常，锚定对象查询会和观察者查询一起使用。观察者查询告诉你某些项目发生了变化，而锚定对象查询来决定有哪些（如果有的话）项目被添加进了存储。
             HKAnchoredObjectQuery
         
         5.  统计查询。使用这种查询来在一系列匹配的样本中执行统计运算。你可以使用统计查询来计算样本的总和、最小值、最大值或平均值。
             HKStatisticsQuery
         
         6.  统计集合查询。使用这种查询来在一系列长度固定的时间间隔中执行多次统计查询。通常使用这种查询来生成图表。查询提供了一些简单的方法来计算某些值，例如，每天消耗的总热量或者每5分钟行走的步数。统计集合查询是长时间运行的。查询可以返回当前的统计集合，也可以监测HealthKit存储，并对更新做出响应。
             HKStatisticsCollectionQuery
         
         7.  Correlation查询。使用这种查询来在correlation查找数据。这种查询可以为correlation中每个样本类型包含独立的谓词。如果你只是想匹配correlation类型，那么请使用样本查询。
             HKCorrelation
         
         8.  来源查询。使用这种查询来查找HealthKit存储中的匹配数据的来源（应用和设备）。来源查询会列出储存的特定样本类型的所有来源。
             HKSourceQuery
         
         *********** 单位换算 ********************
         
         HealthKit使用 HKUnit 和 HKQuantity 类来支持单位。HKUnit 提供了单一单位的表示。它支持大部分的公制和英制单位，当然还包括基本单位和符合单位。基本单位代表单一的度量，例如米、磅或者秒。复合单位使用数学运算连接一个或多个基本单位，例如m/s或者lb/ft2。
         
         HKUnit 提供了便捷方法来创建HealthKit支持的所有基本单位。它还提供了构建复合单位需要的数学运算。最后，你还可以通过直接使用恰当的格式化的单位字符串来创建复合单位。
         
         HKQuantity 类存储了给定单位的值。之后你可以用任何兼容的单位来取值。这样，你的应用就可以很轻松的完成单位换算。
         在某些场合，你可以使用格式化器来本地化数量。iOS8提供了提供了新的格式化器来处理长度（NSLengthFormatter）、质量（NSMassFormatter）和能量（NSEnergyFormatter）。对于其他的数量，你需要自己来换算单位和本地化数据
         */

        HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSSet *shareSet = [NSSet setWithObjects:sampleType, nil];
        
        HKQuantityType *read = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSSet *readSet = [NSSet setWithObjects:read, nil];
        
        [self.healthStore requestAuthorizationToShareTypes:shareSet readTypes:readSet completion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@" 请求权限成功");
            } else{
                NSLog(@"error %@", error);
            }
        }];
        
    };
    
    // 获取步数
    [self getTodyStepNumberForHealthKit];
    
      /*
       
       性别，年龄，
       
       NSError *error;
       HKBiologicalSexObject *bioSex = [healthStore biologicalSexWithError:&error];
       
       switch (bioSex.biologicalSex) {
       case HKBiologicalSexNotSet:
       // undefined
       break;
       case HKBiologicalSexFemale:
       // ...
       break;
       case HKBiologicalSexMale:
       // ...
       break;
       }
        
       
       体重
       // Some weight in gram
       double weightInGram = 83400.f;
       
       // Create an instance of HKQuantityType and
       // HKQuantity to specify the data type and value
       // you want to update
       NSDate          *now = [NSDate date];
       HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
       HKQuantity      *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:weightInGram];
       
       // Create the concrete sample
       HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
       quantity:hkQuantity
       startDate:now
       endDate:now];
       
       // Update the weight in the health store
       [healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
       // ..
       }];
       
       
       */
    
   
    
}
- (void)writeStepNumber:(UIButton *)btn {
    // 写入步数数据
    
    if (self.showView.addStepNumberTextField.text.length <= 0) {
        [self.view endEditing:YES];
        UIAlertView *doneAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [doneAlertView show];
        //刷新数据  重新获取步数
        return;
    }
    
    NSDate *eDate = [NSDate date];
    NSDate *sDate = [NSDate dateWithTimeInterval:-300 sinceDate:eDate];
    
    HKQuantity *stepQuantityConsumed = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:self.showView.addStepNumberTextField.text.doubleValue];
    HKQuantityType *stepConsumedType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSString *strName = [[UIDevice currentDevice] name];
    NSString *strModel = [[UIDevice currentDevice] model];
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
    
    HKDevice *device = [[HKDevice alloc] initWithName:strName manufacturer:@"Apple" model:strModel hardwareVersion:strModel firmwareVersion:strModel softwareVersion:strSysVersion localIdentifier:localeIdentifier UDIDeviceIdentifier:localeIdentifier];
    
    HKQuantitySample *stepConsumedSample = [HKQuantitySample quantitySampleWithType:stepConsumedType quantity:stepQuantityConsumed startDate:sDate endDate:eDate device:device metadata:nil];
    
    [self.healthStore saveObject:stepConsumedSample withCompletion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (success) {
                [self.view endEditing:YES];
                UIAlertView *doneAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [doneAlertView show];
                //刷新数据  重新获取步数
                [self getTodyStepNumberForHealthKit];
            }else {
                NSLog(@"The error was: %@.", error);
                UIAlertView *doneAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [doneAlertView show];
                return ;
            }
        });
    }];
}


- (void)getTodyStepNumberForHealthKit{
    // 读取步数
    // Set your start and end date for your query of interest
    NSDate *startDate, *endDate;
    endDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    startDate = [calendar startOfDayForDate:now];
    endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    //    NSLog(@"startDate %@, endDate %@", startDate, now);
    
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create a predicate to set start/end date bounds of the query
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    __weak UILabel *numberLabel = self.showView.existStpNumberLabel;
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if(!error && results)
        {
            CGFloat sum = 0.0f;
            for(HKQuantitySample *sample in results)
            {
                
                //
                NSLog(@"%@", sample);
                HKUnit *unit = [HKUnit unitFromString:@"count"];
                CGFloat number = [sample.quantity doubleValueForUnit:unit];
                sum += number;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                numberLabel.text = @(sum).description;
            });
        }
        
        
    }];
    [self.healthStore executeQuery:sampleQuery];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
