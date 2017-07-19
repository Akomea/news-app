//
//  FirstViewController.h
//  WnagYiNewsApp
//
//  Created by Fidele on 7/4/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *topicsBar;

@property (weak, nonatomic) IBOutlet UITableView *articleList;

@property (nonatomic) NSMutableArray* data;

@end

