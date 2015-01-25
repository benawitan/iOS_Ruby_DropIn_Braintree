//
//  AlbumTableViewCell.h
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface AlbumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) Album *album;
@end
