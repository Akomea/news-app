//
//  SecondViewController.h
//  WnagYiNewsApp
//
//  Created by Fidele on 7/4/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;

@property (strong, nonatomic) NSArray* topics;
@property (strong, nonatomic) NSArray* articles;

@end

