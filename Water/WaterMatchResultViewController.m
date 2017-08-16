//
//  WaterMatchResultViewController.m
//  Water
//
//  Created by Libo on 17/8/15.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "WaterMatchResultViewController.h"
#import "WaterMatchResultCell.h"
#import "WaterMatchResultModel.h"
#import "WaterflowLayout.h"
#import "Datasource.h"
#import "UIImageView+WebCache.h"
#import "SPImageManager.h"
#import "SPLoadingHUD.h"

static NSString * waterCell = @"waterCell";

@interface WaterMatchResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterflowLayoutDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *doctorList;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat cellWidth;

@end

@implementation WaterMatchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    NSDictionary *dic = [Datasource datasource];
    
    NSArray *dataArray = dic[@"dnData"][@"doctorList"];
    
    [SPLoadingHUD showHUDWithTitle:@"正在加载..." animated:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        for (NSDictionary *dic in dataArray) {
            WaterMatchResultModel *model = [[WaterMatchResultModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.doctorList addObject:model];

            // 提前计算image大小，该方法会阻塞线程
            CGSize imageSize = [[SPImageManager shareImageManager] sizeWithUrlString:model.dnLifePhoto];
            model.imageWidth = imageSize.width;
            model.imageHeight = imageSize.height;
            // 通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.doctorList.count == dataArray.count) {
                    [self.collectionView reloadData];
                    [SPLoadingHUD hideHUDWithAnimated:YES];
                }
            }); 
        }
        
        
    });
 
    [self setupLayout];
}

- (void)setupLayout {
    // 创建布局
    WaterflowLayout *layout = [[WaterflowLayout alloc] init];
    layout.delegate = self;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor lightGrayColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerClass:[WaterMatchResultCell class] forCellWithReuseIdentifier:waterCell];
    
    self.collectionView = collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.doctorList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterMatchResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCell forIndexPath:indexPath];
    WaterMatchResultModel *model = self.doctorList[indexPath.row];
    cell.model = model;
    return cell;
}


#pragma mark - WaterflowLayoutDelegate
- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    
    WaterMatchResultModel *model = self.doctorList[index];
    
    model.cellWidth = itemWidth;

    return [model cellHeightWithCellWidth:itemWidth];
}

- (CGFloat)columnCountInWaterflowLayout:(WaterflowLayout *)waterflowLayout {
    return 2;
}

- (NSMutableArray *)doctorList {
    
    if (!_doctorList) {
        _doctorList = [NSMutableArray array];
        
    }
    return _doctorList;
}


@end
