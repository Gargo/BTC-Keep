//
//  BKPanelImageView.m
//  BTCKeep
//
//  Created by Vyachaslav on 29.05.14.
//  
//

#import "BKPanelImageView.h"

@implementation BKPanelImageView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self resizeImage];
    }
    return self;
}

- (void)resizeImage {
    
    self.image = [self.image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 0, 22, 0)];
}

@end
