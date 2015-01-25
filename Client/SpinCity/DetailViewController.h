//
//  DetailViewController.h
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import <UIKit/UIKit.h>
#import "Album.h"

@class Album;

@interface DetailViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
- (IBAction)buyAction:(id)sender;

@property (strong, nonatomic) Album *detailItem;

//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
