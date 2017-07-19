//
//  LargeImageCell.h
//  WnagYiNewsApp
//
//  Created by Fidele on 7/5/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;

@end
