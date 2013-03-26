<code>- (id)init;</code>

<code>- (void)setDelegate:(id)delegate;</code>

<code>- (void)setCurrentItem:(AVItem*)item;</code>

<code>- (void)setCurrentItem:(AVItem*)item preservingRate:(BOOL)flag;</code>

<code>- (void)setCurrentTime:(double)time;</code> // NSTimeInterval?

<code>- (void)play:(NSError*')outError;</code>

<code>- (BOOL)isCurrentItemReady;</code>

<code>- (void)pause;</code>

<code>- (void)setRate:(float)rate error:(NSError*')outError;</code> // 1.0 = normal?

<code>- (float)volume;</code>

<code>- (void)setVolume:(float)volume;</code>

'''AVController delegate methods'''

<code>- (void)queueItemWasAdded:(id)foo;</code>


[[Category:PointlessInformation]]