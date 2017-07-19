//
//  DefaultArticleCell.h
//  WnagYiNewsApp
//
//  Created by Fidele on 7/5/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@end
