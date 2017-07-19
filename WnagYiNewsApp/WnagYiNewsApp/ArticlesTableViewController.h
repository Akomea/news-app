//
//  ArticlesTableViewController.h
//  WnagYiNewsApp
//
//  Created by Fidele on 7/4/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticlesTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray* topics;
@property (strong, nonatomic) NSArray* articles;

@end
