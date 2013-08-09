//
//  SHViewController.m
//  Example
//
//  Created by Seivan Heidari on 5/14/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#import "SHSegueBlocks.h"
#import "SHViewController.h"
#import "SHControlBlocks.h"

@interface SHViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic,strong) IBOutlet UICollectionView * collectionView;
@end

@implementation SHViewController

-(void)viewDidLoad; {
  [super viewDidLoad];
  UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
  [self.collectionView addSubview:refreshControl];
  self.collectionView.alwaysBounceVertical = YES;
  

  [refreshControl SH_addControlEvents:UIControlEventValueChanged withBlock:^(UIControl *sender) {
    [refreshControl beginRefreshing];

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [refreshControl endRefreshing];
    });
    
  }];
  [refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
  


}

-(void)viewDidAppear:(BOOL)animated; {
  [super viewDidAppear:animated];
}

-(IBAction)unwinder:(UIStoryboardSegue *)theSegue; {
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
  return 100;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
  UICollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"green" forIndexPath:indexPath];
  return cell;
}


@end
