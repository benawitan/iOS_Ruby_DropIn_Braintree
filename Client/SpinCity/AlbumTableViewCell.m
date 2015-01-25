//
//  AlbumTableViewCell.m
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlbum:(Album *)newAlbum {
    
    if (newAlbum != _album) {
        _album = newAlbum;
    }
    self.albumTitleLabel.text = (_album.title != nil) ? _album.title : @"-";
    self.albumSummaryLabel.text = (_album.summary != nil) ? _album.summary : @"-";
    self.priceLabel.text = (_album.price != nil) ? [_album.price stringValue] : @"-";
}
@end
